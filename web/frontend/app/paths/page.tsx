// web/frontend/app/paths/page.tsx

"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { useAuth } from "@/lib/auth";
import { api } from "@/lib/api";
import { LearningPathResponse, Module } from "@/lib/types";
import { LoadingSpinner } from "@/components/shared/loading-spinner";
import { 
  BookOpen, Layers, ArrowRight, ExternalLink 
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
        <div className="max-w-7xl mx-auto px-4 py-12">
          <div className="flex items-start justify-between gap-6 flex-wrap">
            <div>
              <h1 className="text-4xl font-black tracking-tight text-foreground">
                Learning Paths
              </h1>
              <p className="mt-2 text-muted-foreground max-w-xl text-sm leading-relaxed">
                Step-by-step structured curricula guiding you from fundamental DevOps tools to production-grade infrastructure scenarios.
              </p>
            </div>
          </div>
        </div>
      </div>

      {/* Content Area - Open Matrix Grid */}
      <div className="max-w-7xl mx-auto px-4 py-8">
        {paths.length === 0 ? (
          <div className="text-center py-20 border border-dashed border-border rounded-none bg-card/20 space-y-4">
            <div className="h-16 w-16 mx-auto rounded-none bg-muted/50 flex items-center justify-center text-muted-foreground">
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
              className="rounded-none text-xs font-bold"
            >
              <Link href="/modules">Browse All Modules →</Link>
            </Button>
          </div>
        ) : (
          <div className="relative overflow-visible">
            {/* Continuous Vertical Divider Line down the center */}
            <div className="matrix-line-v left-1/2 hidden lg:block" />

            <div className="flex flex-col relative">
              {Array.from({ length: Math.ceil(paths.length / 2) }, (_, rIdx) => {
                const row = paths.slice(rIdx * 2, rIdx * 2 + 2);
                const isLastRow = rIdx === Math.ceil(paths.length / 2) - 1;

                return (
                  <div key={rIdx} className="relative">
                    <div className="grid grid-cols-1 lg:grid-cols-2">
                      {row.map((path, cIdx) => {
                        const globalIndex = rIdx * 2 + cIdx;
                        const isLastInColMobile = isLastRow && cIdx === row.length - 1;

                        const themePalette = [
                          { border: "#10b981", bgDark: "rgba(16, 185, 129, 0.12)", bgLight: "rgba(16, 185, 129, 0.06)", text: "#10b981", label: "DevOps" },
                          { border: "#06b6d4", bgDark: "rgba(6, 182, 212, 0.12)", bgLight: "rgba(6, 182, 212, 0.06)", text: "#06b6d4", label: "Cloud" },
                          { border: "#a855f7", bgDark: "rgba(168, 85, 247, 0.12)", bgLight: "rgba(168, 85, 247, 0.06)", text: "#a855f7", label: "Containers" },
                          { border: "#f59e0b", bgDark: "rgba(245, 158, 11, 0.12)", bgLight: "rgba(245, 158, 11, 0.06)", text: "#f59e0b", label: "Systems" },
                          { border: "#3b82f6", bgDark: "rgba(59, 130, 246, 0.12)", bgLight: "rgba(59, 130, 246, 0.06)", text: "#3b82f6", label: "Architecture" },
                        ];
                        const theme = themePalette[globalIndex % themePalette.length];

                        return (
                          <div
                            key={path.id}
                            className={`group relative p-2.5 sm:p-3 text-left transition-colors border-0 ${
                              !isLastInColMobile ? "max-lg:border-b max-lg:border-border/40" : ""
                            }`}
                          >
                            {/* Sharp-Cornered Inset Tile (100% invisible when idle, thick topic highlight when hover) */}
                            <div
                              className="w-full h-full min-h-[300px] p-6 sm:p-7 rounded-none flex flex-col justify-between transition-all duration-150"
                              style={{
                                border: "none",
                                boxShadow: "none",
                                backgroundColor: "transparent",
                              }}
                              onMouseEnter={(e) => {
                                const isDark = document.documentElement.classList.contains("dark");
                                e.currentTarget.style.boxShadow = `inset 0 0 0 2px ${theme.border}`;
                                e.currentTarget.style.backgroundColor = isDark ? theme.bgDark : theme.bgLight;
                              }}
                              onMouseLeave={(e) => {
                                e.currentTarget.style.boxShadow = "none";
                                e.currentTarget.style.backgroundColor = "transparent";
                              }}
                            >
                              <div className="space-y-4">
                                <div className="flex items-start justify-between gap-4">
                                  <div className="flex items-center gap-3">
                                    <div
                                      className="h-10 w-10 rounded-none flex items-center justify-center font-black shrink-0 transition-colors"
                                      style={{
                                        backgroundColor: `${theme.border}20`,
                                        color: theme.text,
                                      }}
                                    >
                                      <Layers className="h-5 w-5" />
                                    </div>
                                    <div>
                                      <h3 className="font-bold text-lg text-foreground group-hover:text-foreground transition-colors">
                                        {path.name}
                                      </h3>
                                      <p className="text-[11px] font-mono text-muted-foreground">
                                        {path.modules?.length || 0} hands-on labs
                                      </p>
                                    </div>
                                  </div>
                                  <span
                                    className="text-[10px] font-mono uppercase px-2 py-0.5 rounded-none font-bold"
                                    style={{
                                      backgroundColor: `${theme.border}15`,
                                      color: theme.text,
                                    }}
                                  >
                                    {path.status}
                                  </span>
                                </div>

                                <p className="text-xs text-muted-foreground leading-relaxed line-clamp-2">
                                  {path.description || "A complete sequential mastery journey through essential DevOps architecture and automation practices."}
                                </p>

                                {/* Modules sequential checklist */}
                                <div className="space-y-2 pt-1">
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
                                            className="flex items-center justify-between p-2 rounded-none bg-muted/40 hover:bg-muted text-xs font-medium text-foreground transition-colors group/mod"
                                          >
                                            <div className="flex items-center gap-2.5 truncate">
                                              <span className="h-5 w-5 rounded-none bg-background flex items-center justify-center text-[10px] font-mono font-bold text-muted-foreground group-hover/mod:text-foreground">
                                                {idx + 1}
                                              </span>
                                              <span className="truncate">{modInfo?.title || modSlug}</span>
                                            </div>
                                            <ExternalLink className="h-3.5 w-3.5 text-muted-foreground group-hover/mod:text-foreground shrink-0" />
                                          </Link>
                                        );
                                      })
                                    ) : (
                                      <p className="text-xs text-muted-foreground italic">No modules linked yet.</p>
                                    )}
                                  </div>
                                </div>
                              </div>

                              <div className="pt-5 mt-4 border-t border-border/50 flex items-center justify-between">
                                <span className="text-[11px] font-mono text-muted-foreground">
                                  Sequential Track
                                </span>
                                {path.modules && path.modules.length > 0 && (
                                  <Button
                                    size="sm"
                                    asChild
                                    className="rounded-none bg-[var(--accent-primary)] text-white dark:text-black hover:opacity-90 font-bold text-xs gap-1.5"
                                  >
                                    <Link href={`/modules/${path.modules[0]}`}>
                                      <span>Start Track</span>
                                      <ArrowRight className="h-3.5 w-3.5" />
                                    </Link>
                                  </Button>
                                )}
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
