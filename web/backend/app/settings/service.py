# web/backend/app/settings/service.py

from datetime import datetime, timezone
from typing import Any
from fastapi import HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

from app.models import OrganizationSetting
from app.settings.registry import (
    get_setting_definition,
    get_all_setting_definitions,
    get_tier_eligible_settings,
    SettingDefinition,
)
from app.services import log_audit_event


class SettingsService:
    """Centralized service for managing and resolving organization settings and availability."""

    @staticmethod
    def get_definition(setting_key: str) -> SettingDefinition:
        """Retrieve a definition or raise 404."""
        definition = get_setting_definition(setting_key)
        if not definition:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Setting '{setting_key}' is not recognized in the settings registry.",
            )
        return definition

    @staticmethod
    async def get_effective_setting(db: AsyncSession, organization_id: int, setting_key: str) -> Any | None:
        """
        Get the effective setting value for an organization.
        Returns:
        - None if the setting is disabled, unavailable, or unregistered.
        - The configured DB value if enabled and customized.
        - The code default if enabled but not explicitly customized.
        """
        defn = get_setting_definition(setting_key)
        if not defn:
            return None

        setting = await db.scalar(
            select(OrganizationSetting).where(
                OrganizationSetting.organization_id == organization_id,
                OrganizationSetting.setting_key == setting_key,
            )
        )
        if not setting or not setting.is_enabled:
            return None

        if setting.value is not None:
            return setting.value
        return defn.default

    @staticmethod
    async def get_effective_setting_value(db: AsyncSession, organization_id: int, setting_key: str) -> Any:
        """
        Get the effective setting value for an organization, falling back to the registry default
        if enabled, or None if disabled or unrecognized.
        """
        return await SettingsService.get_effective_setting(db, organization_id, setting_key)

    @staticmethod
    async def list_settings_for_org_admin(db: AsyncSession, organization_id: int) -> list[dict[str, Any]]:
        """
        List settings for Organization Admins.
        Only returns settings where is_enabled == True.
        """
        stmt = (
            select(OrganizationSetting)
            .where(
                OrganizationSetting.organization_id == organization_id,
                OrganizationSetting.is_enabled == True,
            )
            .order_by(OrganizationSetting.setting_key)
        )
        rows = (await db.execute(stmt)).scalars().all()

        output = []
        for setting in rows:
            defn = get_setting_definition(setting.setting_key)
            if not defn:
                continue
            output.append({
                "key": setting.setting_key,
                "value": setting.value if setting.value is not None else defn.default,
                "category": defn.category,
                "description": defn.description,
                "data_type": defn.data_type.value,
                "required_permission": defn.required_permission,
                "updated_at": setting.updated_at,
            })
        return output

    @staticmethod
    async def list_settings_for_platform_admin(db: AsyncSession, organization_id: int) -> list[dict[str, Any]]:
        """
        List settings for TLD Platform Personnel.
        Returns ALL registered settings with their availability (enabled/disabled) and configured values.
        """
        res = await db.execute(
            select(OrganizationSetting).where(OrganizationSetting.organization_id == organization_id)
        )
        setting_map = {s.setting_key: s for s in res.scalars().all()}

        output = []
        for defn in get_all_setting_definitions():
            row = setting_map.get(defn.key)
            output.append({
                "key": defn.key,
                "is_enabled": row.is_enabled if row else False,
                "value": row.value if row else None,
                "default": defn.default,
                "category": defn.category,
                "description": defn.description,
                "data_type": defn.data_type.value,
                "allowed_values": defn.allowed_values,
                "updated_at": row.updated_at if row else None,
            })
        return output

    @staticmethod
    async def update_setting_by_org_admin(
        db: AsyncSession,
        organization_id: int,
        setting_key: str,
        new_value: Any,
        actor_user_id: int | None = None,
    ) -> dict[str, Any]:
        """Update an enabled setting value as an organization administrator."""
        defn = SettingsService.get_definition(setting_key)
        valid, err_msg = defn.validate(new_value)
        if not valid:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=err_msg)

        existing = await db.scalar(
            select(OrganizationSetting).where(
                OrganizationSetting.organization_id == organization_id,
                OrganizationSetting.setting_key == setting_key,
            )
        )
        if not existing or not existing.is_enabled:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail=f"Setting '{setting_key}' is not enabled for your organization.",
            )

        old_value = existing.value
        existing.value = new_value
        existing.updated_at = datetime.now(timezone.utc)

        await db.commit()
        await db.refresh(existing)

        await log_audit_event(
            db,
            action="organization_setting.updated",
            entity_type="organization_setting",
            entity_id=setting_key,
            actor_user_id=actor_user_id,
            organization_id=organization_id,
            metadata={"setting_key": setting_key, "old_value": old_value, "new_value": new_value, "by": "org_admin"},
        )

        return {
            "key": setting_key,
            "value": existing.value,
            "category": defn.category,
            "description": defn.description,
            "data_type": defn.data_type.value,
            "can_edit": True,
            "required_permission": defn.required_permission,
            "updated_at": existing.updated_at,
        }

    @staticmethod
    async def enable_setting(
        db: AsyncSession,
        organization_id: int,
        setting_key: str,
        initial_value: Any | None = None,
        actor_user_id: int | None = None,
    ) -> dict[str, Any]:
        """
        Enable a setting for an organization (TLD personnel operation).
        - If setting already has a stored value, retains it.
        - If no stored value exists, initializes with initial_value or registry default.
        """
        defn = SettingsService.get_definition(setting_key)

        setting = await db.scalar(
            select(OrganizationSetting).where(
                OrganizationSetting.organization_id == organization_id,
                OrganizationSetting.setting_key == setting_key,
            )
        )

        if setting:
            setting.is_enabled = True
            if setting.value is None:
                if initial_value is not None:
                    valid, err_msg = defn.validate(initial_value)
                    if not valid:
                        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=err_msg)
                    setting.value = initial_value
                else:
                    setting.value = defn.default
            setting.updated_at = datetime.now(timezone.utc)
        else:
            if initial_value is not None:
                valid, err_msg = defn.validate(initial_value)
                if not valid:
                    raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=err_msg)
                effective_val = initial_value
            else:
                effective_val = defn.default

            setting = OrganizationSetting(
                organization_id=organization_id,
                setting_key=setting_key,
                value=effective_val,
                is_enabled=True,
            )
            db.add(setting)

        await db.commit()
        await db.refresh(setting)

        await log_audit_event(
            db,
            action="organization_setting.enabled",
            entity_type="organization_setting",
            entity_id=setting_key,
            actor_user_id=actor_user_id,
            organization_id=organization_id,
            metadata={"setting_key": setting_key, "value": setting.value, "by": "platform_staff"},
        )

        return {
            "key": setting_key,
            "is_enabled": True,
            "value": setting.value,
            "data_type": defn.data_type.value,
            "updated_at": setting.updated_at,
        }

    @staticmethod
    async def disable_setting(
        db: AsyncSession,
        organization_id: int,
        setting_key: str,
        actor_user_id: int | None = None,
    ) -> dict[str, Any]:
        """
        Disable a setting for an organization (TLD personnel operation).
        Sets is_enabled = False while preserving any stored value.
        """
        defn = SettingsService.get_definition(setting_key)

        setting = await db.scalar(
            select(OrganizationSetting).where(
                OrganizationSetting.organization_id == organization_id,
                OrganizationSetting.setting_key == setting_key,
            )
        )
        if setting:
            setting.is_enabled = False
            setting.updated_at = datetime.now(timezone.utc)
        else:
            setting = OrganizationSetting(
                organization_id=organization_id,
                setting_key=setting_key,
                value=None,
                is_enabled=False,
            )
            db.add(setting)

        await db.commit()
        await db.refresh(setting)

        await log_audit_event(
            db,
            action="organization_setting.disabled",
            entity_type="organization_setting",
            entity_id=setting_key,
            actor_user_id=actor_user_id,
            organization_id=organization_id,
            metadata={"setting_key": setting_key, "by": "platform_staff"},
        )

        return {
            "key": setting_key,
            "is_enabled": False,
            "value": setting.value,
            "data_type": defn.data_type.value,
            "updated_at": setting.updated_at,
        }

    @staticmethod
    async def update_setting_by_platform_admin(
        db: AsyncSession,
        organization_id: int,
        setting_key: str,
        new_value: Any,
        actor_user_id: int | None = None,
    ) -> dict[str, Any]:
        """Update setting value directly (override) as TLD staff."""
        defn = SettingsService.get_definition(setting_key)
        valid, err_msg = defn.validate(new_value)
        if not valid:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=err_msg)

        existing = await db.scalar(
            select(OrganizationSetting).where(
                OrganizationSetting.organization_id == organization_id,
                OrganizationSetting.setting_key == setting_key,
            )
        )

        old_val = existing.value if existing else None
        if existing:
            existing.value = new_value
            existing.updated_at = datetime.now(timezone.utc)
        else:
            existing = OrganizationSetting(
                organization_id=organization_id,
                setting_key=setting_key,
                value=new_value,
                is_enabled=False,
            )
            db.add(existing)

        await db.commit()
        await db.refresh(existing)

        await log_audit_event(
            db,
            action="organization_setting.override",
            entity_type="organization_setting",
            entity_id=setting_key,
            actor_user_id=actor_user_id,
            organization_id=organization_id,
            metadata={"setting_key": setting_key, "old_value": old_val, "new_value": new_value, "by": "platform_staff"},
        )

        return {
            "key": setting_key,
            "is_enabled": existing.is_enabled,
            "value": existing.value,
            "data_type": defn.data_type.value,
            "updated_at": existing.updated_at,
        }

    @staticmethod
    async def initialize_organization_settings(
        db: AsyncSession,
        organization_id: int,
        tier: str = "free",
        auto_commit: bool = True,
    ) -> None:
        """
        Initialize settings and default values for a newly provisioned organization.
        Safe to call multiple times (never overwrites existing values).
        """
        eligible_keys = get_tier_eligible_settings(tier)
        all_defs = get_all_setting_definitions()

        for defn in all_defs:
            is_eligible = defn.key in eligible_keys
            setting = await db.scalar(
                select(OrganizationSetting).where(
                    OrganizationSetting.organization_id == organization_id,
                    OrganizationSetting.setting_key == defn.key,
                )
            )
            if not setting:
                setting = OrganizationSetting(
                    organization_id=organization_id,
                    setting_key=defn.key,
                    value=defn.default if is_eligible else None,
                    is_enabled=is_eligible,
                )
                db.add(setting)

        if auto_commit:
            await db.commit()
        else:
            await db.flush()
