# web/backend/app/routers/analytics.py

import logging
from datetime import datetime
from typing import Any
from fastapi import APIRouter, Depends, HTTPException, Query, Response, status
from pydantic import BaseModel
from sqlalchemy.ext.asyncio import AsyncSession

from app.analytics import analytics
from app.analytics.reporting import AnalyticsServiceReporting
from app.analytics.schemas import (
    AnalyticsOverviewResponse,
    AnalyticsTrendsResponse,
    CohortAnalyticsItem,
    CohortDetailAnalyticsResponse,
    PathAnalyticsItem,
    PathDetailAnalyticsResponse,
    ContentAnalyticsResponse,
    XpAnalyticsResponse,
    LearnerAnalyticsItem,
    LearnerDetailAnalyticsResponse,
    PlatformOverviewAnalyticsResponse,
    PlatformTrendsAnalyticsResponse,
    PlatformOrgSummaryItem,
)
from app.dependencies import (
    get_db,
    get_current_user,
    get_current_organization,
    require_permission,
    require_any_permission,
    require_platform_permission,
)
from app.models import Organization, OrganizationMembership, User
from app.settings.service import SettingsService

router = APIRouter()
logger = logging.getLogger(__name__)


# ================= ANONYMOUS TELEMETRY PROXY =================

class AnalyticsTrackRequest(BaseModel):
    event: str
    properties: dict[str, Any] | None = None


@router.post("/analytics/track", status_code=status.HTTP_200_OK)
async def track_anonymous_event(body: AnalyticsTrackRequest):
    """
    Public proxy endpoint for frontend and landing page anonymous analytics.
    Enforces 100% anonymous tracking — strips IPs, headers, and user tokens.
    """
    try:
        analytics.track("anonymous", body.event, body.properties)
    except Exception as e:
        logger.error("Error in anonymous analytics proxy route: %s", e)

    return {"status": "ok"}


# ================= ORGANIZATION ANALYTICS =================

@router.get("/organizations/{org_slug}/analytics/overview", response_model=AnalyticsOverviewResponse)
async def get_org_analytics_overview(
    org_slug: str,
    membership: OrganizationMembership = Depends(require_permission("analytics.view")),
    org_and_mem: tuple[Organization, OrganizationMembership] = Depends(get_current_organization),
    db: AsyncSession = Depends(get_db),
):
    org, _ = org_and_mem
    return await AnalyticsServiceReporting.get_organization_overview(db, org)


@router.get("/organizations/{org_slug}/analytics/trends", response_model=AnalyticsTrendsResponse)
async def get_org_analytics_trends(
    org_slug: str,
    period: str = Query("30d", regex="^(7d|30d|90d|all|custom)$"),
    start_date: datetime | None = Query(None),
    end_date: datetime | None = Query(None),
    membership: OrganizationMembership = Depends(require_permission("analytics.view")),
    org_and_mem: tuple[Organization, OrganizationMembership] = Depends(get_current_organization),
    db: AsyncSession = Depends(get_db),
):
    org, _ = org_and_mem
    return await AnalyticsServiceReporting.get_organization_trends(
        db, org, period=period, start_date=start_date, end_date=end_date
    )


@router.get("/organizations/{org_slug}/analytics/cohorts", response_model=list[CohortAnalyticsItem])
async def get_org_analytics_cohorts(
    org_slug: str,
    membership: OrganizationMembership = Depends(require_permission("analytics.view")),
    org_and_mem: tuple[Organization, OrganizationMembership] = Depends(get_current_organization),
    db: AsyncSession = Depends(get_db),
):
    org, _ = org_and_mem
    return await AnalyticsServiceReporting.get_organization_cohorts(db, org)


@router.get("/organizations/{org_slug}/analytics/cohorts/{cohort_id}", response_model=CohortDetailAnalyticsResponse)
async def get_org_analytics_cohort_detail(
    org_slug: str,
    cohort_id: int,
    membership: OrganizationMembership = Depends(require_permission("analytics.view")),
    org_and_mem: tuple[Organization, OrganizationMembership] = Depends(get_current_organization),
    db: AsyncSession = Depends(get_db),
):
    org, _ = org_and_mem
    try:
        return await AnalyticsServiceReporting.get_cohort_detail(db, org, cohort_id)
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(e))


@router.get("/organizations/{org_slug}/analytics/paths", response_model=list[PathAnalyticsItem])
async def get_org_analytics_paths(
    org_slug: str,
    membership: OrganizationMembership = Depends(require_permission("analytics.view")),
    org_and_mem: tuple[Organization, OrganizationMembership] = Depends(get_current_organization),
    db: AsyncSession = Depends(get_db),
):
    org, _ = org_and_mem
    return await AnalyticsServiceReporting.get_organization_paths(db, org)


@router.get("/organizations/{org_slug}/analytics/paths/{path_id}", response_model=PathDetailAnalyticsResponse)
async def get_org_analytics_path_detail(
    org_slug: str,
    path_id: int,
    membership: OrganizationMembership = Depends(require_permission("analytics.view")),
    org_and_mem: tuple[Organization, OrganizationMembership] = Depends(get_current_organization),
    db: AsyncSession = Depends(get_db),
):
    org, _ = org_and_mem
    try:
        return await AnalyticsServiceReporting.get_path_detail(db, org, path_id)
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(e))


@router.get("/organizations/{org_slug}/analytics/content", response_model=ContentAnalyticsResponse)
async def get_org_analytics_content(
    org_slug: str,
    membership: OrganizationMembership = Depends(require_permission("analytics.view")),
    org_and_mem: tuple[Organization, OrganizationMembership] = Depends(get_current_organization),
    db: AsyncSession = Depends(get_db),
):
    org, _ = org_and_mem
    return await AnalyticsServiceReporting.get_content_analytics(db, org)


@router.get("/organizations/{org_slug}/analytics/xp", response_model=XpAnalyticsResponse)
async def get_org_analytics_xp(
    org_slug: str,
    membership: OrganizationMembership = Depends(require_permission("analytics.view")),
    org_and_mem: tuple[Organization, OrganizationMembership] = Depends(get_current_organization),
    db: AsyncSession = Depends(get_db),
):
    org, _ = org_and_mem
    return await AnalyticsServiceReporting.get_xp_analytics(db, org)


@router.get("/organizations/{org_slug}/analytics/learners", response_model=list[LearnerAnalyticsItem])
async def get_org_analytics_learners(
    org_slug: str,
    cohort_id: int | None = Query(None),
    search: str | None = Query(None),
    membership: OrganizationMembership = Depends(require_permission("analytics.view")),
    org_and_mem: tuple[Organization, OrganizationMembership] = Depends(get_current_organization),
    db: AsyncSession = Depends(get_db),
):
    org, _ = org_and_mem
    return await AnalyticsServiceReporting.get_learners_analytics(
        db, org, cohort_id=cohort_id, search=search
    )


@router.get("/organizations/{org_slug}/analytics/learners/{user_id}", response_model=LearnerDetailAnalyticsResponse)
async def get_org_analytics_learner_detail(
    org_slug: str,
    user_id: int,
    membership: OrganizationMembership = Depends(require_permission("analytics.view")),
    org_and_mem: tuple[Organization, OrganizationMembership] = Depends(get_current_organization),
    db: AsyncSession = Depends(get_db),
):
    org, _ = org_and_mem
    try:
        return await AnalyticsServiceReporting.get_learner_detail(db, org, user_id)
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(e))


@router.get("/organizations/{org_slug}/analytics/export/{export_type}")
async def export_org_analytics(
    org_slug: str,
    export_type: str,
    membership: OrganizationMembership = Depends(require_any_permission("analytics.export", "analytics.view")),
    org_and_mem: tuple[Organization, OrganizationMembership] = Depends(get_current_organization),
    db: AsyncSession = Depends(get_db),
):
    org, _ = org_and_mem

    # Check analytics.export_enabled setting!
    export_enabled = await SettingsService.get_effective_setting_value(db, org.id, "analytics.export_enabled")
    if not export_enabled:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Exporting analytics reports is disabled for this organization",
        )

    if export_type == "learners":
        csv_content = await AnalyticsServiceReporting.export_learners_csv(db, org)
    elif export_type == "activity":
        csv_content = await AnalyticsServiceReporting.export_activity_csv(db, org)
    elif export_type == "cohorts":
        csv_content = await AnalyticsServiceReporting.export_cohorts_csv(db, org)
    elif export_type == "content":
        csv_content = await AnalyticsServiceReporting.export_content_csv(db, org)
    else:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Unsupported export type '{export_type}'. Allowed types: learners, activity, cohorts, content",
        )

    return Response(
        content=csv_content,
        media_type="text/csv",
        headers={"Content-Disposition": f"attachment; filename={export_type}_{org.slug}.csv"},
    )


# ================= PLATFORM-LEVEL ANALYTICS =================

@router.get("/platform/analytics/overview", response_model=PlatformOverviewAnalyticsResponse)
async def get_platform_analytics_overview(
    current_user: User = Depends(require_platform_permission("platform.audit.view")),
    db: AsyncSession = Depends(get_db),
):
    return await AnalyticsServiceReporting.get_platform_overview(db)


@router.get("/platform/analytics/trends", response_model=PlatformTrendsAnalyticsResponse)
async def get_platform_analytics_trends(
    period: str = Query("30d", regex="^(7d|30d|90d|all|custom)$"),
    start_date: datetime | None = Query(None),
    end_date: datetime | None = Query(None),
    current_user: User = Depends(require_platform_permission("platform.audit.view")),
    db: AsyncSession = Depends(get_db),
):
    return await AnalyticsServiceReporting.get_platform_trends(
        db, period=period, start_date=start_date, end_date=end_date
    )


@router.get("/platform/analytics/organizations", response_model=list[PlatformOrgSummaryItem])
async def get_platform_analytics_organizations(
    current_user: User = Depends(require_platform_permission("platform.audit.view")),
    db: AsyncSession = Depends(get_db),
):
    return await AnalyticsServiceReporting.get_platform_organizations(db)


@router.get("/platform/analytics/export/organizations")
async def export_platform_organizations(
    current_user: User = Depends(require_platform_permission("platform.audit.view")),
    db: AsyncSession = Depends(get_db),
):
    csv_content = await AnalyticsServiceReporting.export_platform_orgs_csv(db)
    return Response(
        content=csv_content,
        media_type="text/csv",
        headers={"Content-Disposition": "attachment; filename=platform_organizations_summary.csv"},
    )
