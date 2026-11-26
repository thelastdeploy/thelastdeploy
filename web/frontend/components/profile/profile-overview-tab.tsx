"use client";

import { useState } from "react";
import type { User } from "@/lib/types";
import type { Rank } from "@/lib/ranks";

function getTopicBadge(labId: string) {
  if (labId.startsWith("dkr-")) {
    return { label: "Docker", color: "text-blue-400 bg-blue-500/10 border-blue-500/20" };
  }
  if (labId.startsWith("k8s-")) {
    return { label: "Kubernetes", color: "text-indigo-400 bg-indigo-500/10 border-indigo-500/20" };
  }
  if (labId.startsWith("lnx-")) {
    return { label: "Linux", color: "text-orange-400 bg-orange-500/10 border-orange-500/20" };
  }
  if (labId.startsWith("git-")) {
    return { label: "Git", color: "text-red-400 bg-red-500/10 border-red-500/20" };
  }
  return { label: "System", color: "text-muted-foreground bg-muted border-border" };
}

interface ProfileOverviewTabProps {
  user: User;
  rank: Rank;
}

export function ProfileOverviewTab({ user, rank }: ProfileOverviewTabProps) {
  const [labSearch, setLabSearch] = useState("");

  const filteredLabs = user.completed_labs.filter((labId) =>
    labId.toLowerCase().includes(labSearch.toLowerCase())
  );

  const dockerCompleted = user.completed_labs.filter((id) => id.startsWith("dkr-")).length;
  const k8sCompleted = user.completed_labs.filter((id) => id.startsWith("k8s-")).length;
  const lnxCompleted = user.completed_labs.filter((id) => id.startsWith("lnx-")).length;
  const gitCompleted = user.completed_labs.filter((id) => id.startsWith("git-")).length;

  return (
    <div className="grid grid-cols-1 md:grid-cols-3 gap-6 items-start">
      {/* Activity Summary Column */}
      <div className="md:col-span-1 space-y-6">
        <div className="bg-card border border-border rounded-2xl p-6 shadow-md space-y-5">
          <div>
            <h2 className="text-lg font-black text-foreground">Activity Summary</h2>
            <p className="text-xs text-muted-foreground mt-0.5">{rank.description}</p>
          </div>
          <div className="space-y-4">
            <div className="flex justify-between items-center border-b border-border/50 pb-2">
              <span className="text-sm text-muted-foreground">Labs Completed</span>
              <span className="font-bold text-foreground font-mono text-base bg-muted px-2.5 py-0.5 rounded-lg border border-border/60">
                {user.completed_labs.length}
              </span>
            </div>
            <div className="flex justify-between items-center border-b border-border/50 pb-2">
              <span className="text-sm text-muted-foreground">Reading Sections</span>
              <span className="font-bold text-foreground font-mono text-base bg-muted px-2.5 py-0.5 rounded-lg border border-border/60">
                {user.completed_sections.length}
              </span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-muted-foreground">Rank Tier</span>
              <span className="font-bold text-xs uppercase tracking-wide px-2 py-0.5 rounded-lg bg-[var(--accent-primary)]/10 text-[var(--accent-primary)] border border-[var(--accent-primary)]/20">
                {rank.label}
              </span>
            </div>
          </div>
        </div>

        {/* Topic Mastery Progress Card */}
        <div className="bg-card border border-border rounded-2xl p-6 shadow-md space-y-5">
          <div>
            <h2 className="text-lg font-black text-foreground">Topic Mastery</h2>
            <p className="text-xs text-muted-foreground mt-0.5">Your progress across disciplines</p>
          </div>
          <div className="space-y-4">
            {[
              { label: "Docker", count: dockerCompleted, dot: "bg-blue-400", text: "text-blue-400" },
              { label: "Kubernetes", count: k8sCompleted, dot: "bg-indigo-400", text: "text-indigo-400" },
              { label: "Linux", count: lnxCompleted, dot: "bg-orange-400", text: "text-orange-400" },
              { label: "Git", count: gitCompleted, dot: "bg-red-400", text: "text-red-400" },
            ].map((topic) => (
              <div key={topic.label} className="space-y-1.5">
                <div className="flex justify-between items-center text-xs">
                  <span className={`font-bold flex items-center gap-1.5 ${topic.text}`}>
                    <span className={`w-2 h-2 rounded-full ${topic.dot}`} /> {topic.label}
                  </span>
                  <span className="font-mono text-[10px] text-muted-foreground">
                    {topic.count} completed
                  </span>
                </div>
                <div className="w-full bg-muted rounded-full h-2 overflow-hidden">
                  <div
                    className={`${topic.dot} h-full rounded-full transition-all duration-500`}
                    style={{ width: `${Math.min(100, topic.count * 10)}%` }}
                  />
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Completed Labs Column */}
      <div className="md:col-span-2 space-y-4">
        <div className="bg-card border border-border rounded-2xl p-6 shadow-md space-y-6">
          <div className="flex flex-col sm:flex-row justify-between sm:items-center gap-3">
            <h2 className="text-lg font-black text-foreground">Completed Labs & Progress</h2>

            {user.completed_labs.length > 0 && (
              <div className="relative max-w-xs">
                <input
                  type="text"
                  placeholder="Search labs..."
                  value={labSearch}
                  onChange={(e) => setLabSearch(e.target.value)}
                  className="w-full bg-background border border-border text-foreground text-xs placeholder:text-muted-foreground/45 h-9 px-3 rounded-lg focus:border-[var(--accent-primary)] focus:ring-0 outline-none"
                />
              </div>
            )}
          </div>

          {user.completed_labs.length === 0 ? (
            <div className="text-center py-16 text-muted-foreground text-sm space-y-3">
              <p>No labs completed yet.</p>
              <p className="text-xs">Go to your dashboard to sync and start practicing DevOps labs!</p>
            </div>
          ) : filteredLabs.length === 0 ? (
            <div className="text-center py-12 text-muted-foreground text-xs">
              No completed labs match &quot;{labSearch}&quot;
            </div>
          ) : (
            <div className="space-y-3 max-h-[420px] overflow-y-auto pr-1">
              {filteredLabs.map((labId) => {
                const topic = getTopicBadge(labId);
                return (
                  <div
                    key={labId}
                    className="flex items-center justify-between p-4 bg-background/50 hover:bg-background/90 hover:scale-[1.005] hover:border-[var(--accent-primary)]/45 transition-all duration-300 rounded-xl border border-border gap-4 group"
                  >
                    <div className="flex items-center gap-3.5">
                      <div className="w-9 h-9 rounded-xl bg-emerald-500/10 flex items-center justify-center text-emerald-500 border border-emerald-500/20 group-hover:scale-105 transition-all">
                        <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M5 13l4 4L19 7" />
                        </svg>
                      </div>
                      <div className="space-y-1">
                        <p className="font-bold text-foreground text-sm tracking-wide group-hover:text-[var(--accent-primary)] transition-all">
                          {labId}
                        </p>
                        <span className={`inline-block px-2 py-0.5 rounded text-[9px] font-black tracking-wider uppercase border ${topic.color}`}>
                          {topic.label}
                        </span>
                      </div>
                    </div>

                    <span className="px-3 py-1 rounded-full text-[10px] font-black uppercase bg-emerald-500/10 text-emerald-400 border border-emerald-500/20 select-none">
                      Completed
                    </span>
                  </div>
                );
              })}
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

