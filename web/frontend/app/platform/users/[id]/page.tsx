// web/frontend/app/platform/users/[id]/page.tsx

"use client";

import { useEffect, useState, useMemo } from "react";
import { useRouter, useParams } from "next/navigation";
import { useAuth } from "@/lib/auth";
import { api } from "@/lib/api";
import { LoadingSpinner } from "@/components/shared/loading-spinner";
import { AccessRestricted } from "@/components/shared/access-restricted";
import { UserPermissionsMatrix } from "@/components/platform/user-permissions-matrix";
import {
  ArrowLeft,
  RotateCcw,
  Save,
  Mail,
  AlertCircle,
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import {
  PlatformPermissionItem,
  PlatformUserPermissionSummary,
} from "@/lib/types";
import {
  PERMISSION_TAXONOMY,
  type DomainKey,
} from "@/lib/platform/permission-taxonomy";

export default function UserRbacConfigPage() {
  const router = useRouter();
  const params = useParams();
  const targetUserIdStr = (params?.id as string) || "";
  const targetUserId = parseInt(targetUserIdStr, 10);

  const { user: currentUser, loading: authLoading, refreshUser } = useAuth();

  const [operator, setOperator] = useState<PlatformUserPermissionSummary | null>(null);
  const [catalog, setCatalog] = useState<PlatformPermissionItem[]>([]);
  const [initialPerms, setInitialPerms] = useState<Set<string>>(new Set());
  const [activePerms, setActivePerms] = useState<Set<string>>(new Set());

  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const [searchQuery, setSearchQuery] = useState("");
  const [selectedDomain, setSelectedDomain] = useState<DomainKey>("all");
  const [statusFilter, setStatusFilter] = useState<"all" | "granted" | "revoked">("all");
  const [copiedKey, setCopiedKey] = useState<string | null>(null);

  const isSelf = useMemo(() => {
    if (!currentUser || !operator) return false;
    return currentUser.id === operator.id || currentUser.username === operator.username;
  }, [currentUser, operator]);

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

  const handleTogglePerm = (permKey: string) => {
    if (isSelf && permKey === "platform.permissions.manage") {
      setError("Self-Lockout Protection: You cannot revoke your own delegation authority ('platform.permissions.manage').");
      return;
    }

    setError(null);
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
        if (isSelf && k === "platform.permissions.manage") return;
        next.delete(k);
      });
      return next;
    });
  };

  const handleReset = () => {
    setError(null);
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

  const filteredCatalog = useMemo(() => {
    return catalog.filter((item) => {
      const meta = PERMISSION_TAXONOMY[item.key] || {
        domain: "system",
        risk: "standard",
        humanName: item.key,
        categoryLabel: "General",
      };

      if (selectedDomain !== "all" && meta.domain !== selectedDomain) return false;

      const isGranted = activePerms.has(item.key);
      if (statusFilter === "granted" && !isGranted) return false;
      if (statusFilter === "revoked" && isGranted) return false;

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
      <AccessRestricted
        title="Access Denied"
        message={error}
        backHref="/platform"
        backLabel="Return to Platform Console"
        icon={<AlertCircle className="h-7 w-7 text-destructive" />}
      />
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
                className="h-9 px-3.5 text-xs font-semibold text-muted-foreground hover:text-foreground rounded-none border-border cursor-pointer gap-1.5 disabled:opacity-40 disabled:cursor-not-allowed"
              >
                <RotateCcw className="h-3.5 w-3.5" />
                <span>Reset</span>
              </Button>
              <Button
                size="sm"
                onClick={handleSave}
                disabled={!diff.hasChanges || saving}
                className="h-9 px-3.5 text-xs font-bold rounded-none bg-[var(--accent-primary)] text-white dark:text-black hover:opacity-90 cursor-pointer gap-1.5 disabled:opacity-40 disabled:cursor-not-allowed"
              >
                {saving ? <LoadingSpinner /> : <Save className="h-3.5 w-3.5" />}
                <span>Save</span>
              </Button>
            </div>
          </div>
        </div>
      </div>

      {/* Main Configuration Content */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-6">
        {error && (
          <div className="p-3.5 rounded-none bg-red-500/10 border border-red-500/20 text-red-400 text-xs flex items-center gap-2">
            <AlertCircle className="h-4 w-4 shrink-0" />
            <span>{error}</span>
          </div>
        )}

        <UserPermissionsMatrix
          catalog={catalog}
          filteredCatalog={filteredCatalog}
          activePerms={activePerms}
          domainCounts={domainCounts}
          selectedDomain={selectedDomain}
          onSelectDomain={setSelectedDomain}
          statusFilter={statusFilter}
          onStatusFilterChange={setStatusFilter}
          searchQuery={searchQuery}
          onSearchQueryChange={setSearchQuery}
          isSelf={isSelf}
          copiedKey={copiedKey}
          onCopyKey={copyKeyToClipboard}
          onTogglePerm={handleTogglePerm}
          onGrantDomain={handleGrantDomain}
          onRevokeDomain={handleRevokeDomain}
          onClearFilters={() => {
            setSelectedDomain("all");
            setStatusFilter("all");
            setSearchQuery("");
          }}
        />
      </div>
    </div>
  );
}
