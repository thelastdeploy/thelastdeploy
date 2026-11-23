# web/backend/app/services.py

from sqlalchemy import select, func, distinct
from sqlalchemy.ext.asyncio import AsyncSession
from app.models import (
    User, LabProgress, SectionProgress, Lab, Section, Module,
    OrganizationMembership, Organization, AuditLog, Role, MembershipRole,
    LearningPath
)


from app.analytics import analytics, AnalyticsEvent


async def get_organizations_using_content(
    db: AsyncSession,
    lab_id: str | None = None,
    section_id: str | None = None,
) -> set[int]:
    """
    Determine the set of organization IDs that 'use' a given content entity (lab or section).
    An organization uses content if:
    1. It directly owns the lab or section.
    2. Any module owned by the organization contains the section or lab.
    3. Any learning path belonging to the organization contains a module with that section or lab.
    4. For TLD official core content: the platform organization always uses it.
    """
    using_org_ids: set[int] = set()

    containing_section_ids: set[str] = set()
    if section_id:
        containing_section_ids.add(section_id)
        sec = await db.scalar(select(Section).where(Section.id == section_id))
        if sec:
            using_org_ids.add(sec.owner_organization_id)
    if lab_id:
        lab = await db.scalar(select(Lab).where(Lab.id == lab_id))
        if lab:
            using_org_ids.add(lab.owner_organization_id)
        sec_rows = (await db.scalars(
            select(Section.id).where(Section.labs.contains([lab_id]))
        )).all()
        for sid in sec_rows:
            containing_section_ids.add(sid)

    containing_module_ids: set[str] = set()
    if containing_section_ids:
        mod_rows = (await db.execute(
            select(Module.id, Module.owner_organization_id, Module.sections)
        )).all()
        for mid, owner_id, secs in mod_rows:
            if secs and any(sid in secs for sid in containing_section_ids):
                containing_module_ids.add(mid)
                using_org_ids.add(owner_id)

    if containing_module_ids:
        lp_rows = (await db.execute(
            select(LearningPath.organization_id, LearningPath.modules)
        )).all()
        for org_id, lp_mods in lp_rows:
            if lp_mods and any(mid in lp_mods for mid in containing_module_ids):
                using_org_ids.add(org_id)

    # If content is owned by platform organization (TLD core curriculum), platform org uses it
    plat_org = await db.scalar(
        select(Organization).where((Organization.type == "platform") | (Organization.slug == "tld"))
    )
    if plat_org:
        if lab_id:
            lab_owner = await db.scalar(select(Lab.owner_organization_id).where(Lab.id == lab_id))
            if lab_owner == plat_org.id:
                using_org_ids.add(plat_org.id)
        elif section_id:
            sec_owner = await db.scalar(select(Section.owner_organization_id).where(Section.id == section_id))
            if sec_owner == plat_org.id:
                using_org_ids.add(plat_org.id)

    return using_org_ids


async def recalculate_membership_xp(
    membership_id: int,
    db: AsyncSession,
) -> tuple[int, int]:
    """
    Recalculates verified total_xp and unverified_xp for an organization membership.
    total_xp = sum of xp_awarded for labs and sections belonging to VERIFIED modules.
    unverified_xp = sum of xp_awarded for labs and sections belonging only to UNVERIFIED modules.
    Atomically updates the OrganizationMembership row and returns (total_xp, unverified_xp).
    """
    mem = await db.scalar(
        select(OrganizationMembership).where(OrganizationMembership.id == membership_id)
    )
    if not mem:
        return 0, 0

    org_id = mem.organization_id
    plat_org_id = await db.scalar(
        select(Organization.id).where((Organization.type == "platform") | (Organization.slug == "tld"))
    )

    # Get all verified modules accessible in this organization
    target_orgs = [org_id]
    if plat_org_id and plat_org_id not in target_orgs:
        target_orgs.append(plat_org_id)

    verified_mods = (await db.execute(
        select(Module.sections)
        .where(
            Module.owner_organization_id.in_(target_orgs),
            Module.status == "verified",
        )
    )).all()

    verified_section_ids: set[str] = set()
    for (secs,) in verified_mods:
        if secs:
            for s in secs:
                verified_section_ids.add(s)

    verified_lab_ids: set[str] = set()
    if verified_section_ids:
        sec_rows = (await db.execute(
            select(Section.labs).where(Section.id.in_(verified_section_ids))
        )).all()
        for (labs,) in sec_rows:
            if labs:
                for l in labs:
                    verified_lab_ids.add(l)

    # Compute verified vs unverified for labs
    lab_progress_rows = (await db.execute(
        select(LabProgress.lab_id, LabProgress.xp_awarded)
        .where(LabProgress.organization_membership_id == mem.id)
    )).all()

    verified_xp = 0
    unverified_xp = 0

    for lid, xp in lab_progress_rows:
        if lid in verified_lab_ids:
            verified_xp += xp
        else:
            unverified_xp += xp

    # Compute verified vs unverified for sections
    sec_progress_rows = (await db.execute(
        select(SectionProgress.section_id, SectionProgress.xp_awarded)
        .where(SectionProgress.organization_membership_id == mem.id)
    )).all()

    for sid, xp in sec_progress_rows:
        if sid in verified_section_ids:
            verified_xp += xp
        else:
            unverified_xp += xp

    mem.total_xp = verified_xp
    mem.unverified_xp = unverified_xp
    db.add(mem)
    await db.flush()

    return verified_xp, unverified_xp


async def recalculate_and_update_user_xp(
    user: User, 
    db: AsyncSession, 
    organization_id: int | None = None
) -> tuple[int, int]:
    """
    Recalculate verified total_xp and unverified_xp across memberships for a user.
    """
    stmt = select(OrganizationMembership).where(
        OrganizationMembership.user_id == user.id,
        OrganizationMembership.status != "removed",
    )
    if organization_id is not None:
        stmt = stmt.where(OrganizationMembership.organization_id == organization_id)

    memberships = (await db.scalars(stmt)).all()
    primary_tot = 0
    primary_unv = 0
    for mem in memberships:
        tot, unv = await recalculate_membership_xp(mem.id, db)
        if organization_id is None or mem.organization_id == organization_id:
            primary_tot = tot
            primary_unv = unv

    await db.commit()
    return primary_tot, primary_unv


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


async def get_or_create_platform_membership(
    user_id: int,
    db: AsyncSession,
    role_slug: str = "learner",
) -> OrganizationMembership:
    """
    Ensure the user has an active membership in the platform organization ('The Last Deploy').
    Creates one with the specified role if it does not already exist.
    """
    plat_org = await db.scalar(
        select(Organization).where(
            (Organization.type == "platform") | (Organization.slug == "tld")
        )
    )
    if not plat_org:
        raise RuntimeError("Platform organization not found in database.")

    mem = await db.scalar(
        select(OrganizationMembership).where(
            OrganizationMembership.user_id == user_id,
            OrganizationMembership.organization_id == plat_org.id,
            OrganizationMembership.status != "removed",
        )
    )
    if mem:
        return mem

    mem = OrganizationMembership(
        organization_id=plat_org.id,
        user_id=user_id,
        status="active",
        total_xp=0,
        unverified_xp=0,
    )
    db.add(mem)
    await db.flush()

    role = await db.scalar(select(Role).where(Role.slug == role_slug))
    if role:
        db.add(MembershipRole(membership_id=mem.id, role_id=role.id))
        await db.flush()

    return mem


