import type {
  AccessRequestResponse,
  AnalyticsOverviewResponse,
  AnalyticsTrendsResponse,
  AuditLogResponse,
  CohortAnalyticsItem,
  CohortMemberResponse,
  CohortResponse,
  ContentAnalyticsResponse,
  InvitationResponse,
  InvitationStatsResponse,
  LearnerDetailAnalyticsResponse,
  LearningPathResponse,
  Module,
  OrganizationMemberResponse,
  OrganizationResponse,
  OrgPermissionItem,
  OrgRole,
  OrgRoleCreateRequest,
  OrgRoleUpdateRequest,
  OrgSettingItemResponse,
  XpAnalyticsResponse,
} from "../types";
import { clearDashboardCache } from "../dashboard/use-dashboard-cache";
import { clearModulesMemoryCache } from "@/hooks/use-modules";
import { getApiBaseUrl, getStoredSelectedOrg, getToken, request, requestBlob } from "./client";

function orgHeader(orgSlug?: string): Record<string, string> | undefined {
  return orgSlug ? { "X-Organization-Slug": orgSlug, "X-Organization": orgSlug } : undefined;
}

export const orgApi = {
  getOrganizations: (includeSuspended: boolean = false) =>
    request<OrganizationResponse[]>(`/organizations${includeSuspended ? "?include_suspended=true" : ""}`),

  createOrganization: (data: { name: string; slug: string; type?: string; domains?: string[] }) =>
    request<OrganizationResponse>("/organizations", {
      method: "POST",
      body: JSON.stringify(data),
    }),

  setSelectedOrg: (slug: string) => {
    if (typeof window !== "undefined") {
      const current = localStorage.getItem("selected_org");
      if (current === slug) return;
      localStorage.setItem("selected_org", slug);
      clearDashboardCache();
      clearModulesMemoryCache();
      window.dispatchEvent(new Event("tld:workspace-changed"));
    }
  },

  clearSelectedOrg: () => {
    if (typeof window !== "undefined") {
      localStorage.removeItem("selected_org");
      clearDashboardCache();
      clearModulesMemoryCache();
      window.dispatchEvent(new Event("tld:workspace-changed"));
    }
  },

  getSelectedOrg: (): string | null => getStoredSelectedOrg(),

  batchUpdateMemberRoles: (orgSlug: string, updates: { user_id: number; role: string }[]) =>
    request<{ detail: string }>(`/organizations/${orgSlug}/members/roles/batch`, {
      method: "PATCH",
      body: JSON.stringify({ updates }),
    }),

  bulkRemoveMembers: (orgSlug: string, userIds: number[]) =>
    request<{ detail: string }>(`/organizations/${orgSlug}/members/bulk-remove`, {
      method: "POST",
      body: JSON.stringify({ user_ids: userIds }),
    }),

  getOrgPermissions: (orgSlug: string) =>
    request<OrgPermissionItem[]>(`/organizations/${orgSlug}/permissions`),

  getOrgRoles: (orgSlug: string) =>
    request<OrgRole[]>(`/organizations/${orgSlug}/roles`),

  createOrgRole: (orgSlug: string, data: OrgRoleCreateRequest) =>
    request<OrgRole>(`/organizations/${orgSlug}/roles`, {
      method: "POST",
      body: JSON.stringify(data),
    }),

  updateOrgRole: (orgSlug: string, roleId: number, data: OrgRoleUpdateRequest) =>
    request<OrgRole>(`/organizations/${orgSlug}/roles/${roleId}`, {
      method: "PATCH",
      body: JSON.stringify(data),
    }),

  deleteOrgRole: (orgSlug: string, roleId: number) =>
    request<{ detail: string }>(`/organizations/${orgSlug}/roles/${roleId}`, {
      method: "DELETE",
    }),

  removeMember: (orgSlug: string, userId: number) =>
    request<{ detail: string }>(`/organizations/${orgSlug}/members/${userId}`, {
      method: "DELETE",
    }),

  getCohortMembers: (orgSlug: string, cohortId: number) =>
    request<CohortMemberResponse[]>(`/organizations/${orgSlug}/cohorts/${cohortId}/members`),

  getOrganization: (orgSlug: string) =>
    request<OrganizationResponse>(`/organizations/${orgSlug}`),

  getOrganizationMembers: (orgSlug: string) =>
    request<OrganizationMemberResponse[]>(`/organizations/${orgSlug}/members`),

  getCohorts: (orgSlug: string) =>
    request<CohortResponse[]>(`/organizations/${orgSlug}/cohorts`),

  createCohort: (
    orgSlug: string,
    data: { name: string; description?: string; starts_at: string; ends_at: string; learning_paths?: number[] }
  ) =>
    request<CohortResponse>(`/organizations/${orgSlug}/cohorts`, {
      method: "POST",
      body: JSON.stringify(data),
    }),

  getLearningPaths: (orgSlug: string) =>
    request<LearningPathResponse[]>(`/organizations/${orgSlug}/learning-paths`),

  getOrgCurriculum: (orgSlug: string) =>
    request<Module[]>(`/organizations/${orgSlug}/curriculum`),

  getAvailableTLDModules: (orgSlug: string) =>
    request<Module[]>(`/organizations/${orgSlug}/curriculum/available`),

  adoptTLDModule: (
    orgSlug: string,
    data: { tld_module_id: string; custom_id?: string; custom_title?: string }
  ) =>
    request<Module>(`/organizations/${orgSlug}/curriculum/adopt`, {
      method: "POST",
      body: JSON.stringify(data),
    }),

  removeOrgModule: (orgSlug: string, moduleId: string) =>
    request<{ detail: string }>(`/organizations/${orgSlug}/curriculum/${moduleId}`, {
      method: "DELETE",
    }),

  createLearningPath: (
    orgSlug: string,
    data: { name: string; slug: string; description?: string; visibility?: string; modules?: string[] }
  ) =>
    request<LearningPathResponse>(`/organizations/${orgSlug}/learning-paths`, {
      method: "POST",
      body: JSON.stringify(data),
    }),

  getInvitations: (orgSlug?: string) =>
    request<InvitationResponse[]>("/organizations/invitations", {
      headers: orgHeader(orgSlug),
    }),

  getInvitationStats: (orgSlug?: string) =>
    request<InvitationStatsResponse>("/organizations/invitations/stats", {
      headers: orgHeader(orgSlug),
    }),

  createInvitation: (data: { email: string; role?: string; cohort_id?: number | null }, orgSlug?: string) =>
    request<InvitationResponse>("/organizations/invitations", {
      method: "POST",
      headers: orgHeader(orgSlug),
      body: JSON.stringify(data),
    }),

  uploadBulkInvitations: async (file: File, cohortId?: number | null, orgSlug?: string) => {
    const token = getToken();
    const selectedOrg = orgSlug || getStoredSelectedOrg();
    const formData = new FormData();
    formData.append("file", file);
    if (cohortId) formData.append("cohort_id", cohortId.toString());

    const headers: Record<string, string> = {};
    if (token) headers["Authorization"] = `Bearer ${token}`;
    if (selectedOrg) {
      headers["X-Organization-Slug"] = selectedOrg;
      headers["X-Organization"] = selectedOrg;
    }

    const res = await fetch(`${getApiBaseUrl()}/organizations/invitations/bulk`, {
      method: "POST",
      headers,
      body: formData,
    });
    if (!res.ok) {
      const err = await res.json().catch(() => ({ detail: "Upload failed" }));
      throw new Error(err.detail || "Upload failed");
    }
    return res.json();
  },

  revokeInvitation: (id: number, orgSlug?: string) =>
    request<{ detail: string }>(`/organizations/invitations/${id}/revoke`, {
      method: "POST",
      headers: orgHeader(orgSlug),
    }),

  getAccessRequests: (orgSlug?: string) =>
    request<AccessRequestResponse[]>("/organizations/access-requests", {
      headers: orgHeader(orgSlug),
    }),

  approveAccessRequest: (id: number, orgSlug?: string) =>
    request<{ status: string; detail: string; invitation_id: number; invitation_code?: string }>(
      `/organizations/access-requests/${id}/approve`,
      {
        method: "POST",
        headers: orgHeader(orgSlug),
        body: JSON.stringify({}),
      }
    ),

  rejectAccessRequest: (id: number, reason?: string, orgSlug?: string) =>
    request<{ detail: string }>(`/organizations/access-requests/${id}/reject`, {
      method: "POST",
      headers: orgHeader(orgSlug),
      body: JSON.stringify({ reason }),
    }),

  getOrgSettings: (orgSlug: string) =>
    request<OrgSettingItemResponse[]>(`/organizations/${orgSlug}/settings`),

  updateOrgSetting: (orgSlug: string, key: string, value: any) =>
    request<OrgSettingItemResponse>(`/organizations/${orgSlug}/settings/${key}`, {
      method: "PATCH",
      body: JSON.stringify({ value }),
    }),

  getOrgAuditLogs: (orgSlug: string, limit: number = 50, offset: number = 0) =>
    request<AuditLogResponse[]>(`/organizations/${orgSlug}/audit-logs?limit=${limit}&offset=${offset}`),

  getOrgAnalyticsOverview: (orgSlug: string) =>
    request<AnalyticsOverviewResponse>(`/organizations/${orgSlug}/analytics/overview`),

  getOrgAnalyticsTrends: (orgSlug: string, period: string = "30d", startDate?: string, endDate?: string) => {
    let url = `/organizations/${orgSlug}/analytics/trends?period=${period}`;
    if (startDate) url += `&start_date=${encodeURIComponent(startDate)}`;
    if (endDate) url += `&end_date=${encodeURIComponent(endDate)}`;
    return request<AnalyticsTrendsResponse>(url);
  },

  getOrgAnalyticsCohorts: (orgSlug: string) =>
    request<CohortAnalyticsItem[]>(`/organizations/${orgSlug}/analytics/cohorts`),

  getOrgAnalyticsContent: (orgSlug: string) =>
    request<ContentAnalyticsResponse>(`/organizations/${orgSlug}/analytics/content`),

  getOrgAnalyticsXp: (orgSlug: string) =>
    request<XpAnalyticsResponse>(`/organizations/${orgSlug}/analytics/xp`),

  getOrgAnalyticsLearnerDetail: (orgSlug: string, userId: number) =>
    request<LearnerDetailAnalyticsResponse>(`/organizations/${orgSlug}/analytics/learners/${userId}`),

  exportOrgAnalyticsBlob: (orgSlug: string, type: string) =>
    requestBlob(`/organizations/${orgSlug}/analytics/export/${type}`, {
      "X-Organization-Slug": orgSlug,
    }),
};
