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
