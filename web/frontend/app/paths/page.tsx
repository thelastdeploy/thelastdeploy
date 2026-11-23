// web/frontend/app/paths/page.tsx

"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { useAuth } from "@/lib/auth";
import { api } from "@/lib/api";
import { LearningPathResponse, Module } from "@/lib/types";
import { LoadingSpinner } from "@/components/shared/loading-spinner";
import { 
  BookOpen, Layers, CheckCircle2, ArrowRight, Sparkles, Building2, 
  GraduationCap, Globe, Shield, Terminal, Zap, ExternalLink 
} from "lucide-react";
import Link from "next/link";
import { Button } from "@/components/ui/button";

export default function LearningPathsPage() {
  const { user, loading: authLoading } = useAuth();
  const router = useRouter();
  const [paths, setPaths] = useState<LearningPathResponse[]>([]);
  const [modules, setModules] = useState<Module[]>([]);
  const [loading, setLoading] = useState(true);
  const [activeOrg, setActiveOrg] = useState<string>("tld");
  const [orgName, setOrgName] = useState<string>("Personal");

  useEffect(() => {
    const selected = api.getSelectedOrg() || "tld";
    setActiveOrg(selected);

    // Fetch org details & learning paths
    Promise.all([
      api.getLearningPaths(selected).catch(() => []),
      api.getModules().catch(() => ({ modules: [] })),
      api.getOrganizations().catch(() => []),
    ])
      .then(([pathsData, modulesData, orgsData]) => {
        setPaths(pathsData || []);
        const rawList = Array.isArray(modulesData) ? modulesData : (modulesData as any)?.modules || [];
        setModules(rawList);
        const current = orgsData.find((o) => o.slug === selected);
        if (current) {
          setOrgName(current.type === "platform" || current.is_platform ? "Personal" : current.name);
        }
      })
      .catch((err) => console.error("Error loading learning paths:", err))
      .finally(() => setLoading(false));

    const handleOrgChange = () => {
      const newOrg = api.getSelectedOrg() || "tld";
      setActiveOrg(newOrg);
      setLoading(true);
      Promise.all([
        api.getLearningPaths(newOrg).catch(() => []),
        api.getModules().catch(() => ({ modules: [] })),
        api.getOrganizations().catch(() => []),
      ])
        .then(([pathsData, modulesData, orgsData]) => {
          setPaths(pathsData || []);
          const rawList = Array.isArray(modulesData) ? modulesData : (modulesData as any)?.modules || [];
          setModules(rawList);
          const current = orgsData.find((o) => o.slug === newOrg);
          if (current) {
            setOrgName(current.type === "platform" || current.is_platform ? "Personal" : current.name);
          }
        })
        .finally(() => setLoading(false));
    };

    window.addEventListener("tld:workspace-changed", handleOrgChange);
    return () => window.removeEventListener("tld:workspace-changed", handleOrgChange);
  }, [user]);

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
        <div className="max-w-6xl mx-auto px-4 py-12">
          <div className="flex items-start justify-between gap-6 flex-wrap">
            <div>
              <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[var(--accent-primary)]/10 text-[var(--accent-primary)] text-xs font-mono font-bold mb-3">
                <Sparkles className="h-3.5 w-3.5" />
                <span>{orgName} Curriculum</span>
              </div>
              <h1 className="text-4xl font-black tracking-tight text-foreground">
                Learning Paths
              </h1>
              <p className="mt-2 text-muted-foreground max-w-xl text-sm leading-relaxed">
                Step-by-step structured curricula guiding you from fundamental DevOps tools to production-grade infrastructure scenarios.
              </p>
            </div>
            <div className="flex items-center gap-3">
              <div className="flex items-center gap-2 px-4 py-2.5 rounded-2xl border border-border bg-card shadow-sm">
                <Layers className="h-4 w-4 text-[var(--accent-primary)]" />
                <span className="font-mono font-bold text-sm text-[var(--accent-primary)]">
                  {paths.length}
                </span>
                <span className="text-muted-foreground text-xs">tracks active</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Content Area */}
      <div className="max-w-6xl mx-auto px-4 py-10">
        {paths.length === 0 ? (
          <div className="text-center py-20 border border-dashed border-border rounded-3xl bg-card/20 space-y-4">
            <div className="h-16 w-16 mx-auto rounded-2xl bg-muted/50 flex items-center justify-center text-muted-foreground">
              <BookOpen className="h-8 w-8" />
            </div>
            <div className="space-y-1">
              <h3 className="text-lg font-bold text-foreground">No Learning Paths in this Workspace</h3>
              <p className="text-xs text-muted-foreground max-w-sm mx-auto">
                There are no curated tracks published in {orgName} yet. Check back soon or switch workspaces.
              </p>
            </div>
            <Button
              variant="outline"
              size="sm"
              asChild
              className="rounded-xl text-xs font-bold"
            >
              <Link href="/modules">Browse All Modules →</Link>
            </Button>
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            {paths.map((path) => (
              <div
                key={path.id}
                className="rounded-3xl border border-border bg-card p-6 shadow-sm hover:border-[var(--accent-primary)]/50 transition-all flex flex-col justify-between group"
              >
                <div className="space-y-4">
                  <div className="flex items-start justify-between gap-4">
                    <div className="flex items-center gap-3">
                      <div className="h-10 w-10 rounded-2xl bg-[var(--accent-primary)]/10 text-[var(--accent-primary)] flex items-center justify-center font-black shrink-0">
                        <Layers className="h-5 w-5" />
                      </div>
                      <div>
                        <h3 className="font-bold text-lg text-foreground group-hover:text-[var(--accent-primary)] transition-colors">
                          {path.name}
                        </h3>
                        <p className="text-[11px] font-mono text-muted-foreground">
                          {path.modules?.length || 0} hands-on labs
                        </p>
                      </div>
                    </div>
                    <span className="text-[10px] font-mono uppercase px-2 py-0.5 rounded-full bg-muted font-bold text-muted-foreground">
                      {path.status}
                    </span>
                  </div>

                  <p className="text-xs text-muted-foreground leading-relaxed">
                    {path.description || "A complete sequential mastery journey through essential DevOps architecture and automation practices."}
                  </p>

                  {/* Modules sequential checklist */}
                  <div className="space-y-2 pt-2">
                    <div className="text-[10px] font-mono uppercase tracking-wider text-muted-foreground font-semibold">
                      Curriculum Labs:
                    </div>
                    <div className="space-y-1.5">
                      {path.modules && path.modules.length > 0 ? (
                        path.modules.map((modSlug, idx) => {
                          const modInfo = Array.isArray(modules) ? modules.find((m) => m.id === modSlug) : undefined;
                          return (
                            <Link
                              key={modSlug}
                              href={`/modules/${modSlug}`}
                              className="flex items-center justify-between p-2 rounded-xl bg-muted/40 hover:bg-muted text-xs font-medium text-foreground transition-colors group/mod"
                            >
                              <div className="flex items-center gap-2.5 truncate">
                                <span className="h-5 w-5 rounded-md bg-background flex items-center justify-center text-[10px] font-mono font-bold text-muted-foreground group-hover/mod:text-[var(--accent-primary)]">
                                  {idx + 1}
                                </span>
                                <span className="truncate">{modInfo?.title || modSlug}</span>
                              </div>
                              <ExternalLink className="h-3.5 w-3.5 text-muted-foreground group-hover/mod:text-[var(--accent-primary)] shrink-0" />
                            </Link>
                          );
                        })
                      ) : (
                        <p className="text-xs text-muted-foreground italic">No modules linked yet.</p>
                      )}
                    </div>
                  </div>
                </div>

                <div className="pt-6 mt-4 border-t border-border flex items-center justify-between">
                  <span className="text-[11px] font-mono text-muted-foreground">
                    Sequential Track
                  </span>
                  {path.modules && path.modules.length > 0 && (
                    <Button
                      size="sm"
                      asChild
                      className="rounded-xl bg-[var(--accent-primary)] text-black hover:opacity-90 font-bold text-xs gap-1.5"
                    >
                      <Link href={`/modules/${path.modules[0]}`}>
                        <span>Start Track</span>
                        <ArrowRight className="h-3.5 w-3.5" />
                      </Link>
                    </Button>
                  )}
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
