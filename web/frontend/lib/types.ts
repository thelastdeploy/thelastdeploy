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
  roles: string[];
  total_xp: number;
  unverified_xp: number;
  joined_at: string;
}

export type ModuleStatus = 'draft' | 'published' | 'pending' | 'verified';

export interface BuilderLabInput {
  id: string;
  title: string;
  order: number;
  xp: number;
  estimated_minutes: number | null;
  environment_profile?: string;
  seed_commands: string[];
  validator_script: string;
}

export interface BuilderSectionInput {
  id: string;
  title: string;
  order: number;
  xp: number;
  content: string;
  labs: BuilderLabInput[];
}

export interface BuilderModuleInput {
  id: string;
  title: string;
  description: string;
  topic: string;
  difficulty: string;
  estimated_minutes: number | null;
  sections: BuilderSectionInput[];
}

export interface BuilderDraftListItem {
  id: string;
  title: string;
  topic: string | null;
  difficulty: string | null;
  total_sections: number;
  total_xp: number;
  status: ModuleStatus;
  is_official_verified?: boolean;
  created_at: string;
  submitted_at: string | null;
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


