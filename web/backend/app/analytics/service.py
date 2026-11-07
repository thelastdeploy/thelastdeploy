# web/backend/app/analytics/service.py

import logging
from typing import Any
from app.analytics.events import AnalyticsEvent
from app.analytics.provider import BaseAnalyticsProvider, NoOpAnalyticsProvider

logger = logging.getLogger(__name__)

# List of forbidden property keys to protect user privacy
DISALLOWED_PROPERTY_KEYS = {
    "password",
    "password_hash",
    "token",
    "reset_token",
    "verification_token",
    "device_key",
    "validator_script",
    "validator_output",
    "validator_hash",
    "output",
    "command",
    "shell_history",
    "logs",
    "user_id",
    "email",
    "username",
    "ip",
    "user",
}


class AnalyticsService:
    """Central analytics service managing anonymous events (no-op; external trackers removed)."""

    def __init__(self) -> None:
        self._provider: BaseAnalyticsProvider = NoOpAnalyticsProvider()

    def _sanitize_properties(self, properties: dict[str, Any] | None) -> dict[str, Any]:
        if not properties:
            return {}
        return {
            k: v
            for k, v in properties.items()
            if k.lower() not in DISALLOWED_PROPERTY_KEYS
        }

    def track(
        self,
        distinct_id: str | int = "anonymous",
        event: AnalyticsEvent | str = "",
        properties: dict[str, Any] | None = None,
    ) -> None:
        """Track an analytics event safely and anonymously (no-op)."""
        pass

    def shutdown(self) -> None:
        """Clean up resources on application shutdown."""
        pass
