// web/frontend/app/select-org/page.tsx

"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { useAuth } from "@/lib/auth";
import { api } from "@/lib/api";
import { OrganizationMembershipInfo } from "@/lib/types";
import { Building2, GraduationCap, Globe, ArrowRight, Check, Shield } from "lucide-react";
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

  if (authLoading || loading) {
    return (
      <div className="min-h-[calc(100vh-64px)] flex items-center justify-center">
        <div className="text-muted-foreground animate-pulse text-sm font-mono">
          Loading workspaces...
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-[calc(100vh-64px)] flex items-center justify-center px-6 py-12 relative overflow-hidden">
      {/* Background radial effects */}
      <div className="absolute inset-0 bg-[radial-gradient(ellipse_70%_50%_at_50%_-20%,rgba(22,163,74,0.07),transparent)] dark:bg-[radial-gradient(ellipse_70%_50%_at_50%_-20%,rgba(22,163,74,0.04),transparent)]" />
      <div className="absolute top-0 left-1/2 -translate-x-1/2 w-96 h-48 bg-[var(--accent-primary)]/5 blur-3xl rounded-full pointer-events-none" />

      <div className="w-full max-w-lg relative z-10 space-y-6">
        <div className="text-center space-y-2">
          <div className="inline-flex items-center justify-center p-3.5 rounded-2xl bg-[var(--accent-primary)]/10 text-[var(--accent-primary)] mb-2">
            <Building2 className="h-8 w-8" />
          </div>
          <h1 className="text-3xl font-black text-foreground">Select Workspace</h1>
          <p className="text-muted-foreground text-sm max-w-sm mx-auto">
            Choose which organization workspace you want to practice and track progress in:
          </p>
        </div>

        <div className="space-y-3">
          {orgs.map((org) => {
            const isPlatform = org.type === "platform" || org.is_platform;
            const isCurrent = selectedSlug === org.slug || (!selectedSlug && isPlatform);
            return (
              <button
                key={org.slug}
                onClick={() => handleSelectOrg(org.slug)}
                className={`w-full text-left p-4 rounded-2xl border transition-all flex items-center justify-between group cursor-pointer ${
                  isCurrent
                    ? "border-[var(--accent-primary)] bg-[var(--accent-primary)]/[0.03] shadow-md shadow-[var(--accent-primary)]/5"
                    : "border-border bg-card hover:border-[var(--accent-primary)] hover:shadow-lg"
                }`}
              >
                <div className="flex items-center gap-4">
                  <div className={`h-12 w-12 rounded-xl flex items-center justify-center font-black transition-colors ${
                    isCurrent
                      ? "bg-[var(--accent-primary)] text-black"
                      : "bg-muted/60 text-foreground group-hover:bg-[var(--accent-primary)]/10 group-hover:text-[var(--accent-primary)]"
                  }`}>
                    {org.type === "university" ? (
                      <GraduationCap className="h-6 w-6" />
                    ) : isPlatform ? (
                      <Globe className="h-6 w-6" />
                    ) : (
                      <Building2 className="h-6 w-6" />
                    )}
                  </div>
                  <div>
                    <div className="flex items-center gap-2">
                      <h3 className="font-bold text-foreground group-hover:text-[var(--accent-primary)] transition-colors">
                        {org.name}
                      </h3>
                      {isPlatform && (
                        <span className="text-[10px] uppercase font-mono px-2 py-0.5 rounded-full bg-[var(--accent-primary)]/10 text-[var(--accent-primary)] font-bold">
                          Default
                        </span>
                      )}
                      {isCurrent && (
                        <span className="text-[10px] uppercase font-mono px-2 py-0.5 rounded-full bg-emerald-500/10 text-emerald-400 font-bold flex items-center gap-1">
                          <Check className="h-2.5 w-2.5" /> Active
                        </span>
                      )}
                    </div>
                    <div className="flex items-center gap-2 mt-1 text-xs text-muted-foreground">
                      <span className="capitalize">{org.type}</span>
                      <span>•</span>
                      <span className="font-mono text-zinc-400 capitalize">
                        {org.roles && org.roles.length > 0 ? org.roles.join(", ") : "Learner"}
                      </span>
                      <span>•</span>
                      <span className="font-mono font-bold text-[var(--accent-primary)]">
                        {org.total_xp} XP
                      </span>
                    </div>
                  </div>
                </div>

                <div className="text-muted-foreground group-hover:text-[var(--accent-primary)] group-hover:translate-x-1 transition-all">
                  <ArrowRight className="h-5 w-5" />
                </div>
              </button>
            );
          })}
        </div>

        <div className="pt-2 text-center">
          <Link
            href="/dashboard"
            className="text-xs text-muted-foreground hover:text-foreground font-mono transition-colors"
          >
            ← Return to Dashboard
          </Link>
        </div>
      </div>
    </div>
  );
}

