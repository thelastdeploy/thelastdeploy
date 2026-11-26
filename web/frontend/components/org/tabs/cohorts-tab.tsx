"use client";

import React from "react";
import { Plus, UserPlus, Users } from "lucide-react";
import { Button } from "@/components/ui/button";
import { EmptyState } from "@/components/shared/empty-state";
import type { CohortResponse } from "@/lib/types";

interface OrgCohortsTabProps {
  cohorts: CohortResponse[];
  onOpenCohortModal: () => void;
  onViewRoster: (cohort: CohortResponse) => void;
  onInviteToCohort: (cohortId: number) => void;
}

export function OrgCohortsTab({
  cohorts,
  onOpenCohortModal,
  onViewRoster,
  onInviteToCohort,
}: OrgCohortsTabProps) {
  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h3 className="text-sm font-bold text-foreground">Cohorts &amp; Batches</h3>
          <p className="text-xs text-muted-foreground">
            Group students into learning cohorts with start and end dates.
          </p>
        </div>
        <Button
          size="sm"
          onClick={onOpenCohortModal}
          className="rounded-none bg-[var(--accent-primary)] text-black hover:opacity-90 font-bold text-xs h-9 px-3.5 cursor-pointer gap-1.5"
        >
          <Plus className="h-3.5 w-3.5" />
          <span>New Cohort</span>
        </Button>
      </div>

      {cohorts.length === 0 ? (
        <EmptyState description='No cohorts created yet. Click "New Cohort" to create one.' />
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 relative overflow-visible">
          {cohorts.map((c, idx) => {
            const isLastRow = idx >= cohorts.length - (cohorts.length % 2 === 0 ? 2 : 1);
            const isRightCol = idx % 2 === 1;
            return (
              <div key={c.id} className="relative">
                <div className="p-6 flex flex-col justify-between gap-4 h-full">
                  <div className="space-y-2">
                    <div className="flex items-center justify-between gap-2">
                      <h4 className="text-base font-bold text-foreground">{c.name}</h4>
                      <span className="text-[10px] uppercase font-mono px-2 py-0.5 rounded-none bg-emerald-500/10 text-emerald-500 border border-emerald-500/20 font-bold">
                        {c.status}
                      </span>
                    </div>
                    {c.description && <p className="text-xs text-muted-foreground">{c.description}</p>}
                    <div className="space-y-1.5 text-xs text-muted-foreground pt-2">
                      <div className="flex items-center justify-between">
                        <span className="font-mono">Timeline:</span>
                        <span className="font-mono text-foreground">
                          {new Date(c.starts_at).toLocaleDateString()} →{" "}
                          {new Date(c.ends_at).toLocaleDateString()}
                        </span>
                      </div>
                      <div className="flex items-center justify-between">
                        <span className="font-mono">Assigned Curricula:</span>
                        <span className="font-bold font-mono text-foreground">
                          {c.learning_paths?.length || 0} paths
                        </span>
                      </div>
                    </div>
                  </div>

                  <div className="flex gap-2 pt-2">
                    <Button
                      size="sm"
                      variant="outline"
                      onClick={() => onViewRoster(c)}
                      className="flex-1 text-xs font-semibold rounded-none border-border h-8 cursor-pointer gap-1.5"
                    >
                      <Users className="h-3.5 w-3.5" />
                      <span>View Student Roster</span>
                    </Button>
                    <Button
                      size="sm"
                      variant="outline"
                      onClick={() => onInviteToCohort(c.id)}
                      className="text-xs font-semibold rounded-none border-border h-8 px-3 cursor-pointer gap-1.5"
                      title="Invite directly to this cohort"
                    >
                      <UserPlus className="h-3.5 w-3.5" />
                      <span>Invite</span>
                    </Button>
                  </div>
                </div>
                {!isRightCol && <div className="matrix-line-v right-0 hidden md:block" />}
                {!isLastRow && <div className="matrix-line-h bottom-0" />}
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}
