# web/backend/app/analytics/reporting.py

import csv
import io
import statistics
from datetime import datetime, date, timedelta, timezone
from typing import Any
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func, and_, or_, cast, Date, desc, asc
from sqlalchemy.orm import selectinload

from app.models import (
    Organization,
    OrganizationMembership,
    Role,
    LabProgress,
    SectionProgress,
    Cohort,
    CohortMembership,
    LearningPath,
    Module,
    Section,
    Lab,
    User,
)
from app.analytics.schemas import (
    AnalyticsOverviewResponse,
    ActivityTrendPoint,
    XpTrendPoint,
    AnalyticsTrendsResponse,
    CohortAnalyticsItem,
    CohortLearnerProgressItem,
    CohortDetailAnalyticsResponse,
    PathAnalyticsItem,
    PathModuleDetailItem,
    PathDetailAnalyticsResponse,
    ContentItemMetric,
    ContentAnalyticsResponse,
    XpRangeDistribution,
    CohortXpSummary,
    XpAnalyticsResponse,
    LearnerAnalyticsItem,
    LearnerCompletedLabItem,
    LearnerCompletedSectionItem,
    LearnerModuleProgressItem,
    LearnerDetailAnalyticsResponse,
    PlatformOverviewAnalyticsResponse,
    PlatformTrendsAnalyticsResponse,
    PlatformOrgSummaryItem,
)


def resolve_date_range(
    period: str | None,
    start_date: datetime | None,
    end_date: datetime | None,
) -> tuple[datetime | None, datetime | None]:
    """Helper to convert standard period presets or custom dates into UTC datetimes."""
    now = datetime.now(timezone.utc)
    if period == "7d":
        return now - timedelta(days=7), now
    elif period == "30d":
        return now - timedelta(days=30), now
    elif period == "90d":
        return now - timedelta(days=90), now
    elif period == "all":
        return None, None
    elif period == "custom" or (start_date or end_date):
        # Normalize naive to UTC
        s = start_date.replace(tzinfo=timezone.utc) if start_date and start_date.tzinfo is None else start_date
        e = end_date.replace(tzinfo=timezone.utc) if end_date and end_date.tzinfo is None else end_date
        return s, e
    # Default to 30d
    return now - timedelta(days=30), now


def fill_date_series(
    data_map: dict[str, int],
    start_dt: datetime | None,
    end_dt: datetime | None,
) -> list[ActivityTrendPoint]:
    """Fill gaps in date series with 0 counts between start and end dates."""
    if not start_dt or not end_dt:
        sorted_keys = sorted(data_map.keys())
        return [ActivityTrendPoint(date=k, count=data_map[k]) for k in sorted_keys]

    curr = start_dt.date()
    end_d = end_dt.date()
    points: list[ActivityTrendPoint] = []
    while curr <= end_d:
        k = curr.isoformat()
        points.append(ActivityTrendPoint(date=k, count=data_map.get(k, 0)))
        curr += timedelta(days=1)
    return points


def fill_xp_series(
    data_map: dict[str, int],
    start_dt: datetime | None,
    end_dt: datetime | None,
) -> list[XpTrendPoint]:
    """Fill gaps in XP date series with 0 counts between start and end dates."""
    if not start_dt or not end_dt:
        sorted_keys = sorted(data_map.keys())
        return [XpTrendPoint(date=k, xp=data_map[k]) for k in sorted_keys]

    curr = start_dt.date()
    end_d = end_dt.date()
    points: list[XpTrendPoint] = []
    while curr <= end_d:
        k = curr.isoformat()
        points.append(XpTrendPoint(date=k, xp=data_map.get(k, 0)))
        curr += timedelta(days=1)
    return points


class AnalyticsServiceReporting:
    """Core analytics and reporting service providing queries across Modules A-F."""

    @staticmethod
    async def get_organization_overview(db: AsyncSession, org: Organization) -> AnalyticsOverviewResponse:
        # Total active members
        total_members = await db.scalar(
            select(func.count(OrganizationMembership.id))
            .where(
                OrganizationMembership.organization_id == org.id,
                OrganizationMembership.status == "active",
            )
        ) or 0

        # Total learners
        total_learners = await db.scalar(
            select(func.count(func.distinct(OrganizationMembership.id)))
            .join(Role, Role.id == OrganizationMembership.role_id)
            .where(
                OrganizationMembership.organization_id == org.id,
                OrganizationMembership.status == "active",
                Role.slug == "learner",
            )
        ) or 0

        # Cohorts & Learning paths
        total_cohorts = await db.scalar(
            select(func.count(Cohort.id)).where(Cohort.organization_id == org.id)
        ) or 0

        total_paths = await db.scalar(
            select(func.count(LearningPath.id)).where(LearningPath.organization_id == org.id)
        ) or 0

        # Modules available to this org: verified TLD modules or modules owned by org
        modules_res = await db.execute(
            select(Module.id, Module.status)
            .where(
                or_(
                    Module.status == "verified",
                    Module.owner_organization_id == org.id,
                )
            )
        )
        avail_mods = modules_res.all()
        total_modules_available = len(avail_mods)
        total_verified_modules = sum(1 for m in avail_mods if m.status == "verified")
        total_unverified_modules = total_modules_available - total_verified_modules

        # Completions in this organization
        total_completed_labs = await db.scalar(
            select(func.count(LabProgress.id))
            .join(OrganizationMembership, OrganizationMembership.id == LabProgress.organization_membership_id)
            .where(OrganizationMembership.organization_id == org.id)
        ) or 0

        total_completed_sections = await db.scalar(
            select(func.count(SectionProgress.id))
            .join(OrganizationMembership, OrganizationMembership.id == SectionProgress.organization_membership_id)
            .where(OrganizationMembership.organization_id == org.id)
        ) or 0

        # Authoritative XP from organization_memberships
        xp_res = await db.execute(
            select(
                func.coalesce(func.sum(OrganizationMembership.total_xp), 0),
                func.coalesce(func.sum(OrganizationMembership.unverified_xp), 0),
            )
            .where(
                OrganizationMembership.organization_id == org.id,
                OrganizationMembership.status == "active",
            )
        )
        row = xp_res.first()
        total_verified_xp = int(row[0]) if row else 0
        total_unverified_xp = int(row[1]) if row else 0

        # Learners who have started learning (completed >= 1 lab or section in this org)
        lab_learner_ids = select(OrganizationMembership.id).join(
            LabProgress, LabProgress.organization_membership_id == OrganizationMembership.id
        ).where(
            OrganizationMembership.organization_id == org.id,
            OrganizationMembership.status == "active",
        )
        sec_learner_ids = select(OrganizationMembership.id).join(
            SectionProgress, SectionProgress.organization_membership_id == OrganizationMembership.id
        ).where(
            OrganizationMembership.organization_id == org.id,
            OrganizationMembership.status == "active",
        )
        started_union = lab_learner_ids.union(sec_learner_ids).subquery()

        learners_started = await db.scalar(
            select(func.count(func.distinct(OrganizationMembership.id)))
            .join(Role, Role.id == OrganizationMembership.role_id)
            .where(
                OrganizationMembership.id.in_(select(started_union.c.id)),
                Role.slug == "learner",
            )
        ) or 0

        # Learners who have completed at least one lab
        learners_completed_lab = await db.scalar(
            select(func.count(func.distinct(OrganizationMembership.id)))
            .join(Role, Role.id == OrganizationMembership.role_id)
            .join(LabProgress, LabProgress.organization_membership_id == OrganizationMembership.id)
            .where(
                OrganizationMembership.organization_id == org.id,
                OrganizationMembership.status == "active",
                Role.slug == "learner",
            )
        ) or 0

        learners_not_started = max(0, total_learners - learners_started)

        return AnalyticsOverviewResponse(
            organization_id=org.id,
            organization_slug=org.slug,
            organization_name=org.name,
            total_members=total_members,
            total_learners=total_learners,
            total_cohorts=total_cohorts,
            total_learning_paths=total_paths,
            total_modules_available=total_modules_available,
            total_verified_modules=total_verified_modules,
            total_unverified_modules=total_unverified_modules,
            total_completed_labs=total_completed_labs,
            total_completed_sections=total_completed_sections,
            total_verified_xp=total_verified_xp,
            total_unverified_xp=total_unverified_xp,
            learners_started=learners_started,
            learners_completed_lab=learners_completed_lab,
            learners_not_started=learners_not_started,
        )

    @staticmethod
    async def get_organization_trends(
        db: AsyncSession,
        org: Organization,
        period: str = "30d",
        start_date: datetime | None = None,
        end_date: datetime | None = None,
    ) -> AnalyticsTrendsResponse:
        s_dt, e_dt = resolve_date_range(period, start_date, end_date)

        # 1. Lab completions over time
        lab_q = (
            select(cast(LabProgress.created_at, Date), func.count(LabProgress.id))
            .join(OrganizationMembership, OrganizationMembership.id == LabProgress.organization_membership_id)
            .where(OrganizationMembership.organization_id == org.id)
        )
        if s_dt:
            lab_q = lab_q.where(LabProgress.created_at >= s_dt)
        if e_dt:
            lab_q = lab_q.where(LabProgress.created_at <= e_dt)
        lab_q = lab_q.group_by(cast(LabProgress.created_at, Date)).order_by(cast(LabProgress.created_at, Date).asc())
        lab_rows = (await db.execute(lab_q)).all()
        lab_map = {row[0].isoformat(): int(row[1]) for row in lab_rows if row[0]}

        # 2. Section completions over time
        sec_q = (
            select(cast(SectionProgress.created_at, Date), func.count(SectionProgress.id))
            .join(OrganizationMembership, OrganizationMembership.id == SectionProgress.organization_membership_id)
            .where(OrganizationMembership.organization_id == org.id)
        )
        if s_dt:
            sec_q = sec_q.where(SectionProgress.created_at >= s_dt)
        if e_dt:
            sec_q = sec_q.where(SectionProgress.created_at <= e_dt)
        sec_q = sec_q.group_by(cast(SectionProgress.created_at, Date)).order_by(cast(SectionProgress.created_at, Date).asc())
        sec_rows = (await db.execute(sec_q)).all()
        sec_map = {row[0].isoformat(): int(row[1]) for row in sec_rows if row[0]}

        # 3. XP earned over time (lab progress xp + section progress xp)
        xp_lab_q = (
            select(cast(LabProgress.created_at, Date), func.coalesce(func.sum(LabProgress.xp_awarded), 0))
            .join(OrganizationMembership, OrganizationMembership.id == LabProgress.organization_membership_id)
            .where(OrganizationMembership.organization_id == org.id)
        )
        if s_dt:
            xp_lab_q = xp_lab_q.where(LabProgress.created_at >= s_dt)
        if e_dt:
            xp_lab_q = xp_lab_q.where(LabProgress.created_at <= e_dt)
        xp_lab_q = xp_lab_q.group_by(cast(LabProgress.created_at, Date))
        xp_lab_rows = (await db.execute(xp_lab_q)).all()

        xp_sec_q = (
            select(cast(SectionProgress.created_at, Date), func.coalesce(func.sum(SectionProgress.xp_awarded), 0))
            .join(OrganizationMembership, OrganizationMembership.id == SectionProgress.organization_membership_id)
            .where(OrganizationMembership.organization_id == org.id)
        )
        if s_dt:
            xp_sec_q = xp_sec_q.where(SectionProgress.created_at >= s_dt)
        if e_dt:
            xp_sec_q = xp_sec_q.where(SectionProgress.created_at <= e_dt)
        xp_sec_q = xp_sec_q.group_by(cast(SectionProgress.created_at, Date))
        xp_sec_rows = (await db.execute(xp_sec_q)).all()

        xp_map: dict[str, int] = {}
        for row in xp_lab_rows:
            if row[0]:
                k = row[0].isoformat()
                xp_map[k] = xp_map.get(k, 0) + int(row[1])
        for row in xp_sec_rows:
            if row[0]:
                k = row[0].isoformat()
                xp_map[k] = xp_map.get(k, 0) + int(row[1])

        # 4. New members over time
        mem_q = (
            select(cast(OrganizationMembership.joined_at, Date), func.count(OrganizationMembership.id))
            .where(
                OrganizationMembership.organization_id == org.id,
                OrganizationMembership.status != "removed",
            )
        )
        if s_dt:
            mem_q = mem_q.where(OrganizationMembership.joined_at >= s_dt)
        if e_dt:
            mem_q = mem_q.where(OrganizationMembership.joined_at <= e_dt)
        mem_q = mem_q.group_by(cast(OrganizationMembership.joined_at, Date)).order_by(cast(OrganizationMembership.joined_at, Date).asc())
        mem_rows = (await db.execute(mem_q)).all()
        mem_map = {row[0].isoformat(): int(row[1]) for row in mem_rows if row[0]}

        # 5. New learners over time
        lrn_q = (
            select(cast(OrganizationMembership.joined_at, Date), func.count(func.distinct(OrganizationMembership.id)))
            .join(Role, Role.id == OrganizationMembership.role_id)
            .where(
                OrganizationMembership.organization_id == org.id,
                OrganizationMembership.status != "removed",
                Role.slug == "learner",
            )
        )
        if s_dt:
            lrn_q = lrn_q.where(OrganizationMembership.joined_at >= s_dt)
        if e_dt:
            lrn_q = lrn_q.where(OrganizationMembership.joined_at <= e_dt)
        lrn_q = lrn_q.group_by(cast(OrganizationMembership.joined_at, Date)).order_by(cast(OrganizationMembership.joined_at, Date).asc())
        lrn_rows = (await db.execute(lrn_q)).all()
        lrn_map = {row[0].isoformat(): int(row[1]) for row in lrn_rows if row[0]}

        return AnalyticsTrendsResponse(
            period=period,
            start_date=s_dt.isoformat() if s_dt else None,
            end_date=e_dt.isoformat() if e_dt else None,
            lab_completions=fill_date_series(lab_map, s_dt, e_dt),
            section_completions=fill_date_series(sec_map, s_dt, e_dt),
            xp_earned=fill_xp_series(xp_map, s_dt, e_dt),
            new_members=fill_date_series(mem_map, s_dt, e_dt),
            new_learners=fill_date_series(lrn_map, s_dt, e_dt),
        )

    @staticmethod
    async def get_organization_cohorts(db: AsyncSession, org: Organization) -> list[CohortAnalyticsItem]:
        cohorts = (
            await db.execute(
                select(Cohort)
                .where(Cohort.organization_id == org.id)
                .order_by(Cohort.created_at.desc())
            )
        ).scalars().all()

        results: list[CohortAnalyticsItem] = []
        for c in cohorts:
            # Active member IDs in cohort
            cm_rows = (
                await db.execute(
                    select(CohortMembership.organization_membership_id)
                    .where(
                        CohortMembership.cohort_id == c.id,
                        CohortMembership.removed_at.is_(None),
                    )
                )
            ).scalars().all()
            mem_ids = list(cm_rows)
            member_count = len(mem_ids)

            if member_count == 0:
                results.append(
                    CohortAnalyticsItem(
                        cohort_id=c.id,
                        name=c.name,
                        status=c.status,
                        starts_at=c.starts_at,
                        ends_at=c.ends_at,
                        member_count=0,
                        learners_started=0,
                        completed_labs=0,
                        completed_sections=0,
                        total_verified_xp=0,
                        total_unverified_xp=0,
                    )
                )
                continue

            # Completed labs and sections by cohort members
            lab_count = await db.scalar(
                select(func.count(LabProgress.id)).where(LabProgress.organization_membership_id.in_(mem_ids))
            ) or 0

            sec_count = await db.scalar(
                select(func.count(SectionProgress.id)).where(SectionProgress.organization_membership_id.in_(mem_ids))
            ) or 0

            # Learners started (>= 1 lab)
            started_count = await db.scalar(
                select(func.count(func.distinct(LabProgress.organization_membership_id))).where(
                    LabProgress.organization_membership_id.in_(mem_ids)
                )
            ) or 0

            # Sum verified and unverified XP
            xp_row = (
                await db.execute(
                    select(
                        func.coalesce(func.sum(OrganizationMembership.total_xp), 0),
                        func.coalesce(func.sum(OrganizationMembership.unverified_xp), 0),
                    ).where(OrganizationMembership.id.in_(mem_ids))
                )
            ).first()
            ver_xp = int(xp_row[0]) if xp_row else 0
            unver_xp = int(xp_row[1]) if xp_row else 0

            results.append(
                CohortAnalyticsItem(
                    cohort_id=c.id,
                    name=c.name,
                    status=c.status,
                    starts_at=c.starts_at,
                    ends_at=c.ends_at,
                    member_count=member_count,
                    learners_started=started_count,
                    completed_labs=lab_count,
                    completed_sections=sec_count,
                    total_verified_xp=ver_xp,
                    total_unverified_xp=unver_xp,
                )
            )

        return results

    @staticmethod
    async def get_cohort_detail(db: AsyncSession, org: Organization, cohort_id: int) -> CohortDetailAnalyticsResponse:
        cohort = (
            await db.execute(
                select(Cohort).where(Cohort.id == cohort_id, Cohort.organization_id == org.id)
            )
        ).scalar_one_or_none()
        if not cohort:
            raise ValueError(f"Cohort with id {cohort_id} not found in this organization")

        # Members in cohort
        cm_stmt = (
            select(CohortMembership, OrganizationMembership, User)
            .join(OrganizationMembership, OrganizationMembership.id == CohortMembership.organization_membership_id)
            .join(User, User.id == OrganizationMembership.user_id)
            .where(
                CohortMembership.cohort_id == cohort.id,
                CohortMembership.removed_at.is_(None),
            )
            .order_by(User.username.asc())
        )
        cm_rows = (await db.execute(cm_stmt)).all()

        learners: list[CohortLearnerProgressItem] = []
        mem_ids = []
        for cm, mem, user in cm_rows:
            mem_ids.append(mem.id)
            # Count completions
            lab_cnt = await db.scalar(
                select(func.count(LabProgress.id)).where(LabProgress.organization_membership_id == mem.id)
            ) or 0
            sec_cnt = await db.scalar(
                select(func.count(SectionProgress.id)).where(SectionProgress.organization_membership_id == mem.id)
            ) or 0

            # Latest activity
            last_lab = await db.scalar(
                select(func.max(LabProgress.created_at)).where(LabProgress.organization_membership_id == mem.id)
            )
            last_sec = await db.scalar(
                select(func.max(SectionProgress.created_at)).where(SectionProgress.organization_membership_id == mem.id)
            )
            latest_active = max(filter(None, [last_lab, last_sec]), default=None)

            learners.append(
                CohortLearnerProgressItem(
                    user_id=user.id,
                    username=user.username,
                    email=user.email,
                    joined_at=cm.joined_at,
                    completed_labs=lab_cnt,
                    completed_sections=sec_cnt,
                    verified_xp=mem.total_xp,
                    unverified_xp=mem.unverified_xp,
                    last_active_at=latest_active,
                )
            )

        # Activity trends for this cohort
        activity_trends: list[ActivityTrendPoint] = []
        if mem_ids:
            trend_q = (
                select(cast(LabProgress.created_at, Date), func.count(LabProgress.id))
                .where(LabProgress.organization_membership_id.in_(mem_ids))
                .group_by(cast(LabProgress.created_at, Date))
                .order_by(cast(LabProgress.created_at, Date).asc())
            )
            trend_rows = (await db.execute(trend_q)).all()
            activity_trends = [ActivityTrendPoint(date=r[0].isoformat(), count=int(r[1])) for r in trend_rows if r[0]]

        total_labs = sum(l.completed_labs for l in learners)
        total_secs = sum(l.completed_sections for l in learners)
        total_ver = sum(l.verified_xp for l in learners)
        total_unver = sum(l.unverified_xp for l in learners)
        started = sum(1 for l in learners if l.completed_labs > 0)

        cohort_item = CohortAnalyticsItem(
            cohort_id=cohort.id,
            name=cohort.name,
            status=cohort.status,
            starts_at=cohort.starts_at,
            ends_at=cohort.ends_at,
            member_count=len(learners),
            learners_started=started,
            completed_labs=total_labs,
            completed_sections=total_secs,
            total_verified_xp=total_ver,
            total_unverified_xp=total_unver,
        )

        return CohortDetailAnalyticsResponse(
            cohort=cohort_item,
            learners=learners,
            activity_trends=activity_trends,
        )

    @staticmethod
    async def get_organization_paths(db: AsyncSession, org: Organization) -> list[PathAnalyticsItem]:
        paths = (
            await db.execute(
                select(LearningPath)
                .where(LearningPath.organization_id == org.id)
                .order_by(LearningPath.created_at.desc())
            )
        ).scalars().all()

        total_org_members = await db.scalar(
            select(func.count(OrganizationMembership.id)).where(
                OrganizationMembership.organization_id == org.id,
                OrganizationMembership.status == "active",
            )
        ) or 0

        # Preload section-to-labs map to resolve path modules -> labs
        sections_rows = (await db.execute(select(Section.id, Section.labs))).all()
        sec_labs_map: dict[str, list[str]] = {r[0]: (r[1] or []) for r in sections_rows}

        modules_rows = (await db.execute(select(Module.id, Module.sections))).all()
        mod_sections_map: dict[str, list[str]] = {r[0]: (r[1] or []) for r in modules_rows}

        results: list[PathAnalyticsItem] = []
        for p in paths:
            mod_ids = p.modules or []
            # Resolve all lab IDs in this path's modules
            path_lab_ids: set[str] = set()
            for m_id in mod_ids:
                s_list = mod_sections_map.get(m_id, [])
                for s_id in s_list:
                    for l_id in sec_labs_map.get(s_id, []):
                        path_lab_ids.add(l_id)

            # Learners with access
            if p.visibility in ["public", "organization"]:
                learners_with_access = total_org_members
            else:
                # Private: assigned via cohorts that include p.id in learning_paths
                cohorts_with_path = (
                    await db.execute(
                        select(Cohort.id).where(
                            Cohort.organization_id == org.id,
                            Cohort.learning_paths.contains([p.id]),
                        )
                    )
                ).scalars().all()
                if cohorts_with_path:
                    learners_with_access = await db.scalar(
                        select(func.count(func.distinct(CohortMembership.organization_membership_id)))
                        .where(
                            CohortMembership.cohort_id.in_(cohorts_with_path),
                            CohortMembership.removed_at.is_(None),
                        )
                    ) or 0
                else:
                    learners_with_access = 0

            # Learners with progress and completed labs
            if path_lab_ids:
                lab_list = list(path_lab_ids)
                learners_with_prog = await db.scalar(
                    select(func.count(func.distinct(LabProgress.organization_membership_id)))
                    .join(OrganizationMembership, OrganizationMembership.id == LabProgress.organization_membership_id)
                    .where(
                        OrganizationMembership.organization_id == org.id,
                        LabProgress.lab_id.in_(lab_list),
                    )
                ) or 0

                completed_labs_count = await db.scalar(
                    select(func.count(LabProgress.id))
                    .join(OrganizationMembership, OrganizationMembership.id == LabProgress.organization_membership_id)
                    .where(
                        OrganizationMembership.organization_id == org.id,
                        LabProgress.lab_id.in_(lab_list),
                    )
                ) or 0
            else:
                learners_with_prog = 0
                completed_labs_count = 0

            results.append(
                PathAnalyticsItem(
                    path_id=p.id,
                    name=p.name,
                    slug=p.slug,
                    visibility=p.visibility,
                    status=p.status,
                    module_count=len(mod_ids),
                    module_ids=mod_ids,
                    learners_with_access=learners_with_access,
                    learners_with_progress=learners_with_prog,
                    completed_labs=completed_labs_count,
                )
            )

        return results

    @staticmethod
    async def get_path_detail(db: AsyncSession, org: Organization, path_id: int) -> PathDetailAnalyticsResponse:
        paths = await AnalyticsServiceReporting.get_organization_paths(db, org)
        matched_item = next((p for p in paths if p.path_id == path_id), None)
        if not matched_item:
            raise ValueError(f"Learning path with id {path_id} not found in this organization")

        # Load modules details
        path_mod_ids = matched_item.module_ids
        modules = (
            await db.execute(
                select(Module).where(Module.id.in_(path_mod_ids))
            )
        ).scalars().all() if path_mod_ids else []

        sections_rows = (await db.execute(select(Section.id, Section.labs))).all()
        sec_labs_map: dict[str, list[str]] = {r[0]: (r[1] or []) for r in sections_rows}

        module_details: list[PathModuleDetailItem] = []
        for m in modules:
            sec_ids = m.sections or []
            all_labs: list[str] = []
            for sid in sec_ids:
                all_labs.extend(sec_labs_map.get(sid, []))

            # Lab completions in this module by org members
            if all_labs:
                comp_labs = await db.scalar(
                    select(func.count(LabProgress.id))
                    .join(OrganizationMembership, OrganizationMembership.id == LabProgress.organization_membership_id)
                    .where(
                        OrganizationMembership.organization_id == org.id,
                        LabProgress.lab_id.in_(all_labs),
                    )
                ) or 0
            else:
                comp_labs = 0

            module_details.append(
                PathModuleDetailItem(
                    module_id=m.id,
                    title=m.title,
                    status=m.status,
                    total_labs=len(all_labs),
                    total_sections=len(sec_ids),
                    completed_labs=comp_labs,
                )
            )

        return PathDetailAnalyticsResponse(
            path=matched_item,
            modules=module_details,
        )

    @staticmethod
    async def get_content_analytics(db: AsyncSession, org: Organization) -> ContentAnalyticsResponse:
        # Load all modules available to this organization
        modules = (
            await db.execute(
                select(Module).where(
                    or_(
                        Module.status == "verified",
                        Module.owner_organization_id == org.id,
                    )
                )
            )
        ).scalars().all()

        sections = (
            await db.execute(
                select(Section).where(
                    or_(
                        Section.owner_organization_id == org.id,
                        Section.owner_organization_id == 1,
                    )
                )
            )
        ).scalars().all()

        labs = (
            await db.execute(
                select(Lab).where(
                    or_(
                        Lab.owner_organization_id == org.id,
                        Lab.owner_organization_id == 1,
                    )
                )
            )
        ).scalars().all()

        sec_dict = {s.id: s for s in sections}
        lab_dict = {l.id: l for l in labs}

        # Lab completions aggregated for this organization
        lab_comp_q = (
            select(
                LabProgress.lab_id,
                func.count(LabProgress.id).label("total_comp"),
                func.count(func.distinct(LabProgress.organization_membership_id)).label("distinct_learners"),
            )
            .join(OrganizationMembership, OrganizationMembership.id == LabProgress.organization_membership_id)
            .where(OrganizationMembership.organization_id == org.id)
            .group_by(LabProgress.lab_id)
        )
        lab_comp_rows = (await db.execute(lab_comp_q)).all()
        lab_stats: dict[str, tuple[int, int]] = {r[0]: (int(r[1]), int(r[2])) for r in lab_comp_rows}

        # Section completions aggregated for this organization
        sec_comp_q = (
            select(
                SectionProgress.section_id,
                func.count(SectionProgress.id).label("total_comp"),
                func.count(func.distinct(SectionProgress.organization_membership_id)).label("distinct_learners"),
            )
            .join(OrganizationMembership, OrganizationMembership.id == SectionProgress.organization_membership_id)
            .where(OrganizationMembership.organization_id == org.id)
            .group_by(SectionProgress.section_id)
        )
        sec_comp_rows = (await db.execute(sec_comp_q)).all()
        sec_stats: dict[str, tuple[int, int]] = {r[0]: (int(r[1]), int(r[2])) for r in sec_comp_rows}

        # Compute metrics for each lab
        lab_metrics: list[ContentItemMetric] = []
        for lab_id, (comp_cnt, lrn_cnt) in lab_stats.items():
            l_obj = lab_dict.get(lab_id)
            lab_metrics.append(
                ContentItemMetric(
                    id=lab_id,
                    title=l_obj.title if l_obj else lab_id,
                    status="verified" if (l_obj and l_obj.owner_organization_id == 1) else "custom",
                    owner_organization_id=l_obj.owner_organization_id if l_obj else None,
                    is_tld_owned=(l_obj.owner_organization_id == 1 if l_obj else False),
                    completions_count=comp_cnt,
                    distinct_learners_count=lrn_cnt,
                )
            )
        lab_metrics.sort(key=lambda x: x.completions_count, reverse=True)

        # Compute metrics for each section
        sec_metrics: list[ContentItemMetric] = []
        for sec_id, (comp_cnt, lrn_cnt) in sec_stats.items():
            s_obj = sec_dict.get(sec_id)
            sec_metrics.append(
                ContentItemMetric(
                    id=sec_id,
                    title=s_obj.title if s_obj else sec_id,
                    status="verified" if (s_obj and s_obj.owner_organization_id == 1) else "custom",
                    owner_organization_id=s_obj.owner_organization_id if s_obj else None,
                    is_tld_owned=(s_obj.owner_organization_id == 1 if s_obj else False),
                    completions_count=comp_cnt,
                    distinct_learners_count=lrn_cnt,
                )
            )
        sec_metrics.sort(key=lambda x: x.completions_count, reverse=True)

        # Compute metrics for each module
        module_metrics: list[ContentItemMetric] = []
        verified_mod_count = 0
        unverified_mod_count = 0
        tld_mod_count = 0
        org_mod_count = 0

        verified_lab_comps = 0
        unverified_lab_comps = 0

        for m in modules:
            is_verified = (m.status == "verified")
            is_tld = (m.owner_organization_id == 1 or m.owner_organization_id is None)

            if is_verified:
                verified_mod_count += 1
            else:
                unverified_mod_count += 1

            if is_tld:
                tld_mod_count += 1
            else:
                org_mod_count += 1

            # Aggregate lab completions in this module
            mod_labs: list[str] = []
            for sid in (m.sections or []):
                s_obj = sec_dict.get(sid)
                if s_obj and s_obj.labs:
                    mod_labs.extend(s_obj.labs)

            tot_comp = 0
            distinct_lrns: set[str] = set()
            for lid in mod_labs:
                c_cnt, _ = lab_stats.get(lid, (0, 0))
                tot_comp += c_cnt
                if is_verified:
                    verified_lab_comps += c_cnt
                else:
                    unverified_lab_comps += c_cnt

            # Query distinct learners for this module if any labs
            if mod_labs:
                distinct_cnt = await db.scalar(
                    select(func.count(func.distinct(LabProgress.organization_membership_id)))
                    .join(OrganizationMembership, OrganizationMembership.id == LabProgress.organization_membership_id)
                    .where(
                        OrganizationMembership.organization_id == org.id,
                        LabProgress.lab_id.in_(mod_labs),
                    )
                ) or 0
            else:
                distinct_cnt = 0

            module_metrics.append(
                ContentItemMetric(
                    id=m.id,
                    title=m.title,
                    status=m.status,
                    owner_organization_id=m.owner_organization_id,
                    is_tld_owned=is_tld,
                    completions_count=tot_comp,
                    distinct_learners_count=distinct_cnt,
                )
            )

        module_metrics.sort(key=lambda x: x.completions_count, reverse=True)
        least_completed_modules = sorted(module_metrics, key=lambda x: x.completions_count)[:10]

        return ContentAnalyticsResponse(
            most_completed_modules=module_metrics[:10],
            most_completed_sections=sec_metrics[:10],
            most_completed_labs=lab_metrics[:10],
            least_completed_modules=least_completed_modules,
            verified_modules_count=verified_mod_count,
            unverified_modules_count=unverified_mod_count,
            verified_lab_completions=verified_lab_comps,
            unverified_lab_completions=unverified_lab_comps,
            tld_owned_modules_count=tld_mod_count,
            org_owned_modules_count=org_mod_count,
        )

    @staticmethod
    async def get_xp_analytics(db: AsyncSession, org: Organization) -> XpAnalyticsResponse:
        # Load all active member total_xp & unverified_xp
        mems = (
            await db.execute(
                select(OrganizationMembership.total_xp, OrganizationMembership.unverified_xp)
                .where(
                    OrganizationMembership.organization_id == org.id,
                    OrganizationMembership.status == "active",
                )
            )
        ).all()

        xp_list = [int(m[0]) for m in mems]
        unver_list = [int(m[1]) for m in mems]

        total_ver = sum(xp_list)
        total_unver = sum(unver_list)

        avg_xp = float(statistics.mean(xp_list)) if xp_list else 0.0
        med_xp = float(statistics.median(xp_list)) if xp_list else 0.0
        max_xp = max(xp_list) if xp_list else 0
        min_xp = min(xp_list) if xp_list else 0

        # Distribution buckets
        b_0 = sum(1 for x in xp_list if x == 0)
        b_1_100 = sum(1 for x in xp_list if 1 <= x <= 100)
        b_101_500 = sum(1 for x in xp_list if 101 <= x <= 500)
        b_501_1000 = sum(1 for x in xp_list if 501 <= x <= 1000)
        b_1001_plus = sum(1 for x in xp_list if x > 1000)

        distribution = [
            XpRangeDistribution(range_label="0 XP", learner_count=b_0),
            XpRangeDistribution(range_label="1 - 100 XP", learner_count=b_1_100),
            XpRangeDistribution(range_label="101 - 500 XP", learner_count=b_101_500),
            XpRangeDistribution(range_label="501 - 1000 XP", learner_count=b_501_1000),
            XpRangeDistribution(range_label="1001+ XP", learner_count=b_1001_plus),
        ]

        # Cohort XP breakdown
        cohorts = (
            await db.execute(
                select(Cohort).where(Cohort.organization_id == org.id)
            )
        ).scalars().all()

        cohort_xp_summaries: list[CohortXpSummary] = []
        for c in cohorts:
            mem_ids = (
                await db.execute(
                    select(CohortMembership.organization_membership_id)
                    .where(
                        CohortMembership.cohort_id == c.id,
                        CohortMembership.removed_at.is_(None),
                    )
                )
            ).scalars().all()
            if mem_ids:
                row = (
                    await db.execute(
                        select(
                            func.coalesce(func.sum(OrganizationMembership.total_xp), 0),
                            func.coalesce(func.sum(OrganizationMembership.unverified_xp), 0),
                        ).where(OrganizationMembership.id.in_(mem_ids))
                    )
                ).first()
                c_ver = int(row[0]) if row else 0
                c_unver = int(row[1]) if row else 0
            else:
                c_ver = 0
                c_unver = 0

            cohort_xp_summaries.append(
                CohortXpSummary(
                    cohort_id=c.id,
                    cohort_name=c.name,
                    verified_xp=c_ver,
                    unverified_xp=c_unver,
                )
            )

        return XpAnalyticsResponse(
            total_verified_xp=total_ver,
            total_unverified_xp=total_unver,
            average_xp=round(avg_xp, 2),
            median_xp=round(med_xp, 2),
            max_xp=max_xp,
            min_xp=min_xp,
            distribution=distribution,
            cohort_xp=cohort_xp_summaries,
        )

    @staticmethod
    async def get_learners_analytics(
        db: AsyncSession,
        org: Organization,
        cohort_id: int | None = None,
        search: str | None = None,
    ) -> list[LearnerAnalyticsItem]:
        stmt = (
            select(OrganizationMembership, User)
            .join(User, User.id == OrganizationMembership.user_id)
            .where(
                OrganizationMembership.organization_id == org.id,
                OrganizationMembership.status == "active",
            )
        )
        if search:
            s_term = f"%{search.strip().lower()}%"
            stmt = stmt.where(
                or_(
                    func.lower(User.username).like(s_term),
                    func.lower(User.email).like(s_term),
                )
            )
        if cohort_id:
            stmt = stmt.join(
                CohortMembership,
                and_(
                    CohortMembership.organization_membership_id == OrganizationMembership.id,
                    CohortMembership.cohort_id == cohort_id,
                    CohortMembership.removed_at.is_(None),
                ),
            )

        stmt = stmt.order_by(OrganizationMembership.total_xp.desc(), OrganizationMembership.joined_at.asc())
        rows = (await db.execute(stmt)).all()

        results: list[LearnerAnalyticsItem] = []
        for mem, user in rows:
            # Role for this membership
            role_slug = await db.scalar(select(Role.slug).where(Role.id == mem.role_id))
            primary_role = role_slug or "learner"

            # Completed labs and sections
            lab_cnt = await db.scalar(
                select(func.count(LabProgress.id)).where(LabProgress.organization_membership_id == mem.id)
            ) or 0
            sec_cnt = await db.scalar(
                select(func.count(SectionProgress.id)).where(SectionProgress.organization_membership_id == mem.id)
            ) or 0

            # Latest activity
            last_lab = await db.scalar(
                select(func.max(LabProgress.created_at)).where(LabProgress.organization_membership_id == mem.id)
            )
            last_sec = await db.scalar(
                select(func.max(SectionProgress.created_at)).where(SectionProgress.organization_membership_id == mem.id)
            )
            latest_active = max(filter(None, [last_lab, last_sec]), default=None)

            # Cohorts
            c_names = (
                await db.execute(
                    select(Cohort.name)
                    .join(CohortMembership, CohortMembership.cohort_id == Cohort.id)
                    .where(
                        CohortMembership.organization_membership_id == mem.id,
                        CohortMembership.removed_at.is_(None),
                    )
                )
            ).scalars().all()

            results.append(
                LearnerAnalyticsItem(
                    user_id=user.id,
                    username=user.username,
                    email=user.email,
                    membership_id=mem.id,
                    role=primary_role,
                    joined_at=mem.joined_at,
                    total_xp=mem.total_xp + mem.unverified_xp,
                    verified_xp=mem.total_xp,
                    unverified_xp=mem.unverified_xp,
                    completed_labs_count=lab_cnt,
                    completed_sections_count=sec_cnt,
                    last_active_at=latest_active,
                    cohorts=list(c_names),
                )
            )

        return results

    @staticmethod
    async def get_learner_detail(
        db: AsyncSession,
        org: Organization,
        user_id: int,
    ) -> LearnerDetailAnalyticsResponse:
        mem_row = (
            await db.execute(
                select(OrganizationMembership, User)
                .join(User, User.id == OrganizationMembership.user_id)
                .where(
                    OrganizationMembership.organization_id == org.id,
                    OrganizationMembership.user_id == user_id,
                    OrganizationMembership.status == "active",
                )
            )
        ).first()
        if not mem_row:
            raise ValueError(f"User {user_id} does not have an active membership in this organization")

        mem, user = mem_row

        # Role
        role_slug = await db.scalar(select(Role.slug).where(Role.id == mem.role_id))
        primary_role = role_slug or "learner"

        # Cohorts
        c_names = (
            await db.execute(
                select(Cohort.name)
                .join(CohortMembership, CohortMembership.cohort_id == Cohort.id)
                .where(
                    CohortMembership.organization_membership_id == mem.id,
                    CohortMembership.removed_at.is_(None),
                )
            )
        ).scalars().all()

        # Load metadata dictionaries
        modules = (await db.execute(select(Module))).scalars().all()
        sections = (await db.execute(select(Section))).scalars().all()
        labs = (await db.execute(select(Lab))).scalars().all()

        lab_dict = {l.id: l for l in labs}
        sec_dict = {s.id: s for s in sections}
        mod_dict = {m.id: m for m in modules}

        # Invert hierarchy: lab -> section -> module
        lab_to_section: dict[str, str] = {}
        for s in sections:
            for lid in (s.labs or []):
                lab_to_section[lid] = s.id

        section_to_module: dict[str, str] = {}
        for m in modules:
            for sid in (m.sections or []):
                section_to_module[sid] = m.id

        # Lab progress
        lab_progs = (
            await db.execute(
                select(LabProgress)
                .where(LabProgress.organization_membership_id == mem.id)
                .order_by(LabProgress.created_at.desc())
            )
        ).scalars().all()

        completed_labs: list[LearnerCompletedLabItem] = []
        for lp in lab_progs:
            l_obj = lab_dict.get(lp.lab_id)
            sec_id = lab_to_section.get(lp.lab_id)
            mod_id = section_to_module.get(sec_id) if sec_id else None
            m_obj = mod_dict.get(mod_id) if mod_id else None

            completed_labs.append(
                LearnerCompletedLabItem(
                    lab_id=lp.lab_id,
                    title=l_obj.title if l_obj else lp.lab_id,
                    module_id=mod_id,
                    module_title=m_obj.title if m_obj else None,
                    xp_awarded=lp.xp_awarded,
                    completed_at=lp.created_at,
                )
            )

        # Section progress
        sec_progs = (
            await db.execute(
                select(SectionProgress)
                .where(SectionProgress.organization_membership_id == mem.id)
                .order_by(SectionProgress.created_at.desc())
            )
        ).scalars().all()

        completed_sections: list[LearnerCompletedSectionItem] = []
        for sp in sec_progs:
            s_obj = sec_dict.get(sp.section_id)
            mod_id = section_to_module.get(sp.section_id)

            completed_sections.append(
                LearnerCompletedSectionItem(
                    section_id=sp.section_id,
                    title=s_obj.title if s_obj else sp.section_id,
                    module_id=mod_id,
                    xp_awarded=sp.xp_awarded,
                    completed_at=sp.created_at,
                )
            )

        # Module-level progress
        completed_lab_ids = {lp.lab_id for lp in lab_progs}
        completed_sec_ids = {sp.section_id for sp in sec_progs}

        module_progress: list[LearnerModuleProgressItem] = []
        for m in modules:
            sec_ids = m.sections or []
            all_mod_labs: list[str] = []
            for sid in sec_ids:
                s_obj = sec_dict.get(sid)
                if s_obj and s_obj.labs:
                    all_mod_labs.extend(s_obj.labs)

            done_labs = sum(1 for lid in all_mod_labs if lid in completed_lab_ids)
            done_secs = sum(1 for sid in sec_ids if sid in completed_sec_ids)

            if done_labs > 0 or done_secs > 0:
                tot_items = len(all_mod_labs) + len(sec_ids)
                done_items = done_labs + done_secs
                pct = round((done_items / tot_items * 100), 1) if tot_items > 0 else 0.0

                module_progress.append(
                    LearnerModuleProgressItem(
                        module_id=m.id,
                        title=m.title,
                        status=m.status,
                        completed_labs=done_labs,
                        total_labs=len(all_mod_labs),
                        completed_sections=done_secs,
                        total_sections=len(sec_ids),
                        percent_complete=pct,
                    )
                )

        module_progress.sort(key=lambda x: x.percent_complete, reverse=True)

        latest_active = max(
            filter(
                None,
                [
                    completed_labs[0].completed_at if completed_labs else None,
                    completed_sections[0].completed_at if completed_sections else None,
                ],
            ),
            default=None,
        )

        learner_item = LearnerAnalyticsItem(
            user_id=user.id,
            username=user.username,
            email=user.email,
            membership_id=mem.id,
            role=primary_role,
            joined_at=mem.joined_at,
            total_xp=mem.total_xp + mem.unverified_xp,
            verified_xp=mem.total_xp,
            unverified_xp=mem.unverified_xp,
            completed_labs_count=len(completed_labs),
            completed_sections_count=len(completed_sections),
            last_active_at=latest_active,
            cohorts=list(c_names),
        )

        return LearnerDetailAnalyticsResponse(
            learner=learner_item,
            completed_labs=completed_labs,
            completed_sections=completed_sections,
            module_progress=module_progress,
        )

    @staticmethod
    async def get_platform_overview(db: AsyncSession) -> PlatformOverviewAnalyticsResponse:
        total_users = await db.scalar(select(func.count(User.id))) or 0
        total_orgs = await db.scalar(select(func.count(Organization.id))) or 0
        total_mems = await db.scalar(
            select(func.count(OrganizationMembership.id)).where(OrganizationMembership.status != "removed")
        ) or 0
        total_cohorts = await db.scalar(select(func.count(Cohort.id))) or 0
        total_paths = await db.scalar(select(func.count(LearningPath.id))) or 0

        # Modules
        mods = (await db.execute(select(Module.id, Module.status))).all()
        total_modules = len(mods)
        total_ver_mods = sum(1 for m in mods if m.status == "verified")
        total_unver_mods = total_modules - total_ver_mods

        # Completions
        total_lab_comps = await db.scalar(select(func.count(LabProgress.id))) or 0
        total_sec_comps = await db.scalar(select(func.count(SectionProgress.id))) or 0

        # Total XP
        xp_row = (
            await db.execute(
                select(
                    func.coalesce(func.sum(OrganizationMembership.total_xp), 0),
                    func.coalesce(func.sum(OrganizationMembership.unverified_xp), 0),
                ).where(OrganizationMembership.status == "active")
            )
        ).first()
        total_ver_xp = int(xp_row[0]) if xp_row else 0
        total_unver_xp = int(xp_row[1]) if xp_row else 0

        return PlatformOverviewAnalyticsResponse(
            total_users=total_users,
            total_organizations=total_orgs,
            total_memberships=total_mems,
            total_cohorts=total_cohorts,
            total_learning_paths=total_paths,
            total_modules=total_modules,
            total_verified_modules=total_ver_mods,
            total_unverified_modules=total_unver_mods,
            total_lab_completions=total_lab_comps,
            total_section_completions=total_sec_comps,
            total_verified_xp=total_ver_xp,
            total_unverified_xp=total_unver_xp,
        )

    @staticmethod
    async def get_platform_trends(
        db: AsyncSession,
        period: str = "30d",
        start_date: datetime | None = None,
        end_date: datetime | None = None,
    ) -> PlatformTrendsAnalyticsResponse:
        s_dt, e_dt = resolve_date_range(period, start_date, end_date)

        # 1. User registrations over time
        u_q = select(cast(User.created_at, Date), func.count(User.id))
        if s_dt:
            u_q = u_q.where(User.created_at >= s_dt)
        if e_dt:
            u_q = u_q.where(User.created_at <= e_dt)
        u_q = u_q.group_by(cast(User.created_at, Date)).order_by(cast(User.created_at, Date).asc())
        u_rows = (await db.execute(u_q)).all()
        u_map = {r[0].isoformat(): int(r[1]) for r in u_rows if r[0]}

        # 2. Organization growth over time
        o_q = select(cast(Organization.created_at, Date), func.count(Organization.id))
        if s_dt:
            o_q = o_q.where(Organization.created_at >= s_dt)
        if e_dt:
            o_q = o_q.where(Organization.created_at <= e_dt)
        o_q = o_q.group_by(cast(Organization.created_at, Date)).order_by(cast(Organization.created_at, Date).asc())
        o_rows = (await db.execute(o_q)).all()
        o_map = {r[0].isoformat(): int(r[1]) for r in o_rows if r[0]}

        # 3. Lab completions over time
        l_q = select(cast(LabProgress.created_at, Date), func.count(LabProgress.id))
        if s_dt:
            l_q = l_q.where(LabProgress.created_at >= s_dt)
        if e_dt:
            l_q = l_q.where(LabProgress.created_at <= e_dt)
        l_q = l_q.group_by(cast(LabProgress.created_at, Date)).order_by(cast(LabProgress.created_at, Date).asc())
        l_rows = (await db.execute(l_q)).all()
        l_map = {r[0].isoformat(): int(r[1]) for r in l_rows if r[0]}

        # 4. Section completions over time
        s_q = select(cast(SectionProgress.created_at, Date), func.count(SectionProgress.id))
        if s_dt:
            s_q = s_q.where(SectionProgress.created_at >= s_dt)
        if e_dt:
            s_q = s_q.where(SectionProgress.created_at <= e_dt)
        s_q = s_q.group_by(cast(SectionProgress.created_at, Date)).order_by(cast(SectionProgress.created_at, Date).asc())
        s_rows = (await db.execute(s_q)).all()
        s_map = {r[0].isoformat(): int(r[1]) for r in s_rows if r[0]}

        return PlatformTrendsAnalyticsResponse(
            period=period,
            start_date=s_dt.isoformat() if s_dt else None,
            end_date=e_dt.isoformat() if e_dt else None,
            user_registrations=fill_date_series(u_map, s_dt, e_dt),
            organization_growth=fill_date_series(o_map, s_dt, e_dt),
            lab_completions=fill_date_series(l_map, s_dt, e_dt),
            section_completions=fill_date_series(s_map, s_dt, e_dt),
        )

    @staticmethod
    async def get_platform_organizations(db: AsyncSession) -> list[PlatformOrgSummaryItem]:
        orgs = (
            await db.execute(
                select(Organization).order_by(Organization.created_at.desc())
            )
        ).scalars().all()

        results: list[PlatformOrgSummaryItem] = []
        for o in orgs:
            mem_count = await db.scalar(
                select(func.count(OrganizationMembership.id)).where(
                    OrganizationMembership.organization_id == o.id,
                    OrganizationMembership.status != "removed",
                )
            ) or 0

            cohort_count = await db.scalar(
                select(func.count(Cohort.id)).where(Cohort.organization_id == o.id)
            ) or 0

            lab_comps = await db.scalar(
                select(func.count(LabProgress.id))
                .join(OrganizationMembership, OrganizationMembership.id == LabProgress.organization_membership_id)
                .where(OrganizationMembership.organization_id == o.id)
            ) or 0

            xp_row = (
                await db.execute(
                    select(
                        func.coalesce(func.sum(OrganizationMembership.total_xp), 0),
                        func.coalesce(func.sum(OrganizationMembership.unverified_xp), 0),
                    ).where(
                        OrganizationMembership.organization_id == o.id,
                        OrganizationMembership.status == "active",
                    )
                )
            ).first()
            ver_xp = int(xp_row[0]) if xp_row else 0
            unver_xp = int(xp_row[1]) if xp_row else 0

            results.append(
                PlatformOrgSummaryItem(
                    organization_id=o.id,
                    name=o.name,
                    slug=o.slug,
                    type=o.type,
                    status=o.status,
                    created_at=o.created_at,
                    member_count=mem_count,
                    cohort_count=cohort_count,
                    lab_completions_count=lab_comps,
                    total_verified_xp=ver_xp,
                    total_unverified_xp=unver_xp,
                )
            )

        return results

    # ================= CSV EXPORT GENERATORS =================

    @staticmethod
    async def export_learners_csv(db: AsyncSession, org: Organization) -> str:
        learners = await AnalyticsServiceReporting.get_learners_analytics(db, org)
        output = io.StringIO()
        writer = csv.writer(output)
        writer.writerow([
            "User ID",
            "Username",
            "Email",
            "Role",
            "Joined At",
            "Verified XP",
            "Unverified XP",
            "Total XP",
            "Completed Labs",
            "Completed Sections",
            "Last Active At",
            "Cohorts",
        ])
        for l in learners:
            writer.writerow([
                l.user_id,
                l.username,
                l.email,
                l.role,
                l.joined_at.isoformat() if l.joined_at else "",
                l.verified_xp,
                l.unverified_xp,
                l.total_xp,
                l.completed_labs_count,
                l.completed_sections_count,
                l.last_active_at.isoformat() if l.last_active_at else "",
                "; ".join(l.cohorts),
            ])
        return output.getvalue()

    @staticmethod
    async def export_activity_csv(db: AsyncSession, org: Organization) -> str:
        # Load all completions for this org
        lab_q = (
            select(LabProgress, User.username, User.id)
            .join(OrganizationMembership, OrganizationMembership.id == LabProgress.organization_membership_id)
            .join(User, User.id == OrganizationMembership.user_id)
            .where(OrganizationMembership.organization_id == org.id)
            .order_by(LabProgress.created_at.desc())
        )
        lab_rows = (await db.execute(lab_q)).all()

        sec_q = (
            select(SectionProgress, User.username, User.id)
            .join(OrganizationMembership, OrganizationMembership.id == SectionProgress.organization_membership_id)
            .join(User, User.id == OrganizationMembership.user_id)
            .where(OrganizationMembership.organization_id == org.id)
            .order_by(SectionProgress.created_at.desc())
        )
        sec_rows = (await db.execute(sec_q)).all()

        labs = (await db.execute(select(Lab.id, Lab.title))).all()
        lab_map = {l[0]: l[1] for l in labs}
        secs = (await db.execute(select(Section.id, Section.title))).all()
        sec_map = {s[0]: s[1] for s in secs}

        # Combine into unified event stream
        events = []
        for lp, u_name, u_id in lab_rows:
            events.append({
                "date": lp.created_at,
                "type": "lab",
                "item_id": lp.lab_id,
                "title": lab_map.get(lp.lab_id, lp.lab_id),
                "user_id": u_id,
                "username": u_name,
                "xp": lp.xp_awarded,
            })
        for sp, u_name, u_id in sec_rows:
            events.append({
                "date": sp.created_at,
                "type": "section",
                "item_id": sp.section_id,
                "title": sec_map.get(sp.section_id, sp.section_id),
                "user_id": u_id,
                "username": u_name,
                "xp": sp.xp_awarded,
            })
        events.sort(key=lambda x: x["date"], reverse=True)

        output = io.StringIO()
        writer = csv.writer(output)
        writer.writerow([
            "Completion Date",
            "Type",
            "Item ID",
            "Title",
            "User ID",
            "Username",
            "XP Awarded",
        ])
        for ev in events:
            writer.writerow([
                ev["date"].isoformat(),
                ev["type"],
                ev["item_id"],
                ev["title"],
                ev["user_id"],
                ev["username"],
                ev["xp"],
            ])
        return output.getvalue()

    @staticmethod
    async def export_cohorts_csv(db: AsyncSession, org: Organization) -> str:
        cohorts = await AnalyticsServiceReporting.get_organization_cohorts(db, org)
        output = io.StringIO()
        writer = csv.writer(output)
        writer.writerow([
            "Cohort ID",
            "Cohort Name",
            "Status",
            "Starts At",
            "Ends At",
            "Member Count",
            "Learners Started",
            "Completed Labs",
            "Completed Sections",
            "Total Verified XP",
            "Total Unverified XP",
        ])
        for c in cohorts:
            writer.writerow([
                c.cohort_id,
                c.name,
                c.status,
                c.starts_at.isoformat() if c.starts_at else "",
                c.ends_at.isoformat() if c.ends_at else "",
                c.member_count,
                c.learners_started,
                c.completed_labs,
                c.completed_sections,
                c.total_verified_xp,
                c.total_unverified_xp,
            ])
        return output.getvalue()

    @staticmethod
    async def export_content_csv(db: AsyncSession, org: Organization) -> str:
        content = await AnalyticsServiceReporting.get_content_analytics(db, org)
        output = io.StringIO()
        writer = csv.writer(output)
        writer.writerow([
            "Item Type",
            "ID",
            "Title",
            "Status",
            "Ownership",
            "Completions Count",
            "Distinct Learners",
        ])
        for m in content.most_completed_modules:
            writer.writerow([
                "module",
                m.id,
                m.title,
                m.status,
                "TLD-Owned" if m.is_tld_owned else "Org-Owned",
                m.completions_count,
                m.distinct_learners_count,
            ])
        for s in content.most_completed_sections:
            writer.writerow([
                "section",
                s.id,
                s.title,
                s.status,
                "TLD-Owned" if s.is_tld_owned else "Org-Owned",
                s.completions_count,
                s.distinct_learners_count,
            ])
        for l in content.most_completed_labs:
            writer.writerow([
                "lab",
                l.id,
                l.title,
                l.status,
                "TLD-Owned" if l.is_tld_owned else "Org-Owned",
                l.completions_count,
                l.distinct_learners_count,
            ])
        return output.getvalue()

    @staticmethod
    async def export_platform_orgs_csv(db: AsyncSession) -> str:
        orgs = await AnalyticsServiceReporting.get_platform_organizations(db)
        output = io.StringIO()
        writer = csv.writer(output)
        writer.writerow([
            "Organization ID",
            "Name",
            "Slug",
            "Type",
            "Status",
            "Created At",
            "Member Count",
            "Cohort Count",
            "Lab Completions",
            "Total Verified XP",
            "Total Unverified XP",
        ])
        for o in orgs:
            writer.writerow([
                o.organization_id,
                o.name,
                o.slug,
                o.type,
                o.status,
                o.created_at.isoformat(),
                o.member_count,
                o.cohort_count,
                o.lab_completions_count,
                o.total_verified_xp,
                o.total_unverified_xp,
            ])
        return output.getvalue()
