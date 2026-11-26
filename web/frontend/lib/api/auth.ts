import type { SessionResponse, User } from "../types";
import { clearDashboardCache } from "../dashboard/use-dashboard-cache";
import { clearModulesMemoryCache } from "@/hooks/use-modules";
import { request, warmCache } from "./client";

export const authApi = {
  register: async (email: string, username: string, password: string) =>
    request<{ detail: string }>("/register", {
      method: "POST",
      body: JSON.stringify({ email, username, password }),
    }),

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

  checkUsername: async (username: string) =>
    request<{ available: boolean; detail?: string }>(
      `/check-username?username=${encodeURIComponent(username)}`
    ),

  verifyEmail: async (token: string) =>
    request<{ detail: string }>("/verify-email", {
      method: "POST",
      body: JSON.stringify({ token }),
    }),

  forgotPassword: async (email: string) =>
    request<{ detail: string }>("/forgot-password", {
      method: "POST",
      body: JSON.stringify({ email }),
    }),

  resetPassword: async (token: string, password: string) =>
    request<{ detail: string }>("/reset-password", {
      method: "POST",
      body: JSON.stringify({ token, password }),
    }),

  resendVerification: async (email: string) =>
    request<{ detail: string }>("/resend-verification", {
      method: "POST",
      body: JSON.stringify({ email }),
    }),

  cliAuthorize: async (userCode: string, action: "approve" | "deny" = "approve") =>
    request<{ detail: string }>("/cli/authorize", {
      method: "POST",
      body: JSON.stringify({ user_code: userCode, action }),
    }),

  updateProfile: async (username?: string, email?: string) =>
    request<{ detail: string }>("/me", {
      method: "PUT",
      body: JSON.stringify({ username, email }),
    }),

  updatePassword: async (oldPassword: string, newPassword: string) =>
    request<{ detail: string }>("/me/password", {
      method: "PUT",
      body: JSON.stringify({ old_password: oldPassword, new_password: newPassword }),
    }),

  logout: () => {
    clearDashboardCache();
    clearModulesMemoryCache();
    localStorage.removeItem("token");
    localStorage.removeItem("device_key");
    localStorage.removeItem("selected_org");
  },

  getMe: () => request<User>("/me"),

  getSessions: () => request<SessionResponse[]>("/sessions"),

  revokeSession: (sessionId: number) =>
    request<{ detail: string }>(`/sessions/${sessionId}`, {
      method: "DELETE",
    }),
};
