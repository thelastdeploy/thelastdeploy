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
          <div className="flex flex-col sm:flex-row sm:items-end sm:justify-between gap-2 border-b border-border/40 pb-5">
            <div>
              <h1 className="text-2xl sm:text-3xl font-black tracking-tight text-foreground">Select Workspace</h1>
              <p className="text-muted-foreground text-xs sm:text-sm mt-1 max-w-xl">
                Choose an organization workspace to switch your active context and track progress.
              </p>
            </div>
          </div>
        </div>

        {/* Open Matrix Grid with Internal Dividers Only */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
          {sortedOrgs.map((org, index) => {
            const isPlatform = org.type === "platform" || org.is_platform;
            const isCurrent = selectedSlug === org.slug || (!selectedSlug && isPlatform);
            const displayName = isPlatform ? "Personal" : org.name;

            // Compute last row to omit bottom border on final row
            const total = sortedOrgs.length;
            const isLastRow1 = index === total - 1;
            const isLastRow2 = index >= total - (total % 2 || 2);
            const isLastRow3 = index >= total - (total % 3 || 3);
            const isLastRow4 = index >= total - (total % 4 || 4);

            return (
              <button
                key={org.slug}
                type="button"
                onClick={() => handleSelectOrg(org.slug)}
                className={`group relative p-5 sm:p-6 text-left transition-colors cursor-pointer flex flex-col justify-between gap-4 border-border/50
                  ${isLastRow1 ? "border-b-0" : "border-b"}
                  ${isLastRow2 ? "sm:border-b-0" : "sm:border-b"}
                  ${isLastRow3 ? "lg:border-b-0" : "lg:border-b"}
                  ${isLastRow4 ? "xl:border-b-0" : "xl:border-b"}
                  border-r-0
                  sm:border-r sm:[&:nth-child(2n)]:border-r-0
                  lg:border-r lg:[&:nth-child(2n)]:border-r lg:[&:nth-child(3n)]:border-r-0
                  xl:[&:nth-child(3n)]:border-r xl:[&:nth-child(4n)]:border-r-0
                  [&:last-child]:border-r-0
                  ${
                    isCurrent
                      ? "bg-[var(--accent-primary)]/[0.04] dark:bg-[var(--accent-primary)]/[0.06]"
                      : "hover:bg-muted/30 dark:hover:bg-muted/15"
                  }
                `}
              >
                {/* Header row inside cell */}
                <div className="flex items-start justify-between gap-3">
                  <div
                    className={`h-9 w-9 rounded-lg flex items-center justify-center shrink-0 transition-colors ${
                      isCurrent
                        ? "bg-[var(--accent-primary)] text-black"
                        : "bg-muted text-muted-foreground group-hover:text-foreground group-hover:bg-muted/80"
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

                  <div className="flex items-center gap-2">
                    {isCurrent && (
                      <span className="inline-flex items-center gap-1 text-[10px] font-mono font-medium text-emerald-400">
                        <span className="h-1.5 w-1.5 rounded-full bg-emerald-400 animate-pulse" />
                        Active
                      </span>
                    )}
                    <span className="text-[10px] font-mono text-muted-foreground uppercase px-1.5 py-0.5 rounded bg-muted/60">
                      {org.type}
                    </span>
                  </div>
                </div>

                {/* Identity: Name & Slug */}
                <div className="min-w-0 space-y-1">
                  <h3 className="font-bold text-sm sm:text-base text-foreground group-hover:text-[var(--accent-primary)] transition-colors truncate">
                    {displayName}
                  </h3>
                  <p className="text-xs font-mono text-muted-foreground truncate">
                    {org.slug}
                  </p>
                </div>

                {/* Footer: Role & XP */}
                <div className="flex items-center justify-between text-[11px] font-mono text-muted-foreground pt-1">
                  <div>
                    {org.is_member === false ? (
                      <span className="text-amber-400 font-semibold">Platform Access</span>
                    ) : org.roles && org.roles.length > 0 ? (
                      <span className="capitalize">{org.roles.join(", ")}</span>
                    ) : (
                      <span>Member</span>
                    )}
                  </div>
                  <div className="font-bold text-foreground">
                    {org.total_xp || 0} <span className="text-[10px] text-muted-foreground font-normal">XP</span>
                  </div>
                </div>
              </button>
            );
          })}
        </div>
      </div>
    </div>
  );
}
