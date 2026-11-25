// web/frontend/lib/types.ts

export type Topic = "docker" | "kubernetes" | "linux" | "git" | "jenkins" | "terraform" | "nginx";
export type Difficulty = "foundational" | "beginner" | "intermediate" | "advanced" | "expert";

export interface Lab {
  id: string;
  title: string;
  order: number;
  xp: number;
  estimated_minutes: number | null;
  environment_profile?: string;
  seed_commands: string | null;
  completed: boolean;
  xp_awarded: number;
}

export interface Section {
  id: string;
  title: string;
  order: number;
  xp: number;                  // reading XP from section.yaml
  content: string | null;
  labs: Lab[];
  section_completed: boolean;  // true = reading scrolled to end (or future: questions done)
}

export interface AuthorInfo {
  name: string;
  is_official: boolean;
}

export type ModuleStatus = 'draft' | 'published' | 'pending' | 'verified';

export interface Module {
  id: string;
  title: string;
  description: string | null;
  topic: Topic;
  difficulty: Difficulty;
  estimated_minutes: number | null;
  shared_seed?: string[];
  total_xp: number;
  total_sections: number;
  completed_sections: number;
  author: AuthorInfo;
  status?: ModuleStatus;
  is_official_verified?: boolean;
}

export interface ModuleDetail extends Module {
  sections: Section[];
}

export interface User {
  id: number;
  username: string;
  email: string;
  xp: number;
  unverified_xp: number;
  is_maintainer: boolean;
  is_admin?: boolean;
  can_manage_workspaces?: boolean;
  platform_roles?: string[];
  platform_permissions?: string[];
  completed_labs: string[];      // lab IDs (tld check)
  completed_sections: string[];  // section IDs (reading / future: questions)
}

export interface OrganizationMembershipInfo {
  id: number;
  name: string;
  slug: string;
  type: string;
  is_platform: boolean;
  status: string;
  domains?: string[];
  roles: string[];
  total_xp: number;
  unverified_xp: number;
  joined_at: string;
  is_member?: boolean;
}


export interface OrganizationPublicInfoResponse {
  name: string;
  slug: string;
  type: string;
  domains: string[];
  requires_domain_match: boolean;
  approval_mode: string;
  invitations_enabled: boolean;
}

export interface InvitationVerifyResponse {
  valid: boolean;
  email: string;
  organization_name: string;
  organization_slug: string;
  cohort_id?: number | null;
  cohort_name?: string | null;
  role: string;
  expires_at: string;
  is_existing_user: boolean;
}

export interface SessionResponse {
  id: number;
  client_type: string;
  user_agent: string | null;
  ip_address: string | null;
  created_at: string;
  expires_at: string;
  last_used_at: string | null;
  is_current: boolean;
}

export interface OrganizationMemberResponse {
  membership_id: number;
  user_id: number;
  username: string;
  email: string;
  status: string;
  roles: string[];
  total_xp: number;
  unverified_xp: number;
  joined_at: string;
}

export interface CohortMemberResponse {
  membership_id: number;
  cohort_membership_id: number;
  user_id: number;
  username: string;
  email: string;
  total_xp: number;
  joined_at: string;
}

export interface OrganizationResponse {
  id: number;
  name: string;
  slug: string;
  type: string;
  is_platform: boolean;
  status: string;
  domains: string[];
  roles: string[];
  total_xp: number;
  unverified_xp: number;
  joined_at: string;
  is_member?: boolean;
}

export interface CohortResponse {
  id: number;
  organization_id: number;
  name: string;
  description: string | null;
  status: string;
  learning_paths: number[];
  starts_at: string;
  ends_at: string;
  created_at: string;
}

export interface LearningPathResponse {
  id: number;
  organization_id: number;
  name: string;
  slug: string;
  description: string | null;
  visibility: string;
  status: string;
  modules: string[];
  module_count: number;
  created_at: string;
}

export interface InvitationResponse {
  id: number;
  organization_id: number;
  organization_name?: string;
  cohort_id?: number | null;
  cohort_name?: string | null;
  email: string;
  invitation_code?: string | null;
  status: string;
  role: string;
  created_at: string;
  expires_at: string;
  redeemed_at?: string | null;
  revoked_at?: string | null;
}

export interface InvitationStatsResponse {
  total: number;
  pending: number;
  accepted: number;
  expired: number;
  revoked: number;
}

export interface AccessRequestResponse {
  id: number;
  organization_id: number;
  email: string;
  status: string;
  requested_at: string;
  reviewed_at?: string | null;
  reviewed_by_user_id?: number | null;
  rejection_reason?: string | null;
}

export interface OrgSettingItemResponse {
  key: string;
  value: any;
  category: string;
  description: string;
  data_type: string;
}

export interface AuditLogResponse {
  id: number;
  organization_id?: number | null;
  actor_user_id?: number | null;
  actor_username?: string | null;
  action: string;
  entity_type: string;
  entity_id?: string | null;
  metadata: Record<string, any>;
  created_at: string;
}

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

export interface CohortLearnerProgressItem {
  user_id: number;
  username: string;
  email: string;
  joined_at?: string | null;
  completed_labs: number;
  completed_sections: number;
  verified_xp: number;
  unverified_xp: number;
  last_active_at?: string | null;
}

export interface CohortDetailAnalyticsResponse {
  cohort: CohortAnalyticsItem;
  learners: CohortLearnerProgressItem[];
  activity_trends: ActivityTrendPoint[];
}

export interface PathAnalyticsItem {
  path_id: number;
  name: string;
  slug: string;
  visibility: string;
  status: string;
  module_count: number;
  module_ids: string[];
  learners_with_access: number;
  learners_with_progress: number;
  completed_labs: number;
}

export interface PathModuleDetailItem {
  module_id: string;
  title: string;
  status: string;
  total_labs: number;
  total_sections: number;
  completed_labs: number;
}

export interface PathDetailAnalyticsResponse {
  path: PathAnalyticsItem;
  modules: PathModuleDetailItem[];
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

export interface PlatformOverviewAnalyticsResponse {
  total_users: number;
  total_organizations: number;
  total_memberships: number;
  total_cohorts: number;
  total_learning_paths: number;
  total_modules: number;
  total_verified_modules: number;
  total_unverified_modules: number;
  total_lab_completions: number;
  total_section_completions: number;
  total_verified_xp: number;
  total_unverified_xp: number;
}

export interface PlatformTrendsAnalyticsResponse {
  period: string;
  start_date?: string | null;
  end_date?: string | null;
  user_registrations: ActivityTrendPoint[];
  organization_growth: ActivityTrendPoint[];
  lab_completions: ActivityTrendPoint[];
  section_completions: ActivityTrendPoint[];
}

export interface PlatformOrgSummaryItem {
  organization_id: number;
  name: string;
  slug: string;
  type: string;
  status: string;
  created_at: string;
  member_count: number;
  cohort_count: number;
  lab_completions_count: number;
  total_verified_xp: number;
  total_unverified_xp: number;
}

export interface PlatformPermissionItem {
  id: number;
  key: string;
  description: string;
}

export interface PlatformUserPermissionSummary {
  id: number;
  username: string;
  email: string;
  permissions: string[];
  assigned_at?: string | null;
}

export interface OrgSettingAdminItemResponse {
  key: string;
  is_enabled: boolean;
  value: any;
  default: any;
  category: string;
  description: string;
  data_type: string;
  allowed_values?: any[] | null;
  updated_at?: string | null;
}



