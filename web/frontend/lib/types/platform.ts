import type { ActivityTrendPoint } from "./analytics";

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
