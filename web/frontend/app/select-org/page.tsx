// web/frontend/app/select-org/page.tsx

"use client";

import { useEffect, useState, useMemo } from "react";
import { useRouter } from "next/navigation";
import { useAuth } from "@/lib/auth";
import { api } from "@/lib/api";
import { OrganizationMembershipInfo } from "@/lib/types";
import { 
  Building2, GraduationCap, Globe, ArrowRight, Check, Search, 
  ArrowLeft, Sparkles, SlidersHorizontal, Layers 
} from "lucide-react";
import Link from "next/link";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";

export default function SelectOrgPage() {
  const { user, loading: authLoading } = useAuth();
  const router = useRouter();
  const [orgs, setOrgs] = useState<OrganizationMembershipInfo[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedSlug, setSelectedSlug] = useState<string | null>(null);
  const [searchQuery, setSearchQuery] = useState("");
  const [typeFilter, setTypeFilter] = useState<"all" | "platform" | "university" | "company">("all");

  useEffect(() => {
    if (authLoading) return;
    if (!user) {
      router.push("/login");
      return;
    }

    const currentSelected = api.getSelectedOrg();
    setSelectedSlug(currentSelected);

    api.getOrganizations()
      .then((data) => {
        setOrgs(data);
      })
      .catch((err) => {
        console.error("Failed to load organizations:", err);
      })
      .finally(() => {
        setLoading(false);
      });
  }, [user, authLoading, router]);

  const handleSelectOrg = (slug: string) => {
    api.setSelectedOrg(slug);
    setSelectedSlug(slug);
    router.push("/dashboard");
  };

  const filteredOrgs = useMemo(() => {
    return orgs.filter((org) => {
      const isPlatform = org.type === "platform" || org.is_platform;
      if (typeFilter === "platform" && !isPlatform) return false;
      if (typeFilter === "university" && org.type !== "university") return false;
      if (typeFilter === "company" && (org.type === "university" || isPlatform)) return false;

      if (searchQuery.trim()) {
        const q = searchQuery.toLowerCase();
        const matchesName = (isPlatform ? "personal" : org.name).toLowerCase().includes(q);
        const matchesSlug = org.slug.toLowerCase().includes(q);
        const matchesRole = (org.roles || []).some((r) => r.toLowerCase().includes(q));
        if (!matchesName && !matchesSlug && !matchesRole) return false;
      }
      return true;
    });
  }, [orgs, typeFilter, searchQuery]);

  if (authLoading || loading) {
    return (
      <div className="min-h-[calc(100vh-64px)] flex items-center justify-center">
        <div className="text-muted-foreground animate-pulse text-sm font-mono flex items-center gap-2">
          <Layers className="h-4 w-4 animate-spin text-[var(--accent-primary)]" />
          <span>Loading workspaces...</span>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-[calc(100vh-64px)] relative overflow-hidden py-10">
      {/* Background radial effects */}
      <div className="absolute inset-0 bg-[radial-gradient(ellipse_70%_50%_at_50%_-20%,rgba(22,163,74,0.07),transparent)] dark:bg-[radial-gradient(ellipse_70%_50%_at_50%_-20%,rgba(22,163,74,0.04),transparent)] pointer-events-none" />
      <div className="absolute top-10 left-1/2 -translate-x-1/2 w-[600px] h-64 bg-[var(--accent-primary)]/5 blur-3xl rounded-full pointer-events-none" />

      <div className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10 space-y-8">
        {/* Header & Back link */}
        <div className="space-y-4">
          <Link
            href="/dashboard"
            className="inline-flex items-center gap-1.5 text-xs text-muted-foreground hover:text-foreground font-mono transition-colors"
          >
            <ArrowLeft className="h-3.5 w-3.5" />
            <span>Return to Dashboard</span>
          </Link>

          <div className="flex flex-col sm:flex-row sm:items-end sm:justify-between gap-4">
            <div>
              <div className="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full bg-[var(--accent-primary)]/10 text-[var(--accent-primary)] text-[10px] font-mono font-bold uppercase tracking-wider mb-2">
                <Sparkles className="h-3 w-3" />
                <span>Workspace Directory</span>
              </div>
              <h1 className="text-3xl font-black tracking-tight text-foreground">Select Workspace</h1>
              <p className="text-muted-foreground text-xs sm:text-sm mt-1 max-w-xl leading-relaxed">
                Choose an organization workspace to switch your active context, view cohort leaderboards, and track progress.
              </p>
            </div>

            <div className="text-xs font-mono text-muted-foreground shrink-0 sm:text-right">
              <span className="font-bold text-foreground text-sm">{orgs.length}</span> Workspaces Joined
            </div>
          </div>
        </div>

        {/* Filter & Search Bar */}
        <div className="flex flex-col sm:flex-row items-stretch sm:items-center justify-between gap-3 p-2 rounded-2xl bg-muted/20 border border-border/50 backdrop-blur-sm">
          <div className="relative flex-1">
            <Search className="absolute left-3.5 top-2.5 h-4 w-4 text-muted-foreground" />
            <Input
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              placeholder="Filter by workspace name, slug, or role..."
              className="pl-9 h-9 text-xs rounded-xl border-border/40 bg-background/60 focus:bg-background transition-all"
            />
          </div>

          <div className="flex items-center gap-1 overflow-x-auto pb-1 sm:pb-0">
            {(
              [
                { id: "all", label: "All" },
                { id: "platform", label: "Personal" },
                { id: "university", label: "Universities" },
                { id: "company", label: "Companies" },
              ] as const
            ).map((tab) => (
              <button
                key={tab.id}
                onClick={() => setTypeFilter(tab.id)}
                className={`px-3 py-1.5 rounded-xl text-xs font-mono font-bold transition-all cursor-pointer whitespace-nowrap ${
                  typeFilter === tab.id
                    ? "bg-[var(--accent-primary)] text-black shadow-sm"
                    : "text-muted-foreground hover:text-foreground hover:bg-muted/40"
                }`}
              >
                {tab.label}
              </button>
            ))}
          </div>
        </div>

        {/* Modern Non-Traditional Workspace Grid */}
        {filteredOrgs.length === 0 ? (
          <div className="rounded-3xl border border-dashed border-border/60 p-12 text-center space-y-3 bg-muted/5">
            <SlidersHorizontal className="h-8 w-8 text-muted-foreground/40 mx-auto" />
            <p className="text-sm font-bold text-foreground">No workspaces match your search</p>
            <p className="text-xs text-muted-foreground">Try clearing the search query or changing the category filter.</p>
            <Button
              variant="outline"
              size="sm"
              onClick={() => {
                setSearchQuery("");
                setTypeFilter("all");
              }}
              className="rounded-xl text-xs font-mono cursor-pointer"
            >
              Reset Filters
            </Button>
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3.5">
            {filteredOrgs.map((org) => {
              const isPlatform = org.type === "platform" || org.is_platform;
              const isCurrent = selectedSlug === org.slug || (!selectedSlug && isPlatform);
              const displayName = isPlatform ? "Personal" : org.name;

              return (
                <div
                  key={org.slug}
                  onClick={() => handleSelectOrg(org.slug)}
                  className={`group relative text-left rounded-2xl p-4.5 border transition-all duration-200 cursor-pointer overflow-hidden flex flex-col justify-between ${
                    isCurrent
                      ? "border-[var(--accent-primary)]/70 bg-[var(--accent-primary)]/[0.04] shadow-[0_0_20px_rgba(var(--accent-primary-rgb),0.07)] ring-1 ring-[var(--accent-primary)]/30 hover:bg-[var(--accent-primary)]/[0.07]"
                      : "border-border/60 bg-muted/[0.08] dark:bg-card/30 hover:border-[var(--accent-primary)]/40 hover:bg-card/70 hover:shadow-md backdrop-blur-sm"
                  }`}
                >
                  <div className="space-y-3">
                    {/* Top Row: Icon and Status Badges */}
                    <div className="flex items-start justify-between gap-3">
                      <div
                        className={`h-11 w-11 rounded-xl flex items-center justify-center shrink-0 transition-colors ${
                          isCurrent
                            ? "bg-[var(--accent-primary)] text-black shadow-sm"
                            : "bg-muted text-foreground group-hover:bg-[var(--accent-primary)]/10 group-hover:text-[var(--accent-primary)]"
                        }`}
                      >
                        {org.type === "university" ? (
                          <GraduationCap className="h-5 w-5" />
                        ) : isPlatform ? (
                          <Globe className="h-5 w-5" />
                        ) : (
                          <Building2 className="h-5 w-5" />
                        )}
                      </div>

                      <div className="flex items-center gap-1.5 flex-wrap justify-end">
                        {isCurrent && (
                          <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-full text-[10px] font-mono font-bold bg-emerald-500/10 text-emerald-400 border border-emerald-500/20">
                            <span className="h-1.5 w-1.5 rounded-full bg-emerald-400 animate-pulse" />
                            Active
                          </span>
                        )}
                        {isPlatform && (
                          <span className="px-2 py-0.5 rounded-full text-[10px] font-mono font-bold bg-muted text-muted-foreground uppercase">
                            Default
                          </span>
                        )}
                        {org.roles && org.roles.length > 0 && (
                          <span className="px-2 py-0.5 rounded-md text-[10px] font-mono font-bold bg-muted/60 text-muted-foreground capitalize">
                            {org.roles[0]}
                          </span>
                        )}
                      </div>
                    </div>

                    {/* Middle Row: Name and Slug */}
                    <div>
                      <h3 className="font-bold text-foreground text-sm sm:text-base group-hover:text-[var(--accent-primary)] transition-colors truncate">
                        {displayName}
                      </h3>
                      <p className="text-[11px] font-mono text-muted-foreground truncate mt-0.5">
                        {org.slug}
                      </p>
                    </div>
                  </div>

                  {/* Bottom Row: Metrics & Action Prompt */}
                  <div className="pt-3.5 mt-3 border-t border-border/40 flex items-center justify-between text-xs font-mono">
                    <div className="flex items-center gap-1.5 text-muted-foreground">
                      <span className="text-[11px] uppercase tracking-wider text-muted-foreground/70">XP</span>
                      <span className="font-bold text-[var(--accent-primary)] font-mono">{org.total_xp}</span>
                    </div>

                    <div className="flex items-center gap-1 text-[11px] text-muted-foreground group-hover:text-[var(--accent-primary)] transition-colors">
                      <span className="font-semibold">{isCurrent ? "Current" : "Switch"}</span>
                      <ArrowRight className="h-3.5 w-3.5 group-hover:translate-x-1 transition-transform" />
                    </div>
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
