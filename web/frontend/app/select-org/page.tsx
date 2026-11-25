// web/frontend/app/select-org/page.tsx

"use client";

import { useEffect, useState, useMemo } from "react";
import { useRouter } from "next/navigation";
import { useAuth } from "@/lib/auth";
import { api } from "@/lib/api";
import { OrganizationMembershipInfo } from "@/lib/types";
import { Building2, GraduationCap, Globe, ArrowLeft, Layers } from "lucide-react";
import Link from "next/link";

export default function SelectOrgPage() {
  const { user, loading: authLoading } = useAuth();
  const router = useRouter();
  const [orgs, setOrgs] = useState<OrganizationMembershipInfo[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedSlug, setSelectedSlug] = useState<string | null>(null);

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

  const sortedOrgs = useMemo(() => {
    return [...orgs].sort((a, b) => {
      const aIsPlatform = a.type === "platform" || a.is_platform;
      const bIsPlatform = b.type === "platform" || b.is_platform;
      const aIsCurrent = selectedSlug === a.slug || (!selectedSlug && aIsPlatform);
      const bIsCurrent = selectedSlug === b.slug || (!selectedSlug && bIsPlatform);
      if (aIsCurrent && !bIsCurrent) return -1;
      if (!aIsCurrent && bIsCurrent) return 1;
      return (b.total_xp || 0) - (a.total_xp || 0);
    });
  }, [orgs, selectedSlug]);

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
      <div className="max-w-7xl mx-auto px-4 sm:px-6 relative z-10 space-y-6">
        {/* Header & Back link */}
        <div className="space-y-4">
          <Link
            href="/dashboard"
            className="inline-flex items-center gap-1.5 text-xs text-muted-foreground hover:text-foreground font-mono transition-colors"
          >
            <ArrowLeft className="h-3.5 w-3.5" />
            <span>Return to Dashboard</span>
          </Link>

          <div className="flex flex-col sm:flex-row sm:items-end sm:justify-between gap-2 border-b border-border/40 pb-5">
            <div>
              <h1 className="text-2xl sm:text-3xl font-black tracking-tight text-foreground">Select Workspace</h1>
              <p className="text-muted-foreground text-xs sm:text-sm mt-1 max-w-xl">
                Choose an organization workspace to switch your active context and track progress.
              </p>
            </div>

            <div className="text-xs font-mono text-muted-foreground shrink-0">
              <span className="font-bold text-foreground text-sm">{orgs.length}</span> Workspaces
            </div>
          </div>
        </div>

        {/* Clean, Non-Card Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-2 sm:gap-2.5">
          {sortedOrgs.map((org) => {
            const isPlatform = org.type === "platform" || org.is_platform;
            const isCurrent = selectedSlug === org.slug || (!selectedSlug && isPlatform);
            const displayName = isPlatform ? "Personal" : org.name;

            return (
              <button
                key={org.slug}
                type="button"
                onClick={() => handleSelectOrg(org.slug)}
                className={`group flex items-center justify-between gap-3.5 p-3.5 rounded-xl text-left transition-colors cursor-pointer ${
                  isCurrent
                    ? "bg-muted/60 dark:bg-muted/40"
                    : "hover:bg-muted/40 dark:hover:bg-muted/20"
                }`}
              >
                <div className="flex items-center gap-3 min-w-0">
                  <div
                    className={`h-9 w-9 rounded-lg flex items-center justify-center shrink-0 transition-colors ${
                      isCurrent
                        ? "bg-[var(--accent-primary)] text-black"
                        : "bg-muted text-muted-foreground group-hover:text-foreground"
                    }`}
                  >
                    {org.type === "university" ? (
                      <GraduationCap className="h-4 w-4" />
                    ) : isPlatform ? (
                      <Globe className="h-4 w-4" />
                    ) : (
                      <Building2 className="h-4 w-4" />
                    )}
                  </div>

                  <div className="min-w-0">
                    <div className="flex items-center gap-2">
                      <span className="font-semibold text-sm text-foreground group-hover:text-[var(--accent-primary)] transition-colors truncate">
                        {displayName}
                      </span>
                      {isCurrent && (
                        <span className="inline-flex items-center gap-1 text-[10px] font-mono font-medium text-emerald-400 shrink-0">
                          <span className="h-1.5 w-1.5 rounded-full bg-emerald-400 animate-pulse" />
                          Active
                        </span>
                      )}
                    </div>
                    <div className="flex items-center gap-1.5 text-[11px] font-mono text-muted-foreground truncate mt-0.5">
                      <span>{org.slug}</span>
                      {org.is_member === false ? (
                        <>
                          <span className="text-muted-foreground/40">•</span>
                          <span className="text-amber-400 font-semibold">Platform Access</span>
                        </>
                      ) : org.roles && org.roles.length > 0 ? (
                        <>
                          <span className="text-muted-foreground/40">•</span>
                          <span className="capitalize">{org.roles.join(", ")}</span>
                        </>
                      ) : null}
                    </div>
                  </div>
                </div>

                <div className="shrink-0 text-right font-mono text-xs text-muted-foreground pl-2">
                  <span className="font-bold text-foreground group-hover:text-[var(--accent-primary)] transition-colors">
                    {org.total_xp}
                  </span>{" "}
                  <span className="text-[10px] text-muted-foreground/60 uppercase">XP</span>
                </div>
              </button>
            );
          })}
        </div>
      </div>
    </div>
  );
}
