// web/frontend/components/modules/module-grid.tsx

"use client";

import { useState, useMemo } from "react";
import { Module, Difficulty, Topic } from "@/lib/types";
import { ModuleCard } from "./module-card";
import { ModuleFilters } from "./module-filters";

export function ModuleGrid({ modules }: { modules: Module[] }) {
  const [searchQuery, setSearchQuery] = useState("");
  const [topic, setTopic] = useState<"all" | Topic>("all");
  const [difficulty, setDifficulty] = useState<"all" | Difficulty>("all");

  const filtered = useMemo(() => {
    return modules.filter((m) => {
      if (topic !== "all" && m.topic !== topic) return false;
      if (difficulty !== "all" && m.difficulty !== difficulty) return false;
      if (searchQuery) {
        const q = searchQuery.toLowerCase();
        const titleMatch = m.title.toLowerCase().includes(q);
        const descMatch = m.description?.toLowerCase().includes(q) ?? false;
        if (!titleMatch && !descMatch) return false;
      }
      return true;
    });
  }, [modules, topic, difficulty, searchQuery]);

  const hasActiveFilters = searchQuery || topic !== "all" || difficulty !== "all";

  return (
    <div>
      <div className="mb-10">
        <ModuleFilters
          searchQuery={searchQuery}
          onSearchChange={setSearchQuery}
          selectedTopic={topic}
          onTopicChange={setTopic}
          selectedDifficulty={difficulty}
          onDifficultyChange={setDifficulty}
          resultCount={filtered.length}
          totalCount={modules.length}
        />
      </div>

      {filtered.length === 0 ? (
        <div className="flex flex-col items-center justify-center py-20 text-center">
          <p className="text-muted-foreground text-sm font-semibold mb-1">
            {searchQuery
              ? `No modules matching "${searchQuery}"`
              : "No modules match your filters"}
          </p>
          <p className="text-xs text-muted-foreground/60 mb-4">
            Try adjusting your search or filter criteria
          </p>
          {hasActiveFilters && (
            <button
              onClick={() => { setSearchQuery(""); setTopic("all"); setDifficulty("all"); }}
              className="text-sm font-semibold text-[var(--accent-primary)] hover:underline cursor-pointer"
            >
              Clear all filters
            </button>
          )}
        </div>
      ) : (
        <div className="relative overflow-visible">
          {/* Continuous Vertical Divider Lines across all rows */}
          <div className="matrix-line-v left-1/3 hidden lg:block" />
          <div className="matrix-line-v left-2/3 hidden lg:block" />

          {/* Row Chunks with Continuous Horizontal Dividers */}
          <div className="flex flex-col relative">
            {Array.from({ length: Math.ceil(filtered.length / 3) }, (_, rIdx) => {
              const row = filtered.slice(rIdx * 3, rIdx * 3 + 3);
              const isLastRow = rIdx === Math.ceil(filtered.length / 3) - 1;

              return (
                <div key={rIdx} className="relative">
                  <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3">
                    {row.map((m, cIdx) => {
                      const isLastInColMobile = isLastRow && cIdx === row.length - 1;

                      return (
                        <div
                          key={m.id}
                          className={`group relative p-2.5 sm:p-3 text-left transition-colors border-0 ${
                            !isLastInColMobile ? "max-lg:border-b max-lg:border-border/40" : ""
                          }`}
                        >
                          <ModuleCard module={m} />
                        </div>
                      );
                    })}
                  </div>

                  {/* Continuous Horizontal Row Divider Line (omitted on last row) */}
                  {!isLastRow && (
                    <div className="matrix-line-h bottom-0 hidden lg:block" />
                  )}
                </div>
              );
            })}
          </div>
        </div>
      )}
    </div>
  );
}