# web/backend/app/routers/organizations.py

from datetime import datetime, timezone
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, and_
from sqlalchemy.orm import selectinload

from app.dependencies import (
    get_db,
    get_current_user,
    get_current_organization,
    require_permission,
    require_platform_permission,
    is_user_maintainer,
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
)
from app.schemas import (
    OrganizationResponse,
    OrganizationCreateRequest,
    OrganizationMemberResponse,
    CohortCreateRequest,
    CohortResponse,
    LearningPathCreateRequest,
    LearningPathResponse,
    MessageResponse,
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

