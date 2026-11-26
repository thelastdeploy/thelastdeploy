"use client";

import React from "react";
import { EmptyState } from "@/components/shared/empty-state";
import type { LearningPathResponse } from "@/lib/types";

interface OrgLearningPathsTabProps {
  learningPaths: LearningPathResponse[];
}

export function OrgLearningPathsTab({ learningPaths }: OrgLearningPathsTabProps) {
  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h3 className="text-sm font-bold text-foreground">Custom Learning Paths</h3>
          <p className="text-xs text-muted-foreground">
            Curate ordered modules tailored for your organization.
          </p>
        </div>
      </div>

      {learningPaths.length === 0 ? (
        <EmptyState description="No custom learning paths created yet." />
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 relative overflow-visible">
          {learningPaths.map((lp, idx) => {
            const isLastRow =
              idx >= learningPaths.length - (learningPaths.length % 2 === 0 ? 2 : 1);
            const isRightCol = idx % 2 === 1;
            return (
              <div key={lp.id} className="relative">
                <div className="p-6 space-y-3 h-full">
                  <div className="flex items-center justify-between gap-2">
                    <h4 className="text-base font-bold text-foreground">{lp.name}</h4>
                    <span className="text-[10px] uppercase font-mono px-2 py-0.5 rounded-none bg-muted font-bold">
                      {lp.visibility}
                    </span>
                  </div>
                  <p className="text-xs font-mono text-muted-foreground">{lp.slug}</p>
                  <p className="text-xs text-muted-foreground">
                    {lp.description || "No description provided."}
                  </p>
                  <div className="flex items-center justify-between pt-2 border-t border-border/50 text-xs">
                    <span className="text-muted-foreground font-mono">Curated Modules:</span>
                    <span className="font-bold font-mono text-foreground">
                      {lp.module_count} modules
                    </span>
                  </div>
                  {lp.modules && lp.modules.length > 0 && (
                    <div className="flex flex-wrap gap-1 pt-1">
                      {lp.modules.map((m) => (
                        <span
                          key={m}
                          className="px-2 py-0.5 rounded-none border border-border bg-muted/40 text-[10px] font-mono"
                        >
                          {m}
                        </span>
                      ))}
                    </div>
                  )}
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
