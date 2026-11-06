# web/backend/app/dependencies.py

from datetime import datetime, timezone
from fastapi import Depends, HTTPException, status, Request
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from app.database import AsyncSessionLocal
from app.auth import decode_token_payload, ensure_utc
from app.models import (
    User, UserSession, Organization, OrganizationMembership,
    MembershipRole, RolePermission, Permission,
    PlatformRole, PlatformUserRole, PlatformRolePermission, PlatformPermission
)

bearer_scheme = HTTPBearer(auto_error=False)


async def get_db():
    async with AsyncSessionLocal() as session:
        yield session


async def get_optional_session(
    credentials: HTTPAuthorizationCredentials | None = Depends(bearer_scheme),
    db: AsyncSession = Depends(get_db),
) -> UserSession | None:
    if credentials is None:
        return None

    payload = decode_token_payload(credentials.credentials)
    if not payload:
        return None

    sid = payload.get("sid")
    if sid is None:
        return None

    try:
        session_id = int(sid)
    except (ValueError, TypeError):
        return None

    result = await db.execute(select(UserSession).where(UserSession.id == session_id))
    user_session = result.scalar_one_or_none()
    if user_session is None or user_session.revoked_at is not None:
        return None

    if ensure_utc(user_session.expires_at) < datetime.now(timezone.utc):
        return None

    # Update last_used_at
    user_session.last_used_at = datetime.now(timezone.utc)
    db.add(user_session)
    await db.commit()

    return user_session


async def get_current_user(
    credentials: HTTPAuthorizationCredentials | None = Depends(bearer_scheme),
    db: AsyncSession = Depends(get_db),
) -> User:
    if credentials is None:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Not authenticated")

    payload = decode_token_payload(credentials.credentials)
    if not payload or "sub" not in payload:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid token")

    try:
        user_id = int(payload["sub"])
    except (ValueError, TypeError):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid token")

    sid = payload.get("sid")
    if sid is not None:
        try:
            session_id = int(sid)
            s_result = await db.execute(select(UserSession).where(UserSession.id == session_id))
            user_session = s_result.scalar_one_or_none()
            if user_session is None:
                raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Session not found")
            if user_session.revoked_at is not None:
                raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Session has been revoked")
            if ensure_utc(user_session.expires_at) < datetime.now(timezone.utc):
                raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Session has expired")

            user_session.last_used_at = datetime.now(timezone.utc)
            db.add(user_session)
            await db.commit()
        except HTTPException:
            raise
        except Exception:
            raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid session")

    result = await db.execute(select(User).where(User.id == user_id))
    user = result.scalar_one_or_none()
    if user is None:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="User not found")

    return user


async def get_optional_user(
    credentials: HTTPAuthorizationCredentials | None = Depends(bearer_scheme),
    db: AsyncSession = Depends(get_db),
) -> User | None:
    if credentials is None:
        return None
    try:
        return await get_current_user(credentials, db)
    except HTTPException:
        return None


# =============================================================================
# Organization Context & RBAC Dependencies
# =============================================================================

async def get_current_organization(
    request: Request,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> tuple[Organization, OrganizationMembership]:
    """
    Resolves the organization context from header 'X-Organization-Id' or 'X-Organization-Slug'.
    Defaults to the platform organization ('The Last Deploy') if unprovided.
    Validates that the user has an active membership in that organization.
    """
    org_id_header = request.headers.get("x-organization-id")
    org_slug_header = request.headers.get("x-organization-slug") or request.headers.get("x-organization")

    if org_id_header:
        try:
            target_id = int(org_id_header)
            org_stmt = select(Organization).where(Organization.id == target_id)
        except ValueError:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Invalid X-Organization-Id header")
    elif org_slug_header:
        org_stmt = select(Organization).where(Organization.slug == org_slug_header.strip())
    else:
        # Default to platform organization if member, otherwise user's first active organization
        user_platform_mem = await db.scalar(
            select(OrganizationMembership.id)
            .join(Organization, Organization.id == OrganizationMembership.organization_id)
            .where(
                OrganizationMembership.user_id == current_user.id,
                Organization.is_platform == True,
                OrganizationMembership.status == "active",
            )
        )
        if user_platform_mem:
            org_stmt = select(Organization).where(Organization.is_platform == True)
        else:
            first_mem_org = await db.scalar(
                select(OrganizationMembership.organization_id)
                .where(
                    OrganizationMembership.user_id == current_user.id,
                    OrganizationMembership.status == "active",
                )
                .order_by(OrganizationMembership.joined_at.asc())
            )
            if first_mem_org:
                org_stmt = select(Organization).where(Organization.id == first_mem_org)
            else:
                org_stmt = select(Organization).where(Organization.is_platform == True)

    org_result = await db.execute(org_stmt)
    organization = org_result.scalar_one_or_none()
    if not organization:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Organization not found")

    # Verify active membership
    mem_stmt = select(OrganizationMembership).where(
        OrganizationMembership.organization_id == organization.id,
        OrganizationMembership.user_id == current_user.id,
        OrganizationMembership.status == "active",
    )
    mem_result = await db.execute(mem_stmt)
    membership = mem_result.scalar_one_or_none()
    if not membership:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=f"You do not have an active membership in organization '{organization.slug}'",
        )

    return organization, membership


def require_permission(permission_key: str):
    """
    Dependency factory: checks if caller's active membership in the current organization
    has the specified permission key through any assigned roles.
    """
    async def _dependency(
        org_and_mem: tuple[Organization, OrganizationMembership] = Depends(get_current_organization),
        db: AsyncSession = Depends(get_db),
    ) -> OrganizationMembership:
        _, membership = org_and_mem
        stmt = (
            select(Permission.id)
            .join(RolePermission, RolePermission.permission_id == Permission.id)
            .join(MembershipRole, MembershipRole.role_id == RolePermission.role_id)
            .where(
                MembershipRole.membership_id == membership.id,
                Permission.key == permission_key,
            )
            .limit(1)
        )
        result = await db.execute(stmt)
        if result.scalar_one_or_none() is None:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail=f"Missing required permission: '{permission_key}' in this organization",
            )
        return membership

    return _dependency


def require_platform_permission(permission_key: str):
    """
    Dependency factory: checks if caller has platform staff authorization
    with the specified platform permission key.
    """
    async def _dependency(
        current_user: User = Depends(get_current_user),
        db: AsyncSession = Depends(get_db),
    ) -> User:
        stmt = (
            select(PlatformPermission.id)
            .join(PlatformRolePermission, PlatformRolePermission.permission_id == PlatformPermission.id)
            .join(PlatformUserRole, PlatformUserRole.platform_role_id == PlatformRolePermission.platform_role_id)
            .where(
                PlatformUserRole.user_id == current_user.id,
                PlatformPermission.key == permission_key,
            )
            .limit(1)
        )
        result = await db.execute(stmt)
        if result.scalar_one_or_none() is None:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail=f"Requires platform staff permission: '{permission_key}'",
            )
        return current_user

    return _dependency


async def is_user_maintainer(user: User, db: AsyncSession) -> bool:
    """Helper to check if a user has platform staff rights."""
    stmt = (
        select(PlatformUserRole.id)
        .where(PlatformUserRole.user_id == user.id)
        .limit(1)
    )
    res = await db.execute(stmt)
    return res.scalar_one_or_none() is not None


async def is_user_platform_admin(user: User, db: AsyncSession) -> bool:
    """Helper to check if a user is a platform super administrator."""
    stmt = (
        select(PlatformUserRole.id)
        .join(PlatformRole, PlatformRole.id == PlatformUserRole.platform_role_id)
        .where(
            PlatformUserRole.user_id == user.id,
            PlatformRole.slug == "platform_admin",
        )
        .limit(1)
    )
    res = await db.execute(stmt)
    return res.scalar_one_or_none() is not None
