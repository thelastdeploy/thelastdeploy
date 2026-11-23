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
)
from app.schemas import (
    OrganizationResponse,
    OrganizationCreateRequest,
    OrganizationMemberResponse,
    MemberRoleUpdateRequest,
    MessageResponse,
    CohortCreateRequest,
    CohortResponse,
    CohortMemberResponse,
    LearningPathCreateRequest,
    LearningPathResponse,
    AuditLogResponse,
)
from app.services import log_audit_event

router = APIRouter(prefix="/organizations", tags=["organizations"])


@router.get("", response_model=list[OrganizationResponse])
async def list_user_organizations(
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """List all organizations the current user belongs to, along with their roles and XP in each."""
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

    responses = []
    for m in memberships:
        org = m.organization
        role_slugs = [r.role.slug for r in m.roles if r.role]
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
    return responses


@router.get("/{org_slug}", response_model=OrganizationResponse)
async def get_organization(
    org_slug: str,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
):
    """Get details of a specific organization if user is an active member."""
    stmt = (
        select(OrganizationMembership)
        .options(
            selectinload(OrganizationMembership.organization),
            selectinload(OrganizationMembership.roles).selectinload(MembershipRole.role),
        )
        .join(Organization)
        .where(
            Organization.slug == org_slug,
            OrganizationMembership.user_id == current_user.id,
            OrganizationMembership.status == "active",
        )
    )
    result = await db.execute(stmt)
    m = result.scalar_one_or_none()
    if not m:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Organization '{org_slug}' not found or you are not an active member.",
        )

    org = m.organization
    role_slugs = [r.role.slug for r in m.roles if r.role]
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
    if caller_mem.user_id == user_id:
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


@router.get("/{org_slug}/learning-paths", response_model=list[LearningPathResponse])
async def list_learning_paths(
    org_slug: str,
    org_and_mem: tuple[Organization, OrganizationMembership] = Depends(get_current_organization),
    db: AsyncSession = Depends(get_db),
):
    """List learning paths for the organization."""
    organization, _ = org_and_mem
    stmt = (
        select(LearningPath)
        .where(LearningPath.organization_id == organization.id)
        .order_by(LearningPath.created_at.desc())
    )
    result = await db.execute(stmt)
    paths = result.scalars().all()

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

    # Check slug uniqueness within organization
    existing = await db.scalar(
        select(LearningPath.id).where(
            LearningPath.organization_id == organization.id,
            LearningPath.slug == body.slug.strip(),
        )
    )
    if existing:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Learning path with slug '{body.slug}' already exists in this organization",
        )

    lp = LearningPath(
        organization_id=organization.id,
        name=body.name,
        slug=body.slug.strip(),
        description=body.description,
        visibility=body.visibility,
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
        metadata={"slug": lp.slug, "modules": lp.modules},
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

