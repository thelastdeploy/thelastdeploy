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

export type OrganizationMembershipInfo = Omit<OrganizationResponse, "domains"> & {
  domains?: string[];
};

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
  can_edit?: boolean;
  required_permission?: string | null;
}

export interface OrgPermissionItem {
  key: string;
  description: string;
}

export interface OrgRole {
  id: number;
  organization_id: number;
  name: string;
  slug: string;
  description?: string | null;
  permissions: string[];
  member_count: number;
  is_caller_role?: boolean;
  can_delete?: boolean;
  can_remove_roles_manage?: boolean;
  created_at: string;
}

export interface OrgRoleCreateRequest {
  name: string;
  slug?: string;
  description?: string;
  permissions: string[];
}

export interface OrgRoleUpdateRequest {
  name?: string;
  description?: string;
  permissions?: string[];
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
