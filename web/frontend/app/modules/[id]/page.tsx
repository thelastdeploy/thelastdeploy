// web/frontend/app/modules/[id]/page.tsx

"use client";

import { useEffect, useState, useCallback, useRef } from "react";
import { useParams } from "next/navigation";
import { api } from "@/lib/api";
import { useAuth } from "@/lib/auth";
import { ModuleDetail, Section } from "@/lib/types";
import { DifficultyBadge } from "@/components/challenges/difficulty-badge";
import { SectionSidebar } from "@/components/modules/section-sidebar";
import { SectionContent } from "@/components/modules/section-content";
import { CompletionToast } from "@/components/modules/completion-toast";
import { useSectionComplete } from "@/lib/module-detail/use-section-complete";
import { updateModuleInMemoryCache } from "@/hooks/use-modules";
import { readCache, updateDashboardCacheModule } from "@/lib/dashboard/use-dashboard-cache";
import { ArrowLeft, Zap } from "lucide-react";
import Link from "next/link";

const topicConfig: Record<string, { border: string; label: string; color: string }> = {
  docker:     { border: "var(--topic-docker-border)",     label: "Docker",     color: "var(--topic-docker-text)" },
  kubernetes: { border: "var(--topic-kubernetes-border)", label: "Kubernetes", color: "var(--topic-kubernetes-text)" },
  linux:      { border: "var(--topic-linux-border)",      label: "Linux",      color: "var(--topic-linux-text)" },
  git:        { border: "var(--topic-git-border)",        label: "Git",        color: "var(--topic-git-text)" },
  jenkins:    { border: "var(--topic-jenkins-border)",    label: "Jenkins",    color: "var(--topic-jenkins-text)" },
  terraform:  { border: "var(--topic-terraform-border)",  label: "Terraform",  color: "var(--topic-terraform-text)" },
  nginx:      { border: "var(--topic-nginx-border)",      label: "Nginx",      color: "var(--topic-nginx-text)" },
};

interface Toast {
  sectionTitle: string;
  xpAwarded: number;
}

// ── Skeleton: shown on true cache miss (new tab before login cache is warm) ──

function ModuleDetailSkeleton() {
  return (
    <div className="flex flex-col h-[calc(100vh-64px)] animate-pulse">
      {/* Header */}
      <div className="border-b border-border px-4 py-4 flex items-center justify-between gap-4 shrink-0 bg-card">
        <div className="flex items-center gap-4">
          <div className="h-4 w-16 bg-muted rounded-lg" />
          <div className="w-px h-4 bg-border" />
          <div className="h-5 w-8 bg-muted rounded-lg" />
          <div className="h-5 w-48 bg-muted rounded-lg" />
        </div>
        <div className="flex items-center gap-4">
          <div className="h-5 w-16 bg-muted rounded-full" />
          <div className="h-1.5 w-24 bg-muted rounded-full" />
          <div className="h-4 w-12 bg-muted rounded-lg" />
        </div>
      </div>

      {/* Body */}
      <div className="flex flex-1 overflow-hidden">
        {/* Sidebar */}
        <aside className="w-64 shrink-0 border-r border-border bg-card hidden md:block p-4">
          <div className="h-3 w-24 bg-muted rounded mb-5" />
          <div className="flex flex-col gap-1">
            {Array.from({ length: 5 }).map((_, i) => (
              <div key={i} className="flex items-start gap-4 px-3 py-3.5">
                <div className="w-5 h-5 rounded-full bg-muted shrink-0 mt-0.5" />
                <div className="flex-1 space-y-2">
                  <div className="h-3 bg-muted rounded w-full" />
                  <div className="h-2.5 bg-muted/60 rounded w-2/3" />
                </div>
              </div>
            ))}
          </div>
        </aside>

        {/* Content */}
        <main className="flex-1 overflow-y-auto bg-background/50">
          <div className="max-w-3xl mx-auto px-6 py-8 space-y-3">
            <div className="h-7 bg-muted rounded w-2/3 mb-8" />
            {Array.from({ length: 8 }).map((_, i) => (
              <div
                key={i}
                className="h-4 bg-muted rounded"
                style={{ width: `${70 + Math.sin(i * 1.7) * 25}%` }}
              />
            ))}
            <div className="h-32 bg-muted/50 rounded-xl mt-6" />
            {Array.from({ length: 5 }).map((_, i) => (
              <div
                key={i + 10}
                className="h-4 bg-muted rounded"
                style={{ width: `${60 + Math.sin(i * 2.3) * 30}%` }}
              />
            ))}
          </div>
        </main>
      </div>
    </div>
  );
}

export default function ModuleDetailPage() {
  const { id } = useParams<{ id: string }>();
  const { user, refreshUser } = useAuth();
  const [module, setModule] = useState<ModuleDetail | null>(null);
  const [activeSection, setActiveSection] = useState<Section | null>(null);
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [toast, setToast] = useState<Toast | null>(null);
  const contentRef = useRef<HTMLDivElement>(null);

  // Optimistic section completion tracking (before API confirms)
  const [optimisticCompleted, setOptimisticCompleted] = useState<Set<string>>(new Set());

  const applyModuleData = useCallback((data: ModuleDetail) => {
    setModule(data);
    updateModuleInMemoryCache(data);
    updateDashboardCacheModule(data);
    setActiveSection((prev) =>
      prev ? data.sections.find((s) => s.id === prev.id) ?? data.sections[0] : data.sections[0] ?? null
    );
  }, []);

  // ── Cache-first loading ──────────────────────────────────────────────────
  // 1. Check sessionStorage dashboard cache immediately — if module is there,
  //    render it instantly (sections list from /all/full, no content field yet).
  // 2. Always fire a background fetch for the full detail (with section.content).
  //    When it resolves, swap in the full data silently — no loading flash.
  // 3. On a true cache miss, show the skeleton and wait for the network response.
  useEffect(() => {
    let cancelled = false;

    // Step 1: instant render from cache
    const cache = readCache();
    const cachedModule = cache?.modules.find((m) => m.id === id);
    if (cachedModule && cachedModule.sections && cachedModule.sections.length > 0) {
      if (!cancelled) {
        applyModuleData(cachedModule as ModuleDetail);
        setLoading(false);
      }
    }

    // Step 2: always fetch full detail in background (cache lacks section.content)
    api.getModule(id)
      .then((data) => { if (!cancelled) applyModuleData(data); })
      .catch((e: unknown) => {
        // Only surface the error if we have nothing to show
        if (!cancelled && !cachedModule) {
          setError(e instanceof Error ? e.message : "Failed to load");
        }
      })
      .finally(() => { if (!cancelled) setLoading(false); });

    return () => { cancelled = true; };
  }, [id, applyModuleData]);

  // Reset scroll on section change
  useEffect(() => {
    if (contentRef.current) contentRef.current.scrollTop = 0;
  }, [activeSection?.id]);

  // Called instantly (optimistic) when scroll sentinel fires
  const handleOptimisticComplete = useCallback(
    (sectionId: string, xpAwarded: number) => {
      setOptimisticCompleted((prev) => new Set([...prev, sectionId]));
      const section = module?.sections.find((s) => s.id === sectionId);
      if (section) {
        setToast({ sectionTitle: section.title, xpAwarded });
      }
      // Refresh user XP in background — don't await
      refreshUser();
    },
    [module, refreshUser]
  );

  const { completeSection } = useSectionComplete({ onComplete: handleOptimisticComplete });

  const handleScrollComplete = useCallback(
    (sectionId: string, sectionXp: number) => {
      completeSection(id, sectionId, sectionXp);
    },
    [id, completeSection]
  );

  const handleRefresh = async () => {
    setRefreshing(true);
    try {
      const data = await api.getModule(id);
      applyModuleData(data);
      await refreshUser();
    } finally {
      setRefreshing(false);
    }
  };

  const isSectionComplete = useCallback(
    (section: Section): boolean => {
      return optimisticCompleted.has(section.id) || section.section_completed;
    },
    [optimisticCompleted]
  );

  // Skeleton only on a true cache miss (no module data yet)
  if (loading && !module) return <ModuleDetailSkeleton />;

  if (error || !module) return (
    <div className="text-center py-40 text-red-400 text-sm">{error ?? "Module not found"}</div>
  );

  const topic = topicConfig[module.topic] ?? topicConfig.docker;
  const completedCount = module.sections.filter(isSectionComplete).length;
  const progressPct = module.sections.length > 0
    ? Math.round((completedCount / module.sections.length) * 100)
    : 0;

  return (
    <div className="flex flex-col h-[calc(100vh-64px)] transition-colors duration-300">

      {/* Header bar */}
      <div className="border-b border-border px-4 py-4 flex items-center justify-between gap-4 shrink-0 bg-card">
        <div className="flex items-center gap-4 min-w-0">
          <Link
            href="/modules"
            className="flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground transition-colors shrink-0"
          >
            <ArrowLeft className="h-4 w-4" />
            <span className="hidden sm:block">Modules</span>
          </Link>
          <div className="w-px h-4 bg-border" />
          <div className="flex items-center gap-2 min-w-0">
            <span
              className="text-[10px] font-black uppercase tracking-widest px-2 py-0.5 rounded-lg shrink-0"
              style={{ color: topic.color, backgroundColor: "rgba(var(--accent-primary-rgb),0.06)", border: `1px solid ${topic.border}` }}
            >
              {topic.label}
            </span>
            <h1 className="font-black text-base truncate text-foreground">{module.title}</h1>
          </div>
        </div>

        <div className="flex items-center gap-4 shrink-0">
          <DifficultyBadge difficulty={module.difficulty} />
          <div className="hidden sm:flex items-center gap-2">
            <div className="w-24 h-1.5 rounded-full bg-muted overflow-hidden">
              <div
                className="h-full rounded-full transition-all"
                style={{ width: `${progressPct}%`, backgroundColor: "var(--accent-primary)" }}
              />
            </div>
            <span className="text-xs font-mono text-muted-foreground">{completedCount}/{module.sections.length}</span>
          </div>
          <div className="flex items-center gap-1 font-mono text-xs font-bold text-[var(--accent-primary)]">
            <Zap className="h-3.5 w-3.5" />
            {module.total_xp} XP
          </div>
        </div>
      </div>

      {/* Body */}
      <div className="flex flex-1 overflow-hidden">
        <SectionSidebar
          sections={module.sections}
          activeId={activeSection?.id ?? null}
          onSelect={(s) => setActiveSection(s)}
          isSectionComplete={isSectionComplete}
        />

        <main ref={contentRef} className="flex-1 overflow-y-auto bg-background/50">
          {activeSection ? (
            <SectionContent
              section={activeSection}
              module={module}
              isLoggedIn={!!user}
              isSectionComplete={isSectionComplete}
              onScrollComplete={handleScrollComplete}
              onNavigate={(s) => setActiveSection(s)}
              onRefresh={handleRefresh}
              refreshing={refreshing}
            />
          ) : (
            <div className="flex items-center justify-center h-full text-muted-foreground text-sm">
              Select a section to begin
            </div>
          )}
        </main>
      </div>

      {/* Completion toast */}
      {toast && (
        <CompletionToast
          sectionTitle={toast.sectionTitle}
          xpAwarded={toast.xpAwarded}
          onDismiss={() => setToast(null)}
        />
      )}
    </div>
  );
}