# web/backend/app/analytics/__init__.py

from app.analytics.events import AnalyticsEvent
from app.analytics.service import AnalyticsService
from app.analytics.reporting import AnalyticsServiceReporting

analytics = AnalyticsService()

__all__ = ["analytics", "AnalyticsEvent", "AnalyticsService", "AnalyticsServiceReporting"]
