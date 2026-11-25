// web/frontend/app/platform/page.tsx

"use client";

import { useEffect, useState, useMemo } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { useAuth } from "@/lib/auth";
import { LoadingSpinner } from "@/components/shared/loading-spinner";
import { Building2, Shield, KeyRound, BarChart3, ShieldAlert } from "lucide-react";
import { Button } from "@/components/ui/button";

import { OrganizationsTab } from "@/components/platform/organizations-tab";
import { AnalyticsTab } from "@/components/platform/analytics-tab";
import { OperatorsRbacTab } from "@/components/platform/operators-rbac-tab";
import { AuditLogsTab } from "@/components/platform/audit-logs-tab";

type TabKey = "organizations" | "analytics" | "staff" | "audit";

export default function PlatformConsolePage() {
  const { user, loading: authLoading, refreshUser } = useAuth();
  const router = useRouter();

  // Revalidate current user permissions on page mount
  useEffect(() => {
    refreshUser();
  }, []);

  // Helper for checking granular platform permissions
  const hasPerm = (permKey: string): boolean => {
    if (!user) return false;
    return Boolean(user.platform_permissions?.includes(permKey));
  };

  // Dynamically determine permitted tabs
  const permittedTabs = useMemo(() => {
    const tabs: { key: TabKey; label: string; icon: any }[] = [];
    if (
      hasPerm("platform.organizations.view") ||
      hasPerm("platform.organizations.create") ||
      hasPerm("platform.organizations.manage") ||
      hasPerm("platform.organizations.settings")
    ) {
      tabs.push({ key: "organizations", label: "Organizations", icon: Building2 });
    }
    if (hasPerm("platform.analytics.view")) {
      tabs.push({ key: "analytics", label: "Global Analytics", icon: BarChart3 });
    }
    if (
      hasPerm("platform.users.view") ||
      hasPerm("platform.users.manage") ||
      hasPerm("platform.permissions.manage")
    ) {
      tabs.push({ key: "staff", label: "Platform Users & RBAC", icon: Shield });
    }
    if (hasPerm("platform.audit.view")) {
      tabs.push({ key: "audit", label: "Security & Audit Logs", icon: KeyRound });
    }
    return tabs;
  }, [user]);

  // Active tab state
  const [activeTab, setActiveTab] = useState<TabKey>("organizations");

  const isPlatformStaff = Boolean(
    user &&
      ((user.platform_roles && user.platform_roles.length > 0) ||
        (user.platform_permissions && user.platform_permissions.length > 0))
  );

  // Initial access check & auto-select first permitted tab
  useEffect(() => {
    if (authLoading) return;
    if (!user) {
      router.push("/login");
      return;
    }

    if (permittedTabs.length > 0 && !permittedTabs.some((t) => t.key === activeTab)) {
      setActiveTab(permittedTabs[0].key);
    }
  }, [user, authLoading, permittedTabs, activeTab, router]);

  if (authLoading) {
    return (
      <div className="min-h-[calc(100vh-64px)] flex items-center justify-center">
        <LoadingSpinner />
      </div>
    );
  }

  if (!isPlatformStaff || permittedTabs.length === 0) {
    return (
      <div className="min-h-[calc(100vh-64px)] flex items-center justify-center px-4">
        <div className="max-w-md w-full text-center space-y-4 p-8 rounded-none border border-border bg-card shadow-xl">
          <div className="h-16 w-16 mx-auto rounded-none bg-destructive/10 text-destructive flex items-center justify-center">
            <ShieldAlert className="h-8 w-8" />
          </div>
          <h2 className="text-xl font-black text-foreground">Access Restricted</h2>
          <p className="text-xs text-muted-foreground leading-relaxed">
            The Platform Console is restricted to authorized platform operations personnel.
            Your global account does not possess active platform permissions.
          </p>
          <Button
            asChild
            className="rounded-none text-xs font-bold bg-[var(--accent-primary)] text-white dark:text-black cursor-pointer"
          >
            <Link href="/dashboard">Return to Dashboard</Link>
          </Button>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-[calc(100vh-64px)]">
      {/* Top Banner */}
      <div className="border-b border-border bg-card/30">
        <div className="max-w-7xl mx-auto px-4 py-8">
          <div className="flex items-start justify-between gap-6 flex-wrap">
            <div>
              <h1 className="text-3xl font-black tracking-tight text-foreground">
                Platform Console
              </h1>
              <p className="mt-1.5 text-muted-foreground text-xs max-w-xl leading-relaxed">
                Global governance for The Last Deploy: manage tenant organizations, platform operators, and security audit logs.
              </p>
            </div>

            {/* Dynamic Permission-Gated Navigation Tabs */}
            <div className="flex items-center gap-2 flex-wrap">
              {permittedTabs.map((t) => {
                const Icon = t.icon;
                const isSelected = activeTab === t.key;
                return (
                  <Button
                    key={t.key}
                    variant={isSelected ? "default" : "outline"}
                    size="sm"
                    onClick={() => setActiveTab(t.key)}
                    className={`rounded-none text-xs font-bold gap-1.5 cursor-pointer transition-all border ${
                      isSelected
                        ? "bg-[var(--accent-primary)] text-white dark:text-black border-[var(--accent-primary)]"
                        : "text-muted-foreground hover:text-foreground border-border/60"
                    }`}
                  >
                    <Icon className="h-3.5 w-3.5" />
                    <span>{t.label}</span>
                  </Button>
                );
              })}
            </div>
          </div>
        </div>
      </div>

      {/* Main Content Area - Active Tab Component */}
      <div className="max-w-7xl mx-auto px-4 py-8">
        {activeTab === "organizations" && <OrganizationsTab hasPerm={hasPerm} />}
        {activeTab === "analytics" && <AnalyticsTab hasPerm={hasPerm} />}
        {activeTab === "staff" && (
          <OperatorsRbacTab
            hasPerm={hasPerm}
            currentUserId={user?.id}
            currentUsername={user?.username}
          />
        )}
        {activeTab === "audit" && <AuditLogsTab />}
      </div>
    </div>
  );
}
