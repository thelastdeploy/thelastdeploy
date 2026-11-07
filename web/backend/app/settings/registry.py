# web/backend/app/settings/registry.py

from dataclasses import dataclass
from enum import Enum
from typing import Any, Callable


class SettingType(str, Enum):
    BOOLEAN = "boolean"
    INTEGER = "integer"
    STRING = "string"
    LIST = "list"
    OBJECT = "object"


@dataclass(frozen=True)
class SettingDefinition:
    key: str
    data_type: SettingType
    default: Any
    category: str
    description: str
    validator: Callable[[Any], bool] | None = None
    allowed_values: list[Any] | None = None
    min_value: int | None = None
    max_value: int | None = None

    def validate(self, value: Any) -> tuple[bool, str | None]:
        """Validate a proposed value against this setting definition."""
        # 1. Type validation
        if self.data_type == SettingType.BOOLEAN:
            if not isinstance(value, bool):
                return False, f"Value for '{self.key}' must be a boolean (got {type(value).__name__})"
        elif self.data_type == SettingType.INTEGER:
            if not isinstance(value, int) or isinstance(value, bool):
                return False, f"Value for '{self.key}' must be an integer (got {type(value).__name__})"
            if self.min_value is not None and value < self.min_value:
                return False, f"Value for '{self.key}' cannot be less than {self.min_value}"
            if self.max_value is not None and value > self.max_value:
                return False, f"Value for '{self.key}' cannot be greater than {self.max_value}"
        elif self.data_type == SettingType.STRING:
            if not isinstance(value, str):
                return False, f"Value for '{self.key}' must be a string (got {type(value).__name__})"
            if self.allowed_values is not None and value not in self.allowed_values:
                return False, f"Value '{value}' is not allowed for '{self.key}'. Allowed: {self.allowed_values}"
        elif self.data_type == SettingType.LIST:
            if not isinstance(value, list):
                return False, f"Value for '{self.key}' must be a list (got {type(value).__name__})"
        elif self.data_type == SettingType.OBJECT:
            if not isinstance(value, dict):
                return False, f"Value for '{self.key}' must be a JSON object/dict (got {type(value).__name__})"

        # 2. Custom validator if defined
        if self.validator is not None:
            try:
                if not self.validator(value):
                    return False, f"Custom validation failed for '{self.key}'"
            except Exception as e:
                return False, f"Validation error for '{self.key}': {str(e)}"

        return True, None


# Centralized registry of all supported code-defined settings
_SETTINGS_REGISTRY: dict[str, SettingDefinition] = {
    "content.show_unverified": SettingDefinition(
        key="content.show_unverified",
        data_type=SettingType.BOOLEAN,
        default=False,
        category="Content",
        description="Allow learners in the organization to discover and access unverified community modules.",
    ),
    "content.allow_custom_modules": SettingDefinition(
        key="content.allow_custom_modules",
        data_type=SettingType.BOOLEAN,
        default=False,
        category="Content",
        description="Allow instructors/maintainers within the organization to author custom modules and labs.",
    ),
    "security.enforce_domain_match": SettingDefinition(
        key="security.enforce_domain_match",
        data_type=SettingType.BOOLEAN,
        default=True,
        category="Security",
        description="Enforce that newly invited members must possess an email address ending in the organization's verified domain.",
    ),
    "cohorts.max_active_cohorts": SettingDefinition(
        key="cohorts.max_active_cohorts",
        data_type=SettingType.INTEGER,
        default=5,
        min_value=1,
        max_value=500,
        category="Cohorts",
        description="Maximum number of active cohorts that can run concurrently within this organization.",
    ),
    "analytics.export_enabled": SettingDefinition(
        key="analytics.export_enabled",
        data_type=SettingType.BOOLEAN,
        default=False,
        category="Analytics",
        description="Allow organization administrators to export learner lab completion records and audit reports.",
    ),
}


def get_setting_definition(key: str) -> SettingDefinition | None:
    """Retrieve a setting definition from the registry by key."""
    return _SETTINGS_REGISTRY.get(key)


def get_all_setting_definitions() -> list[SettingDefinition]:
    """Retrieve all code-defined setting definitions."""
    return list(_SETTINGS_REGISTRY.values())


def is_registered_setting(key: str) -> bool:
    """Check if a setting key exists in the registry."""
    return key in _SETTINGS_REGISTRY


# Default settings enabled based on organization tier (Subscription entitlement boundary)
TIER_DEFAULT_SETTINGS: dict[str, set[str]] = {
    "free": {
        "content.show_unverified",
        "security.enforce_domain_match",
        "cohorts.max_active_cohorts",
    },
    "starter": {
        "content.show_unverified",
        "content.allow_custom_modules",
        "security.enforce_domain_match",
        "cohorts.max_active_cohorts",
    },
    "enterprise": {
        "content.show_unverified",
        "content.allow_custom_modules",
        "security.enforce_domain_match",
        "cohorts.max_active_cohorts",
        "analytics.export_enabled",
    },
}


def get_tier_eligible_settings(tier: str) -> set[str]:
    """Determine which settings are eligible by default for an organization tier."""
    return TIER_DEFAULT_SETTINGS.get(tier.lower(), TIER_DEFAULT_SETTINGS["free"])

