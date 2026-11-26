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
          {(["7d", "30d", "90d", "all"] as const).map((p) => {
            const isActive = platformPeriod === p;
            return (
              <button
                key={p}
                type="button"
                onClick={() => handlePeriodChange(p)}
                className={`h-8 px-3 text-xs font-bold rounded-none border transition-all cursor-pointer ${
                  isActive
                    ? "bg-[var(--accent-primary)]/10 text-[var(--accent-primary)] border-[var(--accent-primary)]"
                    : "bg-transparent text-muted-foreground border-border hover:text-foreground hover:border-foreground/30"
                }`}
              >
                {p === "all" ? "All Time" : p.toUpperCase()}
              </button>
            );
          })}
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
              className="h-9 px-3.5 text-xs font-semibold text-foreground rounded-none border-border cursor-pointer gap-1.5"
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
            >
              <p className="text-[11px] font-mono uppercase text-muted-foreground">Verified XP Awarded</p>
              <p className="text-2xl font-black text-amber-400 mt-2">
                {platformOverview?.total_verified_xp ?? "—"} XP
              </p>
            </div>
          </div>
        </div>
      </div>

      {/* Organizations Breakdown: Single-Column Open Matrix with Continuous Horizontal Lines */}
      <div className="space-y-3">
        <div className="flex items-center justify-between">
          <h3 className="font-bold text-sm text-foreground">Tenant Organization Summary</h3>
          <span className="text-xs font-mono text-muted-foreground">{platformOrgsSummary.length} organizations active</span>
        </div>

        <div className="relative overflow-visible">
          <div className="relative">
            <div className="grid grid-cols-12 gap-3 px-4 py-3 text-muted-foreground font-mono uppercase text-[10px] font-semibold">
              <div className="col-span-3">Organization</div>
              <div className="col-span-1">Type</div>
              <div className="col-span-2">Status</div>
              <div className="col-span-1">Members</div>
              <div className="col-span-2">Active Cohorts</div>
              <div className="col-span-2">Lab Completions</div>
              <div className="col-span-1 text-right">Verified XP</div>
            </div>
            <div className="matrix-line-h bottom-0" />
          </div>

          <div className="flex flex-col relative">
            {platformOrgsSummary.map((org, idx) => {
              const isLast = idx === platformOrgsSummary.length - 1;
              return (
                <div key={org.organization_id} className="relative">
                  <div className="grid grid-cols-12 gap-3 px-4 py-3.5 items-center text-xs">
                    <div className="col-span-3 font-semibold text-foreground truncate">{org.name}</div>
                    <div className="col-span-1 uppercase font-mono text-[10px] text-muted-foreground truncate">{org.type}</div>
                    <div className="col-span-2">
                      <span className={`px-2 py-0.5 rounded-none text-[10px] font-bold ${
                        org.status === "active"
                          ? "bg-emerald-500/10 text-emerald-500 border border-emerald-500/30"
                          : "bg-red-500/10 text-red-500 border border-red-500/30"
                      }`}>
                        {org.status}
                      </span>
                    </div>
                    <div className="col-span-1 font-mono">{org.member_count}</div>
                    <div className="col-span-2 font-mono">{org.cohort_count}</div>
                    <div className="col-span-2 font-mono">{org.lab_completions_count}</div>
                    <div className="col-span-1 text-right font-mono text-amber-500 font-bold">{org.total_verified_xp} XP</div>
                  </div>
                  {!isLast && <div className="matrix-line-h bottom-0" />}
                </div>
              );
            })}
          </div>
        </div>
      </div>
    </div>
  );
}

