// web/frontend/components/platform/analytics-tab.tsx

"use client";

import { Button } from "@/components/ui/button";
import { Download, RefreshCw } from "lucide-react";
import { usePlatformAnalytics } from "@/lib/platform/hooks/use-platform-analytics";

interface AnalyticsTabProps {
  hasPerm: (perm: string) => boolean;
}

export function AnalyticsTab({ hasPerm }: AnalyticsTabProps) {
  const {
    platformOverview,
    platformOrgsSummary,
    platformPeriod,
    loading,
    exporting,
    loadAnalytics,
    handlePeriodChange,
    exportOrganizationsCsv,
  } = usePlatformAnalytics();

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 p-4 rounded-none bg-card border border-border">
        <div className="flex items-center gap-2 flex-wrap">
          <span className="text-xs font-bold text-muted-foreground uppercase tracking-wider font-mono mr-1">Period:</span>
          {(["7d", "30d", "90d", "all"] as const).map((p) => (
            <Button
              key={p}
              size="sm"
              variant={platformPeriod === p ? "default" : "outline"}
              onClick={() => handlePeriodChange(p)}
              className={`h-8 px-3 rounded-none text-xs font-bold cursor-pointer border ${
                platformPeriod === p
                  ? "bg-[var(--accent-primary)] text-white dark:text-black border-[var(--accent-primary)]"
                  : "border-border/60"
              }`}
            >
              {p === "all" ? "All Time" : p.toUpperCase()}
            </Button>
          ))}
          <Button
            size="sm"
            variant="ghost"
            onClick={() => loadAnalytics(platformPeriod)}
            disabled={loading}
            className="h-8 w-8 p-0 rounded-none ml-1 text-muted-foreground hover:text-foreground cursor-pointer"
            title="Refresh Platform Analytics"
          >
            <RefreshCw className={`h-3.5 w-3.5 ${loading ? "animate-spin" : ""}`} />
          </Button>
        </div>

        {hasPerm("platform.analytics.export") && (
          <div>
            <Button
              size="sm"
              variant="outline"
              onClick={exportOrganizationsCsv}
              disabled={exporting}
              className="h-8 px-3 rounded-none text-xs font-semibold gap-1.5 cursor-pointer"
            >
              <Download className="h-3.5 w-3.5 text-[var(--accent-primary)]" />
              <span>{exporting ? "Exporting..." : "Export Organizations CSV"}</span>
            </Button>
          </div>
        )}
      </div>

      {/* KPI Cards: 4-Column Open Matrix with Continuous Extending Lines */}
      <div className="relative overflow-visible">
        <div className="matrix-line-v left-1/4 hidden md:block" />
        <div className="matrix-line-v left-2/4 hidden md:block" />
        <div className="matrix-line-v left-3/4 hidden md:block" />

        <div className="grid grid-cols-2 md:grid-cols-4">
          {/* Total Organizations */}
          <div className="group relative p-2.5 sm:p-3 text-left border-0">
            <div
              className="p-5 rounded-none flex flex-col justify-between transition-all duration-150"
              style={{ border: "none", boxShadow: "none", backgroundColor: "transparent" }}
              onMouseEnter={(e) => {
                const isDark = document.documentElement.classList.contains("dark");
                e.currentTarget.style.boxShadow = "inset 0 0 0 2px var(--accent-primary)";
                e.currentTarget.style.backgroundColor = isDark
                  ? "rgba(var(--accent-primary-rgb), 0.12)"
                  : "rgba(var(--accent-primary-rgb), 0.05)";
              }}
              onMouseLeave={(e) => {
                e.currentTarget.style.boxShadow = "none";
                e.currentTarget.style.backgroundColor = "transparent";
              }}
            >
              <p className="text-[11px] font-mono uppercase text-muted-foreground">Total Organizations</p>
              <p className="text-2xl font-black text-foreground mt-2">
                {platformOverview?.total_organizations ?? "—"}
              </p>
            </div>
          </div>

          {/* Global Users */}
          <div className="group relative p-2.5 sm:p-3 text-left border-0">
            <div
              className="p-5 rounded-none flex flex-col justify-between transition-all duration-150"
              style={{ border: "none", boxShadow: "none", backgroundColor: "transparent" }}
              onMouseEnter={(e) => {
                const isDark = document.documentElement.classList.contains("dark");
                e.currentTarget.style.boxShadow = "inset 0 0 0 2px var(--accent-primary)";
                e.currentTarget.style.backgroundColor = isDark
                  ? "rgba(var(--accent-primary-rgb), 0.12)"
                  : "rgba(var(--accent-primary-rgb), 0.05)";
              }}
              onMouseLeave={(e) => {
                e.currentTarget.style.boxShadow = "none";
                e.currentTarget.style.backgroundColor = "transparent";
              }}
            >
              <p className="text-[11px] font-mono uppercase text-muted-foreground">Global Users</p>
              <p className="text-2xl font-black text-[var(--accent-primary)] mt-2">
                {platformOverview?.total_users ?? "—"}
              </p>
            </div>
          </div>

          {/* Lab Completions */}
          <div className="group relative p-2.5 sm:p-3 text-left border-0">
            <div
              className="p-5 rounded-none flex flex-col justify-between transition-all duration-150"
              style={{ border: "none", boxShadow: "none", backgroundColor: "transparent" }}
              onMouseEnter={(e) => {
                const isDark = document.documentElement.classList.contains("dark");
                e.currentTarget.style.boxShadow = "inset 0 0 0 2px #10b981";
                e.currentTarget.style.backgroundColor = isDark
                  ? "rgba(16, 185, 129, 0.12)"
                  : "rgba(16, 185, 129, 0.05)";
              }}
              onMouseLeave={(e) => {
                e.currentTarget.style.boxShadow = "none";
                e.currentTarget.style.backgroundColor = "transparent";
              }}
            >
              <p className="text-[11px] font-mono uppercase text-muted-foreground">Lab Completions</p>
              <p className="text-2xl font-black text-emerald-400 mt-2">
                {platformOverview?.total_lab_completions ?? "—"}
              </p>
            </div>
          </div>

          {/* Verified XP Awarded */}
          <div className="group relative p-2.5 sm:p-3 text-left border-0">
            <div
              className="p-5 rounded-none flex flex-col justify-between transition-all duration-150"
              style={{ border: "none", boxShadow: "none", backgroundColor: "transparent" }}
              onMouseEnter={(e) => {
                const isDark = document.documentElement.classList.contains("dark");
                e.currentTarget.style.boxShadow = "inset 0 0 0 2px #f59e0b";
                e.currentTarget.style.backgroundColor = isDark
                  ? "rgba(245, 158, 11, 0.12)"
                  : "rgba(245, 158, 11, 0.05)";
              }}
              onMouseLeave={(e) => {
                e.currentTarget.style.boxShadow = "none";
                e.currentTarget.style.backgroundColor = "transparent";
              }}
            >
              <p className="text-[11px] font-mono uppercase text-muted-foreground">Verified XP Awarded</p>
              <p className="text-2xl font-black text-amber-400 mt-2">
                {platformOverview?.total_verified_xp ?? "—"} XP
              </p>
            </div>
          </div>
        </div>
      </div>

      {/* Organizations Breakdown Table */}
      <div className="rounded-none border border-border bg-card overflow-hidden">
        <div className="p-4 border-b border-border bg-muted/20 flex items-center justify-between">
          <h3 className="font-bold text-sm text-foreground">Tenant Organization Summary</h3>
          <span className="text-xs font-mono text-muted-foreground">{platformOrgsSummary.length} organizations active</span>
        </div>
        <div className="overflow-x-auto">
          <table className="w-full text-xs text-left">
            <thead className="bg-muted/30 text-muted-foreground font-mono uppercase text-[10px]">
              <tr>
                <th className="p-3">Organization</th>
                <th className="p-3">Type</th>
                <th className="p-3">Status</th>
                <th className="p-3">Members</th>
                <th className="p-3">Active Cohorts</th>
                <th className="p-3">Lab Completions</th>
                <th className="p-3 text-right">Verified XP</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-border">
              {platformOrgsSummary.map((org) => (
                <tr key={org.organization_id} className="hover:bg-muted/10 transition-colors">
                  <td className="p-3 font-semibold text-foreground">{org.name}</td>
                  <td className="p-3 uppercase font-mono text-[10px] text-muted-foreground">{org.type}</td>
                  <td className="p-3">
                    <span className={`px-2 py-0.5 rounded-none text-[10px] font-bold ${
                      org.status === "active" ? "bg-emerald-500/10 text-emerald-400 border border-emerald-500/30" : "bg-red-500/10 text-red-400 border border-red-500/30"
                    }`}>
                      {org.status}
                    </span>
                  </td>
                  <td className="p-3 font-mono">{org.member_count}</td>
                  <td className="p-3 font-mono">{org.cohort_count}</td>
                  <td className="p-3 font-mono">{org.lab_completions_count}</td>
                  <td className="p-3 text-right font-mono text-amber-400 font-bold">{org.total_verified_xp} XP</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}

