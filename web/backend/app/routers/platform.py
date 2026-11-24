# web/backend/app/routers/platform.py

from datetime import datetime, timezone
from typing import Optional
from fastapi import APIRouter, Depends, HTTPException, Query, status
from pydantic import BaseModel
from sqlalchemy import select, func, or_
from sqlalchemy.ext.asyncio import AsyncSession

from app.database import AsyncSessionLocal
from app.dependencies import (
    get_db,
    get_current_user,
    require_platform_permission,
    has_platform_permission,
    is_user_maintainer,
    is_user_platform_admin,
)
from app.models import (
    User,
    Organization,
    PlatformPermission,
    PlatformUserPermission,
    PlatformUserRole,
    PlatformRole,
    PlatformRolePermission,
    AuditLog,
)
from app.schemas import AuditLogResponse, OrganizationResponse, MessageResponse
from app.services import log_audit_event

router = APIRouter(prefix="/platform", tags=["Platform Governance"])


# --- Schemas ---

class PlatformPermissionItem(BaseModel):
    id: int
    key: str
    description: str


class PlatformUserPermissionSummary(BaseModel):
    id: int
    username: str
    email: str
    permissions: list[str]
    assigned_at: Optional[datetime] = None


class PlatformUserAddRequest(BaseModel):
    identity: str
    permissions: list[str] = []


class PlatformUserPermissionsUpdateRequest(BaseModel):
    permissions: list[str]


class OrgStatusUpdateRequest(BaseModel):
    status: str  # 'active' | 'suspended'
    reason: Optional[str] = None


# --- Endpoints ---

@router.get("/permissions", response_model=list[PlatformPermissionItem])
async def list_available_permissions(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """List all supported platform permissions."""
    if not (await is_user_maintainer(current_user, db)):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Access restricted to platform operators",
        )
    result = await db.execute(select(PlatformPermission).order_by(PlatformPermission.key.asc()))
    perms = result.scalars().all()
    return [
        PlatformPermissionItem(id=p.id, key=p.key, description=p.description)
        for p in perms
    ]


@router.get("/users", response_model=list[PlatformUserPermissionSummary])
async def list_platform_users(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
    _perm: User = Depends(require_platform_permission("platform.permissions.manage")),
):
    """List all users who possess platform permissions."""
    # Find all user IDs present in platform_user_permissions or platform_user_roles or devuser
    perm_user_ids = select(PlatformUserPermission.user_id)
    role_user_ids = select(PlatformUserRole.user_id)
    dev_user_id = select(User.id).where(User.username == "devuser")

    combined_stmt = select(User).where(
        or_(
            User.id.in_(perm_user_ids),
            User.id.in_(role_user_ids),
            User.id.in_(dev_user_id),
        )
    ).distinct().order_by(User.username.asc())

    users = (await db.execute(combined_stmt)).scalars().all()

    # Pre-fetch all available DB permissions for devuser fallback
    all_db_perms = list((await db.scalars(select(PlatformPermission.key))).all())

    summaries = []
    for u in users:
        # Fetch direct permissions
        direct_stmt = (
            select(PlatformPermission.key, PlatformUserPermission.assigned_at)
            .join(PlatformUserPermission, PlatformUserPermission.permission_id == PlatformPermission.id)
            .where(PlatformUserPermission.user_id == u.id)
        )
        direct_res = (await db.execute(direct_stmt)).all()
        direct_keys = {row[0] for row in direct_res}
        latest_assigned_at = max([row[1] for row in direct_res], default=None)

        # Fetch role permissions
        role_stmt = (
            select(PlatformPermission.key)
            .join(PlatformRolePermission, PlatformRolePermission.permission_id == PlatformPermission.id)
            .join(PlatformUserRole, PlatformUserRole.platform_role_id == PlatformRolePermission.platform_role_id)
            .where(PlatformUserRole.user_id == u.id)
        )
        role_keys = set((await db.scalars(role_stmt)).all())

        all_keys = direct_keys | role_keys
        if u.username == "devuser":
            all_keys = set(all_db_perms)

        summaries.append(
            PlatformUserPermissionSummary(
                id=u.id,
                username=u.username,
                email=u.email,
                permissions=sorted(list(all_keys)),
                assigned_at=latest_assigned_at or u.created_at,
            )
        )

    return summaries


@router.post("/users", response_model=PlatformUserPermissionSummary)
async def add_platform_user(
    body: PlatformUserAddRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
    _perm: User = Depends(require_platform_permission("platform.permissions.manage")),
):
    """Grant a user platform access with specific permissions."""
    identity = body.identity.strip()
    if not identity:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Username or email is required")

    stmt = select(User).where((User.username == identity) | (User.email == identity))
    target_user = (await db.execute(stmt)).scalar_one_or_none()
    if not target_user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"User '{identity}' not found")

    # Fetch valid permissions from catalog
    valid_perms_res = await db.execute(select(PlatformPermission).where(PlatformPermission.key.in_(body.permissions)))
    valid_perms = valid_perms_res.scalars().all()

    # Synchronize direct permissions using diff-based update
    existing_records = (await db.scalars(
        select(PlatformUserPermission).where(PlatformUserPermission.user_id == target_user.id)
    )).all()
    existing_perm_ids = {ep.permission_id: ep for ep in existing_records}
    desired_perm_ids = {p.id for p in valid_perms}

    for pid, ep in existing_perm_ids.items():
        if pid not in desired_perm_ids:
            await db.delete(ep)

    for p in valid_perms:
        if p.id not in existing_perm_ids:
            db.add(PlatformUserPermission(
                user_id=target_user.id,
                permission_id=p.id,
                assigned_by=current_user.id,
                assigned_at=datetime.now(timezone.utc),
            ))

    await db.commit()

    await log_audit_event(
        db=db,
        organization_id=None,
        actor_user_id=current_user.id,
        action="platform.permissions.update",
        entity_type="user",
        entity_id=str(target_user.id),
        metadata={
            "target_username": target_user.username,
            "granted_permissions": [p.key for p in valid_perms],
            "assigned_by": current_user.username,
        },
    )

    return PlatformUserPermissionSummary(
        id=target_user.id,
        username=target_user.username,
        email=target_user.email,
        permissions=[p.key for p in valid_perms],
        assigned_at=datetime.now(timezone.utc),
    )


@router.get("/users/{user_id}/permissions", response_model=PlatformUserPermissionSummary)
async def get_user_permissions(
    user_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
    _perm: User = Depends(require_platform_permission("platform.permissions.manage")),
):
    """Inspect granted platform permissions for a specific user."""
    target_user = await db.get(User, user_id)
    if not target_user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")

    if target_user.username == "devuser":
        all_perms = list((await db.scalars(select(PlatformPermission.key))).all())
        return PlatformUserPermissionSummary(
            id=target_user.id,
            username=target_user.username,
            email=target_user.email,
            permissions=sorted(all_perms),
            assigned_at=target_user.created_at,
        )

    direct_keys = set((await db.scalars(
        select(PlatformPermission.key)
        .join(PlatformUserPermission, PlatformUserPermission.permission_id == PlatformPermission.id)
        .where(PlatformUserPermission.user_id == target_user.id)
    )).all())

    role_keys = set((await db.scalars(
        select(PlatformPermission.key)
        .join(PlatformRolePermission, PlatformRolePermission.permission_id == PlatformPermission.id)
        .join(PlatformUserRole, PlatformUserRole.platform_role_id == PlatformRolePermission.platform_role_id)
        .where(PlatformUserRole.user_id == target_user.id)
    )).all())

    return PlatformUserPermissionSummary(
        id=target_user.id,
        username=target_user.username,
        email=target_user.email,
        permissions=sorted(list(direct_keys | role_keys)),
        assigned_at=target_user.created_at,
    )


@router.put("/users/{user_id}/permissions", response_model=PlatformUserPermissionSummary)
async def update_user_permissions(
    user_id: int,
    body: PlatformUserPermissionsUpdateRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
    _perm: User = Depends(require_platform_permission("platform.permissions.manage")),
):
    """Update granted platform permissions for a user."""
    target_user = await db.get(User, user_id)
    if not target_user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")

    # Safety guard: prevent self-lockout of critical permissions
    if target_user.id == current_user.id and "platform.permissions.manage" not in body.permissions:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Self-lockout protection: you cannot revoke your own 'platform.permissions.manage' permission.",
        )

    # Safety guard: protect devuser root permissions
    if target_user.username == "devuser" and "platform.permissions.manage" not in body.permissions:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Cannot revoke root 'platform.permissions.manage' from superadmin devuser",
        )

    valid_perms_res = await db.execute(select(PlatformPermission).where(PlatformPermission.key.in_(body.permissions)))
    valid_perms = valid_perms_res.scalars().all()

    # Synchronize direct permissions using diff-based update
    existing_records = (await db.scalars(
        select(PlatformUserPermission).where(PlatformUserPermission.user_id == target_user.id)
    )).all()
    existing_perm_ids = {ep.permission_id: ep for ep in existing_records}
    desired_perm_ids = {p.id for p in valid_perms}

    for pid, ep in existing_perm_ids.items():
        if pid not in desired_perm_ids:
            await db.delete(ep)

    for p in valid_perms:
        if p.id not in existing_perm_ids:
            db.add(PlatformUserPermission(
                user_id=target_user.id,
                permission_id=p.id,
                assigned_by=current_user.id,
                assigned_at=datetime.now(timezone.utc),
            ))

    await db.commit()

    await log_audit_event(
        db=db,
        organization_id=None,
        actor_user_id=current_user.id,
        action="platform.permissions.update",
        entity_type="user",
        entity_id=str(target_user.id),
        metadata={
            "target_username": target_user.username,
            "granted_permissions": [p.key for p in valid_perms],
            "assigned_by": current_user.username,
        },
    )

    return PlatformUserPermissionSummary(
        id=target_user.id,
        username=target_user.username,
        email=target_user.email,
        permissions=[p.key for p in valid_perms],
        assigned_at=datetime.now(timezone.utc),
    )


@router.delete("/users/{user_id}", response_model=MessageResponse)
async def revoke_platform_user(
    user_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
    _perm: User = Depends(require_platform_permission("platform.permissions.manage")),
):
    """Revoke all platform permissions for a user."""
    target_user = await db.get(User, user_id)
    if not target_user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")

    if target_user.id == current_user.id:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Self-protection: you cannot delete or revoke your own platform operator account.",
        )

    if target_user.username == "devuser":
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Cannot revoke platform access for primary superadmin devuser",
        )

    # Delete direct permissions
    existing_perms = (await db.execute(
        select(PlatformUserPermission).where(PlatformUserPermission.user_id == target_user.id)
    )).scalars().all()
    for ep in existing_perms:
        await db.delete(ep)

    # Delete any platform roles
    existing_roles = (await db.execute(
        select(PlatformUserRole).where(PlatformUserRole.user_id == target_user.id)
    )).scalars().all()
    for er in existing_roles:
        await db.delete(er)

    await db.commit()

    await log_audit_event(
        db=db,
        organization_id=None,
        actor_user_id=current_user.id,
        action="platform.staff.revoke",
        entity_type="user",
        entity_id=str(target_user.id),
        metadata={
            "target_username": target_user.username,
            "revoked_by": current_user.username,
        },
    )

    return MessageResponse(detail=f"Platform access revoked for user '{target_user.username}'")


@router.put("/organizations/{slug}/status", response_model=OrganizationResponse)
async def update_organization_status(
    slug: str,
    body: OrgStatusUpdateRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
    _perm: User = Depends(require_platform_permission("platform.organizations.suspend")),
):
    """Suspend or reactivate a tenant organization."""
    org = await db.scalar(select(Organization).where(Organization.slug == slug))
    if not org:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Organization not found")

    if org.type == "platform" or org.slug == "tld":
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="The root TLD platform organization cannot be suspended",
        )

    new_status = body.status.lower()
    if new_status not in ["active", "suspended"]:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Status must be 'active' or 'suspended'")

    old_status = org.status
    org.status = new_status
    org.updated_at = datetime.now(timezone.utc)
    await db.commit()
    await db.refresh(org)

    await log_audit_event(
        db=db,
        organization_id=org.id,
        actor_user_id=current_user.id,
        action="platform.organization.suspend" if new_status == "suspended" else "platform.organization.activate",
        entity_type="organization",
        entity_id=str(org.id),
        metadata={
            "org_slug": org.slug,
            "old_status": old_status,
            "new_status": new_status,
            "reason": body.reason,
            "updated_by": current_user.username,
        },
    )

    return OrganizationResponse(
        id=org.id,
        name=org.name,
        slug=org.slug,
        type=org.type,
        is_platform=org.is_platform,
        status=org.status,
        domains=org.domains or [],
        roles=["platform_admin"],
        total_xp=0,
        unverified_xp=0,
        joined_at=org.created_at,
    )


@router.get("/audit-logs", response_model=list[AuditLogResponse])
async def list_platform_audit_logs(
    limit: int = Query(50, ge=1, le=200),
    offset: int = Query(0, ge=0),
    action: Optional[str] = None,
    search: Optional[str] = None,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
    _perm: User = Depends(require_platform_permission("platform.audit.view")),
):
    """View global platform security audit logs."""
    stmt = (
        select(AuditLog, User.username)
        .outerjoin(User, AuditLog.actor_user_id == User.id)
        .order_by(AuditLog.created_at.desc())
    )

    if action:
        stmt = stmt.where(AuditLog.action.ilike(f"%{action}%"))
    if search:
        stmt = stmt.where(
            or_(
                AuditLog.action.ilike(f"%{search}%"),
                AuditLog.entity_type.ilike(f"%{search}%"),
                AuditLog.entity_id.ilike(f"%{search}%"),
                User.username.ilike(f"%{search}%"),
            )
        )

    stmt = stmt.limit(limit).offset(offset)
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
