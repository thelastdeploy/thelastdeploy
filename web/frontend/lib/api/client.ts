import type { ModuleDetail, User } from "../types";
import { writeCache } from "../dashboard/use-dashboard-cache";

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

export function getToken(): string | null {
  if (typeof window === "undefined") return null;
  return localStorage.getItem("token");
}

export function getStoredSelectedOrg(): string | null {
  if (typeof window === "undefined") return null;
  return localStorage.getItem("selected_org");
}

export async function request<T>(path: string, options: RequestInit = {}): Promise<T> {
  const token = getToken();
  const selectedOrg = getStoredSelectedOrg();
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

export async function requestBlob(path: string, extraHeaders: Record<string, string> = {}): Promise<Blob> {
  const token = getToken();
  const res = await fetch(`${getApiBaseUrl()}${path}`, {
    headers: {
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
      ...extraHeaders,
    },
  });
  if (!res.ok) {
    const err = await res.json().catch(() => ({ detail: "Export failed" }));
    throw new Error(err.detail || "Export failed");
  }
  return res.blob();
}

/** After login/register — fetch everything needed and warm the cache. */
export async function warmCache(token: string): Promise<void> {
  try {
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
