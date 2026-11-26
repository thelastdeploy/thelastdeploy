"use client";

import React from "react";
import { Award, Download, TrendingUp } from "lucide-react";
import { Button } from "@/components/ui/button";
import { PeriodSelector } from "@/components/shared/period-selector";
import type {
  AnalyticsOverviewResponse,
  AnalyticsTrendsResponse,
  CohortAnalyticsItem,
  ContentAnalyticsResponse,
  XpAnalyticsResponse,
} from "@/lib/types";

interface OrgAnalyticsTabProps {
  analyticsPeriod: string;
  analyticsLoading: boolean;
  exportLoading: string | null;
  analyticsOverview: AnalyticsOverviewResponse | null;
  analyticsTrends: AnalyticsTrendsResponse | null;
  analyticsCohorts: CohortAnalyticsItem[];
  analyticsContent: ContentAnalyticsResponse | null;
  analyticsXp: XpAnalyticsResponse | null;
  onChangePeriod: (period: string) => void;
  onRefresh: () => void;
  onExport: (type: "learners" | "activity" | "cohorts" | "content") => void;
}

export function OrgAnalyticsTab({
  analyticsPeriod,
  analyticsLoading,
  exportLoading,
  analyticsOverview,
  analyticsTrends,
  analyticsCohorts,
  analyticsContent,
  analyticsXp,
  onChangePeriod,
  onRefresh,
  onExport,
}: OrgAnalyticsTabProps) {
  return (
    <div className="space-y-8">
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 p-4 rounded-none bg-card border border-border">
        <PeriodSelector
          value={analyticsPeriod}
          onChange={onChangePeriod}
          onRefresh={onRefresh}
          loading={analyticsLoading}
        />

        <div className="flex items-center gap-2 flex-wrap">
          <span className="text-xs font-bold text-muted-foreground uppercase tracking-wider font-mono mr-1">
            Export:
          </span>
          {(["learners", "activity", "cohorts", "content"] as const).map((expType) => (
            <Button
              key={expType}
              size="sm"
              variant="outline"
              onClick={() => onExport(expType)}
              disabled={exportLoading === expType}
              className="h-8 px-2.5 rounded-none border-border text-xs font-semibold gap-1.5 cursor-pointer"
            >
              <Download className="h-3.5 w-3.5 text-[var(--accent-primary)]" />
              <span className="capitalize">{expType}</span>
            </Button>
          ))}
        </div>
      </div>

      <div className="relative overflow-visible">
        <div className="grid grid-cols-2 md:grid-cols-4 relative">
          <div className="p-5 relative">
            <span className="text-[11px] font-mono text-muted-foreground font-semibold uppercase tracking-wider">
              Learners Participation
            </span>
            <p className="text-3xl font-black font-mono text-foreground mt-2">
              {analyticsOverview
                ? `${analyticsOverview.learners_started} / ${analyticsOverview.total_learners}`
                : "—"}
            </p>
            <p className="text-[11px] text-muted-foreground mt-1">
              {analyticsOverview && analyticsOverview.total_learners > 0
                ? `${Math.round(
                    (analyticsOverview.learners_started / analyticsOverview.total_learners) * 100
                  )}% active learners`
                : "0% active"}
            </p>
            <div className="matrix-line-v right-0" />
          </div>

          <div className="p-5 relative">
            <span className="text-[11px] font-mono text-muted-foreground font-semibold uppercase tracking-wider">
              Labs Completed
            </span>
            <p className="text-3xl font-black font-mono text-[var(--accent-primary)] mt-2">
              {analyticsOverview?.total_completed_labs ?? "—"}
            </p>
            <p className="text-[11px] text-muted-foreground mt-1">
              {analyticsOverview?.total_completed_sections ?? 0} reading sections finished
            </p>
            <div className="matrix-line-v right-0 hidden md:block" />
          </div>

          <div className="p-5 relative">
            <span className="text-[11px] font-mono text-muted-foreground font-semibold uppercase tracking-wider">
              Verified XP
            </span>
            <p className="text-3xl font-black font-mono text-emerald-500 mt-2">
              {analyticsOverview?.total_verified_xp ?? "—"}
            </p>
            <p className="text-[11px] text-muted-foreground mt-1">Authoritative tenant score</p>
            <div className="matrix-line-v right-0" />
          </div>

          <div className="p-5 relative">
            <span className="text-[11px] font-mono text-muted-foreground font-semibold uppercase tracking-wider">
              Unverified XP
            </span>
            <p className="text-3xl font-black font-mono text-amber-500 mt-2">
              {analyticsOverview?.total_unverified_xp ?? "—"}
            </p>
            <p className="text-[11px] text-muted-foreground mt-1">From custom/pending content</p>
          </div>
        </div>
        <div className="matrix-line-h bottom-0" />
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 relative overflow-visible">
        <div className="p-6 relative space-y-4">
          <div className="flex items-center justify-between">
            <div>
              <h3 className="text-sm font-bold text-foreground">Activity Trends</h3>
              <p className="text-xs text-muted-foreground">
                Lab completions &amp; XP earned ({analyticsPeriod})
              </p>
            </div>
            <TrendingUp className="h-4 w-4 text-[var(--accent-primary)]" />
          </div>
          {analyticsTrends && analyticsTrends.lab_completions.filter((p) => p.count > 0).length > 0 ? (
            <div className="space-y-1 max-h-60 overflow-y-auto pr-1">
              {analyticsTrends.lab_completions
                .filter((p) => p.count > 0)
                .slice(-10)
                .reverse()
                .map((pt) => {
                  const xpPoint = analyticsTrends.xp_earned.find((x) => x.date === pt.date);
                  return (
                    <div
                      key={pt.date}
                      className="flex items-center justify-between py-2 border-b border-border/40 text-xs"
                    >
                      <span className="font-mono text-muted-foreground">{pt.date}</span>
                      <div className="flex items-center gap-3">
                        <span className="font-bold text-foreground">
                          {pt.count} lab{pt.count > 1 ? "s" : ""}
                        </span>
                        {xpPoint && xpPoint.xp > 0 && (
                          <span className="font-mono text-[var(--accent-primary)] font-bold">
                            +{xpPoint.xp} XP
                          </span>
                        )}
                      </div>
                    </div>
                  );
                })}
            </div>
          ) : (
            <div className="py-8 text-center text-xs font-mono text-muted-foreground">
              No completion activity recorded in selected timeframe.
            </div>
          )}
          <div className="matrix-line-v right-0 hidden md:block" />
        </div>

        <div className="p-6 space-y-4">
          <div className="flex items-center justify-between">
            <div>
              <h3 className="text-sm font-bold text-foreground">XP Distribution</h3>
              <p className="text-xs text-muted-foreground">
                Summary metrics across organization members
              </p>
            </div>
            <Award className="h-4 w-4 text-emerald-500" />
          </div>
          <div className="grid grid-cols-4 gap-2 text-center">
            <div className="p-2.5 border border-border bg-muted/20 rounded-none">
              <span className="text-[10px] font-mono text-muted-foreground uppercase font-bold">
                Average
              </span>
              <p className="text-sm font-black font-mono mt-1">{analyticsXp?.average_xp ?? 0}</p>
            </div>
            <div className="p-2.5 border border-border bg-muted/20 rounded-none">
              <span className="text-[10px] font-mono text-muted-foreground uppercase font-bold">
                Median
              </span>
              <p className="text-sm font-black font-mono mt-1">{analyticsXp?.median_xp ?? 0}</p>
            </div>
            <div className="p-2.5 border border-border bg-muted/20 rounded-none">
              <span className="text-[10px] font-mono text-muted-foreground uppercase font-bold">
                Min
              </span>
              <p className="text-sm font-black font-mono mt-1">{analyticsXp?.min_xp ?? 0}</p>
            </div>
            <div className="p-2.5 border border-border bg-muted/20 rounded-none">
              <span className="text-[10px] font-mono text-muted-foreground uppercase font-bold">
                Max
              </span>
              <p className="text-sm font-black font-mono mt-1 text-[var(--accent-primary)]">
                {analyticsXp?.max_xp ?? 0}
              </p>
            </div>
          </div>

          {analyticsXp && analyticsXp.distribution.length > 0 && (
            <div className="space-y-2 pt-2">
              {analyticsXp.distribution.map((d) => (
                <div
                  key={d.range_label}
                  className="flex items-center justify-between text-xs py-1 border-b border-border/40"
                >
                  <span className="text-muted-foreground font-mono">{d.range_label}</span>
                  <span className="font-bold font-mono text-foreground">
                    {d.learner_count} learners
                  </span>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>

      <div className="space-y-3">
        <div>
          <h3 className="text-base font-bold text-foreground">Cohort Performance</h3>
          <p className="text-xs text-muted-foreground">Progress and XP generated by cohorts</p>
        </div>
        <div className="relative overflow-visible">
          <div className="relative">
            <div className="grid grid-cols-12 gap-3 px-4 py-3 text-muted-foreground font-mono uppercase text-[10px] font-semibold">
              <div className="col-span-3">Cohort</div>
              <div className="col-span-2">Status</div>
              <div className="col-span-1">Members</div>
              <div className="col-span-2">Learners Active</div>
              <div className="col-span-2">Completed Labs</div>
              <div className="col-span-1">Verified XP</div>
              <div className="col-span-1 text-right">Unverified</div>
            </div>
            <div className="matrix-line-h bottom-0" />
          </div>
          <div className="flex flex-col relative">
            {analyticsCohorts.length === 0 ? (
              <div className="p-8 text-center text-muted-foreground text-xs font-mono">
                No cohorts configured in this organization.
              </div>
            ) : (
              analyticsCohorts.map((c, idx) => (
                <div key={c.cohort_id} className="relative">
                  <div className="grid grid-cols-12 gap-3 px-4 py-3.5 items-center text-xs">
                    <div className="col-span-3 font-bold text-foreground truncate">{c.name}</div>
                    <div className="col-span-2">
                      <span className="capitalize font-mono px-2 py-0.5 text-[10px] bg-muted font-bold">
                        {c.status}
                      </span>
                    </div>
                    <div className="col-span-1 font-mono">{c.member_count}</div>
                    <div className="col-span-2 font-mono text-[var(--accent-primary)] font-bold">
                      {c.learners_started}
                    </div>
                    <div className="col-span-2 font-mono">{c.completed_labs}</div>
                    <div className="col-span-1 font-mono text-emerald-500 font-bold">
                      {c.total_verified_xp} XP
                    </div>
                    <div className="col-span-1 text-right font-mono text-amber-500">
                      {c.total_unverified_xp} XP
                    </div>
                  </div>
                  {idx < analyticsCohorts.length - 1 && <div className="matrix-line-h bottom-0" />}
                </div>
              ))
            )}
          </div>
        </div>
      </div>

      {analyticsContent && (
        <div className="grid grid-cols-1 md:grid-cols-2 border-y border-border/60 divide-y md:divide-y-0 md:divide-x divide-border/50">
          <div className="py-5 pr-0 md:pr-6 space-y-4">
            <div>
              <h3 className="text-sm font-bold text-foreground">Most Completed Modules</h3>
              <p className="text-xs text-muted-foreground mt-0.5">
                Top modules with recorded lab completions
              </p>
            </div>
            {analyticsContent.most_completed_modules.filter((m) => m.completions_count > 0).length >
            0 ? (
              <div className="divide-y divide-border/40">
                {analyticsContent.most_completed_modules
                  .filter((m) => m.completions_count > 0)
                  .slice(0, 5)
                  .map((m) => (
                    <div key={m.id} className="flex items-center justify-between py-2.5 text-xs">
                      <div>
                        <p className="font-bold text-foreground">{m.title}</p>
                        <span className="text-[10px] font-mono text-muted-foreground">
                          {m.is_tld_owned ? "TLD Core" : "Custom Org"} • {m.distinct_learners_count}{" "}
                          learners
                        </span>
                      </div>
                      <span className="font-mono font-bold text-[var(--accent-primary)]">
                        {m.completions_count} finished
                      </span>
                    </div>
                  ))}
              </div>
            ) : (
              <p className="py-6 text-center text-xs text-muted-foreground font-mono">
                No module completions recorded yet.
              </p>
            )}
          </div>

          <div className="py-5 pl-0 md:pl-6 space-y-4">
            <div>
              <h3 className="text-sm font-bold text-foreground">
                Content Ownership &amp; Verification
              </h3>
              <p className="text-xs text-muted-foreground mt-0.5">
                Module catalog breakdown for this organization
              </p>
            </div>
            <div className="divide-y divide-border/40 text-xs">
              <div className="flex justify-between py-2">
                <span className="text-muted-foreground">Verified Modules Available</span>
                <span className="font-bold text-emerald-500 font-mono">
                  {analyticsContent.verified_modules_count}
                </span>
              </div>
              <div className="flex justify-between py-2">
                <span className="text-muted-foreground">Custom / Unverified Modules</span>
                <span className="font-bold text-amber-500 font-mono">
                  {analyticsContent.unverified_modules_count}
                </span>
              </div>
              <div className="flex justify-between py-2">
                <span className="text-muted-foreground">TLD-Owned Modules</span>
                <span className="font-bold text-foreground font-mono">
                  {analyticsContent.tld_owned_modules_count}
                </span>
              </div>
              <div className="flex justify-between py-2">
                <span className="text-muted-foreground">Organization-Owned Modules</span>
                <span className="font-bold text-foreground font-mono">
                  {analyticsContent.org_owned_modules_count}
                </span>
              </div>
              <div className="flex justify-between py-2">
                <span className="text-muted-foreground">Verified Lab Completions</span>
                <span className="font-bold text-emerald-500 font-mono">
                  {analyticsContent.verified_lab_completions}
                </span>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
