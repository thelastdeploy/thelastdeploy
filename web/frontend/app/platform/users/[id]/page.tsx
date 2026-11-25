// web/frontend/app/platform/users/[id]/page.tsx

"use client";

import { useEffect, useState, useMemo } from "react";
import { useRouter, useParams } from "next/navigation";
import Link from "next/link";
import { useAuth } from "@/lib/auth";
import { api } from "@/lib/api";
import { LoadingSpinner } from "@/components/shared/loading-spinner";
import {
  Lock,
  KeyRound,
  ArrowLeft,
  Search,
  Copy,
  Check,
  Building2,
  BarChart3,
  RotateCcw,
  Save,
  Mail,
  AlertCircle,
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
type DomainKey = "all" | "security" | "tenants" | "analytics";
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
    risk: "critical",
    humanName: "Manage Tenant Workspaces",
    categoryLabel: "Tenant Governance",
  },
  "platform.organizations.settings": {
    domain: "tenants",
    risk: "elevated",
    humanName: "Platform Setting Availability & Overrides",
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
  { id: "analytics", label: "Analytics & Audit", icon: BarChart3, description: "Platform-wide KPI dashboards, audit trails, and data export pipelines." },
];

export default function UserRbacConfigPage() {
  const router = useRouter();
  const params = useParams();
  const targetUserIdStr = (params?.id as string) || "";
  const targetUserId = parseInt(targetUserIdStr, 10);

  const { user: currentUser, loading: authLoading, refreshUser } = useAuth();

  // State
  const [operator, setOperator] = useState<PlatformUserPermissionSummary | null>(null);
  const [catalog, setCatalog] = useState<PlatformPermissionItem[]>([]);
  const [initialPerms, setInitialPerms] = useState<Set<string>>(new Set());
  const [activePerms, setActivePerms] = useState<Set<string>>(new Set());
  
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

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
    setError(null);
    try {
      const updated = await api.updateUserPermissions(operator.id, Array.from(activePerms));
      setOperator(updated);
      const newSet = new Set(updated.permissions || []);
      setInitialPerms(newSet);
      setActivePerms(new Set(newSet));

      // Immediately broadcast and refresh current user
      window.dispatchEvent(new CustomEvent("tld:user-updated"));
      await refreshUser();
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
              <div className="flex items-center gap-3">
                <Button
                  variant="ghost"
                  size="sm"
                  onClick={() => router.push("/platform")}
                  className="rounded-none h-8 px-2 cursor-pointer -ml-2 text-muted-foreground hover:text-foreground"
                >
                  <ArrowLeft className="h-4 w-4" />
                </Button>
                <div className="flex items-center gap-2.5">
                  <div className="h-9 w-9 rounded-none bg-purple-500/10 border border-purple-500/30 flex items-center justify-center text-purple-400 font-bold text-sm uppercase">
                    {operator.username.slice(0, 2)}
                  </div>
                  <div>
                    <h1 className="text-xl font-bold tracking-tight flex items-center gap-2">
                      <span>{operator.username}</span>
                      {isSelf && (
                        <Badge variant="outline" className="text-[10px] bg-amber-500/10 text-amber-500 dark:text-amber-400 border-amber-500/30 font-mono rounded-none">
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
                className="rounded-none text-xs h-9 cursor-pointer gap-1.5"
              >
                <RotateCcw className="h-3.5 w-3.5" />
                <span>Reset</span>
              </Button>
              <Button
                size="sm"
                onClick={handleSave}
                disabled={!diff.hasChanges || saving}
                className="rounded-none text-xs h-9 font-bold bg-[var(--accent-primary)] hover:opacity-90 text-white dark:text-black cursor-pointer gap-1.5"
              >
                {saving ? <LoadingSpinner /> : <Save className="h-3.5 w-3.5" />}
                <span>Save</span>
              </Button>
            </div>
          </div>
        </div>
      </div>

      {/* Main Configuration Content */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="grid grid-cols-1 lg:grid-cols-4 gap-8">
          {/* Left Column: Domain Selector & Filters */}
          <div className="space-y-6">
            <div className="rounded-none border border-border bg-card">
              <div className="p-4 pb-3">
                <h3 className="text-sm font-bold uppercase tracking-wider text-muted-foreground flex items-center gap-2">
                  <Sliders className="h-4 w-4 text-[var(--accent-primary)]" /> Capability Domains
                </h3>
              </div>
              <div className="space-y-1.5 p-3 pt-0">
                {DOMAIN_SECTIONS.map((sec) => {
                  const Icon = sec.icon;
                  const count = domainCounts[sec.id] || { granted: 0, total: 0 };
                  const isSelected = selectedDomain === sec.id;
                  return (
                    <button
                      key={sec.id}
                      onClick={() => setSelectedDomain(sec.id)}
                      className={`w-full flex items-center justify-between p-2.5 rounded-none text-xs font-medium transition-all text-left cursor-pointer border ${
                        isSelected
                          ? "bg-[var(--accent-primary)]/10 text-[var(--accent-primary)] font-bold border-[var(--accent-primary)]/30"
                          : "text-muted-foreground hover:bg-muted/50 hover:text-foreground border-transparent"
                      }`}
                    >
                      <div className="flex items-center gap-2.5 truncate">
                        <Icon className={`h-4 w-4 shrink-0 ${isSelected ? "text-[var(--accent-primary)]" : "text-muted-foreground"}`} />
                        <span className="truncate">{sec.label}</span>
                      </div>
                      <Badge
                        variant="secondary"
                        className={`text-[10px] font-mono shrink-0 ml-2 rounded-none ${
                          count.granted === count.total && count.total > 0
                            ? "bg-emerald-500/10 text-emerald-400 border border-emerald-500/30"
                            : count.granted > 0
                            ? "bg-purple-500/10 text-purple-400 border border-purple-500/30"
                            : ""
                        }`}
                      >
                        {count.granted}/{count.total}
                      </Badge>
                    </button>
                  );
                })}
              </div>
            </div>

            {/* Quick Actions Panel */}
            <div className="rounded-none border border-border bg-card">
              <div className="p-4 pb-3">
                <h3 className="text-sm font-bold uppercase tracking-wider text-muted-foreground">
                  Domain Actions
                </h3>
                <p className="text-xs text-muted-foreground mt-1">
                  Apply batch grants or revocations to the active domain filter.
                </p>
              </div>
              <div className="space-y-2 p-3 pt-0">
                <Button
                  variant="outline"
                  size="sm"
                  onClick={() => handleGrantDomain(selectedDomain)}
                  className="w-full text-xs font-semibold rounded-none cursor-pointer hover:bg-emerald-500/10 hover:text-emerald-400 hover:border-emerald-500/30"
                >
                  Grant All in Domain
                </Button>
                <Button
                  variant="outline"
                  size="sm"
                  onClick={() => handleRevokeDomain(selectedDomain)}
                  className="w-full text-xs font-semibold rounded-none cursor-pointer hover:bg-red-500/10 hover:text-red-400 hover:border-red-500/30"
                >
                  Revoke All in Domain
                </Button>
              </div>
            </div>
          </div>

          {/* Right 3 Columns: Search, Filters & Permission Grid (Single Column Matrix) */}
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
                  className="pl-10 h-10 rounded-none bg-card border-border text-xs font-mono"
                />
              </div>

              <div className="flex items-center gap-1.5 bg-card p-1 rounded-none border border-border shrink-0">
                {(["all", "granted", "revoked"] as const).map((filter) => (
                  <button
                    key={filter}
                    onClick={() => setStatusFilter(filter)}
                    className={`px-3 py-1.5 rounded-none text-xs font-mono capitalize transition-colors cursor-pointer ${
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

            {/* Permissions List: Single-Column Open Matrix with Continuous Lines */}
            {filteredCatalog.length === 0 ? (
              <div className="rounded-none border border-border bg-card p-12 text-center">
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
                  className="mt-4 rounded-none text-xs cursor-pointer"
                >
                  Clear All Filters
                </Button>
              </div>
            ) : (
              <div className="relative overflow-visible">
                <div className="flex flex-col relative">
                  {filteredCatalog.map((item, idx) => {
                    const isLast = idx === filteredCatalog.length - 1;
                    const isGranted = activePerms.has(item.key);
                    const isLockedSelf = isSelf && item.key === "platform.permissions.manage";
                    const meta = PERMISSION_TAXONOMY[item.key] || {
                      domain: "system",
                      risk: "standard",
                      humanName: item.key,
                      categoryLabel: "General",
                    };

                    const riskColor =
                      meta.risk === "critical"
                        ? "#ef4444"
                        : meta.risk === "elevated"
                        ? "#f59e0b"
                        : meta.risk === "readonly"
                        ? "#64748b"
                        : "#3b82f6";

                    const riskRgb =
                      meta.risk === "critical"
                        ? "239, 68, 68"
                        : meta.risk === "elevated"
                        ? "245, 158, 11"
                        : meta.risk === "readonly"
                        ? "100, 116, 139"
                        : "59, 130, 246";

                    const riskBadge =
                      meta.risk === "critical" ? (
                        <Badge variant="outline" className="text-[10px] bg-red-500/10 text-red-400 border-red-500/30 font-mono rounded-none">
                          Critical Risk
                        </Badge>
                      ) : meta.risk === "elevated" ? (
                        <Badge variant="outline" className="text-[10px] bg-amber-500/10 text-amber-400 border-amber-500/30 font-mono rounded-none">
                          Elevated
                        </Badge>
                      ) : meta.risk === "readonly" ? (
                        <Badge variant="outline" className="text-[10px] bg-slate-500/10 text-slate-400 border-slate-500/30 font-mono rounded-none">
                          Read Only
                        </Badge>
                      ) : (
                        <Badge variant="outline" className="text-[10px] bg-blue-500/10 text-blue-400 border-blue-500/30 font-mono rounded-none">
                          Standard
                        </Badge>
                      );

                    return (
                      <div key={item.key} className="relative">
                        <div className="p-2.5 sm:p-3 text-left border-0">
                          {/* Frameless Idle -> Sharp Risk-Colored Inset Highlight */}
                          <div
                            onClick={() => !isLockedSelf && handleTogglePerm(item.key)}
                            className={`p-4 sm:p-5 rounded-none flex items-start justify-between gap-4 transition-all duration-150 ${
                              isLockedSelf
                                ? "cursor-not-allowed opacity-90"
                                : "cursor-pointer"
                            }`}
                            style={{
                              border: "none",
                              boxShadow: isGranted
                                ? `inset 0 0 0 2px ${riskColor}`
                                : "none",
                              backgroundColor: isGranted
                                ? `rgba(${riskRgb}, 0.08)`
                                : isLockedSelf
                                ? "rgba(245, 158, 11, 0.04)"
                                : "transparent",
                            }}
                            onMouseEnter={(e) => {
                              if (!isGranted && !isLockedSelf) {
                                e.currentTarget.style.boxShadow = `inset 0 0 0 2px ${riskColor}`;
                                e.currentTarget.style.backgroundColor = `rgba(${riskRgb}, 0.05)`;
                              }
                            }}
                            onMouseLeave={(e) => {
                              if (!isGranted && !isLockedSelf) {
                                e.currentTarget.style.boxShadow = "none";
                                e.currentTarget.style.backgroundColor = "transparent";
                              }
                            }}
                          >
                            <div className="space-y-1.5 flex-1 min-w-0">
                              <div className="flex items-center gap-2 flex-wrap">
                                <span className="text-sm font-bold text-foreground">
                                  {meta.humanName}
                                </span>
                                {riskBadge}
                                <Badge variant="secondary" className="text-[10px] font-mono rounded-none">
                                  {meta.categoryLabel}
                                </Badge>
                                {isLockedSelf && (
                                  <Badge variant="outline" className="text-[10px] bg-amber-500/10 text-amber-500 dark:text-amber-400 border-amber-500/30 font-mono flex items-center gap-1 rounded-none">
                                    <Lock className="h-2.5 w-2.5" /> Locked
                                  </Badge>
                                )}
                              </div>

                              <div className="flex items-center gap-2 text-xs font-mono text-muted-foreground">
                                <code className="bg-muted px-1.5 py-0.5 text-[11px] text-foreground font-semibold rounded-none">
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

                            {/* Sharp Interactive Checkbox Toggle */}
                            <div className="shrink-0 flex items-center pt-1" onClick={(e) => e.stopPropagation()}>
                              {isLockedSelf ? (
                                <div className="flex items-center gap-1.5 px-3 py-1.5 rounded-none bg-amber-500/10 border border-amber-500/30 text-amber-600 dark:text-amber-400 text-xs font-mono font-bold">
                                  <Lock className="h-3.5 w-3.5" />
                                  <span>LOCKED</span>
                                </div>
                              ) : (
                                <button
                                  type="button"
                                  onClick={() => handleTogglePerm(item.key)}
                                  className={`h-6 w-6 rounded-none flex items-center justify-center shrink-0 border transition-all cursor-pointer ${
                                    isGranted
                                      ? "border-transparent text-white dark:text-black font-bold"
                                      : "border-border bg-card hover:border-muted-foreground/60"
                                  }`}
                                  style={{
                                    backgroundColor: isGranted ? riskColor : undefined,
                                  }}
                                  role="switch"
                                  aria-checked={isGranted}
                                >
                                  {isGranted && <Check className="h-4 w-4 stroke-[3]" />}
                                </button>
                              )}
                            </div>
                          </div>
                        </div>

                        {/* Continuous Horizontal Row Divider Line */}
                        {!isLast && (
                          <div className="matrix-line-h bottom-0" />
                        )}
                      </div>
                    );
                  })}
                </div>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
