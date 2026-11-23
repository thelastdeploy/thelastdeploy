# web/backend/app/analytics/schemas.py

from datetime import datetime, date
from typing import Any
from pydantic import BaseModel, ConfigDict


class AnalyticsOverviewResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    organization_id: int
    organization_slug: str
    organization_name: str
    total_members: int
    total_learners: int
    total_cohorts: int
    total_learning_paths: int
    total_modules_available: int
    total_verified_modules: int
    total_unverified_modules: int
    total_completed_labs: int
    total_completed_sections: int
    total_verified_xp: int
    total_unverified_xp: int
    learners_started: int
    learners_completed_lab: int
    learners_not_started: int


class ActivityTrendPoint(BaseModel):
    date: str
    count: int


class XpTrendPoint(BaseModel):
    date: str
    xp: int


class AnalyticsTrendsResponse(BaseModel):
    period: str
    start_date: str | None = None
    end_date: str | None = None
    lab_completions: list[ActivityTrendPoint]
    section_completions: list[ActivityTrendPoint]
    xp_earned: list[XpTrendPoint]
    new_members: list[ActivityTrendPoint]
    new_learners: list[ActivityTrendPoint]


class CohortAnalyticsItem(BaseModel):
    cohort_id: int
    name: str
    status: str
    starts_at: datetime | None = None
    ends_at: datetime | None = None
    member_count: int
    learners_started: int
    completed_labs: int
    completed_sections: int
    total_verified_xp: int
    total_unverified_xp: int


class CohortLearnerProgressItem(BaseModel):
    user_id: int
    username: str
    email: str
    joined_at: datetime | None = None
    completed_labs: int
    completed_sections: int
    verified_xp: int
    unverified_xp: int
    last_active_at: datetime | None = None


class CohortDetailAnalyticsResponse(BaseModel):
    cohort: CohortAnalyticsItem
    learners: list[CohortLearnerProgressItem]
    activity_trends: list[ActivityTrendPoint]


class PathAnalyticsItem(BaseModel):
    path_id: int
    name: str
    slug: str
    visibility: str
    status: str
    module_count: int
    module_ids: list[str]
    learners_with_access: int
    learners_with_progress: int
    completed_labs: int


class PathModuleDetailItem(BaseModel):
    module_id: str
    title: str
    status: str
    total_labs: int
    total_sections: int
    completed_labs: int


class PathDetailAnalyticsResponse(BaseModel):
    path: PathAnalyticsItem
    modules: list[PathModuleDetailItem]


class ContentItemMetric(BaseModel):
    id: str
    title: str
    status: str
    owner_organization_id: int | None = None
    is_tld_owned: bool
    completions_count: int
    distinct_learners_count: int


class ContentAnalyticsResponse(BaseModel):
    most_completed_modules: list[ContentItemMetric]
    most_completed_sections: list[ContentItemMetric]
    most_completed_labs: list[ContentItemMetric]
    least_completed_modules: list[ContentItemMetric]
    verified_modules_count: int
    unverified_modules_count: int
    verified_lab_completions: int
    unverified_lab_completions: int
    tld_owned_modules_count: int
    org_owned_modules_count: int


class XpRangeDistribution(BaseModel):
    range_label: str
    learner_count: int


class CohortXpSummary(BaseModel):
    cohort_id: int
    cohort_name: str
    verified_xp: int
    unverified_xp: int


class XpAnalyticsResponse(BaseModel):
    total_verified_xp: int
    total_unverified_xp: int
    average_xp: float
    median_xp: float
    max_xp: int
    min_xp: int
    distribution: list[XpRangeDistribution]
    cohort_xp: list[CohortXpSummary]


class LearnerAnalyticsItem(BaseModel):
    user_id: int
    username: str
    email: str
    membership_id: int
    role: str
    joined_at: datetime | None = None
    total_xp: int
    verified_xp: int
    unverified_xp: int
    completed_labs_count: int
    completed_sections_count: int
    last_active_at: datetime | None = None
    cohorts: list[str]


class LearnerCompletedLabItem(BaseModel):
    lab_id: str
    title: str
    module_id: str | None = None
    module_title: str | None = None
    xp_awarded: int
    completed_at: datetime


class LearnerCompletedSectionItem(BaseModel):
    section_id: str
    title: str
    module_id: str | None = None
    xp_awarded: int
    completed_at: datetime


class LearnerModuleProgressItem(BaseModel):
    module_id: str
    title: str
    status: str
    completed_labs: int
    total_labs: int
    completed_sections: int
    total_sections: int
    percent_complete: float


class LearnerDetailAnalyticsResponse(BaseModel):
    learner: LearnerAnalyticsItem
    completed_labs: list[LearnerCompletedLabItem]
    completed_sections: list[LearnerCompletedSectionItem]
    module_progress: list[LearnerModuleProgressItem]


class PlatformOverviewAnalyticsResponse(BaseModel):
    total_users: int
    total_organizations: int
    total_memberships: int
    total_cohorts: int
    total_learning_paths: int
    total_modules: int
    total_verified_modules: int
    total_unverified_modules: int
    total_lab_completions: int
    total_section_completions: int
    total_verified_xp: int
    total_unverified_xp: int


class PlatformTrendsAnalyticsResponse(BaseModel):
    period: str
    start_date: str | None = None
    end_date: str | None = None
    user_registrations: list[ActivityTrendPoint]
    organization_growth: list[ActivityTrendPoint]
    lab_completions: list[ActivityTrendPoint]
    section_completions: list[ActivityTrendPoint]


class PlatformOrgSummaryItem(BaseModel):
    organization_id: int
    name: str
    slug: str
    type: str
    status: str
    created_at: datetime
    member_count: int
    cohort_count: int
    lab_completions_count: int
    total_verified_xp: int
    total_unverified_xp: int
