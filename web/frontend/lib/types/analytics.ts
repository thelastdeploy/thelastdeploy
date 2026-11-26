export interface AnalyticsOverviewResponse {
  organization_id: number;
  organization_slug: string;
  organization_name: string;
  total_members: number;
  total_learners: number;
  total_cohorts: number;
  total_learning_paths: number;
  total_modules_available: number;
  total_verified_modules: number;
  total_unverified_modules: number;
  total_completed_labs: number;
  total_completed_sections: number;
  total_verified_xp: number;
  total_unverified_xp: number;
  learners_started: number;
  learners_completed_lab: number;
  learners_not_started: number;
}

export interface ActivityTrendPoint {
  date: string;
  count: number;
}

export interface XpTrendPoint {
  date: string;
  xp: number;
}

export interface AnalyticsTrendsResponse {
  period: string;
  start_date?: string | null;
  end_date?: string | null;
  lab_completions: ActivityTrendPoint[];
  section_completions: ActivityTrendPoint[];
  xp_earned: XpTrendPoint[];
  new_members: ActivityTrendPoint[];
  new_learners: ActivityTrendPoint[];
}

export interface CohortAnalyticsItem {
  cohort_id: number;
  name: string;
  status: string;
  starts_at?: string | null;
  ends_at?: string | null;
  member_count: number;
  learners_started: number;
  completed_labs: number;
  completed_sections: number;
  total_verified_xp: number;
  total_unverified_xp: number;
}

export interface ContentItemMetric {
  id: string;
  title: string;
  status: string;
  owner_organization_id?: number | null;
  is_tld_owned: boolean;
  completions_count: number;
  distinct_learners_count: number;
}

export interface ContentAnalyticsResponse {
  most_completed_modules: ContentItemMetric[];
  most_completed_sections: ContentItemMetric[];
  most_completed_labs: ContentItemMetric[];
  least_completed_modules: ContentItemMetric[];
  verified_modules_count: number;
  unverified_modules_count: number;
  verified_lab_completions: number;
  unverified_lab_completions: number;
  tld_owned_modules_count: number;
  org_owned_modules_count: number;
}

export interface XpRangeDistribution {
  range_label: string;
  learner_count: number;
}

export interface CohortXpSummary {
  cohort_id: number;
  cohort_name: string;
  verified_xp: number;
  unverified_xp: number;
}

export interface XpAnalyticsResponse {
  total_verified_xp: number;
  total_unverified_xp: number;
  average_xp: number;
  median_xp: number;
  max_xp: number;
  min_xp: number;
  distribution: XpRangeDistribution[];
  cohort_xp: CohortXpSummary[];
}

export interface LearnerAnalyticsItem {
  user_id: number;
  username: string;
  email: string;
  membership_id: number;
  role: string;
  joined_at?: string | null;
  total_xp: number;
  verified_xp: number;
  unverified_xp: number;
  completed_labs_count: number;
  completed_sections_count: number;
  last_active_at?: string | null;
  cohorts: string[];
}

export interface LearnerCompletedLabItem {
  lab_id: string;
  title: string;
  module_id?: string | null;
  module_title?: string | null;
  xp_awarded: number;
  completed_at: string;
}

export interface LearnerCompletedSectionItem {
  section_id: string;
  title: string;
  module_id?: string | null;
  xp_awarded: number;
  completed_at: string;
}

export interface LearnerModuleProgressItem {
  module_id: string;
  title: string;
  status: string;
  completed_labs: number;
  total_labs: number;
  completed_sections: number;
  total_sections: number;
  percent_complete: number;
}

export interface LearnerDetailAnalyticsResponse {
  learner: LearnerAnalyticsItem;
  completed_labs: LearnerCompletedLabItem[];
  completed_sections: LearnerCompletedSectionItem[];
  module_progress: LearnerModuleProgressItem[];
}
