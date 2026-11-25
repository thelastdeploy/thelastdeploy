// web/frontend/lib/platform/hooks/use-platform-analytics.ts

"use client";

import { useState, useEffect, useCallback } from "react";
import { api } from "@/lib/api";
import {
  PlatformOverviewAnalyticsResponse,
  PlatformTrendsAnalyticsResponse,
  PlatformOrgSummaryItem,
} from "@/lib/types";

export function usePlatformAnalytics() {
  const [platformOverview, setPlatformOverview] = useState<PlatformOverviewAnalyticsResponse | null>(null);
  const [platformTrends, setPlatformTrends] = useState<PlatformTrendsAnalyticsResponse | null>(null);
  const [platformOrgsSummary, setPlatformOrgsSummary] = useState<PlatformOrgSummaryItem[]>([]);
  const [platformPeriod, setPlatformPeriod] = useState<string>("30d");
  const [loading, setLoading] = useState(false);
  const [exporting, setExporting] = useState(false);

  const loadAnalytics = useCallback(async (period: string = platformPeriod) => {
    setLoading(true);
    try {
      const [ov, tr, orgsSummary] = await Promise.all([
        api.getPlatformAnalyticsOverview().catch(() => null),
        api.getPlatformAnalyticsTrends(period).catch(() => null),
        api.getPlatformAnalyticsOrganizations().catch(() => []),
      ]);
      setPlatformOverview(ov);
      setPlatformTrends(tr);
      setPlatformOrgsSummary(orgsSummary);
    } catch (err) {
      console.error("Failed to load platform analytics:", err);
    } finally {
      setLoading(false);
    }
  }, [platformPeriod]);

  useEffect(() => {
    loadAnalytics(platformPeriod);
  }, []);

  const handlePeriodChange = (newPeriod: string) => {
    setPlatformPeriod(newPeriod);
    loadAnalytics(newPeriod);
  };

  const exportOrganizationsCsv = async () => {
    setExporting(true);
    try {
      const blob = await api.exportPlatformAnalyticsBlob();
      const url = window.URL.createObjectURL(blob);
      const a = document.createElement("a");
      a.href = url;
      a.download = "platform_organizations_summary.csv";
      document.body.appendChild(a);
      a.click();
      window.URL.revokeObjectURL(url);
      document.body.removeChild(a);
    } catch (err: any) {
      alert("Platform export failed: " + err.message);
    } finally {
      setExporting(false);
    }
  };

  return {
    platformOverview,
    platformTrends,
    platformOrgsSummary,
    platformPeriod,
    loading,
    exporting,
    loadAnalytics,
    handlePeriodChange,
    exportOrganizationsCsv,
  };
}

