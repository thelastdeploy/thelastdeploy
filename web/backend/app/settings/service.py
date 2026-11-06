# web/backend/app/settings/service.py

from datetime import datetime, timezone
from typing import Any
from fastapi import HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, and_

from app.models import OrganizationSettingAvailability, OrganizationSetting
from app.settings.registry import (
    get_setting_definition,
    is_registered_setting,
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
        Returns the configured value IF and ONLY IF the setting is currently enabled in availability.
        Returns None if disabled or not configured.
        """
        # 1. Check availability
        avail = await db.scalar(
            select(OrganizationSettingAvailability.is_enabled).where(
                OrganizationSettingAvailability.organization_id == organization_id,
                OrganizationSettingAvailability.setting_key == setting_key,
            )
        )
        if not avail:  # Either no record or is_enabled == False
            return None

        # 2. Query configured value
        val_record = await db.scalar(
            select(OrganizationSetting.value).where(
                OrganizationSetting.organization_id == organization_id,
                OrganizationSetting.setting_key == setting_key,
            )
        )
        return val_record

    @staticmethod
    async def list_settings_for_org_admin(db: AsyncSession, organization_id: int) -> list[dict[str, Any]]:
        """
        List settings for Organization Admins.
        Only returns settings where is_enabled == True.
        """
        stmt = (
            select(OrganizationSettingAvailability, OrganizationSetting)
            .outerjoin(
                OrganizationSetting,
                and_(
                    OrganizationSetting.organization_id == OrganizationSettingAvailability.organization_id,
                    OrganizationSetting.setting_key == OrganizationSettingAvailability.setting_key,
                ),
            )
            .where(
                OrganizationSettingAvailability.organization_id == organization_id,
                OrganizationSettingAvailability.is_enabled == True,
            )
            .order_by(OrganizationSettingAvailability.setting_key)
        )
        result = await db.execute(stmt)
        rows = result.all()

        output = []
        for avail, setting in rows:
            defn = get_setting_definition(avail.setting_key)
            if not defn:
                continue  # Skip unknown/deprecated keys
            output.append({
                "key": avail.setting_key,
                "value": setting.value if setting else defn.default,
                "category": defn.category,
                "description": defn.description,
                "data_type": defn.data_type.value,
                "updated_at": setting.updated_at if setting else avail.updated_at,
            })
        return output

    @staticmethod
    async def list_settings_for_platform_admin(db: AsyncSession, organization_id: int) -> list[dict[str, Any]]:
        """
        List settings for TLD Platform Personnel.
        Returns ALL registered settings with their availability (enabled/disabled) and configured values.
        """
        # Get existing availability and setting values
        avail_res = await db.execute(
            select(OrganizationSettingAvailability).where(OrganizationSettingAvailability.organization_id == organization_id)
        )
        avail_map = {a.setting_key: a.is_enabled for a in avail_res.scalars().all()}

        val_res = await db.execute(
            select(OrganizationSetting).where(OrganizationSetting.organization_id == organization_id)
        )
        val_map = {s.setting_key: (s.value, s.updated_at) for s in val_res.scalars().all()}

        output = []
        for defn in get_all_setting_definitions():
            is_enabled = avail_map.get(defn.key, False)
            stored_val_info = val_map.get(defn.key)
            stored_value = stored_val_info[0] if stored_val_info else None
            updated_at = stored_val_info[1] if stored_val_info else None

            output.append({
                "key": defn.key,
                "is_enabled": is_enabled,
                "value": stored_value,
                "default": defn.default,
                "category": defn.category,
                "description": defn.description,
                "data_type": defn.data_type.value,
                "updated_at": updated_at,
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
        """
        Update an enabled setting value as an organization administrator.
        Enforces:
        - Setting must exist in registry.
        - Value must validate against definition.
        - Setting must be currently enabled for the organization.
        - Records audit log.
        """
        defn = SettingsService.get_definition(setting_key)
        valid, err_msg = defn.validate(new_value)
        if not valid:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=err_msg)

        # Check availability
        avail = await db.scalar(
            select(OrganizationSettingAvailability.is_enabled).where(
                OrganizationSettingAvailability.organization_id == organization_id,
                OrganizationSettingAvailability.setting_key == setting_key,
            )
        )
        if not avail:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail=f"Setting '{setting_key}' is not enabled for your organization.",
            )

        # Upsert or update value
        existing = await db.scalar(
            select(OrganizationSetting).where(
                OrganizationSetting.organization_id == organization_id,
                OrganizationSetting.setting_key == setting_key,
            )
        )

        old_value = existing.value if existing else None
        if existing:
            existing.value = new_value
            existing.updated_at = datetime.now(timezone.utc)
        else:
            existing = OrganizationSetting(
                organization_id=organization_id,
                setting_key=setting_key,
                value=new_value,
            )
            db.add(existing)

        await db.commit()
        await db.refresh(existing)

        # Audit log
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
        - If setting already has a stored value, retains it (restores previous value).
        - If no stored value exists, initializes with initial_value or registry default.
        - Sets is_enabled = True in availability.
        - Transactional & safe to re-run.
        """
        defn = SettingsService.get_definition(setting_key)

        # 1. Update or create availability record
        avail = await db.scalar(
            select(OrganizationSettingAvailability).where(
                OrganizationSettingAvailability.organization_id == organization_id,
                OrganizationSettingAvailability.setting_key == setting_key,
            )
        )
        if avail:
            avail.is_enabled = True
            avail.updated_at = datetime.now(timezone.utc)
        else:
            avail = OrganizationSettingAvailability(
                organization_id=organization_id,
                setting_key=setting_key,
                is_enabled=True,
            )
            db.add(avail)

        # 2. Check existing value
        setting = await db.scalar(
            select(OrganizationSetting).where(
                OrganizationSetting.organization_id == organization_id,
                OrganizationSetting.setting_key == setting_key,
            )
        )

        effective_val = None
        if setting:
            # Re-enable: preserve stored value
            effective_val = setting.value
        else:
            # Newly enabled: use custom initial_value or code default
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
            )
            db.add(setting)

        await db.commit()
        await db.refresh(avail)
        await db.refresh(setting)

        # Audit log
        await log_audit_event(
            db,
            action="organization_setting.enabled",
            entity_type="organization_setting",
            entity_id=setting_key,
            actor_user_id=actor_user_id,
            organization_id=organization_id,
            metadata={"setting_key": setting_key, "value": effective_val, "by": "platform_staff"},
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
        - Sets is_enabled = False in availability.
        - Stored value in organization_settings is NEVER deleted or modified.
        - Logs audit event.
        """
        defn = SettingsService.get_definition(setting_key)

        avail = await db.scalar(
            select(OrganizationSettingAvailability).where(
                OrganizationSettingAvailability.organization_id == organization_id,
                OrganizationSettingAvailability.setting_key == setting_key,
            )
        )
        if avail:
            avail.is_enabled = False
            avail.updated_at = datetime.now(timezone.utc)
        else:
            avail = OrganizationSettingAvailability(
                organization_id=organization_id,
                setting_key=setting_key,
                is_enabled=False,
            )
            db.add(avail)

        # Keep existing setting record untouched
        setting = await db.scalar(
            select(OrganizationSetting).where(
                OrganizationSetting.organization_id == organization_id,
                OrganizationSetting.setting_key == setting_key,
            )
        )

        await db.commit()
        await db.refresh(avail)

        # Audit log
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
            "value": setting.value if setting else None,
            "data_type": defn.data_type.value,
            "updated_at": avail.updated_at,
        }

    @staticmethod
    async def update_setting_by_platform_admin(
        db: AsyncSession,
        organization_id: int,
        setting_key: str,
        new_value: Any,
        actor_user_id: int | None = None,
    ) -> dict[str, Any]:
        """
        Update setting value directly (override) as TLD staff.
        Can update even if disabled; validates type against registry.
        """
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
            )
            db.add(existing)

        # Ensure availability record exists (defaults to False if not yet enabled)
        avail = await db.scalar(
            select(OrganizationSettingAvailability).where(
                OrganizationSettingAvailability.organization_id == organization_id,
                OrganizationSettingAvailability.setting_key == setting_key,
            )
        )
        if not avail:
            avail = OrganizationSettingAvailability(
                organization_id=organization_id,
                setting_key=setting_key,
                is_enabled=False,
            )
            db.add(avail)

        await db.commit()
        await db.refresh(existing)
        await db.refresh(avail)

        # Audit log
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
            "is_enabled": avail.is_enabled,
            "value": existing.value,
            "data_type": defn.data_type.value,
            "updated_at": existing.updated_at,
        }

    @staticmethod
    async def initialize_organization_settings(
        db: AsyncSession,
        organization_id: int,
        tier: str = "free",
    ) -> None:
        """
        Initialize available settings and default values for a newly provisioned organization.
        Safe to call multiple times (never overwrites existing values).
        """
        eligible_keys = get_tier_eligible_settings(tier)

        for key in eligible_keys:
            defn = get_setting_definition(key)
            if not defn:
                continue

            # 1. Availability
            avail = await db.scalar(
                select(OrganizationSettingAvailability).where(
                    OrganizationSettingAvailability.organization_id == organization_id,
                    OrganizationSettingAvailability.setting_key == key,
                )
            )
            if not avail:
                avail = OrganizationSettingAvailability(
                    organization_id=organization_id,
                    setting_key=key,
                    is_enabled=True,
                )
                db.add(avail)

            # 2. Setting value (never overwrite existing)
            setting = await db.scalar(
                select(OrganizationSetting).where(
                    OrganizationSetting.organization_id == organization_id,
                    OrganizationSetting.setting_key == key,
                )
            )
            if not setting:
                setting = OrganizationSetting(
                    organization_id=organization_id,
                    setting_key=key,
                    value=defn.default,
                )
                db.add(setting)

        await db.commit()

