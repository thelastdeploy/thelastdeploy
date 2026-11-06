# web/backend/app/services.py

from sqlalchemy import select, func, distinct
from sqlalchemy.ext.asyncio import AsyncSession
from app.models import User, LabProgress, SectionProgress, Lab, Section, Module, OrganizationMembership, Organization, AuditLog


from app.analytics import analytics, AnalyticsEvent


async def recalculate_and_update_user_xp(
    user: User, 
    db: AsyncSession, 
    organization_id: int | None = None
) -> tuple[int, int]:
    """
    Recalculate verified total_xp and unverified_xp for a user within an organization
    based on the owner_organization_id of the completed modules.
    Returns (total_xp, unverified_xp) for the target organization.
    """
    # 1. Determine target organization(s)
    if organization_id is not None:
        target_org_ids = [organization_id]
    else:
        # Update all organizations the user has active memberships in
        target_org_ids = (await db.scalars(
            select(OrganizationMembership.organization_id)
            .where(OrganizationMembership.user_id == user.id, OrganizationMembership.status != "removed")
        )).all()
        if not target_org_ids:
            # Fallback to platform org
            plat_id = await db.scalar(select(Organization.id).where(Organization.is_platform == True))
            target_org_ids = [plat_id] if plat_id else [1]

    primary_verified = 0
    primary_unverified = 0

    for oid in target_org_ids:
        # Get membership for this org
        mem = await db.scalar(
            select(OrganizationMembership).where(
                OrganizationMembership.user_id == user.id,
                OrganizationMembership.organization_id == oid,
                OrganizationMembership.status != "removed",
            )
        )
        if not mem:
            continue

        # Verified XP: content owned by this organization
        lab_verified = await db.scalar(
            select(func.sum(LabProgress.xp_awarded))
            .join(Lab, Lab.id == LabProgress.lab_id)
            .where(
                LabProgress.organization_membership_id == mem.id,
                Lab.owner_organization_id == oid,
            )
        ) or 0

        sec_verified = await db.scalar(
            select(func.sum(SectionProgress.xp_awarded))
            .join(Section, Section.id == SectionProgress.section_id)
            .where(
                SectionProgress.organization_membership_id == mem.id,
                Section.owner_organization_id == oid,
            )
        ) or 0

        # Unverified XP: content owned outside this organization
        lab_unverified = await db.scalar(
            select(func.sum(LabProgress.xp_awarded))
            .join(Lab, Lab.id == LabProgress.lab_id)
            .where(
                LabProgress.organization_membership_id == mem.id,
                Lab.owner_organization_id != oid,
            )
        ) or 0

        sec_unverified = await db.scalar(
            select(func.sum(SectionProgress.xp_awarded))
            .join(Section, Section.id == SectionProgress.section_id)
            .where(
                SectionProgress.organization_membership_id == mem.id,
                Section.owner_organization_id != oid,
            )
        ) or 0

        tot_xp = int(lab_verified + sec_verified)
        unv_xp = int(lab_unverified + sec_unverified)

        mem.total_xp = tot_xp
        mem.unverified_xp = unv_xp
        db.add(mem)

        if oid == organization_id or (primary_verified == 0 and primary_unverified == 0):
            primary_verified = tot_xp
            primary_unverified = unv_xp

    await db.commit()
    return primary_verified, primary_unverified


async def log_audit_event(
    db: AsyncSession,
    action: str,
    entity_type: str,
    entity_id: str | None = None,
    actor_user_id: int | None = None,
    organization_id: int | None = None,
    metadata: dict | None = None,
) -> AuditLog:
    """Helper to record append-oriented security and organization audit events."""
    entry = AuditLog(
        organization_id=organization_id,
        actor_user_id=actor_user_id,
        action=action,
        entity_type=entity_type,
        entity_id=str(entity_id) if entity_id is not None else None,
        metadata_=metadata or {},
    )
    db.add(entry)
    await db.commit()
    return entry


async def check_and_track_module_completion(user_id: int, module_id: str, db: AsyncSession) -> bool:
    """
    Check if all sections and labs of a module are completed for a user.
    If so, fire the module.completed analytics event.
    """
    if not user_id or not module_id:
        return False

    module = await db.scalar(select(Module).where(Module.id == module_id))
    if not module:
        return False

    section_ids = module.sections or []
    if not section_ids:
        return False

    # Get all labs across all sections of this module
    sec_rows = (await db.execute(select(Section).where(Section.id.in_(section_ids)))).scalars().all()
    all_lab_ids = [lid for s in sec_rows for lid in (s.labs or [])]

    user_mems = (await db.scalars(
        select(OrganizationMembership.id).where(
            OrganizationMembership.user_id == user_id,
            OrganizationMembership.status != "removed",
        )
    )).all()
    if not user_mems:
        return False

    # Check completed sections
    completed_sec_count = (await db.scalar(
        select(func.count(distinct(SectionProgress.section_id))).where(
            SectionProgress.organization_membership_id.in_(user_mems),
            SectionProgress.section_id.in_(section_ids),
        )
    )) or 0

    if completed_sec_count < len(section_ids):
        return False

    # Check completed labs
    if all_lab_ids:
        completed_lab_count = (await db.scalar(
            select(func.count(distinct(LabProgress.lab_id))).where(
                LabProgress.organization_membership_id.in_(user_mems),
                LabProgress.lab_id.in_(all_lab_ids),
            )
        )) or 0
        if completed_lab_count < len(all_lab_ids):
            return False

    analytics.track(
        "anonymous",
        AnalyticsEvent.MODULE_COMPLETED,
        {
            "module_id": module_id,
            "total_sections": len(section_ids),
            "total_labs": len(all_lab_ids),
        },
    )
    return True

