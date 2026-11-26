// web/frontend/app/cohorts/page.tsx

"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { useAuth } from "@/lib/auth";
import { api } from "@/lib/api";
import { useWorkspaceSync } from "@/lib/hooks/use-workspace-sync";
import { CohortResponse, LearningPathResponse } from "@/lib/types";
import { LoadingSpinner } from "@/components/shared/loading-spinner";
import { EmptyState } from "@/components/shared/empty-state";
import { 
  Users, Calendar, Clock, ArrowRight, ShieldCheck, CheckCircle2, 
  Sparkles, Layers, BookOpen, KeyRound, ExternalLink 
} from "lucide-react";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";

export default function CohortsPage() {
  const { user, loading: authLoading } = useAuth();
  const router = useRouter();
  const [cohorts, setCohorts] = useState<CohortResponse[]>([]);
  const [paths, setPaths] = useState<LearningPathResponse[]>([]);
  const [loading, setLoading] = useState(true);
  const selectedOrg = useWorkspaceSync() || "tld";
  const [activeOrg, setActiveOrg] = useState<string>("tld");
  const [orgName, setOrgName] = useState<string>("Personal");
  const [isAdmin, setIsAdmin] = useState(false);
  const [inviteCode, setInviteCode] = useState("");

  useEffect(() => {
    setActiveOrg(selectedOrg);
    setLoading(true);

    Promise.all([
      api.getCohorts(selectedOrg).catch(() => []),
      api.getLearningPaths(selectedOrg).catch(() => []),
      api.getOrganizations().catch(() => []),
    ])
      .then(([cohortsData, pathsData, orgsData]) => {
        setCohorts(cohortsData);
        setPaths(pathsData);
        const current = orgsData.find((o) => o.slug === selectedOrg);
        if (current) {
          setOrgName(current.type === "platform" || current.is_platform ? "Personal" : current.name);
          const adminCheck =
            current.roles?.some((r) => ["admin", "owner", "platform_admin"].includes(r)) ||
            user?.is_maintainer ||
            user?.is_admin;
          setIsAdmin(!!adminCheck);
        }
      })
      .catch((err) => console.error("Error loading cohorts:", err))
      .finally(() => setLoading(false));
  }, [user, selectedOrg]);

  const handleRedeemInvite = (e: React.FormEvent) => {
    e.preventDefault();
    if (!inviteCode.trim()) return;
    router.push(`/join?code=${encodeURIComponent(inviteCode.trim())}`);
  };

  if (authLoading || loading) {
    return (
      <div className="min-h-[calc(100vh-64px)] flex items-center justify-center">
        <LoadingSpinner />
      </div>
    );
  }

  return (
    <div className="min-h-[calc(100vh-64px)]">
      {/* Header Banner */}
      <div className="border-b border-border bg-card/30">
        <div className="max-w-7xl mx-auto px-4 py-12">
          <div className="flex items-start justify-between gap-6 flex-wrap">
            <div>
              <h1 className="text-4xl font-black tracking-tight text-foreground">
                Class Cohorts
              </h1>
              <p className="mt-2 text-muted-foreground max-w-xl text-sm leading-relaxed">
                Collaborative learning cohorts with synchronized schedules, curated syllabi, milestone deadlines, and peer progress.
              </p>
            </div>
          </div>
        </div>
      </div>

      {/* Main Container */}
      <div className="max-w-7xl mx-auto px-4 py-8 space-y-8">
        {/* Cohort Invite Code Box - Sharp Architectural Style */}
        <div className="rounded-none border border-border bg-card/60 p-5 sm:p-6 flex flex-col sm:flex-row items-center justify-between gap-6">
          <div className="flex items-center gap-4">
            <div className="h-10 w-10 rounded-none bg-[var(--accent-primary)]/10 text-[var(--accent-primary)] flex items-center justify-center shrink-0">
              <KeyRound className="h-5 w-5" />
            </div>
            <div>
              <h4 className="font-bold text-sm text-foreground">Have a Cohort Invitation Code?</h4>
              <p className="text-xs text-muted-foreground">
                Enter your instructor-issued code or invitation token to join your class cohort immediately.
              </p>
            </div>
          </div>

          <form onSubmit={handleRedeemInvite} className="flex items-center gap-2 w-full sm:w-auto">
            <Input
              placeholder="e.g. TLD-OCT26-XYZ"
              value={inviteCode}
              onChange={(e) => setInviteCode(e.target.value)}
              className="h-9 text-xs font-mono w-full sm:w-56 rounded-none"
            />
            <Button
              type="submit"
              size="sm"
              className="h-9 rounded-none bg-[var(--accent-primary)] text-white dark:text-black hover:opacity-90 font-bold text-xs shrink-0 cursor-pointer"
            >
              Join Cohort
            </Button>
          </form>
        </div>

        {/* Cohort Cards - Open Matrix Grid */}
        {cohorts.length === 0 ? (
          <EmptyState
            icon={<Users className="h-8 w-8" />}
            title={`No Cohorts Found in ${orgName}`}
            description="No active cohorts are currently scheduled for this workspace. Use an invite code above or switch to an organization with active cohorts."
            className="py-20 bg-card/20"
            action={
              <Button variant="outline" size="sm" asChild className="rounded-none text-xs font-bold">
                <Link href="/paths">Explore Learning Paths →</Link>
              </Button>
            }
          />
        ) : (
          <div className="relative overflow-visible">
            {/* Continuous Vertical Divider Line down the center */}
            <div className="matrix-line-v left-1/2 hidden lg:block" />

            <div className="flex flex-col relative">
              {Array.from({ length: Math.ceil(cohorts.length / 2) }, (_, rIdx) => {
                const row = cohorts.slice(rIdx * 2, rIdx * 2 + 2);
                const isLastRow = rIdx === Math.ceil(cohorts.length / 2) - 1;

                return (
                  <div key={rIdx} className="relative">
                    <div className="grid grid-cols-1 lg:grid-cols-2">
                      {row.map((cohort, cIdx) => {
                        const assignedPaths = paths.filter((p) => cohort.learning_paths?.includes(p.id));
                        const isLastInColMobile = isLastRow && cIdx === row.length - 1;

                        const isActive = cohort.status === "active";
                        const statusTheme = isActive
                          ? { border: "#10b981", bgDark: "rgba(16, 185, 129, 0.12)", bgLight: "rgba(16, 185, 129, 0.06)", text: "#10b981" }
                          : { border: "#0ea5e9", bgDark: "rgba(14, 165, 233, 0.12)", bgLight: "rgba(14, 165, 233, 0.06)", text: "#0ea5e9" };

                        return (
                          <div
                            key={cohort.id}
                            className={`group relative p-2.5 sm:p-3 text-left transition-colors border-0 ${
                              !isLastInColMobile ? "max-lg:border-b max-lg:border-border/40" : ""
                            }`}
                          >
                            {/* Sharp-Cornered Inset Tile (100% invisible when idle, inset highlight when hovered) */}
                            <div className="matrix-hover-cell w-full h-full min-h-[300px] p-6 sm:p-7 rounded-none flex flex-col justify-between">
                              <div className="space-y-4">
                                <div className="flex items-start justify-between gap-4">
                                  <div className="flex items-center gap-3">
                                    <div
                                      className="h-10 w-10 rounded-none flex items-center justify-center font-black shrink-0 transition-colors"
                                      style={{
                                        backgroundColor: `${statusTheme.border}20`,
                                        color: statusTheme.text,
                                      }}
                                    >
                                      <Users className="h-5 w-5" />
                                    </div>
                                    <div>
                                      <h3 className="font-bold text-lg text-foreground group-hover:text-foreground transition-colors">
                                        {cohort.name}
                                      </h3>
                                      <div className="flex items-center gap-2 mt-0.5">
                                        <span
                                          className={`flex h-2 w-2 rounded-full ${isActive ? "bg-emerald-500 animate-pulse" : "bg-sky-500"}`}
                                        />
                                        <span className="text-[11px] font-mono capitalize text-muted-foreground">
                                          {cohort.status} Cohort
                                        </span>
                                      </div>
                                    </div>
                                  </div>
                                </div>

                                <p className="text-xs text-muted-foreground leading-relaxed line-clamp-2">
                                  {cohort.description || "Active class cohort progressing through scheduled milestones, lab assignments, and peer reviews."}
                                </p>

                                {/* Schedule / Timeline */}
                                <div className="p-3 rounded-none bg-muted/30 border border-border/50 grid grid-cols-2 gap-2 text-xs">
                                  <div>
                                    <div className="text-[10px] font-mono uppercase text-muted-foreground">Starts</div>
                                    <div className="font-semibold text-foreground text-xs mt-0.5">
                                      {cohort.starts_at ? new Date(cohort.starts_at).toLocaleDateString() : "Flexible"}
                                    </div>
                                  </div>
                                  <div>
                                    <div className="text-[10px] font-mono uppercase text-muted-foreground">Ends</div>
                                    <div className="font-semibold text-foreground text-xs mt-0.5">
                                      {cohort.ends_at ? new Date(cohort.ends_at).toLocaleDateString() : "Open-ended"}
                                    </div>
                                  </div>
                                </div>
                              </div>
                            </div>
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
    </div>
  );
}

