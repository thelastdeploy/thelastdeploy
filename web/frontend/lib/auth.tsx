// web/frontend/lib/auth.tsx

"use client";

import { createContext, useContext, useEffect, useState } from "react";
import { usePathname } from "next/navigation";
import { api } from "./api";
import { User } from "./types";
import { readCache, writeCache, CACHE_EVENT } from "./dashboard/use-dashboard-cache";

interface AuthContextType {
  user: User | null;
  loading: boolean;
  login: (token: string, deviceKey?: string) => Promise<void>;
  logout: () => void;
  refreshUser: () => Promise<void>;
}

const AuthContext = createContext<AuthContextType>({
  user: null,
  loading: true,
  login: async () => {},
  logout: () => {},
  refreshUser: async () => {},
});

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);
  const pathname = usePathname();

  const fetchUser = async () => {
    try {
      // Warm state immediately from cache if available so UI does not flicker
      const cache = readCache();
      if (cache?.user) {
        setUser(cache.user);
      }
      // Always revalidate with /me to ensure RBAC permissions and session data are 100% current
      const me = await api.getMe();
      setUser(me);
      if (cache) {
        writeCache({ ...cache, user: me });
      }
    } catch {
      localStorage.removeItem("token");
      localStorage.removeItem("device_key");
      setUser(null);
    }
  };

  useEffect(() => {
    const token = localStorage.getItem("token");
    if (token) {
      fetchUser().finally(() => setLoading(false));
    } else {
      setLoading(false);
    }
  }, []);

  // Revalidate user whenever the pathname changes
  useEffect(() => {
    if (pathname && localStorage.getItem("token")) {
      refreshUser();
    }
  }, [pathname]);

  useEffect(() => {
    if (typeof window === "undefined") return;
    const handleUpdate = () => {
      const cache = readCache();
      if (cache?.user) {
        setUser(cache.user);
      }
    };
    window.addEventListener(CACHE_EVENT, handleUpdate);

    const handleWsChange = () => {
      refreshUser();
    };
    window.addEventListener("tld:workspace-changed", handleWsChange);

    const handleUserUpdated = () => {
      refreshUser();
    };
    window.addEventListener("tld:user-updated", handleUserUpdated);

    const handleFocus = () => {
      refreshUser();
    };
    window.addEventListener("focus", handleFocus);

    return () => {
      window.removeEventListener(CACHE_EVENT, handleUpdate);
      window.removeEventListener("tld:workspace-changed", handleWsChange);
      window.removeEventListener("tld:user-updated", handleUserUpdated);
      window.removeEventListener("focus", handleFocus);
    };
  }, []);

  const login = async (token: string, deviceKey?: string) => {
    localStorage.setItem("token", token);
    if (deviceKey) localStorage.setItem("device_key", deviceKey);
    // Cache was already warmed by api.login() — just read from it
    const cache = readCache();
    if (cache?.user) {
      setUser(cache.user);
    } else {
      await fetchUser();
    }
  };

  const logout = () => {
    api.logout(); // clears token, device_key, and dashboard cache
    setUser(null);
  };

  const refreshUser = async () => {
    const token = localStorage.getItem("token");
    if (!token) return;
    try {
      const me = await api.getMe();
      setUser(me);
      const cache = readCache();
      if (cache) {
        writeCache({ ...cache, user: me });
      }
    } catch {
      // ignore
    }
  };

  return (
    <AuthContext.Provider value={{ user, loading, login, logout, refreshUser }}>
      {children}
    </AuthContext.Provider>
  );
}

export const useAuth = () => useContext(AuthContext);