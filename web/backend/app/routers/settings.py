# web/backend/app/routers/settings.py

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

from app.dependencies import (
    get_db,
    get_current_user,
    get_current_organization,
    require_permission,
    require_platform_permission,
    has_platform_permission,
)
from app.models import User, Organization, OrganizationMembership, OrganizationSettingAvailability
from app.schemas import (
    OrgSettingItemResponse,
    OrgSettingAdminItemResponse,
    OrgSettingUpdateRequest,
    OrgSettingEnableRequest,
)
from app.settings.service import SettingsService

router = APIRouter(prefix="/organizations/{org_slug}/settings", tags=["Organization Settings"])


# --- Organization Admin Endpoints ---

@router.get("", response_model=list[OrgSettingItemResponse])
async def list_org_settings(
    org_slug: str,
    org_and_mem: tuple[Organization, OrganizationMembership] = Depends(get_current_organization),
    db: AsyncSession = Depends(get_db),
    _perm: OrganizationMembership = Depends(require_permission("organization.manage")),
):
    """List all settings currently enabled for the organization (requires 'organization.manage')."""
    organization, _ = org_and_mem
    return await SettingsService.list_settings_for_org_admin(db, organization.id)


@router.get("/{setting_key}", response_model=OrgSettingItemResponse)
async def get_org_setting(
    org_slug: str,
    setting_key: str,
    org_and_mem: tuple[Organization, OrganizationMembership] = Depends(get_current_organization),
    db: AsyncSession = Depends(get_db),
    _perm: OrganizationMembership = Depends(require_permission("organization.manage")),
):
    """Get a single setting if enabled for the organization."""
    organization, _ = org_and_mem
    defn = SettingsService.get_definition(setting_key)
    avail = await db.scalar(
        select(OrganizationSettingAvailability.is_enabled).where(
            OrganizationSettingAvailability.organization_id == organization.id,
            OrganizationSettingAvailability.setting_key == setting_key,
        )
    )
    if not avail:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Setting '{setting_key}' is not available or enabled for this organization.",
        )
    effective_val = await SettingsService.get_effective_setting(db, organization.id, setting_key)
    return {
        "key": setting_key,
        "value": effective_val,
        "category": defn.category,
        "description": defn.description,
        "data_type": defn.data_type.value,
    }


@router.patch("/{setting_key}", response_model=OrgSettingItemResponse)
async def update_org_setting(
    org_slug: str,
    setting_key: str,
    body: OrgSettingUpdateRequest,
    org_and_mem: tuple[Organization, OrganizationMembership] = Depends(get_current_organization),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
    _perm: OrganizationMembership = Depends(require_permission("organization.manage")),
):
    """Update an enabled setting value as an organization administrator (requires 'organization.manage')."""
    organization, _ = org_and_mem
    return await SettingsService.update_setting_by_org_admin(
        db=db,
        organization_id=organization.id,
        setting_key=setting_key,
        new_value=body.value,
        actor_user_id=current_user.id,
    )


# --- Platform Staff Endpoints ---

admin_router = APIRouter(prefix="/admin/organizations/{org_slug}/settings", tags=["Platform Admin Settings"])


async def require_platform_settings_perm(
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_db),
) -> User:
    if (
        await has_platform_permission(current_user, "platform.organizations.settings", db)
        or await has_platform_permission(current_user, "organization_settings.manage", db)
        or await has_platform_permission(current_user, "platform.organizations.manage", db)
    ):
        return current_user
    raise HTTPException(
        status_code=status.HTTP_403_FORBIDDEN,
        detail="Requires platform permission: 'platform.organizations.settings'",
    )


@admin_router.get("", response_model=list[OrgSettingAdminItemResponse])
async def list_all_settings_for_platform(
    org_slug: str,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
    _perm: User = Depends(require_platform_settings_perm),
):
    """Platform staff only: view all settings and availability for an organization."""
    org = await db.scalar(select(Organization).where(Organization.slug == org_slug))
    if not org:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Organization not found")
    return await SettingsService.list_settings_for_platform_admin(db, org.id)


@admin_router.post("/{setting_key}/enable")
async def enable_setting_for_platform(
    org_slug: str,
    setting_key: str,
    body: OrgSettingEnableRequest | None = None,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
    _perm: User = Depends(require_platform_settings_perm),
):
    """Platform staff only: enable a setting for an organization."""
    org = await db.scalar(select(Organization).where(Organization.slug == org_slug))
    if not org:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Organization not found")

    initial_val = body.initial_value if body else None
    return await SettingsService.enable_setting(
        db=db,
        organization_id=org.id,
        setting_key=setting_key,
        initial_value=initial_val,
        actor_user_id=current_user.id,
    )


@admin_router.post("/{setting_key}/disable")
async def disable_setting_for_platform(
    org_slug: str,
    setting_key: str,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
    _perm: User = Depends(require_platform_settings_perm),
):
    """Platform staff only: disable a setting for an organization (preserves stored value)."""
    org = await db.scalar(select(Organization).where(Organization.slug == org_slug))
    if not org:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Organization not found")

    return await SettingsService.disable_setting(
        db=db,
        organization_id=org.id,
        setting_key=setting_key,
        actor_user_id=current_user.id,
    )


@admin_router.patch("/{setting_key}")
async def override_setting_for_platform(
    org_slug: str,
    setting_key: str,
    body: OrgSettingUpdateRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
    _perm: User = Depends(require_platform_settings_perm),
):
    """Platform staff only: override any setting value for an organization."""
    org = await db.scalar(select(Organization).where(Organization.slug == org_slug))
    if not org:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Organization not found")

    return await SettingsService.update_setting_by_platform_admin(
        db=db,
        organization_id=org.id,
        setting_key=setting_key,
        new_value=body.value,
        actor_user_id=current_user.id,
    )
