// web/frontend/app/platform/users/[id]/page.tsx

"use client";

import { useEffect, useState, useMemo } from "react";
import { useRouter, useParams } from "next/navigation";
import Link from "next/link";
import { useAuth } from "@/lib/auth";
import { api } from "@/lib/api";
import { LoadingSpinner } from "@/components/shared/loading-spinner";
import {
  Shield,
  ShieldAlert,
  Lock,
  Unlock,
  KeyRound,
  ArrowLeft,
  Search,
  CheckCircle2,
  AlertTriangle,
  Copy,
  Check,
  Building2,
  Award,
  BarChart3,
  RotateCcw,
  Save,
  HelpCircle,
  Clock,
  Mail,
  UserCheck,
  AlertCircle,
  Eye,
  Sliders,
  SlidersHorizontal,
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import {
  PlatformPermissionItem,
  PlatformUserPermissionSummary,
} from "@/lib/types";

// Categorization & Risk Taxonomy
type DomainKey = "all" | "security" | "tenants" | "curriculum" | "analytics";
type RiskLevel = "critical" | "elevated" | "standard" | "readonly";

interface PermMetadata {
  domain: DomainKey;
  risk: RiskLevel;
  humanName: string;
  categoryLabel: string;
}

const PERMISSION_TAXONOMY: Record<string, PermMetadata> = {
  // Security & RBAC
  "platform.permissions.manage": {
    domain: "security",
    risk: "critical",
    humanName: "Root Delegation Authority",
    categoryLabel: "Security & Access",
  },
  "platform.users.manage": {
    domain: "security",
    risk: "elevated",
    humanName: "Add Platform Users",
    categoryLabel: "Security & Access",
  },
  "platform.users.view": {
    domain: "security",
    risk: "readonly",
    humanName: "View Platform Users",
    categoryLabel: "Security & Access",
  },

  // Tenant Governance
  "platform.organizations.suspend": {
    domain: "tenants",
    risk: "critical",
    humanName: "Suspend / Reactivate Tenant",
    categoryLabel: "Tenant Governance",
  },
  "platform.organizations.manage": {
    domain: "tenants",
    risk: "elevated",
    humanName: "Tenant Workspace Administration",
    categoryLabel: "Tenant Governance",
  },
  "platform.organizations.settings": {
    domain: "tenants",
    risk: "elevated",
    humanName: "Platform Setting Availability & Overrides",
    categoryLabel: "Tenant Governance",
  },
  "organization_settings.manage": {
    domain: "tenants",
    risk: "elevated",
    humanName: "Legacy Global Organization Settings",
    categoryLabel: "Tenant Governance",
  },
  "platform.organizations.create": {
    domain: "tenants",
    risk: "standard",
    humanName: "Provision New Organization",
    categoryLabel: "Tenant Governance",
  },
  "platform.organizations.view": {
    domain: "tenants",
    risk: "readonly",
    humanName: "Inspect Organizations Catalog",
    categoryLabel: "Tenant Governance",
  },

  // Curriculum
  "platform.modules.delete": {
    domain: "curriculum",
    risk: "critical",
    humanName: "Deprecate & Delete Curriculum",
    categoryLabel: "Curriculum QA",
  },
  "platform.modules.verify": {
    domain: "curriculum",
    risk: "elevated",
    humanName: "Verify Curriculum Modules",
    categoryLabel: "Curriculum QA",
  },
  "platform.modules.reject": {
    domain: "curriculum",
    risk: "elevated",
    humanName: "Reject Curriculum Submissions",
    categoryLabel: "Curriculum QA",
  },
  "platform.modules.calibrate_xp": {
    domain: "curriculum",
    risk: "elevated",
    humanName: "Calibrate Module & Lab XP",
    categoryLabel: "Curriculum QA",
  },
  "platform.modules.view_all": {
    domain: "curriculum",
    risk: "readonly",
    humanName: "Audit Unverified Curriculum",
    categoryLabel: "Curriculum QA",
  },

  // Analytics
  "platform.analytics.export": {
    domain: "analytics",
    risk: "standard",
    humanName: "Export Platform Intelligence (CSV)",
    categoryLabel: "Analytics & Audit",
  },
  "platform.analytics.view": {
    domain: "analytics",
    risk: "readonly",
    humanName: "Access Global Analytics",
    categoryLabel: "Analytics & Audit",
  },
  "platform.audit.view": {
    domain: "analytics",
    risk: "readonly",
    humanName: "Inspect Platform Audit Logs",
    categoryLabel: "Analytics & Audit",
  },
};

const DOMAIN_SECTIONS: { id: DomainKey; label: string; icon: any; description: string }[] = [
  { id: "all", label: "All Permissions", icon: SlidersHorizontal, description: "Overview of complete platform capability catalog." },
  { id: "security", label: "Security & RBAC", icon: KeyRound, description: "Administrative delegation, operator provisioning, and user access control." },
  { id: "tenants", label: "Tenant Governance", icon: Building2, description: "Organization lifecycle, suspension, setting enablement, and override values." },
  { id: "curriculum", label: "Curriculum QA", icon: Award, description: "Module verification, reviewer rejections, and interactive XP calibration." },
  { id: "analytics", label: "Analytics & Audit", icon: BarChart3, description: "Platform-wide KPI dashboards, audit trails, and data export pipelines." },
];

export default function UserRbacConfigPage() {
  const router = useRouter();
  const params = useParams();
  const targetUserIdStr = (params?.id as string) || "";
  const targetUserId = parseInt(targetUserIdStr, 10);

  const { user: currentUser, loading: authLoading } = useAuth();

  // State
  const [operator, setOperator] = useState<PlatformUserPermissionSummary | null>(null);
  const [catalog, setCatalog] = useState<PlatformPermissionItem[]>([]);
  const [initialPerms, setInitialPerms] = useState<Set<string>>(new Set());
  const [activePerms, setActivePerms] = useState<Set<string>>(new Set());
  
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [successMessage, setSuccessMessage] = useState<string | null>(null);

  // Filters
  const [searchQuery, setSearchQuery] = useState("");
  const [selectedDomain, setSelectedDomain] = useState<DomainKey>("all");
  const [statusFilter, setStatusFilter] = useState<"all" | "granted" | "revoked">("all");
  const [copiedKey, setCopiedKey] = useState<string | null>(null);

  // Is current user editing their own account?
  const isSelf = useMemo(() => {
    if (!currentUser || !operator) return false;
    return currentUser.id === operator.id || currentUser.username === operator.username;
  }, [currentUser, operator]);

  // Load operator and catalog
  useEffect(() => {
    if (authLoading) return;
    if (!currentUser) {
      router.push("/login");
      return;
    }

    const hasManagePerm =
      currentUser.platform_permissions?.includes("platform.permissions.manage");

    if (!hasManagePerm) {
      setError("Unauthorized. You require 'platform.permissions.manage' delegation permission.");
      setLoading(false);
      return;
    }

    if (isNaN(targetUserId)) {
      setError("Invalid user ID specified.");
      setLoading(false);
      return;
    }

    loadData();
  }, [authLoading, currentUser?.id, targetUserId]);

  const loadData = async () => {
    setLoading(true);
    setError(null);
    try {
      const [permCatalog, userData] = await Promise.all([
        api.getPlatformPermissions(),
        api.getUserPermissions(targetUserId),
      ]);
      setCatalog(permCatalog);
      setOperator(userData);
      const permSet = new Set(userData.permissions || []);
      setInitialPerms(permSet);
      setActivePerms(new Set(permSet));
    } catch (err: any) {
      setError(err.message || "Failed to load operator permissions.");
    } finally {
      setLoading(false);
    }
  };

  // Live diff calculation
  const diff = useMemo(() => {
    const added: string[] = [];
    const removed: string[] = [];

    activePerms.forEach((p) => {
      if (!initialPerms.has(p)) added.push(p);
    });

    initialPerms.forEach((p) => {
      if (!activePerms.has(p)) removed.push(p);
    });

    return { added, removed, hasChanges: added.length > 0 || removed.length > 0 };
  }, [initialPerms, activePerms]);

  // Toggle permission with self-protection
  const handleTogglePerm = (permKey: string) => {
    // Self-protection check
    if (isSelf && permKey === "platform.permissions.manage") {
      alert("Self-Lockout Protection: You cannot revoke your own delegation authority ('platform.permissions.manage').");
      return;
    }

    setActivePerms((prev) => {
      const next = new Set(prev);
      if (next.has(permKey)) {
        next.delete(permKey);
      } else {
        next.add(permKey);
      }
      return next;
    });
  };

  // Batch domain actions
  const handleGrantDomain = (domain: DomainKey) => {
    const domainKeys = catalog
      .filter((p) => domain === "all" || PERMISSION_TAXONOMY[p.key]?.domain === domain)
      .map((p) => p.key);

    setActivePerms((prev) => {
      const next = new Set(prev);
      domainKeys.forEach((k) => next.add(k));
      return next;
    });
  };

  const handleRevokeDomain = (domain: DomainKey) => {
    const domainKeys = catalog
      .filter((p) => domain === "all" || PERMISSION_TAXONOMY[p.key]?.domain === domain)
      .map((p) => p.key);

    setActivePerms((prev) => {
      const next = new Set(prev);
      domainKeys.forEach((k) => {
        // Protect self-lockout
        if (isSelf && k === "platform.permissions.manage") return;
        next.delete(k);
      });
      return next;
    });
  };

  const handleReset = () => {
    setActivePerms(new Set(initialPerms));
  };

  const handleSave = async () => {
    if (!operator) return;
    setSaving(true);
    setSuccessMessage(null);
    setError(null);
    try {
      const updated = await api.updateUserPermissions(operator.id, Array.from(activePerms));
      setOperator(updated);
      const newSet = new Set(updated.permissions || []);
      setInitialPerms(newSet);
      setActivePerms(new Set(newSet));
      setSuccessMessage("Platform permissions committed successfully.");
      setTimeout(() => setSuccessMessage(null), 4000);
    } catch (err: any) {
      setError(err.message || "Failed to commit permissions.");
    } finally {
      setSaving(false);
    }
  };

  const copyKeyToClipboard = (key: string) => {
    navigator.clipboard.writeText(key);
    setCopiedKey(key);
    setTimeout(() => setCopiedKey(null), 2000);
  };

  // Filtered permission list
  const filteredCatalog = useMemo(() => {
    return catalog.filter((item) => {
      const meta = PERMISSION_TAXONOMY[item.key] || {
        domain: "system",
        risk: "standard",
        humanName: item.key,
        categoryLabel: "General",
      };

      // Domain filter
      if (selectedDomain !== "all" && meta.domain !== selectedDomain) return false;

      // Status filter
      const isGranted = activePerms.has(item.key);
      if (statusFilter === "granted" && !isGranted) return false;
      if (statusFilter === "revoked" && isGranted) return false;

      // Search query
      if (searchQuery.trim()) {
        const q = searchQuery.toLowerCase();
        const matchesKey = item.key.toLowerCase().includes(q);
        const matchesDesc = (item.description || "").toLowerCase().includes(q);
        const matchesHuman = meta.humanName.toLowerCase().includes(q);
        if (!matchesKey && !matchesDesc && !matchesHuman) return false;
      }

      return true;
    });
  }, [catalog, selectedDomain, statusFilter, searchQuery, activePerms]);

  // Domain badge counts
  const domainCounts = useMemo(() => {
    const counts: Record<DomainKey, { granted: number; total: number }> = {
      all: { granted: 0, total: 0 },
      security: { granted: 0, total: 0 },
      tenants: { granted: 0, total: 0 },
      curriculum: { granted: 0, total: 0 },
      analytics: { granted: 0, total: 0 },
    };

    catalog.forEach((item) => {
      const domain = PERMISSION_TAXONOMY[item.key]?.domain;
      const isGranted = activePerms.has(item.key);

      counts.all.total += 1;
      if (isGranted) counts.all.granted += 1;

      if (domain && counts[domain]) {
        counts[domain].total += 1;
        if (isGranted) counts[domain].granted += 1;
      }
    });

    return counts;
  }, [catalog, activePerms]);

  if (authLoading || (loading && !operator)) {
    return (
      <div className="min-h-[calc(100vh-64px)] flex items-center justify-center">
        <LoadingSpinner />
      </div>
    );
  }

  if (error && !operator) {
    return (
      <div className="min-h-[calc(100vh-64px)] flex items-center justify-center p-4">
        <Card className="max-w-md w-full border-destructive/30">
          <CardHeader>
            <CardTitle className="text-destructive flex items-center gap-2">
              <AlertCircle className="h-5 w-5" /> Access Denied
            </CardTitle>
            <CardDescription>{error}</CardDescription>
          </CardHeader>
          <CardContent>
            <Button
              variant="outline"
              onClick={() => router.push("/platform")}
              className="w-full rounded-xl cursor-pointer"
            >
              Return to Platform Console
            </Button>
          </CardContent>
        </Card>
      </div>
    );
  }

  if (!operator) return null;

  return (
    <div className="min-h-[calc(100vh-64px)] bg-background text-foreground pb-12">
      {/* Top Header & Breadcrumbs */}
      <div className="border-b border-border bg-card/40 backdrop-blur-md sticky top-16 z-30">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
          <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
            <div className="space-y-1.5">
              <div className="flex items-center gap-2 text-xs font-mono text-muted-foreground">
                <Link href="/platform" className="hover:text-foreground transition-colors">
                  Platform Console
                </Link>
                <span>/</span>
                <span>Platform Users & RBAC</span>
                <span>/</span>
                <span className="text-foreground font-semibold">Operator #{operator.id}</span>
              </div>
              <div className="flex items-center gap-3">
                <Button
                  variant="ghost"
                  size="sm"
                  onClick={() => router.push("/platform")}
                  className="rounded-xl h-8 px-2 cursor-pointer -ml-2 text-muted-foreground hover:text-foreground"
                >
                  <ArrowLeft className="h-4 w-4" />
                </Button>
                <div className="flex items-center gap-2.5">
                  <div className="h-9 w-9 rounded-xl bg-purple-500/10 border border-purple-500/30 flex items-center justify-center text-purple-400 font-bold text-sm uppercase">
                    {operator.username.slice(0, 2)}
                  </div>
                  <div>
                    <h1 className="text-xl font-bold tracking-tight flex items-center gap-2">
                      <span>{operator.username}</span>
                      {isSelf && (
                        <Badge variant="outline" className="text-[10px] bg-amber-500/10 text-amber-500 dark:text-amber-400 border-amber-500/30 font-mono">
                          You
                        </Badge>
                      )}
                    </h1>
                    <p className="text-xs text-muted-foreground font-mono flex items-center gap-2">
                      <Mail className="h-3 w-3" /> {operator.email}
                      <span>•</span>
                      <span>Assigned: {operator.assigned_at ? new Date(operator.assigned_at).toLocaleDateString() : "Initial Provisioning"}</span>
                    </p>
                  </div>
                </div>
              </div>
            </div>

            {/* Quick Metrics & Actions */}
            <div className="flex items-center gap-3">
              <div className="text-right hidden sm:block">
                <p className="text-xs text-muted-foreground font-mono">Granted Privileges</p>
                <p className="text-lg font-bold font-mono text-[var(--accent-primary)]">
                  {activePerms.size} <span className="text-xs text-muted-foreground font-normal">/ {catalog.length} Active</span>
                </p>
              </div>
              <Button
                variant="outline"
                size="sm"
                onClick={handleReset}
                disabled={!diff.hasChanges || saving}
                className="rounded-xl text-xs h-9 cursor-pointer gap-1.5"
              >
                <RotateCcw className="h-3.5 w-3.5" />
                <span>Reset</span>
              </Button>
              <Button
                size="sm"
                onClick={handleSave}
                disabled={!diff.hasChanges || saving}
                className="rounded-xl text-xs h-9 font-bold bg-[var(--accent-primary)] hover:bg-[var(--accent-primary)]/90 text-black cursor-pointer gap-1.5 shadow-[0_0_15px_rgba(var(--accent-primary-rgb),0.2)]"
              >
                {saving ? <LoadingSpinner /> : <Save className="h-3.5 w-3.5" />}
                <span>Save</span>
              </Button>
            </div>
          </div>

          {/* Success or Error Banners */}
          {successMessage && (
            <div className="mt-4 p-3 rounded-xl bg-emerald-500/10 border border-emerald-500/30 flex items-center gap-2 text-xs text-emerald-300">
              <CheckCircle2 className="h-4 w-4 text-emerald-400 shrink-0" />
              <span>{successMessage}</span>
            </div>
          )}

          {error && (
            <div className="mt-4 p-3 rounded-xl bg-destructive/10 border border-destructive/30 flex items-center gap-2 text-xs text-destructive">
              <AlertCircle className="h-4 w-4 shrink-0" />
              <span>{error}</span>
            </div>
          )}
        </div>
      </div>

      {/* Main Configuration Content */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="grid grid-cols-1 lg:grid-cols-4 gap-8">
          {/* Left Column: Domain Selector & Filters */}
          <div className="space-y-6">
            <Card className="rounded-2xl border-border bg-card/60 backdrop-blur-sm">
              <CardHeader className="pb-3">
                <CardTitle className="text-sm font-bold uppercase tracking-wider text-muted-foreground flex items-center gap-2">
                  <Sliders className="h-4 w-4 text-[var(--accent-primary)]" /> Capability Domains
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-1.5 p-3 pt-0">
                {DOMAIN_SECTIONS.map((sec) => {
                  const Icon = sec.icon;
                  const count = domainCounts[sec.id] || { granted: 0, total: 0 };
                  const isSelected = selectedDomain === sec.id;
                  return (
                    <button
                      key={sec.id}
                      onClick={() => setSelectedDomain(sec.id)}
                      className={`w-full flex items-center justify-between p-2.5 rounded-xl text-xs font-medium transition-all text-left cursor-pointer ${
                        isSelected
                          ? "bg-[var(--accent-primary)]/10 text-[var(--accent-primary)] font-bold border border-[var(--accent-primary)]/20 shadow-sm"
                          : "text-muted-foreground hover:bg-muted/50 hover:text-foreground border border-transparent"
                      }`}
                    >
                      <div className="flex items-center gap-2.5 truncate">
                        <Icon className={`h-4 w-4 shrink-0 ${isSelected ? "text-[var(--accent-primary)]" : "text-muted-foreground"}`} />
                        <span className="truncate">{sec.label}</span>
                      </div>
                      <Badge
                        variant="secondary"
                        className={`text-[10px] font-mono shrink-0 ml-2 ${
                          count.granted === count.total && count.total > 0
                            ? "bg-emerald-500/10 text-emerald-400 border-emerald-500/20"
                            : count.granted > 0
                            ? "bg-purple-500/10 text-purple-400 border-purple-500/20"
                            : ""
                        }`}
                      >
                        {count.granted}/{count.total}
                      </Badge>
                    </button>
                  );
                })}
              </CardContent>
            </Card>

            {/* Quick Actions Panel */}
            <Card className="rounded-2xl border-border bg-card/60 backdrop-blur-sm">
              <CardHeader className="pb-3">
                <CardTitle className="text-sm font-bold uppercase tracking-wider text-muted-foreground">
                  Domain Actions
                </CardTitle>
                <CardDescription className="text-xs">
                  Apply batch grants or revocations to the active domain filter.
                </CardDescription>
              </CardHeader>
              <CardContent className="space-y-2 p-3 pt-0">
                <Button
                  variant="outline"
                  size="sm"
                  onClick={() => handleGrantDomain(selectedDomain)}
                  className="w-full text-xs font-semibold rounded-xl cursor-pointer hover:bg-emerald-500/10 hover:text-emerald-400 hover:border-emerald-500/30"
                >
                  Grant All in Domain
                </Button>
                <Button
                  variant="outline"
                  size="sm"
                  onClick={() => handleRevokeDomain(selectedDomain)}
                  className="w-full text-xs font-semibold rounded-xl cursor-pointer hover:bg-red-500/10 hover:text-red-400 hover:border-red-500/30"
                >
                  Revoke All in Domain
                </Button>
              </CardContent>
            </Card>

            {/* Risk Governance Legend */}
            <Card className="rounded-2xl border-border bg-card/60 backdrop-blur-sm p-4 space-y-2.5">
              <p className="text-xs font-bold uppercase tracking-wider text-muted-foreground flex items-center gap-1.5">
                <HelpCircle className="h-3.5 w-3.5 text-muted-foreground" /> Security Risk Levels
              </p>
              <div className="space-y-2 text-[11px] text-muted-foreground font-mono">
                <div className="flex items-center gap-2">
                  <span className="h-2 w-2 rounded-full bg-red-400 shrink-0" />
                  <span className="text-red-400 font-bold">Critical:</span>
                  <span>Root delegation, suspension, deletion</span>
                </div>
                <div className="flex items-center gap-2">
                  <span className="h-2 w-2 rounded-full bg-amber-400 shrink-0" />
                  <span className="text-amber-400 font-bold">Elevated:</span>
                  <span>Tenant settings, module verification, XP</span>
                </div>
                <div className="flex items-center gap-2">
                  <span className="h-2 w-2 rounded-full bg-blue-400 shrink-0" />
                  <span className="text-blue-400 font-bold">Standard:</span>
                  <span>Provisioning, data export pipelines</span>
                </div>
                <div className="flex items-center gap-2">
                  <span className="h-2 w-2 rounded-full bg-slate-400 shrink-0" />
                  <span className="text-slate-400 font-bold">Audit:</span>
                  <span>Read-only inspection of logs and telemetry</span>
                </div>
              </div>
            </Card>
          </div>

          {/* Right 3 Columns: Search, Filters & Permission Grid */}
          <div className="lg:col-span-3 space-y-6">
            {/* Search and Status Filter Bar */}
            <div className="flex flex-col sm:flex-row items-center gap-3">
              <div className="relative flex-1 w-full">
                <Search className="absolute left-3.5 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                <Input
                  type="text"
                  placeholder="Filter permissions by key (e.g. 'platform.organizations'), title, or keywords..."
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  className="pl-10 h-10 rounded-xl bg-card border-border text-xs font-mono"
                />
              </div>

              <div className="flex items-center gap-1.5 bg-card p-1 rounded-xl border border-border shrink-0">
                {(["all", "granted", "revoked"] as const).map((filter) => (
                  <button
                    key={filter}
                    onClick={() => setStatusFilter(filter)}
                    className={`px-3 py-1.5 rounded-lg text-xs font-mono capitalize transition-colors cursor-pointer ${
                      statusFilter === filter
                        ? "bg-muted text-foreground font-bold"
                        : "text-muted-foreground hover:text-foreground"
                    }`}
                  >
                    {filter}
                  </button>
                ))}
              </div>
            </div>

            {/* Permissions List */}
            {filteredCatalog.length === 0 ? (
              <Card className="rounded-2xl border-border bg-card/40 p-12 text-center">
                <SlidersHorizontal className="h-10 w-10 text-muted-foreground/40 mx-auto mb-3" />
                <h3 className="text-base font-bold">No permissions match criteria</h3>
                <p className="text-xs text-muted-foreground mt-1 max-w-sm mx-auto">
                  No platform capabilities matched your active domain filter, status selection, or search query.
                </p>
                <Button
                  variant="outline"
                  size="sm"
                  onClick={() => {
                    setSelectedDomain("all");
                    setStatusFilter("all");
                    setSearchQuery("");
                  }}
                  className="mt-4 rounded-xl text-xs cursor-pointer"
                >
                  Clear All Filters
                </Button>
              </Card>
            ) : (
              <div className="space-y-3">
                {filteredCatalog.map((item) => {
                  const isGranted = activePerms.has(item.key);
                  const isLockedSelf = isSelf && item.key === "platform.permissions.manage";
                  const meta = PERMISSION_TAXONOMY[item.key] || {
                    domain: "system",
                    risk: "standard",
                    humanName: item.key,
                    categoryLabel: "General",
                  };

                  const riskBadge =
                    meta.risk === "critical" ? (
                      <Badge variant="outline" className="text-[10px] bg-red-500/10 text-red-400 border-red-500/30 font-mono">
                        Critical Risk
                      </Badge>
                    ) : meta.risk === "elevated" ? (
                      <Badge variant="outline" className="text-[10px] bg-amber-500/10 text-amber-400 border-amber-500/30 font-mono">
                        Elevated
                      </Badge>
                    ) : meta.risk === "readonly" ? (
                      <Badge variant="outline" className="text-[10px] bg-slate-500/10 text-slate-400 border-slate-500/30 font-mono">
                        Read Only
                      </Badge>
                    ) : (
                      <Badge variant="outline" className="text-[10px] bg-blue-500/10 text-blue-400 border-blue-500/30 font-mono">
                        Standard
                      </Badge>
                    );

                  return (
                    <div
                      key={item.key}
                      onClick={() => !isLockedSelf && handleTogglePerm(item.key)}
                      className={`p-4 rounded-2xl border transition-all ${
                        isLockedSelf
                          ? "bg-amber-500/[0.04] border-amber-500/30 cursor-not-allowed opacity-90"
                          : isGranted
                          ? "bg-card border-emerald-500/40 dark:border-[var(--accent-primary)]/30 hover:border-emerald-500/70 dark:hover:border-[var(--accent-primary)]/60 cursor-pointer shadow-sm"
                          : "bg-card border-border hover:border-muted-foreground/30 hover:bg-muted/20 cursor-pointer"
                      }`}
                    >
                      <div className="flex items-start justify-between gap-4">
                        <div className="space-y-1.5 flex-1 min-w-0">
                          <div className="flex items-center gap-2 flex-wrap">
                            <span className="text-sm font-bold text-foreground">
                              {meta.humanName}
                            </span>
                            {riskBadge}
                            <Badge variant="secondary" className="text-[10px] font-mono">
                              {meta.categoryLabel}
                            </Badge>
                            {isLockedSelf && (
                              <Badge variant="outline" className="text-[10px] bg-amber-500/10 text-amber-500 dark:text-amber-400 border-amber-500/30 font-mono flex items-center gap-1">
                                <Lock className="h-2.5 w-2.5" /> Locked
                              </Badge>
                            )}
                          </div>

                          <div className="flex items-center gap-2 text-xs font-mono text-muted-foreground">
                            <code className="bg-muted px-1.5 py-0.5 rounded text-[11px] text-foreground font-semibold">
                              {item.key}
                            </code>
                            <button
                              type="button"
                              onClick={(e) => {
                                e.stopPropagation();
                                copyKeyToClipboard(item.key);
                              }}
                              className="hover:text-foreground transition-colors p-1"
                              title="Copy permission key"
                            >
                              {copiedKey === item.key ? (
                                <Check className="h-3 w-3 text-emerald-400" />
                              ) : (
                                <Copy className="h-3 w-3" />
                              )}
                            </button>
                          </div>

                          <p className="text-xs text-muted-foreground leading-relaxed pt-0.5">
                            {item.description || "Grants authority to execute operations associated with this platform capability."}
                          </p>
                        </div>

                        {/* Interactive Toggle Switch */}
                        <div className="shrink-0 flex items-center pt-1" onClick={(e) => e.stopPropagation()}>
                          {isLockedSelf ? (
                            <div className="flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-amber-500/10 border border-amber-500/30 text-amber-600 dark:text-amber-400 text-xs font-mono font-bold">
                              <Lock className="h-3.5 w-3.5" />
                              <span>LOCKED</span>
                            </div>
                          ) : (
                            <button
                              type="button"
                              onClick={() => handleTogglePerm(item.key)}
                              className={`relative inline-flex h-6 w-11 shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors duration-200 ease-in-out focus:outline-none focus-visible:ring-2 focus-visible:ring-[var(--accent-primary)] ${
                                isGranted
                                  ? "bg-emerald-500 dark:bg-[var(--accent-primary)] shadow-sm"
                                  : "bg-zinc-200 dark:bg-zinc-700 hover:bg-zinc-300 dark:hover:bg-zinc-600 border border-zinc-300/60 dark:border-zinc-600/60"
                              }`}
                              role="switch"
                              aria-checked={isGranted}
                            >
                              <span
                                aria-hidden="true"
                                className={`pointer-events-none inline-block h-5 w-5 transform rounded-full bg-white shadow-md ring-0 transition duration-200 ease-in-out border border-zinc-200/50 dark:border-transparent ${
                                  isGranted ? "translate-x-5" : "translate-x-0"
                                }`}
                              />
                            </button>
                          )}
                        </div>
                      </div>
                    </div>
                  );
                })}
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
