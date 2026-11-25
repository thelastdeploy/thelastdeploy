# web/backend/app/routers/organizations.py

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, delete
from sqlalchemy.orm import selectinload

from app.dependencies import (
    get_db,
    get_current_user,
    get_current_organization,
    require_permission,
    require_platform_permission,
    is_user_platform_admin,
    has_platform_permission,
    has_org_permission,
)
from app.models import (
    User,
    Organization,
    OrganizationMembership,
    MembershipRole,
    Role,
    Cohort,
    CohortMembership,
    LearningPath,
    OrganizationRoleAvailability,
    AuditLog,
    Module,
    Section,
    Lab,
)
from app.schemas import (
    OrganizationResponse,
    OrganizationCreateRequest,
    OrganizationMemberResponse,
    MemberRoleUpdateRequest,
    MessageResponse,
    CohortCreateRequest,
    CohortUpdateRequest,
    CohortMemberAddRequest,
    CohortResponse,
    CohortMemberResponse,
    LearningPathCreateRequest,
    LearningPathUpdateRequest,
    LearningPathResponse,
    AuditLogResponse,
    AdoptModuleRequest,
    ModuleListItem,
    AuthorInfo,
)
from app.services import log_audit_event
from app.settings.service import SettingsService

router = APIRouter(prefix="/organizations", tags=["organizations"])


@router.get("", response_model=list[OrganizationResponse])
async def list_user_organizations(
    include_all: bool = False,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """List all organizations the current user belongs to, along with their roles and XP in each.
    If include_all is True and caller has workspace management authority, all active organizations are appended.
    """
    has_workspace_authority = await has_platform_permission(current_user, "platform.organizations.manage", db) or await is_user_platform_admin(current_user, db)

    stmt = (
        select(OrganizationMembership)
        .options(
            selectinload(OrganizationMembership.organization),
            selectinload(OrganizationMembership.roles).selectinload(MembershipRole.role),
        )
        .where(
            OrganizationMembership.user_id == current_user.id,
            OrganizationMembership.status != "removed",
        )
        .order_by(OrganizationMembership.joined_at.asc())
    )
    result = await db.execute(stmt)
    memberships = result.scalars().all()

    existing_org_ids = set()
    responses = []
    for m in memberships:
        org = m.organization
        existing_org_ids.add(org.id)
        role_slugs = [r.role.slug for r in m.roles if r.role]
        if has_workspace_authority and "admin" not in role_slugs:
            role_slugs.append("admin")
        responses.append(
            OrganizationResponse(
                id=org.id,
                name=org.name,
                slug=org.slug,
                type=org.type,
                is_platform=org.is_platform,
                status=org.status,
                domains=org.domains or [],
                roles=role_slugs,
                total_xp=m.total_xp,
                unverified_xp=m.unverified_xp,
                joined_at=m.joined_at,
            )
        )

    if include_all and has_workspace_authority:
        all_orgs = (await db.execute(select(Organization).where(Organization.status == "active"))).scalars().all()
        for o in all_orgs:
            if o.id not in existing_org_ids:
                responses.append(
                    OrganizationResponse(
                        id=o.id,
                        name=o.name,
                        slug=o.slug,
                        type=o.type,
                        is_platform=o.is_platform,
                        status=o.status,
                        domains=o.domains or [],
                        roles=["platform_admin", "admin"],
                        total_xp=0,
                        unverified_xp=0,
                        joined_at=o.created_at,
                    )
                )

    return responses


@router.get("/{org_slug}", response_model=OrganizationResponse)
async def get_organization(
    org_slug: str,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """Get details of a specific organization if user is an active member or has workspace management authority."""
    has_workspace_authority = await has_platform_permission(current_user, "platform.organizations.manage", db) or await is_user_platform_admin(current_user, db)

    org = await db.scalar(select(Organization).where(Organization.slug == org_slug))
    if not org:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Organization '{org_slug}' not found.",
        )

    stmt = (
        select(OrganizationMembership)
        .options(
            selectinload(OrganizationMembership.roles).selectinload(MembershipRole.role),
        )
        .where(
            OrganizationMembership.organization_id == org.id,
            OrganizationMembership.user_id == current_user.id,
            OrganizationMembership.status == "active",
        )
    )
    result = await db.execute(stmt)
    m = result.scalar_one_or_none()

    if not m and not has_workspace_authority:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=f"Access denied. You do not have permission to view or manage workspace '{org_slug}'.",
        )

    if m:
        role_slugs = [r.role.slug for r in m.roles if r.role]
        if has_workspace_authority and "admin" not in role_slugs:
            role_slugs.append("admin")
        return OrganizationResponse(
            id=org.id,
            name=org.name,
            slug=org.slug,
            type=org.type,
            is_platform=org.is_platform,
            status=org.status,
            domains=org.domains or [],
            roles=role_slugs,
            total_xp=m.total_xp,
            unverified_xp=m.unverified_xp,
            joined_at=m.joined_at,
        )

    # Caller is not a direct member, but holds platform.organizations.manage / platform admin
    return OrganizationResponse(
        id=org.id,
        name=org.name,
        slug=org.slug,
        type=org.type,
        is_platform=org.is_platform,
        status=org.status,
        domains=org.domains or [],
        roles=["platform_admin", "admin"],
        total_xp=0,
        unverified_xp=0,
        joined_at=org.created_at,
    )


@router.get("/{org_slug}/members", response_model=list[OrganizationMemberResponse])
async def list_organization_members(
    org_slug: str,
    org_and_mem: tuple[Organization, OrganizationMembership] = Depends(get_current_organization),
    db: AsyncSession = Depends(get_db),
    _perm: OrganizationMembership = Depends(require_permission("members.view")),
):
    """List members of the organization (requires 'members.view' permission)."""
    organization, _ = org_and_mem
    stmt = (
        select(OrganizationMembership)
        .options(
            selectinload(OrganizationMembership.user),
            selectinload(OrganizationMembership.roles).selectinload(MembershipRole.role),
        )
        .where(
            OrganizationMembership.organization_id == organization.id,
            OrganizationMembership.status != "removed",
        )
        .order_by(OrganizationMembership.joined_at.asc())
    )
    result = await db.execute(stmt)
    memberships = result.scalars().all()

    return [
        OrganizationMemberResponse(
            membership_id=m.id,
            user_id=m.user.id,
            username=m.user.username,
            email=m.user.email,
            status=m.status,
            roles=[r.role.slug for r in m.roles if r.role],
            total_xp=m.total_xp,
            unverified_xp=m.unverified_xp,
            joined_at=m.joined_at,
        )
        for m in memberships
    ]


@router.patch("/{org_slug}/members/{user_id}/role", response_model=OrganizationMemberResponse)
async def update_member_role(
    org_slug: str,
    user_id: int,
    body: MemberRoleUpdateRequest,
    org_and_mem: tuple[Organization, OrganizationMembership] = Depends(get_current_organization),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
    _perm: OrganizationMembership = Depends(require_permission("members.manage")),
):
    """Change the role of an organization member (requires 'members.manage' permission)."""
    organization, caller_mem = org_and_mem
    stmt = (
        select(OrganizationMembership)
        .options(
            selectinload(OrganizationMembership.user),
            selectinload(OrganizationMembership.roles).selectinload(MembershipRole.role),
        )
        .where(
            OrganizationMembership.organization_id == organization.id,
            OrganizationMembership.user_id == user_id,
            OrganizationMembership.status != "removed",
        )
    )
    res = await db.execute(stmt)
    target_mem = res.scalar_one_or_none()
    if not target_mem:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Member not found in organization.",
        )

    clean_role_slug = body.role.strip().lower()
    target_role = await db.scalar(select(Role).where(Role.slug == clean_role_slug))
    if not target_role:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Role '{body.role}' is not recognized.",
        )

    # Delete existing roles and assign the new role
    await db.execute(delete(MembershipRole).where(MembershipRole.membership_id == target_mem.id))
    db.add(MembershipRole(membership_id=target_mem.id, role_id=target_role.id, assigned_by=current_user.id))
    await db.commit()
    await db.refresh(target_mem)

    await log_audit_event(
        db,
        action="member.role_updated",
        entity_type="membership",
        entity_id=str(target_mem.id),
        actor_user_id=current_user.id,
        organization_id=organization.id,
        metadata={"user_id": user_id, "new_role": target_role.slug},
    )

    return OrganizationMemberResponse(
        membership_id=target_mem.id,
        user_id=target_mem.user.id,
        username=target_mem.user.username,
        email=target_mem.user.email,
        status=target_mem.status,
        roles=[target_role.slug],
        total_xp=target_mem.total_xp,
        unverified_xp=target_mem.unverified_xp,
        joined_at=target_mem.joined_at,
    )


@router.delete("/{org_slug}/members/{user_id}", response_model=MessageResponse)
async def remove_organization_member(
    org_slug: str,
    user_id: int,
    org_and_mem: tuple[Organization, OrganizationMembership] = Depends(get_current_organization),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
    _perm: OrganizationMembership = Depends(require_permission("members.manage")),
):
    """Remove a member from the organization (requires 'members.manage' permission)."""
    organization, caller_mem = org_and_mem
    if current_user.id == user_id:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="You cannot remove yourself from the organization.",
        )

    stmt = select(OrganizationMembership).where(
        OrganizationMembership.organization_id == organization.id,
        OrganizationMembership.user_id == user_id,
        OrganizationMembership.status != "removed",
    )
    target_mem = await db.scalar(stmt)
    if not target_mem:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Member not found in organization.",
        )

    target_mem.status = "removed"
    db.add(target_mem)
    await db.commit()

    await log_audit_event(
        db,
        action="member.removed",
        entity_type="membership",
        entity_id=str(target_mem.id),
        actor_user_id=current_user.id,
        organization_id=organization.id,
        metadata={"user_id": user_id},
    )

    return MessageResponse(detail="Member removed successfully.")


@router.get("/{org_slug}/cohorts/{cohort_id}/members", response_model=list[CohortMemberResponse])
async def list_cohort_members(
    org_slug: str,
    cohort_id: int,
    org_and_mem: tuple[Organization, OrganizationMembership] = Depends(get_current_organization),
    db: AsyncSession = Depends(get_db),
    _perm: OrganizationMembership = Depends(require_permission("cohorts.manage")),
):
    """List enrolled students in a cohort (requires 'cohorts.manage' permission)."""
    organization, _ = org_and_mem
    cohort = await db.scalar(
        select(Cohort).where(Cohort.id == cohort_id, Cohort.organization_id == organization.id)
    )
    if not cohort:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Cohort not found.")

    stmt = (
        select(CohortMembership, OrganizationMembership, User)
        .join(OrganizationMembership, CohortMembership.organization_membership_id == OrganizationMembership.id)
        .join(User, OrganizationMembership.user_id == User.id)
        .where(
            CohortMembership.cohort_id == cohort.id,
            CohortMembership.removed_at.is_(None),
            OrganizationMembership.status == "active",
        )
        .order_by(CohortMembership.joined_at.asc())
    )
    res = await db.execute(stmt)
    rows = res.all()

    return [
        CohortMemberResponse(
            membership_id=om.id,
            cohort_membership_id=cm.id,
            user_id=u.id,
            username=u.username,
            email=u.email,
            total_xp=om.total_xp,
            joined_at=cm.joined_at,
        )
        for cm, om, u in rows
    ]


@router.get("/{org_slug}/cohorts", response_model=list[CohortResponse])
async def list_cohorts(
    org_slug: str,
    org_and_mem: tuple[Organization, OrganizationMembership] = Depends(get_current_organization),
    db: AsyncSession = Depends(get_db),
):
    """List active cohorts in the organization."""
    organization, _ = org_and_mem
    stmt = (
        select(Cohort)
        .where(Cohort.organization_id == organization.id)
        .order_by(Cohort.created_at.desc())
    )
    result = await db.execute(stmt)
    cohorts = result.scalars().all()
    return [
        CohortResponse(
            id=c.id,
            organization_id=c.organization_id,
            name=c.name,
            description=c.description,
            status=c.status,
            learning_paths=c.learning_paths or [],
            starts_at=c.starts_at,
            ends_at=c.ends_at,
            created_at=c.created_at,
        )
        for c in cohorts
    ]


@router.post("/{org_slug}/cohorts", response_model=CohortResponse, status_code=status.HTTP_201_CREATED)
async def create_cohort(
    org_slug: str,
    body: CohortCreateRequest,
    org_and_mem: tuple[Organization, OrganizationMembership] = Depends(get_current_organization),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
    _perm: OrganizationMembership = Depends(require_permission("cohorts.manage")),
):
    """Create a new cohort within the organization (requires 'cohorts.manage')."""
    organization, _ = org_and_mem
    cohort = Cohort(
        organization_id=organization.id,
        name=body.name,
        description=body.description,
        learning_paths=body.learning_paths or [],
        starts_at=body.starts_at,
        ends_at=body.ends_at,
        created_by=current_user.id,
    )
    db.add(cohort)
    await db.commit()
    await db.refresh(cohort)

    await log_audit_event(
        db,
        action="cohort.created",
        entity_type="cohort",
        entity_id=str(cohort.id),
        actor_user_id=current_user.id,
        organization_id=organization.id,
        metadata={"name": cohort.name, "learning_paths": cohort.learning_paths},
    )

    return CohortResponse(
        id=cohort.id,
        organization_id=cohort.organization_id,
        name=cohort.name,
        description=cohort.description,
        status=cohort.status,
        learning_paths=cohort.learning_paths or [],
        starts_at=cohort.starts_at,
        ends_at=cohort.ends_at,
        created_at=cohort.created_at,
    )


@router.patch("/{org_slug}/cohorts/{cohort_id}", response_model=CohortResponse)
async def update_cohort(
    org_slug: str,
    cohort_id: int,
    body: CohortUpdateRequest,
    org_and_mem: tuple[Organization, OrganizationMembership] = Depends(get_current_organization),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
    _perm: OrganizationMembership = Depends(require_permission("cohorts.manage")),
):
    """Update an existing cohort (requires 'cohorts.manage')."""
    organization, _ = org_and_mem
    cohort = await db.scalar(
        select(Cohort).where(Cohort.id == cohort_id, Cohort.organization_id == organization.id)
    )
    if not cohort:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Cohort not found.")

    if body.name is not None:
        cohort.name = body.name.strip()
    if body.description is not None:
        cohort.description = body.description
    if body.status is not None:
        cohort.status = body.status
    if body.learning_paths is not None:
        cohort.learning_paths = body.learning_paths
    if body.starts_at is not None:
        cohort.starts_at = body.starts_at
    if body.ends_at is not None:
        cohort.ends_at = body.ends_at

    db.add(cohort)
    await db.commit()
    await db.refresh(cohort)

    await log_audit_event(
        db,
        action="cohort.updated",
        entity_type="cohort",
        entity_id=str(cohort.id),
        actor_user_id=current_user.id,
        organization_id=organization.id,
        metadata={"name": cohort.name, "learning_paths": cohort.learning_paths},
    )

    return CohortResponse(
        id=cohort.id,
        organization_id=cohort.organization_id,
        name=cohort.name,
        description=cohort.description,
        status=cohort.status,
        learning_paths=cohort.learning_paths or [],
        starts_at=cohort.starts_at,
        ends_at=cohort.ends_at,
        created_at=cohort.created_at,
    )


@router.delete("/{org_slug}/cohorts/{cohort_id}", response_model=MessageResponse)
async def delete_cohort(
    org_slug: str,
    cohort_id: int,
    org_and_mem: tuple[Organization, OrganizationMembership] = Depends(get_current_organization),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
    _perm: OrganizationMembership = Depends(require_permission("cohorts.manage")),
):
    """Archive a cohort (requires 'cohorts.manage')."""
    organization, _ = org_and_mem
    cohort = await db.scalar(
        select(Cohort).where(Cohort.id == cohort_id, Cohort.organization_id == organization.id)
    )
    if not cohort:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Cohort not found.")

    cohort.status = "archived"
    db.add(cohort)
    await db.commit()

    await log_audit_event(
        db,
        action="cohort.archived",
        entity_type="cohort",
        entity_id=str(cohort.id),
        actor_user_id=current_user.id,
        organization_id=organization.id,
        metadata={"name": cohort.name},
    )

    return MessageResponse(detail="Cohort archived successfully.")


@router.post("/{org_slug}/cohorts/{cohort_id}/members", response_model=CohortMemberResponse, status_code=status.HTTP_201_CREATED)
async def add_cohort_member(
    org_slug: str,
    cohort_id: int,
    body: CohortMemberAddRequest,
    org_and_mem: tuple[Organization, OrganizationMembership] = Depends(get_current_organization),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
    _perm: OrganizationMembership = Depends(require_permission("cohorts.manage")),
):
    """Enroll an organization member into a cohort (requires 'cohorts.manage')."""
    organization, _ = org_and_mem
    cohort = await db.scalar(
        select(Cohort).where(Cohort.id == cohort_id, Cohort.organization_id == organization.id)
    )
    if not cohort:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Cohort not found.")

    # Target user must be an active member of this organization
    target_mem = await db.scalar(
        select(OrganizationMembership)
        .options(selectinload(OrganizationMembership.user))
        .where(
            OrganizationMembership.organization_id == organization.id,
            OrganizationMembership.user_id == body.user_id,
            OrganizationMembership.status == "active",
        )
    )
    if not target_mem:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User is not an active member of this organization.",
        )

    # Check if cohort membership already exists
    cm = await db.scalar(
        select(CohortMembership).where(
            CohortMembership.cohort_id == cohort.id,
            CohortMembership.organization_membership_id == target_mem.id,
        )
    )
    from datetime import datetime, timezone
    if cm:
        if cm.removed_at is None:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="User is already enrolled in this cohort.",
            )
        cm.removed_at = None
        cm.joined_at = datetime.now(timezone.utc)
    else:
        cm = CohortMembership(
            organization_id=organization.id,
            cohort_id=cohort.id,
            organization_membership_id=target_mem.id,
            joined_at=datetime.now(timezone.utc),
        )
        db.add(cm)

    await db.commit()
    await db.refresh(cm)

    await log_audit_event(
        db,
        action="cohort.member_added",
        entity_type="cohort",
        entity_id=str(cohort.id),
        actor_user_id=current_user.id,
        organization_id=organization.id,
        metadata={"user_id": body.user_id, "username": target_mem.user.username},
    )

    return CohortMemberResponse(
        membership_id=target_mem.id,
        cohort_membership_id=cm.id,
        user_id=target_mem.user.id,
        username=target_mem.user.username,
        email=target_mem.user.email,
        total_xp=target_mem.total_xp,
        joined_at=cm.joined_at,
    )


@router.delete("/{org_slug}/cohorts/{cohort_id}/members/{user_id}", response_model=MessageResponse)
async def remove_cohort_member(
    org_slug: str,
    cohort_id: int,
    user_id: int,
    org_and_mem: tuple[Organization, OrganizationMembership] = Depends(get_current_organization),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
    _perm: OrganizationMembership = Depends(require_permission("cohorts.manage")),
):
    """Remove a student from a cohort (requires 'cohorts.manage')."""
    organization, _ = org_and_mem
    cohort = await db.scalar(
        select(Cohort).where(Cohort.id == cohort_id, Cohort.organization_id == organization.id)
    )
    if not cohort:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Cohort not found.")

    target_mem = await db.scalar(
        select(OrganizationMembership).where(
            OrganizationMembership.organization_id == organization.id,
            OrganizationMembership.user_id == user_id,
        )
    )
    if not target_mem:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Member not found in organization.")

    cm = await db.scalar(
        select(CohortMembership).where(
            CohortMembership.cohort_id == cohort.id,
            CohortMembership.organization_membership_id == target_mem.id,
            CohortMembership.removed_at.is_(None),
        )
    )
    if not cm:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Student is not active in this cohort.")

    from datetime import datetime, timezone
    cm.removed_at = datetime.now(timezone.utc)
    db.add(cm)
    await db.commit()

    await log_audit_event(
        db,
        action="cohort.member_removed",
        entity_type="cohort",
        entity_id=str(cohort.id),
        actor_user_id=current_user.id,
        organization_id=organization.id,
        metadata={"user_id": user_id},
    )

    return MessageResponse(detail="Member removed from cohort successfully.")


@router.get("/{org_slug}/learning-paths", response_model=list[LearningPathResponse])
async def list_learning_paths(
    org_slug: str,
    org_and_mem: tuple[Organization, OrganizationMembership] = Depends(get_current_organization),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """
    List learning paths for the organization.
    Instructors/Admins view all learning paths.
    Learners view public paths plus private paths assigned to cohorts they belong to.
    """
    organization, caller_mem = org_and_mem
    is_manager = await has_org_permission(caller_mem, "learning_paths.manage", current_user, db)

    stmt = (
        select(LearningPath)
        .where(
            LearningPath.organization_id == organization.id,
            LearningPath.status == "active",
        )
        .order_by(LearningPath.created_at.desc())
    )
    result = await db.execute(stmt)
    all_paths = result.scalars().all()

    if is_manager:
        paths = all_paths
    elif not caller_mem:
        paths = []
    else:
        # Get learning paths assigned to cohorts where this user is an active enrolled member
        cohort_lp_stmt = (
            select(Cohort.learning_paths)
            .join(CohortMembership, CohortMembership.cohort_id == Cohort.id)
            .where(
                CohortMembership.organization_membership_id == caller_mem.id,
                CohortMembership.removed_at.is_(None),
                Cohort.organization_id == organization.id,
                Cohort.status == "active",
            )
        )
        cohort_lp_res = await db.execute(cohort_lp_stmt)
        allowed_path_refs = set()
        for row in cohort_lp_res.scalars().all():
            if isinstance(row, list):
                for item in row:
                    allowed_path_refs.add(str(item))
                    if isinstance(item, int) or (isinstance(item, str) and item.isdigit()):
                        allowed_path_refs.add(int(item))

        paths = [
            p for p in all_paths
            if p.visibility == "public" or p.id in allowed_path_refs or str(p.id) in allowed_path_refs or p.slug in allowed_path_refs
        ]

    return [
        LearningPathResponse(
            id=p.id,
            organization_id=p.organization_id,
            name=p.name,
            slug=p.slug,
            description=p.description,
            visibility=p.visibility,
            status=p.status,
            modules=p.modules or [],
            module_count=len(p.modules or []),
            created_at=p.created_at,
        )
        for p in paths
    ]


@router.post("/{org_slug}/learning-paths", response_model=LearningPathResponse, status_code=status.HTTP_201_CREATED)
async def create_learning_path(
    org_slug: str,
    body: LearningPathCreateRequest,
    org_and_mem: tuple[Organization, OrganizationMembership] = Depends(get_current_organization),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
    _perm: OrganizationMembership = Depends(require_permission("learning_paths.manage")),
):
    """Create a new learning path within the organization (requires 'learning_paths.manage')."""
    organization, _ = org_and_mem

    # Check slug uniqueness within organization (excluding archived paths)
    existing = await db.scalar(
        select(LearningPath.id).where(
            LearningPath.organization_id == organization.id,
            LearningPath.slug == body.slug.strip(),
            LearningPath.status != "archived",
        )
    )
    if existing:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Learning path with slug '{body.slug}' already exists in this organization",
        )

    # Visibility handling: use provided or fallback to Module E setting
    visibility = body.visibility
    if not visibility:
        effective_vis = await SettingsService.get_effective_setting(db, organization.id, "learning_paths.default_visibility")
        visibility = str(effective_vis) if effective_vis else "public"
    if visibility not in ["public", "private"]:
        visibility = "public"

    lp = LearningPath(
        organization_id=organization.id,
        name=body.name,
        slug=body.slug.strip(),
        description=body.description,
        visibility=visibility,
        modules=body.modules or [],
        created_by=current_user.id,
    )
    db.add(lp)
    await db.commit()
    await db.refresh(lp)

    await log_audit_event(
        db,
        action="learning_path.created",
        entity_type="learning_path",
        entity_id=str(lp.id),
        actor_user_id=current_user.id,
        organization_id=organization.id,
        metadata={"slug": lp.slug, "visibility": lp.visibility, "modules": lp.modules},
    )

    return LearningPathResponse(
        id=lp.id,
        organization_id=lp.organization_id,
        name=lp.name,
        slug=lp.slug,
        description=lp.description,
        visibility=lp.visibility,
        status=lp.status,
        modules=lp.modules or [],
        module_count=len(lp.modules or []),
        created_at=lp.created_at,
    )


@router.patch("/{org_slug}/learning-paths/{path_id}", response_model=LearningPathResponse)
async def update_learning_path(
    org_slug: str,
    path_id: int,
    body: LearningPathUpdateRequest,
    org_and_mem: tuple[Organization, OrganizationMembership] = Depends(get_current_organization),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
    _perm: OrganizationMembership = Depends(require_permission("learning_paths.manage")),
):
    """Update learning path metadata, visibility, or modules (requires 'learning_paths.manage')."""
    organization, _ = org_and_mem
    lp = await db.scalar(
        select(LearningPath).where(
            LearningPath.id == path_id,
            LearningPath.organization_id == organization.id,
        )
    )
    if not lp:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Learning path not found.")

    if body.name is not None:
        lp.name = body.name.strip()
    if body.description is not None:
        lp.description = body.description
    if body.visibility is not None:
        if body.visibility not in ["public", "private"]:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Visibility must be 'public' or 'private'")
        lp.visibility = body.visibility
    if body.status is not None:
        lp.status = body.status
    if body.modules is not None:
        lp.modules = body.modules

    db.add(lp)
    await db.commit()
    await db.refresh(lp)

    await log_audit_event(
        db,
        action="learning_path.updated",
        entity_type="learning_path",
        entity_id=str(lp.id),
        actor_user_id=current_user.id,
        organization_id=organization.id,
        metadata={"slug": lp.slug, "visibility": lp.visibility, "modules": lp.modules},
    )

    return LearningPathResponse(
        id=lp.id,
        organization_id=lp.organization_id,
        name=lp.name,
        slug=lp.slug,
        description=lp.description,
        visibility=lp.visibility,
        status=lp.status,
        modules=lp.modules or [],
        module_count=len(lp.modules or []),
        created_at=lp.created_at,
    )


@router.delete("/{org_slug}/learning-paths/{path_id}", response_model=MessageResponse)
async def delete_learning_path(
    org_slug: str,
    path_id: int,
    org_and_mem: tuple[Organization, OrganizationMembership] = Depends(get_current_organization),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
    _perm: OrganizationMembership = Depends(require_permission("learning_paths.manage")),
):
    """Archive a learning path (requires 'learning_paths.manage')."""
    organization, _ = org_and_mem
    lp = await db.scalar(
        select(LearningPath).where(
            LearningPath.id == path_id,
            LearningPath.organization_id == organization.id,
        )
    )
    if not lp:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Learning path not found.")

    lp.status = "archived"
    db.add(lp)
    await db.commit()

    await log_audit_event(
        db,
        action="learning_path.deleted",
        entity_type="learning_path",
        entity_id=str(lp.id),
        actor_user_id=current_user.id,
        organization_id=organization.id,
        metadata={"slug": lp.slug},
    )

    return MessageResponse(detail="Learning path archived successfully.")


@router.get("/{org_slug}/audit-logs", response_model=list[AuditLogResponse])
async def list_organization_audit_logs(
    org_slug: str,
    limit: int = 50,
    offset: int = 0,
    org_and_mem: tuple[Organization, OrganizationMembership] = Depends(get_current_organization),
    db: AsyncSession = Depends(get_db),
    _perm: OrganizationMembership = Depends(require_permission("members.manage")),
):
    """List audit events for the organization (requires 'members.manage' permission)."""
    organization, _ = org_and_mem
    stmt = (
        select(AuditLog, User.username)
        .outerjoin(User, AuditLog.actor_user_id == User.id)
        .where(AuditLog.organization_id == organization.id)
        .order_by(AuditLog.created_at.desc())
        .limit(min(limit, 100))
        .offset(offset)
    )
    res = await db.execute(stmt)
    rows = res.all()

    return [
        AuditLogResponse(
            id=log.id,
            organization_id=log.organization_id,
            actor_user_id=log.actor_user_id,
            actor_username=username or "System",
            action=log.action,
            entity_type=log.entity_type,
            entity_id=log.entity_id,
            metadata=log.metadata_ or {},
            created_at=log.created_at,
        )
        for log, username in rows
    ]


# --- Platform Staff Administrative Endpoints ---

@router.post("", response_model=OrganizationResponse, status_code=status.HTTP_201_CREATED)
async def provision_organization(
    body: OrganizationCreateRequest,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
    _perm: User = Depends(require_platform_permission("platform.organizations.create")),
):
    """Platform staff only: provision a new organization."""
    existing = await db.scalar(select(Organization.id).where(Organization.slug == body.slug.strip()))
    if existing:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Organization slug '{body.slug}' is already taken",
        )

    clean_domains = list(dict.fromkeys(d.strip().lower() for d in body.domains if d.strip()))
    org = Organization(
        name=body.name,
        slug=body.slug.strip(),
        type=body.type,
        domains=clean_domains,
        status="active",
    )
    db.add(org)
    await db.flush()

    # Assign all standard roles as available to this organization
    roles_res = await db.execute(select(Role).where(Role.is_system == True))
    standard_roles = roles_res.scalars().all()
    for r in standard_roles:
        db.add(OrganizationRoleAvailability(organization_id=org.id, role_id=r.id))

    # Add creator as Owner of the new organization
    owner_role = next((r for r in standard_roles if r.slug == "owner"), None)
    membership = OrganizationMembership(
        organization_id=org.id,
        user_id=current_user.id,
        status="active",
    )
    db.add(membership)
    await db.flush()

    if owner_role:
        db.add(MembershipRole(membership_id=membership.id, role_id=owner_role.id, assigned_by=current_user.id))

    # Initialize code-defined organization settings for the newly provisioned organization
    await SettingsService.initialize_organization_settings(db, org.id, tier="free", auto_commit=False)

    await db.commit()
    await db.refresh(org)

    await log_audit_event(
        db,
        action="organization.provisioned",
        entity_type="organization",
        entity_id=str(org.id),
        actor_user_id=current_user.id,
        organization_id=org.id,
        metadata={"slug": org.slug, "type": org.type},
    )

    return OrganizationResponse(
        id=org.id,
        name=org.name,
        slug=org.slug,
        type=org.type,
        is_platform=org.is_platform,
        status=org.status,
        domains=org.domains or [],
        roles=["owner"] if owner_role else [],
        total_xp=0,
        unverified_xp=0,
        joined_at=membership.joined_at,
    )


# ---------------------------------------------------------------------------
# Organization Workspace Curriculum Endpoints
# ---------------------------------------------------------------------------

@router.get("/{org_slug}/curriculum", response_model=list[ModuleListItem])
async def list_organization_curriculum(
    org_slug: str,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """List all modules belonging to this organization's workspace catalog."""
    org = await db.scalar(select(Organization).where(Organization.slug == org_slug.strip()))
    if not org:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Organization not found")

    # Caller must be a member or platform operator
    mem = await db.scalar(
        select(OrganizationMembership.id).where(
            OrganizationMembership.organization_id == org.id,
            OrganizationMembership.user_id == current_user.id,
            OrganizationMembership.status == "active",
        )
    )
    if not mem and not await is_user_platform_admin(current_user, db):
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not authorized for this organization")

    stmt = (
        select(Module)
        .options(selectinload(Module.author))
        .where(
            Module.owner_organization_id == org.id,
            Module.status != "draft",
        )
        .order_by(Module.title.asc())
    )
    modules = (await db.execute(stmt)).scalars().all()

    return [
        ModuleListItem(
            id=m.id,
            title=m.title,
            description=m.description,
            topic=m.topic,
            difficulty=m.difficulty,
            estimated_minutes=m.estimated_minutes,
            total_xp=m.total_xp,
            total_sections=len(m.sections or []),
            completed_sections=0,
            version=m.version,
            author=AuthorInfo(name=m.author.username, is_official=False) if m.author else AuthorInfo(name="The Last Deploy", is_official=True),
            status=m.status,
            is_official_verified=(m.status == "verified"),
        )
        for m in modules
    ]


@router.get("/{org_slug}/curriculum/available", response_model=list[ModuleListItem])
async def list_available_tld_modules(
    org_slug: str,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """List official platform modules available to be directly adopted into this workspace."""
    org = await db.scalar(select(Organization).where(Organization.slug == org_slug.strip()))
    if not org:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Organization not found")

    platform_org_id = await db.scalar(select(Organization.id).where(Organization.type == "platform"))
    if not platform_org_id:
        return []

    # Get IDs of modules already present in this organization
    org_mod_ids = set((await db.scalars(
        select(Module.id).where(Module.owner_organization_id == org.id)
    )).all())

    # Get verified official TLD modules not yet added to this organization
    stmt = (
        select(Module)
        .options(selectinload(Module.author))
        .where(
            Module.owner_organization_id == platform_org_id,
            Module.status.in_(["verified", "published"]),
        )
        .order_by(Module.title.asc())
    )
    tld_modules = (await db.execute(stmt)).scalars().all()

    return [
        ModuleListItem(
            id=m.id,
            title=m.title,
            description=m.description,
            topic=m.topic,
            difficulty=m.difficulty,
            estimated_minutes=m.estimated_minutes,
            total_xp=m.total_xp,
            total_sections=len(m.sections or []),
            completed_sections=0,
            version=m.version,
            author=AuthorInfo(name="The Last Deploy", is_official=True),
            status=m.status,
            is_official_verified=True,
        )
        for m in tld_modules
        if m.id not in org_mod_ids
    ]


@router.post("/{org_slug}/curriculum/adopt", response_model=ModuleListItem, status_code=status.HTTP_201_CREATED)
async def adopt_tld_module(
    org_slug: str,
    body: AdoptModuleRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Directly adopt an official TLD module into the organization workspace without modifying sections."""
    org = await db.scalar(select(Organization).where(Organization.slug == org_slug.strip()))
    if not org:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Organization not found")

    # Caller must have admin rights or content publishing permission in this org
    mem = await db.scalar(
        select(OrganizationMembership).where(
            OrganizationMembership.organization_id == org.id,
            OrganizationMembership.user_id == current_user.id,
            OrganizationMembership.status == "active",
        )
    )
    is_platform_admin = await is_user_platform_admin(current_user, db)
    can_publish = mem and (await has_org_permission(mem, "content.publish", current_user, db) or await has_org_permission(mem, "workspace.manage", current_user, db))
    if not can_publish and not is_platform_admin:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Requires content.publish or workspace.manage permission")

    platform_org_id = await db.scalar(select(Organization.id).where(Organization.type == "platform"))
    if not platform_org_id:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="Platform organization not configured")

    # 1. Fetch official TLD module
    tld_mod = (await db.execute(
        select(Module).where(
            Module.id == body.tld_module_id,
            Module.owner_organization_id == platform_org_id,
        )
    )).scalar_one_or_none()
    if not tld_mod:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Official TLD module '{body.tld_module_id}' not found")

    target_id = (body.custom_id or tld_mod.id).strip()
    if not target_id:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Module ID cannot be empty")

    # 2. Check if (target_id, org.id) already exists
    existing = await db.scalar(
        select(Module.id).where(
            Module.id == target_id,
            Module.owner_organization_id == org.id,
        )
    )
    if existing:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Module '{target_id}' is already present in this organization's workspace",
        )

    # 3. Golden Integrity Validation: verify all referenced sections belong to platform or org
    sec_ids = tld_mod.sections or []
    if sec_ids:
        valid_sec_ids = set((await db.scalars(
            select(Section.id).where(
                Section.id.in_(sec_ids),
                Section.owner_organization_id.in_([platform_org_id, org.id]),
            )
        )).all())
        missing_secs = [sid for sid in sec_ids if sid not in valid_sec_ids]
        if missing_secs:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"Integrity check failed: Referenced sections not found in platform or org: {missing_secs}",
            )

    # 4. Insert new Module record for this organization
    target_title = (body.custom_title or tld_mod.title).strip()
    new_mod = Module(
        id=target_id,
        owner_organization_id=org.id,
        title=target_title,
        description=tld_mod.description,
        topic=tld_mod.topic,
        difficulty=tld_mod.difficulty,
        estimated_minutes=tld_mod.estimated_minutes,
        version=tld_mod.version,
        total_xp=tld_mod.total_xp,
        sections=tld_mod.sections,
        shared_seed=tld_mod.shared_seed,
        author_id=current_user.id,
        status="verified",
        content_hash=tld_mod.content_hash,
    )
    db.add(new_mod)
    await db.commit()
    await db.refresh(new_mod)

    await log_audit_event(
        db,
        action="organization.curriculum.adopt",
        entity_type="module",
        entity_id=new_mod.id,
        actor_user_id=current_user.id,
        organization_id=org.id,
        metadata={"adopted_from": tld_mod.id, "module_id": new_mod.id, "title": new_mod.title},
    )

    return ModuleListItem(
        id=new_mod.id,
        title=new_mod.title,
        description=new_mod.description,
        topic=new_mod.topic,
        difficulty=new_mod.difficulty,
        estimated_minutes=new_mod.estimated_minutes,
        total_xp=new_mod.total_xp,
        total_sections=len(new_mod.sections or []),
        completed_sections=0,
        version=new_mod.version,
        author=AuthorInfo(name="The Last Deploy", is_official=True),
        status=new_mod.status,
        is_official_verified=True,
    )


@router.delete("/{org_slug}/curriculum/{module_id}", response_model=MessageResponse)
async def remove_organization_module(
    org_slug: str,
    module_id: str,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Remove a module from the organization workspace."""
    org = await db.scalar(select(Organization).where(Organization.slug == org_slug.strip()))
    if not org:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Organization not found")

    mem = await db.scalar(
        select(OrganizationMembership).where(
            OrganizationMembership.organization_id == org.id,
            OrganizationMembership.user_id == current_user.id,
            OrganizationMembership.status == "active",
        )
    )
    is_platform_admin = await is_user_platform_admin(current_user, db)
    can_manage = mem and (await has_org_permission(mem, "content.publish", current_user, db) or await has_org_permission(mem, "workspace.manage", current_user, db))
    if not can_manage and not is_platform_admin:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Requires content.publish or workspace.manage permission")

    mod = (await db.execute(
        select(Module).where(
            Module.id == module_id,
            Module.owner_organization_id == org.id,
        )
    )).scalar_one_or_none()
    if not mod:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Module not found in this organization")

    await db.delete(mod)
    await db.commit()

    await log_audit_event(
        db,
        action="organization.curriculum.remove",
        entity_type="module",
        entity_id=module_id,
        actor_user_id=current_user.id,
        organization_id=org.id,
        metadata={"module_id": module_id},
    )

    return MessageResponse(detail=f"Module '{module_id}' successfully removed from {org.name}.")

