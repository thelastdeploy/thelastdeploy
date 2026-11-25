// web/frontend/lib/api.ts

import {
  Module,
  ModuleDetail,
  User,
  OrganizationMembershipInfo,
  OrganizationPublicInfoResponse,
  InvitationVerifyResponse,
  SessionResponse,
  OrganizationMemberResponse,
  CohortMemberResponse,
  OrganizationResponse,
  CohortResponse,
  LearningPathResponse,
  InvitationResponse,
  InvitationStatsResponse,
  AccessRequestResponse,
  OrgSettingItemResponse,
  AuditLogResponse,
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
  PlatformPermissionItem,
  PlatformUserPermissionSummary,
  OrgSettingAdminItemResponse,
} from "./types";
import { writeCache, clearDashboardCache } from "./dashboard/use-dashboard-cache";
import { clearModulesMemoryCache } from "@/hooks/use-modules";

export function getApiBaseUrl(): string {
  const envUrl = process.env.NEXT_PUBLIC_API_URL;
  if (envUrl && envUrl.startsWith("http") && !envUrl.includes("app.thelastdeploy.com")) {
    return envUrl.replace(/\/$/, "");
  }
  if (typeof window !== "undefined") {
    const host = window.location.hostname;
    if (host === "localhost" || host === "127.0.0.1") {
      return "http://localhost:9001";
    }
  }
  return "https://api.thelastdeploy.com";
}

export const API_BASE = getApiBaseUrl();

function getToken(): string | null {
  if (typeof window === "undefined") return null;
  return localStorage.getItem("token");
}

function getSelectedOrg(): string | null {
  if (typeof window === "undefined") return null;
  return localStorage.getItem("selected_org");
}

async function request<T>(path: string, options: RequestInit = {}): Promise<T> {
  const token = getToken();
  const selectedOrg = getSelectedOrg();
  const headers: Record<string, string> = {
    "Content-Type": "application/json",
    ...(options.headers as Record<string, string>),
  };
  if (token) headers["Authorization"] = `Bearer ${token}`;
  if (selectedOrg) {
    headers["X-Organization-Slug"] = selectedOrg;
    headers["X-Organization"] = selectedOrg;
  }

  const baseUrl = getApiBaseUrl();
  const res = await fetch(`${baseUrl}${path}`, { ...options, headers });
  if (!res.ok) {
    const error = await res.json().catch(() => ({ detail: "Request failed" }));
    throw new Error(error.detail || "Request failed");
  }
  return res.json();
}

/** After login/register — fetch everything needed and warm the cache. */
async function warmCache(token: string): Promise<void> {
  try {
    // Temporarily set token so request() can use it
    localStorage.setItem("token", token);
    const [user, modules] = await Promise.all([
      request<User>("/me"),
      request<ModuleDetail[]>("/modules/all/full?exclude_content=true"),
    ]);
    writeCache({ user, modules });
  } catch {
    // Non-fatal — dashboard will fetch on next load
  }
}

export const api = {
  // Auth
  register: async (email: string, username: string, password: string) => {
    return request<{ detail: string }>("/register", {
      method: "POST",
      body: JSON.stringify({ email, username, password }),
    });
  },

  login: async (email: string, password: string) => {
    const res = await request<{ access_token: string; device_key: string }>("/login", {
      method: "POST",
      body: JSON.stringify({ email, password }),
    });
    await warmCache(res.access_token);
    return res;
  },

  loginWithGitHub: async (code: string) => {
    const res = await request<{ access_token: string; device_key: string }>("/github", {
      method: "POST",
      body: JSON.stringify({ code }),
    });
    await warmCache(res.access_token);
    return res;
  },

  loginWithGoogle: async (code: string, redirectUri: string) => {
    const res = await request<{ access_token: string; device_key: string }>("/google", {
      method: "POST",
      body: JSON.stringify({ code, redirect_uri: redirectUri }),
    });
    await warmCache(res.access_token);
    return res;
  },

  checkUsername: async (username: string) => {
    return request<{ available: boolean; detail?: string }>(`/check-username?username=${encodeURIComponent(username)}`);
  },

  verifyEmail: async (token: string) => {
    return request<{ detail: string }>("/verify-email", {
      method: "POST",
      body: JSON.stringify({ token }),
    });
  },

  forgotPassword: async (email: string) => {
    return request<{ detail: string }>("/forgot-password", {
      method: "POST",
      body: JSON.stringify({ email }),
    });
  },

  resetPassword: async (token: string, password: string) => {
    return request<{ detail: string }>("/reset-password", {
      method: "POST",
      body: JSON.stringify({ token, password }),
    });
  },

  resendVerification: async (email: string) => {
    return request<{ detail: string }>("/resend-verification", {
      method: "POST",
      body: JSON.stringify({ email }),
    });
  },

  cliAuthorize: async (userCode: string, action: "approve" | "deny" = "approve") => {
    return request<{ detail: string }>("/cli/authorize", {
      method: "POST",
      body: JSON.stringify({ user_code: userCode, action }),
    });
  },

  updateProfile: async (username?: string, email?: string) => {
    return request<{ detail: string }>("/me", {
      method: "PUT",
      body: JSON.stringify({ username, email }),
    });
  },

  updatePassword: async (oldPassword: string, newPassword: string) => {
    return request<{ detail: string }>("/me/password", {
      method: "PUT",
      body: JSON.stringify({ old_password: oldPassword, new_password: newPassword }),
    });
  },

  logout: () => {
    clearDashboardCache();
    clearModulesMemoryCache();
    localStorage.removeItem("token");
    localStorage.removeItem("device_key");
    localStorage.removeItem("selected_org");
  },

  // Organizations
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

  getSelectedOrg: (): string | null => {
    return getSelectedOrg();
  },

  // Modules
  getModules: () =>
    request<{ modules: Module[] }>("/modules"),

  getAllModulesFull: (excludeContent?: boolean) =>
    request<ModuleDetail[]>(`/modules/all/full?exclude_content=${excludeContent ?? false}`),

  getModule: (id: string) =>
    request<ModuleDetail>(`/modules/${id}/full`),

  completeSection: (moduleId: string, sectionId: string) =>
    request<{ xp_awarded: number; total_xp: number }>(
      `/modules/${moduleId}/sections/${sectionId}/complete`,
      { method: "POST" }
    ),

  // Users
  getMe: () => request<User>("/me"),

  // Onboarding & Invitations (Module F)
  getOrganizationInfo: () =>
    request<OrganizationPublicInfoResponse>("/onboarding/organization-info"),

  requestAccess: (email: string) =>
    request<{ detail: string; status: string; mode?: string }>("/onboarding/access-request", {
      method: "POST",
      body: JSON.stringify({ email }),
    }),

  verifyInvitation: (token?: string, code?: string) =>
    request<InvitationVerifyResponse>("/onboarding/invitations/verify", {
      method: "POST",
      body: JSON.stringify({ token, code }),
    }),

  redeemInvitation: (token?: string, code?: string) =>
    request<{
      detail: string;
      access_token?: string;
      onboarding_token?: string;
      requires_password_setup?: boolean;
    }>("/onboarding/invitations/redeem", {
      method: "POST",
      body: JSON.stringify({ token, code }),
    }),

  completeOnboardingSetup: (onboardingToken: string, username: string, password: string) =>
    request<{ detail: string; access_token: string }>("/onboarding/invitations/complete-setup", {
      method: "POST",
      body: JSON.stringify({
        onboarding_token: onboardingToken,
        username,
        password,
      }),
    }),

  // Sessions (Module A)
  getSessions: () =>
    request<SessionResponse[]>("/sessions"),

  revokeSession: (sessionId: number) =>
    request<{ detail: string }>(`/sessions/${sessionId}`, {
      method: "DELETE",
    }),

  // Organization Administration (Module B)
  updateMemberRole: (orgSlug: string, userId: number, role: string) =>
    request<OrganizationMemberResponse>(`/organizations/${orgSlug}/members/${userId}/role`, {
      method: "PATCH",
      body: JSON.stringify({ role }),
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

  createCohort: (orgSlug: string, data: { name: string; description?: string; starts_at: string; ends_at: string; learning_paths?: number[] }) =>
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

  createLearningPath: (orgSlug: string, data: { name: string; slug: string; description?: string; visibility?: string; modules?: string[] }) =>
    request<LearningPathResponse>(`/organizations/${orgSlug}/learning-paths`, {
      method: "POST",
      body: JSON.stringify(data),
    }),

  getInvitations: (orgSlug?: string) =>
    request<InvitationResponse[]>("/organizations/invitations", {
      headers: orgSlug ? { "X-Organization-Slug": orgSlug, "X-Organization": orgSlug } : undefined,
    }),

  getInvitationStats: (orgSlug?: string) =>
    request<InvitationStatsResponse>("/organizations/invitations/stats", {
      headers: orgSlug ? { "X-Organization-Slug": orgSlug, "X-Organization": orgSlug } : undefined,
    }),

  createInvitation: (data: { email: string; role?: string; cohort_id?: number | null }, orgSlug?: string) =>
    request<InvitationResponse>("/organizations/invitations", {
      method: "POST",
      headers: orgSlug ? { "X-Organization-Slug": orgSlug, "X-Organization": orgSlug } : undefined,
      body: JSON.stringify(data),
    }),

  uploadBulkInvitations: async (file: File, cohortId?: number | null, orgSlug?: string) => {
    const token = typeof window !== "undefined" ? localStorage.getItem("token") : null;
    const selectedOrg = orgSlug || (typeof window !== "undefined" ? localStorage.getItem("selected_org") : null);
    const formData = new FormData();
    formData.append("file", file);
    if (cohortId) formData.append("cohort_id", cohortId.toString());

    const headers: Record<string, string> = {};
    if (token) headers["Authorization"] = `Bearer ${token}`;
    if (selectedOrg) {
      headers["X-Organization-Slug"] = selectedOrg;
      headers["X-Organization"] = selectedOrg;
    }

    const baseUrl = getApiBaseUrl();
    const res = await fetch(`${baseUrl}/organizations/invitations/bulk`, {
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
      headers: orgSlug ? { "X-Organization-Slug": orgSlug, "X-Organization": orgSlug } : undefined,
    }),

  getAccessRequests: (orgSlug?: string) =>
    request<AccessRequestResponse[]>("/organizations/access-requests", {
      headers: orgSlug ? { "X-Organization-Slug": orgSlug, "X-Organization": orgSlug } : undefined,
    }),

  approveAccessRequest: (id: number, orgSlug?: string) =>
    request<{ status: string; detail: string; invitation_id: number; invitation_code?: string }>(`/organizations/access-requests/${id}/approve`, {
      method: "POST",
      headers: orgSlug ? { "X-Organization-Slug": orgSlug, "X-Organization": orgSlug } : undefined,
      body: JSON.stringify({}),
    }),

  rejectAccessRequest: (id: number, reason?: string, orgSlug?: string) =>
    request<{ detail: string }>(`/organizations/access-requests/${id}/reject`, {
      method: "POST",
      headers: orgSlug ? { "X-Organization-Slug": orgSlug, "X-Organization": orgSlug } : undefined,
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

  // Analytics & Reporting
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

  getOrgAnalyticsCohortDetail: (orgSlug: string, cohortId: number) =>
    request<CohortDetailAnalyticsResponse>(`/organizations/${orgSlug}/analytics/cohorts/${cohortId}`),

  getOrgAnalyticsPaths: (orgSlug: string) =>
    request<PathAnalyticsItem[]>(`/organizations/${orgSlug}/analytics/paths`),

  getOrgAnalyticsPathDetail: (orgSlug: string, pathId: number) =>
    request<PathDetailAnalyticsResponse>(`/organizations/${orgSlug}/analytics/paths/${pathId}`),

  getOrgAnalyticsContent: (orgSlug: string) =>
    request<ContentAnalyticsResponse>(`/organizations/${orgSlug}/analytics/content`),

  getOrgAnalyticsXp: (orgSlug: string) =>
    request<XpAnalyticsResponse>(`/organizations/${orgSlug}/analytics/xp`),

  getOrgAnalyticsLearners: (orgSlug: string, cohortId?: number, search?: string) => {
    let url = `/organizations/${orgSlug}/analytics/learners?`;
    if (cohortId) url += `cohort_id=${cohortId}&`;
    if (search) url += `search=${encodeURIComponent(search)}&`;
    return request<LearnerAnalyticsItem[]>(url);
  },

  getOrgAnalyticsLearnerDetail: (orgSlug: string, userId: number) =>
    request<LearnerDetailAnalyticsResponse>(`/organizations/${orgSlug}/analytics/learners/${userId}`),

  exportOrgAnalyticsBlob: async (orgSlug: string, type: string) => {
    const token = getToken();
    const res = await fetch(`${API_BASE}/organizations/${orgSlug}/analytics/export/${type}`, {
      headers: {
        ...(token ? { Authorization: `Bearer ${token}` } : {}),
        "X-Organization-Slug": orgSlug,
      },
    });
    if (!res.ok) {
      const err = await res.json().catch(() => ({ detail: "Export failed" }));
      throw new Error(err.detail || "Export failed");
    }
    return await res.blob();
  },

  getPlatformAnalyticsOverview: () =>
    request<PlatformOverviewAnalyticsResponse>("/platform/analytics/overview"),

  getPlatformAnalyticsTrends: (period: string = "30d") =>
    request<PlatformTrendsAnalyticsResponse>(`/platform/analytics/trends?period=${period}`),

  getPlatformAnalyticsOrganizations: () =>
    request<PlatformOrgSummaryItem[]>("/platform/analytics/organizations"),

  exportPlatformAnalyticsBlob: async () => {
    const token = getToken();
    const res = await fetch(`${API_BASE}/platform/analytics/export/organizations`, {
      headers: {
        ...(token ? { Authorization: `Bearer ${token}` } : {}),
      },
    });
    if (!res.ok) {
      const err = await res.json().catch(() => ({ detail: "Export failed" }));
      throw new Error(err.detail || "Export failed");
    }
    return await res.blob();
  },

  // --- Platform Governance ---
  getPlatformPermissions: () =>
    request<PlatformPermissionItem[]>("/platform/permissions"),

  getPlatformUsers: () =>
    request<PlatformUserPermissionSummary[]>("/platform/users"),

  addPlatformUser: (data: { identity: string; permissions: string[] }) =>
    request<PlatformUserPermissionSummary>("/platform/users", {
      method: "POST",
      body: JSON.stringify(data),
    }),

  getUserPermissions: (userId: number) =>
    request<PlatformUserPermissionSummary>(`/platform/users/${userId}/permissions`),

  updateUserPermissions: (userId: number, permissions: string[]) =>
    request<PlatformUserPermissionSummary>(`/platform/users/${userId}/permissions`, {
      method: "PUT",
      body: JSON.stringify({ permissions }),
    }),

  revokePlatformUser: (userId: number) =>
    request<{ detail: string }>(`/platform/users/${userId}`, {
      method: "DELETE",
    }),

  updateOrgStatus: (slug: string, status: string, reason?: string) =>
    request<OrganizationResponse>(`/platform/organizations/${slug}/status`, {
      method: "PUT",
      body: JSON.stringify({ status, reason }),
    }),

  getPlatformAuditLogs: (params?: { limit?: number; offset?: number; action?: string; search?: string }) => {
    const q = new URLSearchParams();
    if (params?.limit) q.set("limit", String(params.limit));
    if (params?.offset) q.set("offset", String(params.offset));
    if (params?.action) q.set("action", params.action);
    if (params?.search) q.set("search", params.search);
    const qs = q.toString() ? `?${q.toString()}` : "";
    return request<AuditLogResponse[]>(`/platform/audit-logs${qs}`);
  },

  getPlatformOrgSettings: (orgSlug: string) =>
    request<OrgSettingAdminItemResponse[]>(`/admin/organizations/${orgSlug}/settings`),

  enablePlatformOrgSetting: (orgSlug: string, settingKey: string, initialValue?: any) =>
    request<any>(`/admin/organizations/${orgSlug}/settings/${settingKey}/enable`, {
      method: "POST",
      body: JSON.stringify({ initial_value: initialValue }),
    }),

  disablePlatformOrgSetting: (orgSlug: string, settingKey: string) =>
    request<any>(`/admin/organizations/${orgSlug}/settings/${settingKey}/disable`, {
      method: "POST",
    }),

  overridePlatformOrgSetting: (orgSlug: string, settingKey: string, value: any) =>
    request<any>(`/admin/organizations/${orgSlug}/settings/${settingKey}`, {
      method: "PATCH",
      body: JSON.stringify({ value }),
    }),
};