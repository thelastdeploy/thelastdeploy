"use client";

import React from "react";
import { ExternalLink, Layers, Plus, Trash2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import { EmptyState } from "@/components/shared/empty-state";
import type { Module } from "@/lib/types";

interface OrgCurriculumTabProps {
  modules: Module[];
  loading: boolean;
  onOpenAdoptModal: () => void;
  onViewModule: (moduleId: string) => void;
  onRemoveModule: (moduleId: string) => void;
}

export function OrgCurriculumTab({
  modules,
  loading,
  onOpenAdoptModal,
  onViewModule,
  onRemoveModule,
}: OrgCurriculumTabProps) {
  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h3 className="text-sm font-bold text-foreground">Workspace Curriculum Catalog</h3>
          <p className="text-xs text-muted-foreground">
            Manage learning modules available to learners and cohorts in this organization.
          </p>
        </div>
        <Button
          size="sm"
          onClick={onOpenAdoptModal}
          className="rounded-none bg-[var(--accent-primary)] text-black hover:opacity-90 font-bold text-xs h-9 px-3.5 cursor-pointer gap-1.5"
        >
          <Plus className="h-4 w-4" />
          <span>Adopt Platform Module</span>
        </Button>
      </div>

      {modules.length === 0 && !loading ? (
        <EmptyState
          icon={<Layers className="h-10 w-10" />}
          title="No modules in this workspace yet"
          description="Adopt official modules from the platform library or publish custom curriculum using the TLD CLI."
          action={
            <Button
              size="sm"
              onClick={onOpenAdoptModal}
              className="rounded-none bg-[var(--accent-primary)] text-black hover:opacity-90 font-bold text-xs h-9 px-3.5 cursor-pointer gap-1.5"
            >
              <Plus className="h-4 w-4" />
              <span>Browse &amp; Adopt Modules</span>
            </Button>
          }
        />
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 relative overflow-visible">
          {modules.map((mod, idx) => {
            const isLastRow = idx >= modules.length - (modules.length % 3 || 3);
            const isCol3 = (idx + 1) % 3 === 0;
            return (
              <div key={mod.id} className="relative">
                <div className="p-6 flex flex-col justify-between gap-4 h-full">
                  <div className="space-y-2">
                    <div className="flex items-start justify-between gap-2">
                      <span className="text-[10px] font-mono px-2 py-0.5 rounded-none bg-muted font-bold text-muted-foreground">
                        {mod.topic || "devops"}
                      </span>
                      <span
                        className={`text-[10px] font-mono font-bold px-2 py-0.5 rounded-none ${
                          mod.is_official_verified
                            ? "bg-emerald-500/10 text-emerald-500 border border-emerald-500/20"
                            : "bg-blue-500/10 text-blue-500 border border-blue-500/20"
                        }`}
                      >
                        {mod.is_official_verified ? "Official Verified" : mod.status}
                      </span>
                    </div>
                    <h4 className="text-base font-bold leading-snug text-foreground">
                      {mod.title}
                    </h4>
                    <p className="text-xs text-muted-foreground line-clamp-2">
                      {mod.description || "No description provided."}
                    </p>
                  </div>

                  <div className="flex items-center justify-between text-xs text-muted-foreground pt-3 border-t border-border/50">
                    <div className="flex items-center gap-2 font-mono">
                      <span>{mod.total_sections} sections</span>
                      <span>•</span>
                      <span>{mod.difficulty || "intermediate"}</span>
                    </div>
                    <div className="flex items-center gap-1">
                      <Button
                        size="sm"
                        variant="ghost"
                        onClick={() => onViewModule(mod.id)}
                        className="h-8 px-2 text-xs rounded-none hover:text-[var(--accent-primary)] cursor-pointer"
                        title="View module syllabus"
                      >
                        <ExternalLink className="h-3.5 w-3.5" />
                      </Button>
                      <Button
                        size="sm"
                        variant="ghost"
                        onClick={() => onRemoveModule(mod.id)}
                        className="h-8 px-2 text-xs rounded-none text-red-500 hover:text-red-400 hover:bg-red-500/10 cursor-pointer"
                        title="Remove module from workspace"
                      >
                        <Trash2 className="h-3.5 w-3.5" />
                      </Button>
                    </div>
                  </div>
                </div>
                {!isCol3 && <div className="matrix-line-v right-0 hidden lg:block" />}
                {!isLastRow && <div className="matrix-line-h bottom-0" />}
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}
