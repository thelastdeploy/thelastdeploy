// web/frontend/lib/platform/hooks/use-platform-operators.ts

"use client";

import { useState, useEffect, useCallback } from "react";
import { api } from "@/lib/api";
import { PlatformUserPermissionSummary, PlatformPermissionItem } from "@/lib/types";

export function usePlatformOperators() {
  const [platformUsers, setPlatformUsers] = useState<PlatformUserPermissionSummary[]>([]);
  const [availablePermissions, setAvailablePermissions] = useState<PlatformPermissionItem[]>([]);
  const [loading, setLoading] = useState(false);

  const loadOperatorsData = useCallback(async () => {
    setLoading(true);
    try {
      const [usersList, permsList] = await Promise.all([
        api.getPlatformUsers().catch(() => []),
        api.getPlatformPermissions().catch(() => []),
      ]);
      setPlatformUsers(usersList);
      setAvailablePermissions(permsList);
    } catch (err) {
      console.error("Failed to load platform operators:", err);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    loadOperatorsData();
  }, [loadOperatorsData]);

  const addPlatformUser = async (identity: string) => {
    const added = await api.addPlatformUser({
      identity: identity.trim(),
      permissions: [
        "platform.analytics.view",
        "platform.users.view",
      ],
    });
    await loadOperatorsData();
    return added;
  };

  const updateUserPermissions = async (userId: number, permissions: string[]) => {
    await api.updateUserPermissions(userId, permissions);
    await loadOperatorsData();
  };

  const revokePlatformUser = async (userId: number) => {
    await api.revokePlatformUser(userId);
    await loadOperatorsData();
  };

  return {
    platformUsers,
    availablePermissions,
    loading,
    loadOperatorsData,
    addPlatformUser,
    updateUserPermissions,
    revokePlatformUser,
  };
}

