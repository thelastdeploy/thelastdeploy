import type {
  AuditLogResponse,
  OrganizationResponse,
  OrgSettingAdminItemResponse,
  PlatformOrgSummaryItem,
  PlatformOverviewAnalyticsResponse,
  PlatformPermissionItem,
  PlatformTrendsAnalyticsResponse,
  PlatformUserPermissionSummary,
} from "../types";
import { request, requestBlob } from "./client";

export const platformApi = {
  getPlatformAnalyticsOverview: () =>
    request<PlatformOverviewAnalyticsResponse>("/platform/analytics/overview"),

  getPlatformAnalyticsTrends: (period: string = "30d") =>
    request<PlatformTrendsAnalyticsResponse>(`/platform/analytics/trends?period=${period}`),

  getPlatformAnalyticsOrganizations: () =>
    request<PlatformOrgSummaryItem[]>("/platform/analytics/organizations"),

  exportPlatformAnalyticsBlob: () => requestBlob("/platform/analytics/export/organizations"),

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
