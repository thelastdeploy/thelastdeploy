// web/frontend/lib/platform/hooks/use-platform-audit.ts

"use client";

import { useState, useEffect, useCallback } from "react";
import { api } from "@/lib/api";
import { AuditLogResponse } from "@/lib/types";

export function usePlatformAudit() {
  const [auditLogs, setAuditLogs] = useState<AuditLogResponse[]>([]);
  const [loading, setLoading] = useState(false);
  const [auditSearch, setAuditSearch] = useState("");
  const [auditActionFilter, setAuditActionFilter] = useState("all");

  const loadAuditLogs = useCallback(async () => {
    setLoading(true);
    try {
      const logs = await api.getPlatformAuditLogs({
        limit: 100,
        action: auditActionFilter === "all" ? undefined : auditActionFilter,
        search: auditSearch || undefined,
      });
      setAuditLogs(logs);
    } catch (err) {
      console.error("Failed to load audit logs:", err);
    } finally {
      setLoading(false);
    }
  }, [auditActionFilter, auditSearch]);

  useEffect(() => {
    loadAuditLogs();
  }, [loadAuditLogs]);

  return {
    auditLogs,
    loading,
    auditSearch,
    setAuditSearch,
    auditActionFilter,
    setAuditActionFilter,
    loadAuditLogs,
  };
}

