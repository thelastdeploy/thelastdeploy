// web/frontend/app/select-org/page.tsx

"use client";

import { useEffect, useState, useMemo } from "react";
import { useRouter } from "next/navigation";
import { useAuth } from "@/lib/auth";
import { api } from "@/lib/api";
import { OrganizationMembershipInfo } from "@/lib/types";
import { Building2, GraduationCap, Globe, Layers } from "lucide-react";

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
        const activeOnly = (data || []).filter((o) => o.status === "active");
        setOrgs(activeOnly);
        // If the stored selection is no longer an active workspace, clear it
        if (currentSelected && !activeOnly.some((o) => o.slug === currentSelected)) {
          setSelectedSlug(null);
        }
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
    <div>
      <div className="border-b border-border bg-card/30">
        <div className="max-w-7xl mx-auto px-4 py-12">
          <div className="flex items-start justify-between gap-6 flex-wrap">
            <div>
              <h1 className="text-4xl font-black tracking-tight text-foreground">Select Workspace</h1>
              <p className="mt-2 text-muted-foreground max-w-xl">
                Choose an organization workspace to switch your active context and track progress.
              </p>
            </div>
          </div>
        </div>
      </div>

      {/* Open Matrix Grid with Continuous Extending Lines */}
      <div className="max-w-7xl mx-auto mt-4 px-4 sm:px-6 relative z-10 overflow-visible">
        {/* Continuous Vertical Divider Lines across all rows */}
        <div className="matrix-line-v left-1/3 hidden md:block" />
        <div className="matrix-line-v left-2/3 hidden md:block" />

        {/* Row Chunks with Continuous Horizontal Dividers */}
        <div className="flex flex-col relative">
          {Array.from({ length: Math.ceil(sortedOrgs.length / 3) }, (_, rIdx) => {
            const row = sortedOrgs.slice(rIdx * 3, rIdx * 3 + 3);
            const isLastRow = rIdx === Math.ceil(sortedOrgs.length / 3) - 1;

            return (
              <div key={rIdx} className="relative">
                <div className="grid grid-cols-1 md:grid-cols-3">
                  {row.map((org, cIdx) => {
                    const isPlatform = org.type === "platform" || org.is_platform;
                    const isCurrent = selectedSlug === org.slug || (!selectedSlug && isPlatform);
                    const displayName = isPlatform ? "Personal" : org.name;
                    const isLastInColMobile = rIdx === Math.ceil(sortedOrgs.length / 3) - 1 && cIdx === row.length - 1;

                    return (
                      <button
                        key={org.slug}
                        type="button"
                        onClick={() => handleSelectOrg(org.slug)}
                        className={`group relative p-2.5 sm:p-3 text-left transition-colors cursor-pointer border-0 ${
                          !isLastInColMobile ? "max-md:border-b max-md:border-border/40" : ""
                        }`}
                      >
                        {/* Sharp-Cornered Inner Box (100% invisible when idle, thick green when active, thick gray when hover) */}
                        <div
                          className={`w-full h-full min-h-[200px] sm:min-h-[220px] p-6 sm:p-7 rounded-none flex flex-col justify-between transition-all duration-150 ${
                            isCurrent ? "workspace-tile-active shadow-sm" : "workspace-tile-inactive"
                          }`}
                        >
                          {/* Top row inside cell: Icon */}
                          <div className="flex items-start justify-between">
                            <div
                              className={`h-10 w-10 rounded-none flex items-center justify-center shrink-0 transition-colors ${
                                isCurrent
                                  ? "bg-[var(--accent-primary)] text-white dark:text-black font-bold"
                                  : "bg-muted text-muted-foreground group-hover:text-foreground group-hover:bg-muted/80"
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
                          </div>

                          {/* Identity: Name & Org Slug */}
                          <div className="min-w-0 space-y-1">
                            <h3 className="font-bold text-base sm:text-lg text-foreground group-hover:text-[var(--accent-primary)] transition-colors truncate">
                              {displayName}
                            </h3>
                            <p className="text-xs font-mono text-muted-foreground truncate">
                              {org.slug}
                            </p>
                          </div>
                        </div>
                      </button>
                    );
                  })}
                </div>

                {/* Continuous Horizontal Row Divider Line (omitted on last row) */}
                {!isLastRow && (
                  <div className="matrix-line-h bottom-0 hidden md:block" />
                )}
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
}
