// web/frontend/lib/platform/hooks/use-platform-orgs.ts

"use client";

import { useState, useEffect, useCallback } from "react";
import { api } from "@/lib/api";
import { OrganizationResponse } from "@/lib/types";

export function usePlatformOrgs() {
  const [orgs, setOrgs] = useState<OrganizationResponse[]>([]);
  const [myMembershipSlugs, setMyMembershipSlugs] = useState<Set<string>>(new Set());
  const [orgSearch, setOrgSearch] = useState("");
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const loadOrgs = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const allOrgs = await api.getOrganizations().catch(() => []);
      setOrgs(allOrgs);
      setMyMembershipSlugs(new Set(allOrgs.filter((o) => o.is_member).map((o) => o.slug)));
    } catch (err: any) {
      setError(err.message || "Failed to load organizations");
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    loadOrgs();
  }, [loadOrgs]);

  const toggleOrgStatus = async (org: OrganizationResponse) => {
    const isSuspended = org.status === "suspended";
    const nextStatus = isSuspended ? "active" : "suspended";
    await api.updateOrgStatus(org.slug, nextStatus);
    const updated = await api.getOrganizations();
    setOrgs(updated);
  };

  const filteredOrgs = orgs.filter(
    (o) =>
      o.name.toLowerCase().includes(orgSearch.toLowerCase()) ||
      o.slug.toLowerCase().includes(orgSearch.toLowerCase())
  );

  return {
    orgs,
    filteredOrgs,
    myMembershipSlugs,
    orgSearch,
    setOrgSearch,
    loading,
    error,
    loadOrgs,
    toggleOrgStatus,
  };
}

