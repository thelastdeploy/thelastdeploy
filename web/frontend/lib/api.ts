// web/frontend/lib/api.ts

import {
  Module,
  ModuleDetail,
  User,
  BuilderDraftListItem,
  BuilderModuleInput,
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
  getOrganizations: () =>
    request<OrganizationMembershipInfo[]>("/organizations"),

  createOrganization: (data: { name: string; slug: string; type?: string; domains?: string[] }) =>
    request<OrganizationResponse>("/organizations", {
      method: "POST",
      body: JSON.stringify(data),
    }),

  setSelectedOrg: (slug: string) => {
    if (typeof window !== "undefined") {
      localStorage.setItem("selected_org", slug);
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

  // Builder
  getMyModules: () =>
    request<BuilderDraftListItem[]>("/builder/modules"),

  getBuilderModule: (id: string) =>
    request<BuilderModuleInput>(`/builder/modules/${id}`),

  createModule: (data: BuilderModuleInput) =>
    request<{ id: string }>("/builder/modules", {
      method: "POST",
      body: JSON.stringify(data),
    }),

  saveModule: (id: string, data: BuilderModuleInput) =>
    request<{ id: string }>(`/builder/modules/${id}`, {
      method: "PUT",
      body: JSON.stringify(data),
    }),

  publishModule: (id: string) =>
    request<{ id: string }>([`/builder/modules/${id}/publish`][0], {
      method: "POST",
    }),

  deleteModule: (id: string) =>
    request<{ detail: string }>(`/builder/modules/${id}`, {
      method: "DELETE",
    }),

  submitModuleForVerification: (id: string) =>
    request<{ detail: string }>(`/builder/modules/${id}/submit`, {
      method: "POST",
    }),

  verifyModule: (id: string, data: any) =>
    request<{ detail: string }>(`/modules/${id}/verify`, {
      method: "PATCH",
      body: JSON.stringify(data),
    }),

  rejectModule: (id: string, reason?: string) =>
    request<{ detail: string }>(`/modules/${id}/reject`, {
      method: "PATCH",
      body: JSON.stringify({ reason }),
    }),

  adminGetMaintainers: () =>
    request<any[]>("/admin/maintainers"),

  adminAddMaintainer: (identity: string) =>
    request<any>("/admin/maintainers", {
      method: "POST",
      body: JSON.stringify({ identity }),
    }),

  adminRemoveMaintainer: (userId: number) =>
    request<any>(`/admin/maintainers/${userId}`, {
      method: "DELETE",
    }),

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

  createLearningPath: (orgSlug: string, data: { name: string; slug: string; description?: string; visibility?: string; modules?: string[] }) =>
    request<LearningPathResponse>(`/organizations/${orgSlug}/learning-paths`, {
      method: "POST",
      body: JSON.stringify(data),
    }),

  getInvitations: () =>
    request<InvitationResponse[]>("/organizations/invitations"),

  getInvitationStats: () =>
    request<InvitationStatsResponse>("/organizations/invitations/stats"),

  createInvitation: (data: { email: string; role?: string; cohort_id?: number | null }) =>
    request<InvitationResponse>("/organizations/invitations", {
      method: "POST",
      body: JSON.stringify(data),
    }),

  uploadBulkInvitations: async (file: File, cohortId?: number | null) => {
    const token = typeof window !== "undefined" ? localStorage.getItem("token") : null;
    const selectedOrg = typeof window !== "undefined" ? localStorage.getItem("selected_org") : null;
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

  revokeInvitation: (id: number) =>
    request<{ detail: string }>(`/organizations/invitations/${id}/revoke`, {
      method: "POST",
    }),

  getAccessRequests: () =>
    request<AccessRequestResponse[]>("/organizations/access-requests"),

  approveAccessRequest: (id: number) =>
    request<{ status: string; detail: string; invitation_id: number; invitation_code?: string }>(`/organizations/access-requests/${id}/approve`, {
      method: "POST",
      body: JSON.stringify({}),
    }),

  rejectAccessRequest: (id: number, reason?: string) =>
    request<{ detail: string }>(`/organizations/access-requests/${id}/reject`, {
      method: "POST",
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
};