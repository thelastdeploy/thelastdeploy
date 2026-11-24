// web/frontend/app/cohorts/page.tsx

"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { useAuth } from "@/lib/auth";
import { api } from "@/lib/api";
import { CohortResponse, LearningPathResponse } from "@/lib/types";
import { LoadingSpinner } from "@/components/shared/loading-spinner";
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
  const [activeOrg, setActiveOrg] = useState<string>("tld");
  const [orgName, setOrgName] = useState<string>("Personal");
  const [isAdmin, setIsAdmin] = useState(false);
  const [inviteCode, setInviteCode] = useState("");

  useEffect(() => {
    const selected = api.getSelectedOrg() || "tld";
    setActiveOrg(selected);

    Promise.all([
      api.getCohorts(selected).catch(() => []),
      api.getLearningPaths(selected).catch(() => []),
      api.getOrganizations().catch(() => []),
    ])
      .then(([cohortsData, pathsData, orgsData]) => {
        setCohorts(cohortsData);
        setPaths(pathsData);
        const current = orgsData.find((o) => o.slug === selected);
        if (current) {
          setOrgName(current.type === "platform" || current.is_platform ? "Personal" : current.name);
          const adminCheck = current.roles?.some((r) => ["admin", "owner", "platform_admin"].includes(r)) || user?.is_maintainer || user?.is_admin;
          setIsAdmin(!!adminCheck);
        }
      })
      .catch((err) => console.error("Error loading cohorts:", err))
      .finally(() => setLoading(false));

    const handleOrgChange = () => {
      const newOrg = api.getSelectedOrg() || "tld";
      setActiveOrg(newOrg);
      setLoading(true);
      Promise.all([
        api.getCohorts(newOrg).catch(() => []),
        api.getLearningPaths(newOrg).catch(() => []),
      ])
        .then(([cData, pData]) => {
          setCohorts(cData);
          setPaths(pData);
        })
        .finally(() => setLoading(false));
    };

    window.addEventListener("tld:workspace-changed", handleOrgChange);
    return () => window.removeEventListener("tld:workspace-changed", handleOrgChange);
  }, [user]);

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
      <div className="max-w-6xl mx-auto px-4 py-10 space-y-8">
        {/* Cohort Invite Code Box */}
        <div className="rounded-3xl border border-border bg-card/60 p-6 shadow-sm flex flex-col sm:flex-row items-center justify-between gap-6">
          <div className="flex items-center gap-4">
            <div className="h-12 w-12 rounded-2xl bg-[var(--accent-primary)]/10 text-[var(--accent-primary)] flex items-center justify-center shrink-0">
              <KeyRound className="h-6 w-6" />
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
              className="h-9 text-xs font-mono w-full sm:w-56 rounded-xl"
            />
            <Button
              type="submit"
              size="sm"
              className="h-9 rounded-xl bg-[var(--accent-primary)] text-black hover:opacity-90 font-bold text-xs shrink-0 cursor-pointer"
            >
              Join Cohort
            </Button>
          </form>
        </div>

        {/* Cohort Cards */}
        {cohorts.length === 0 ? (
          <div className="text-center py-20 border border-dashed border-border rounded-3xl bg-card/20 space-y-4">
            <div className="h-16 w-16 mx-auto rounded-2xl bg-muted/50 flex items-center justify-center text-muted-foreground">
              <Users className="h-8 w-8" />
            </div>
            <div className="space-y-1">
              <h3 className="text-lg font-bold text-foreground">No Cohorts Found in {orgName}</h3>
              <p className="text-xs text-muted-foreground max-w-sm mx-auto">
                No active cohorts are currently scheduled for this workspace. Use an invite code above or switch to an organization with active cohorts.
              </p>
            </div>
            <Button
              variant="outline"
              size="sm"
              asChild
              className="rounded-xl text-xs font-bold"
            >
              <Link href="/paths">Explore Learning Paths →</Link>
            </Button>
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            {cohorts.map((cohort) => {
              const assignedPaths = paths.filter((p) => cohort.learning_paths?.includes(p.id));

              return (
                <div
                  key={cohort.id}
                  className="rounded-3xl border border-border bg-card p-6 shadow-sm hover:border-[var(--accent-primary)]/50 transition-all flex flex-col justify-between group space-y-6"
                >
                  <div className="space-y-4">
                    <div className="flex items-start justify-between gap-4">
                      <div className="flex items-center gap-3">
                        <div className="h-11 w-11 rounded-2xl bg-[var(--accent-primary)]/10 text-[var(--accent-primary)] flex items-center justify-center font-black shrink-0">
                          <Users className="h-5 w-5" />
                        </div>
                        <div>
                          <h3 className="font-bold text-lg text-foreground group-hover:text-[var(--accent-primary)] transition-colors">
                            {cohort.name}
                          </h3>
                          <div className="flex items-center gap-2 mt-0.5">
                            <span className="flex h-2 w-2 rounded-full bg-emerald-500 animate-pulse" />
                            <span className="text-[11px] font-mono capitalize text-muted-foreground">
                              {cohort.status} Cohort
                            </span>
                          </div>
                        </div>
                      </div>
                    </div>

                    <p className="text-xs text-muted-foreground leading-relaxed">
                      {cohort.description || "Active class cohort progressing through scheduled milestones, lab assignments, and peer reviews."}
                    </p>

                    {/* Schedule / Timeline */}
                    <div className="p-3 rounded-2xl bg-muted/30 border border-border/50 grid grid-cols-2 gap-2 text-xs">
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

                    {/* Curricula assigned */}
                    <div className="space-y-2">
                      <div className="text-[10px] font-mono uppercase tracking-wider text-muted-foreground font-semibold">
                        Assigned Curricula:
                      </div>
                      {assignedPaths.length > 0 ? (
                        <div className="space-y-1.5">
                          {assignedPaths.map((p) => (
                            <div
                              key={p.id}
                              className="flex items-center justify-between p-2.5 rounded-xl bg-muted/40 text-xs font-medium text-foreground"
                            >
                              <div className="flex items-center gap-2">
                                <Layers className="h-3.5 w-3.5 text-[var(--accent-primary)]" />
                                <span>{p.name}</span>
                              </div>
                              <span className="text-[10px] font-mono text-muted-foreground">
                                {p.modules?.length || 0} labs
                              </span>
                            </div>
                          ))}
                        </div>
                      ) : (
                        <p className="text-xs text-muted-foreground italic">Curriculum assigned directly by instructors.</p>
                      )}
                    </div>
                  </div>

                  <div className="pt-4 border-t border-border flex items-center justify-between">
                    <span className="text-[11px] font-mono text-muted-foreground">
                      Cohort Track
                    </span>
                    <Button
                      size="sm"
                      asChild
                      className="rounded-xl bg-[var(--accent-primary)] text-black hover:opacity-90 font-bold text-xs gap-1.5"
                    >
                      <Link href="/paths">
                        <span>View Syllabus</span>
                        <ArrowRight className="h-3.5 w-3.5" />
                      </Link>
                    </Button>
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </div>
    </div>
  );
}

