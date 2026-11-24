// web/frontend/app/platform/page.tsx

"use client";

import { useEffect, useState, useMemo } from "react";
import { useRouter } from "next/navigation";
import { useAuth } from "@/lib/auth";
import { api } from "@/lib/api";
import { LoadingSpinner } from "@/components/shared/loading-spinner";
import { 
  Building2, Users, Award, ShieldAlert, Shield, CheckCircle, 
  ExternalLink, Plus, Trash2, Clock, Globe, GraduationCap, 
  Search, AlertCircle, CheckCircle2, ChevronRight, BookOpen, 
  Terminal, Sparkles, KeyRound, BarChart3, Download, TrendingUp, RefreshCw,
  Sliders, Settings2, Power, Eye, X, Check
} from "lucide-react";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { NumberStepper } from "@/components/ui/number-stepper";
import { ConfirmModal } from "@/components/builder/confirm-modal";
import {
  Module,
  ModuleDetail,
  OrganizationResponse,
  PlatformOverviewAnalyticsResponse,
  PlatformTrendsAnalyticsResponse,
  PlatformOrgSummaryItem,
  PlatformPermissionItem,
  PlatformUserPermissionSummary,
  OrgSettingAdminItemResponse,
  AuditLogResponse,
} from "@/lib/types";

type TabKey = "organizations" | "analytics" | "staff" | "curriculum" | "audit";

export default function PlatformConsolePage() {
  const { user, loading: authLoading } = useAuth();
  const router = useRouter();

  // Helper for checking granular platform permissions
  const hasPerm = (permKey: string): boolean => {
    if (!user) return false;
    return Boolean(user.platform_permissions?.includes(permKey));
  };

  // Dynamically determine permitted tabs
  const permittedTabs = useMemo(() => {
    const tabs: { key: TabKey; label: string; icon: any }[] = [];
    if (hasPerm("platform.organizations.view") || hasPerm("platform.organizations.create") || hasPerm("platform.organizations.manage") || hasPerm("platform.organizations.settings")) {
      tabs.push({ key: "organizations", label: "Organizations", icon: Building2 });
    }
    if (hasPerm("platform.analytics.view") || hasPerm("platform.audit.view")) {
      tabs.push({ key: "analytics", label: "Global Analytics", icon: BarChart3 });
    }
    if (hasPerm("platform.staff.manage") || hasPerm("platform.permissions.manage")) {
      tabs.push({ key: "staff", label: "Platform Users & RBAC", icon: Shield });
    }
    if (hasPerm("platform.modules.verify") || hasPerm("platform.modules.view_all")) {
      tabs.push({ key: "curriculum", label: "Curriculum Review", icon: Award });
    }
    if (hasPerm("platform.audit.view")) {
      tabs.push({ key: "audit", label: "Security & Audit Logs", icon: KeyRound });
    }
    return tabs;
  }, [user]);

  // Active tab state
  const [activeTab, setActiveTab] = useState<TabKey>("organizations");

  // Loading & error states
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // Organizations state
  const [orgs, setOrgs] = useState<OrganizationResponse[]>([]);
  const [myMembershipSlugs, setMyMembershipSlugs] = useState<Set<string>>(new Set());
  const [orgSearch, setOrgSearch] = useState("");
  const [showCreateOrgModal, setShowCreateOrgModal] = useState(false);
  const [newOrgName, setNewOrgName] = useState("");
  const [newOrgSlug, setNewOrgSlug] = useState("");
  const [newOrgType, setNewOrgType] = useState("company");
  const [newOrgDomain, setNewOrgDomain] = useState("");
  const [createOrgLoading, setCreateOrgLoading] = useState(false);
  const [createOrgError, setCreateOrgError] = useState<string | null>(null);

  // "Manage Org" Platform Settings Modal State
  const [selectedOrgForSettings, setSelectedOrgForSettings] = useState<OrganizationResponse | null>(null);
  const [orgSettingsList, setOrgSettingsList] = useState<OrgSettingAdminItemResponse[]>([]);
  const [loadingSettings, setLoadingSettings] = useState(false);
  const [settingsSaveMsg, setSettingsSaveMsg] = useState<string | null>(null);
  const [editingValues, setEditingValues] = useState<Record<string, any>>({});

  // Staff & Permissions state
  const [platformUsers, setPlatformUsers] = useState<PlatformUserPermissionSummary[]>([]);
  const [availablePermissions, setAvailablePermissions] = useState<PlatformPermissionItem[]>([]);
  const [loadingUsers, setLoadingUsers] = useState(false);
  const [showAddUserModal, setShowAddUserModal] = useState(false);
  const [newUserIdentity, setNewUserIdentity] = useState("");
  const [selectedUserForPerms, setSelectedUserForPerms] = useState<PlatformUserPermissionSummary | null>(null);
  const [userPermsDraft, setUserPermsDraft] = useState<string[]>([]);
  const [savingPerms, setSavingPerms] = useState(false);

  // Platform Analytics State
  const [platformOverview, setPlatformOverview] = useState<PlatformOverviewAnalyticsResponse | null>(null);
  const [platformTrends, setPlatformTrends] = useState<PlatformTrendsAnalyticsResponse | null>(null);
  const [platformOrgsSummary, setPlatformOrgsSummary] = useState<PlatformOrgSummaryItem[]>([]);
  const [platformPeriod, setPlatformPeriod] = useState<string>("30d");
  const [platformAnalyticsLoading, setPlatformAnalyticsLoading] = useState(false);
  const [exportingPlatform, setExportingPlatform] = useState(false);

  // Curriculum review state
  const [unverifiedModules, setUnverifiedModules] = useState<Module[]>([]);
  const [selectedModule, setSelectedModule] = useState<ModuleDetail | null>(null);
  const [loadingDetail, setLoadingDetail] = useState(false);
  const [xpState, setXpState] = useState<Record<string, number>>({});

  // Security Audit Logs state
  const [auditLogs, setAuditLogs] = useState<AuditLogResponse[]>([]);
  const [loadingAudit, setLoadingAudit] = useState(false);
  const [auditSearch, setAuditSearch] = useState("");
  const [auditActionFilter, setAuditActionFilter] = useState("all");

  // Confirmation modal
  const [modalConfig, setModalConfig] = useState<{
    isOpen: boolean;
    title: string;
    message: string;
    confirmText?: string;
    type?: "danger" | "warning" | "info" | "success";
    onConfirm: () => void;
    onCancel?: () => void;
  }>({
    isOpen: false,
    title: "",
    message: "",
    onConfirm: () => {},
  });

  const isPlatformStaff = Boolean(
    user && ((user.platform_roles && user.platform_roles.length > 0) || (user.platform_permissions && user.platform_permissions.length > 0))
  );

  // Initial access check & auto-select first permitted tab
  useEffect(() => {
    if (authLoading) return;
    if (!user) {
      router.push("/login");
      return;
    }

    if (!isPlatformStaff) {
      setLoading(false);
      return;
    }

    if (permittedTabs.length > 0 && !permittedTabs.some(t => t.key === activeTab)) {
      setActiveTab(permittedTabs[0].key);
    }

    loadInitialData();
  }, [user, authLoading, isPlatformStaff, permittedTabs]);

  // Tab switch loading
  useEffect(() => {
    if (!isPlatformStaff) return;
    if (activeTab === "analytics") loadPlatformAnalytics();
    if (activeTab === "staff") loadPlatformStaffData();
    if (activeTab === "audit") loadAuditLogs();
    if (activeTab === "curriculum") loadCurriculumData();
  }, [activeTab, isPlatformStaff]);

  const loadInitialData = async () => {
    setLoading(true);
    try {
      const [allOrgs, myOrgs] = await Promise.all([
        api.getOrganizations().catch(() => []),
        api.getOrganizations().catch(() => []),
      ]);
      setOrgs(allOrgs);
      setMyMembershipSlugs(new Set(myOrgs.map((o: any) => o.slug)));
    } catch (err: any) {
      setError(err.message || "Failed to load platform data");
    } finally {
      setLoading(false);
    }
  };

  const loadPlatformStaffData = async () => {
    setLoadingUsers(true);
    try {
      const [usersList, permsList] = await Promise.all([
        api.getPlatformUsers().catch(() => []),
        api.getPlatformPermissions().catch(() => []),
      ]);
      setPlatformUsers(usersList);
      setAvailablePermissions(permsList);
    } catch (err) {
      console.error("Failed to load platform staff:", err);
    } finally {
      setLoadingUsers(false);
    }
  };

  const loadCurriculumData = async () => {
    try {
      const res = await api.getModules();
      const unverified = (res.modules || []).filter((m: any) => m.status !== "verified");
      setUnverifiedModules(unverified);
    } catch (err) {
      console.error("Failed to load curriculum:", err);
    }
  };

  const loadAuditLogs = async () => {
    setLoadingAudit(true);
    try {
      const logs = await api.getPlatformAuditLogs({
        limit: 100,
        action: auditActionFilter === "all" ? undefined : auditActionFilter,
        search: auditSearch || undefined,
      });
      setAuditLogs(logs);
    } catch (err) {
      console.error("Failed to load audit logs:", err);
    } finally {
      setLoadingAudit(false);
    }
  };

  const loadPlatformAnalytics = async (period: string = platformPeriod) => {
    setPlatformAnalyticsLoading(true);
    try {
      const [ov, tr, orgsSummary] = await Promise.all([
        api.getPlatformAnalyticsOverview().catch(() => null),
        api.getPlatformAnalyticsTrends(period).catch(() => null),
        api.getPlatformAnalyticsOrganizations().catch(() => []),
      ]);
      setPlatformOverview(ov);
      setPlatformTrends(tr);
      setPlatformOrgsSummary(orgsSummary);
    } catch (err) {
      console.error(err);
    } finally {
      setPlatformAnalyticsLoading(false);
    }
  };

  const handleExportPlatformOrgs = async () => {
    setExportingPlatform(true);
    try {
      const blob = await api.exportPlatformAnalyticsBlob();
      const url = window.URL.createObjectURL(blob);
      const a = document.createElement("a");
      a.href = url;
      a.download = "platform_organizations_summary.csv";
      document.body.appendChild(a);
      a.click();
      window.URL.revokeObjectURL(url);
      document.body.removeChild(a);
    } catch (err: any) {
      alert("Platform export failed: " + err.message);
    } finally {
      setExportingPlatform(false);
    }
  };

  // --- Manage Org (Platform Settings & Tenant Governance Modal) ---
  const handleOpenManageOrg = async (org: OrganizationResponse) => {
    setSelectedOrgForSettings(org);
    setLoadingSettings(true);
    setSettingsSaveMsg(null);
    try {
      const settings = await api.getPlatformOrgSettings(org.slug);
      setOrgSettingsList(settings);
      const initialValues: Record<string, any> = {};
      settings.forEach((s) => {
        initialValues[s.key] = s.value !== null && s.value !== undefined ? s.value : s.default;
      });
      setEditingValues(initialValues);
    } catch (err: any) {
      alert("Failed to load platform settings for organization: " + err.message);
    } finally {
      setLoadingSettings(false);
    }
  };

  const handleToggleSettingAvailability = async (settingKey: string, currentEnabled: boolean) => {
    if (!selectedOrgForSettings) return;
    try {
      if (currentEnabled) {
        await api.disablePlatformOrgSetting(selectedOrgForSettings.slug, settingKey);
      } else {
        await api.enablePlatformOrgSetting(selectedOrgForSettings.slug, settingKey, editingValues[settingKey]);
      }
      const updated = await api.getPlatformOrgSettings(selectedOrgForSettings.slug);
      setOrgSettingsList(updated);
      setSettingsSaveMsg(`Setting '${settingKey}' availability updated.`);
      setTimeout(() => setSettingsSaveMsg(null), 3000);
    } catch (err: any) {
      alert("Failed to toggle availability: " + err.message);
    }
  };

  const handleSaveSettingValue = async (settingKey: string) => {
    if (!selectedOrgForSettings) return;
    const value = editingValues[settingKey];
    try {
      await api.overridePlatformOrgSetting(selectedOrgForSettings.slug, settingKey, value);
      const updated = await api.getPlatformOrgSettings(selectedOrgForSettings.slug);
      setOrgSettingsList(updated);
      setSettingsSaveMsg(`Saved value for '${settingKey}'.`);
      setTimeout(() => setSettingsSaveMsg(null), 3000);
    } catch (err: any) {
      alert("Failed to save setting value: " + err.message);
    }
  };

  const handleToggleOrgStatus = (org: OrganizationResponse) => {
    const isSuspended = org.status === "suspended";
    const nextStatus = isSuspended ? "active" : "suspended";
    setModalConfig({
      isOpen: true,
      title: isSuspended ? "Reactivate Organization" : "Suspend Organization",
      message: isSuspended
        ? `Are you sure you want to reactivate "${org.name}"? Members will regain access to their workspace.`
        : `Are you sure you want to suspend "${org.name}"? Tenant access will be immediately deactivated for all members.`,
      confirmText: isSuspended ? "Reactivate Tenant" : "Suspend Tenant",
      type: isSuspended ? "info" : "danger",
      onCancel: () => setModalConfig((prev) => ({ ...prev, isOpen: false })),
      onConfirm: async () => {
        setModalConfig((prev) => ({ ...prev, isOpen: false }));
        try {
          await api.updateOrgStatus(org.slug, nextStatus);
          const updated = await api.getOrganizations();
          setOrgs(updated);
        } catch (err: any) {
          alert("Status update failed: " + err.message);
        }
      },
    });
  };

  // --- Permissions Configuration Modal ---
  const handleOpenPermsModal = (staff: PlatformUserPermissionSummary) => {
    setSelectedUserForPerms(staff);
    setUserPermsDraft([...staff.permissions]);
  };

  const handleToggleDraftPerm = (permKey: string) => {
    setUserPermsDraft((prev) =>
      prev.includes(permKey) ? prev.filter((k) => k !== permKey) : [...prev, permKey]
    );
  };

  const handleSaveUserPermissions = async () => {
    if (!selectedUserForPerms) return;
    setSavingPerms(true);
    try {
      await api.updateUserPermissions(selectedUserForPerms.id, userPermsDraft);
      setSelectedUserForPerms(null);
      await loadPlatformStaffData();
    } catch (err: any) {
      alert("Failed to update permissions: " + err.message);
    } finally {
      setSavingPerms(false);
    }
  };

  const handleAddPlatformUserSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!newUserIdentity.trim()) return;
    try {
      const added = await api.addPlatformUser({ identity: newUserIdentity.trim(), permissions: [] });
      setNewUserIdentity("");
      setShowAddUserModal(false);
      router.push(`/platform/users/${added.id}`);
    } catch (err: any) {
      alert("Error adding user: " + err.message);
    }
  };

  const handleRevokePlatformUser = (userId: number, username: string) => {
    if (user && (user.id === userId || user.username === username)) {
      alert("Self-Protection Guard: You cannot delete or revoke your own platform operator account.");
      return;
    }
    setModalConfig({
      isOpen: true,
      title: "Revoke Platform Operator Access",
      message: `Are you sure you want to revoke all platform permissions for '${username}'? They will lose access to global governance operations.`,
      confirmText: "Revoke Access",
      type: "danger",
      onCancel: () => setModalConfig((prev) => ({ ...prev, isOpen: false })),
      onConfirm: async () => {
        setModalConfig((prev) => ({ ...prev, isOpen: false }));
        try {
          await api.revokePlatformUser(userId);
          await loadPlatformStaffData();
        } catch (err: any) {
          alert("Error revoking user: " + err.message);
        }
      },
    });
  };

  // --- Provision Organization ---
  const handleCreateOrg = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!newOrgName.trim() || !newOrgSlug.trim()) {
      setCreateOrgError("Organization name and slug are required");
      return;
    }

    setCreateOrgLoading(true);
    setCreateOrgError(null);
    try {
      const domains = newOrgDomain.trim()
        ? newOrgDomain.split(",").map((d) => d.trim()).filter(Boolean)
        : [];
      await api.createOrganization({
        name: newOrgName.trim(),
        slug: newOrgSlug.trim().toLowerCase(),
        type: newOrgType,
        domains,
      });

      setShowCreateOrgModal(false);
      setNewOrgName("");
      setNewOrgSlug("");
      setNewOrgDomain("");
      const updated = await api.getOrganizations();
      setOrgs(updated);
    } catch (err: any) {
      setCreateOrgError(err.message || "Failed to provision organization");
    } finally {
      setCreateOrgLoading(false);
    }
  };

  // --- Curriculum Review & Calibrator ---
  const handleSelectModule = async (id: string) => {
    setLoadingDetail(true);
    try {
      const detail = await api.getModule(id);
      setSelectedModule(detail);
      const initialXP: Record<string, number> = {};
      detail.sections.forEach((sec: any) => {
        initialXP[sec.id] = sec.xp || 10;
        sec.labs?.forEach((lab: any) => {
          initialXP[lab.id] = lab.xp || 30;
        });
      });
      setXpState(initialXP);
    } catch (err: any) {
      alert("Failed to load module details: " + err.message);
    } finally {
      setLoadingDetail(false);
    }
  };

  const handleApprove = (id: string, title: string) => {
    setModalConfig({
      isOpen: true,
      title: "Verify & Publish Curriculum",
      message: `Approve and officially verify "${title}" with the calibrated XP rewards? This elevates it to official verified TLD curriculum.`,
      confirmText: "Verify & Publish",
      type: "success",
      onCancel: () => setModalConfig((prev) => ({ ...prev, isOpen: false })),
      onConfirm: async () => {
        setModalConfig((prev) => ({ ...prev, isOpen: false }));
        try {
          await api.verifyModule(id, xpState);
          setSelectedModule(null);
          await loadCurriculumData();
        } catch (err: any) {
          alert("Verification failed: " + err.message);
        }
      },
    });
  };

  const handleReject = (id: string, title: string) => {
    const reason = prompt(`Provide rejection feedback for "${title}":`);
    if (reason === null) return;
    if (!reason.trim()) {
      alert("Rejection reason is required.");
      return;
    }
    api.rejectModule(id, reason.trim())
      .then(async () => {
        setSelectedModule(null);
        await loadCurriculumData();
      })
      .catch((err) => alert("Rejection failed: " + err.message));
  };

  if (authLoading || loading) {
    return (
      <div className="min-h-[calc(100vh-64px)] flex items-center justify-center">
        <LoadingSpinner />
      </div>
    );
  }

  if (!isPlatformStaff || permittedTabs.length === 0) {
    return (
      <div className="min-h-[calc(100vh-64px)] flex items-center justify-center px-4">
        <div className="max-w-md w-full text-center space-y-4 p-8 rounded-3xl border border-border bg-card shadow-xl">
          <div className="h-16 w-16 mx-auto rounded-2xl bg-destructive/10 text-destructive flex items-center justify-center">
            <ShieldAlert className="h-8 w-8" />
          </div>
          <h2 className="text-xl font-black text-foreground">Access Restricted</h2>
          <p className="text-xs text-muted-foreground leading-relaxed">
            The Platform Console is restricted to authorized platform operations personnel.
            Your global account does not possess active platform permissions.
          </p>
          <Button asChild className="rounded-xl text-xs font-bold" style={{ backgroundColor: "var(--accent-primary)", color: "black" }}>
            <Link href="/dashboard">Return to Dashboard</Link>
          </Button>
        </div>
      </div>
    );
  }

  const filteredOrgs = orgs.filter((o) =>
    o.name.toLowerCase().includes(orgSearch.toLowerCase()) ||
    o.slug.toLowerCase().includes(orgSearch.toLowerCase())
  );

  return (
    <div className="min-h-[calc(100vh-64px)]">
      {/* Top Banner */}
      <div className="border-b border-border bg-card/30">
        <div className="max-w-6xl mx-auto px-4 py-8">
          <div className="flex items-start justify-between gap-6 flex-wrap">
            <div>
              <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[var(--accent-primary)]/10 text-[var(--accent-primary)] text-xs font-mono font-bold mb-3">
                <Globe className="h-3.5 w-3.5" />
                <span>Superadmin Operations</span>
              </div>
              <h1 className="text-3xl font-black tracking-tight text-foreground">
                Platform Console
              </h1>
              <p className="mt-1.5 text-muted-foreground text-xs max-w-xl leading-relaxed">
                Global governance for The Last Deploy: manage tenant organizations, platform permissions, and official curriculum verification.
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
                    className={`rounded-xl text-xs font-bold gap-1.5 cursor-pointer transition-all ${
                      isSelected ? "bg-[var(--accent-primary)] text-black" : "text-muted-foreground hover:text-foreground"
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

      {/* Main Content Area */}
      <div className="max-w-6xl mx-auto px-4 py-8">
        {/* ========================================================================= */}
        {/* TAB 1: Organizations Directory & Platform Governance                      */}
        {/* ========================================================================= */}
        {activeTab === "organizations" && (
          <div className="space-y-6">
            <div className="flex items-center justify-between gap-4 flex-wrap">
              <div className="relative w-72">
                <Search className="absolute left-3 top-2.5 h-4 w-4 text-muted-foreground" />
                <Input
                  placeholder="Search organizations..."
                  value={orgSearch}
                  onChange={(e) => setOrgSearch(e.target.value)}
                  className="pl-9 h-9 text-xs rounded-xl"
                />
              </div>

              {hasPerm("platform.organizations.create") && (
                <Button
                  size="sm"
                  onClick={() => setShowCreateOrgModal(true)}
                  className="rounded-xl bg-[var(--accent-primary)] text-black hover:opacity-90 font-bold text-xs gap-1.5 cursor-pointer"
                >
                  <Plus className="h-3.5 w-3.5" />
                  <span>Provision Organization</span>
                </Button>
              )}
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
              {filteredOrgs.map((org) => {
                const isPlatform = org.type === "platform" || org.is_platform;
                const isSuspended = org.status === "suspended";
                const isMemberOfOrg = myMembershipSlugs.has(org.slug);

                return (
                  <div
                    key={org.slug}
                    className="p-5 rounded-2xl border border-border bg-card shadow-sm hover:border-[var(--accent-primary)]/40 transition-all flex flex-col justify-between space-y-4"
                  >
                    <div className="space-y-2.5">
                      <div className="flex items-start justify-between gap-3">
                        <div className="flex items-center gap-3">
                          <div className="h-10 w-10 rounded-xl bg-[var(--accent-primary)]/10 text-[var(--accent-primary)] flex items-center justify-center shrink-0 font-bold">
                            {org.type === "university" ? (
                              <GraduationCap className="h-5 w-5" />
                            ) : isPlatform ? (
                              <Globe className="h-5 w-5" />
                            ) : (
                              <Building2 className="h-5 w-5" />
                            )}
                          </div>
                          <div>
                            <h3 className="font-bold text-sm text-foreground truncate max-w-[150px]">
                              {isPlatform ? "The Last Deploy (Personal)" : org.name}
                            </h3>
                            <span className="text-[10px] font-mono text-muted-foreground">
                              slug: {org.slug}
                            </span>
                          </div>
                        </div>
                        <span className="text-[10px] font-mono uppercase px-2 py-0.5 rounded-full bg-muted font-bold text-muted-foreground">
                          {org.type}
                        </span>
                      </div>

                      <div className="space-y-1.5 text-xs text-muted-foreground">
                        <div className="flex items-center justify-between">
                          <span>Status:</span>
                          <span className={`font-mono font-semibold flex items-center gap-1 text-[11px] ${
                            isSuspended ? "text-red-400" : "text-emerald-400"
                          }`}>
                            <span className={`h-1.5 w-1.5 rounded-full ${isSuspended ? "bg-red-400" : "bg-emerald-400"}`} />
                            {isSuspended ? "Suspended" : "Active"}
                          </span>
                        </div>
                        {org.domains && org.domains.length > 0 && (
                          <div className="flex items-center justify-between">
                            <span>Domains:</span>
                            <span className="font-mono text-zinc-300 text-[10px] truncate max-w-[140px]">
                              {org.domains.join(", ")}
                            </span>
                          </div>
                        )}
                        <div className="flex items-center justify-between">
                          <span>Your Membership:</span>
                          <span className="font-mono text-zinc-300 text-[11px]">
                            {isMemberOfOrg ? (
                              <span className="text-emerald-400 font-semibold">Active Member</span>
                            ) : (
                              <span className="text-muted-foreground">Not Enrolled</span>
                            )}
                          </span>
                        </div>
                      </div>
                    </div>

                    {/* Scoped Actions Footer */}
                    <div className="pt-3 border-t border-border flex items-center justify-between gap-2">
                      <div className="flex items-center gap-1.5">
                        {/* Switch Workspace: ONLY rendered if user has an active membership */}
                        {isMemberOfOrg && (
                          <Button
                            variant="outline"
                            size="sm"
                            onClick={() => {
                              api.setSelectedOrg(org.slug);
                              router.push("/dashboard");
                            }}
                            className="rounded-xl text-[11px] font-bold h-7 cursor-pointer"
                          >
                            Switch Workspace
                          </Button>
                        )}

                        {/* Suspend / Reactivate action */}
                        {hasPerm("platform.organizations.suspend") && !isPlatform && (
                          <Button
                            variant="ghost"
                            size="sm"
                            onClick={() => handleToggleOrgStatus(org)}
                            className={`rounded-xl text-[11px] font-bold h-7 cursor-pointer px-2 ${
                              isSuspended ? "text-emerald-400 hover:bg-emerald-500/10" : "text-red-400 hover:bg-red-500/10"
                            }`}
                            title={isSuspended ? "Reactivate Organization" : "Suspend Organization"}
                          >
                            <Power className="h-3.5 w-3.5" />
                          </Button>
                        )}
                      </div>

                      {/* Manage Org: Opens the Platform Organization Configuration Modal */}
                      {(hasPerm("platform.organizations.settings") || hasPerm("platform.organizations.manage")) && (
                        <Button
                          variant="ghost"
                          size="sm"
                          onClick={() => handleOpenManageOrg(org)}
                          className="rounded-xl text-[11px] font-bold text-[var(--accent-primary)] hover:bg-[var(--accent-primary)]/10 h-7 cursor-pointer gap-1"
                        >
                          <Settings2 className="h-3 w-3" />
                          <span>Manage Org</span>
                        </Button>
                      )}
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        )}

        {/* ========================================================================= */}
        {/* TAB 2: Global Analytics & Platform Intelligence                             */}
        {/* ========================================================================= */}
        {activeTab === "analytics" && (
          <div className="space-y-6">
            <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 p-4 rounded-2xl bg-card border border-border">
              <div className="flex items-center gap-2">
                <span className="text-xs font-bold text-muted-foreground uppercase tracking-wider font-mono mr-1">Period:</span>
                {(["7d", "30d", "90d", "all"] as const).map((p) => (
                  <Button
                    key={p}
                    size="sm"
                    variant={platformPeriod === p ? "default" : "outline"}
                    onClick={() => {
                      setPlatformPeriod(p);
                      loadPlatformAnalytics(p);
                    }}
                    className={`h-8 px-3 rounded-xl text-xs font-bold ${
                      platformPeriod === p ? "bg-[var(--accent-primary)] text-black" : ""
                    }`}
                  >
                    {p === "all" ? "All Time" : p.toUpperCase()}
                  </Button>
                ))}
                <Button
                  size="sm"
                  variant="ghost"
                  onClick={() => loadPlatformAnalytics(platformPeriod)}
                  disabled={platformAnalyticsLoading}
                  className="h-8 w-8 p-0 rounded-xl ml-1 text-muted-foreground hover:text-foreground cursor-pointer"
                  title="Refresh Platform Analytics"
                >
                  <RefreshCw className={`h-3.5 w-3.5 ${platformAnalyticsLoading ? "animate-spin" : ""}`} />
                </Button>
              </div>

              {hasPerm("platform.analytics.export") && (
                <div>
                  <Button
                    size="sm"
                    variant="outline"
                    onClick={handleExportPlatformOrgs}
                    disabled={exportingPlatform}
                    className="h-8 px-3 rounded-xl text-xs font-semibold gap-1.5 cursor-pointer"
                  >
                    <Download className="h-3.5 w-3.5 text-[var(--accent-primary)]" />
                    <span>{exportingPlatform ? "Exporting..." : "Export Organizations CSV"}</span>
                  </Button>
                </div>
              )}
            </div>

            {/* KPI Cards */}
            <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
              <Card className="rounded-2xl border-border bg-card p-4">
                <p className="text-[11px] font-mono uppercase text-muted-foreground">Total Organizations</p>
                <p className="text-2xl font-black text-foreground mt-1">
                  {platformOverview?.total_organizations ?? "—"}
                </p>
              </Card>
              <Card className="rounded-2xl border-border bg-card p-4">
                <p className="text-[11px] font-mono uppercase text-muted-foreground">Global Users</p>
                <p className="text-2xl font-black text-[var(--accent-primary)] mt-1">
                  {platformOverview?.total_users ?? "—"}
                </p>
              </Card>
              <Card className="rounded-2xl border-border bg-card p-4">
                <p className="text-[11px] font-mono uppercase text-muted-foreground">Lab Completions</p>
                <p className="text-2xl font-black text-emerald-400 mt-1">
                  {platformOverview?.total_lab_completions ?? "—"}
                </p>
              </Card>
              <Card className="rounded-2xl border-border bg-card p-4">
                <p className="text-[11px] font-mono uppercase text-muted-foreground">Verified XP Awarded</p>
                <p className="text-2xl font-black text-amber-400 mt-1">
                  {platformOverview?.total_verified_xp ?? "—"} XP
                </p>
              </Card>
            </div>

            {/* Organizations Breakdown Table */}
            <Card className="rounded-2xl border-border bg-card overflow-hidden">
              <div className="p-4 border-b border-border bg-muted/20 flex items-center justify-between">
                <h3 className="font-bold text-sm text-foreground">Tenant Organization Summary</h3>
                <span className="text-xs font-mono text-muted-foreground">{platformOrgsSummary.length} organizations active</span>
              </div>
              <div className="overflow-x-auto">
                <table className="w-full text-xs text-left">
                  <thead className="bg-muted/30 text-muted-foreground font-mono uppercase text-[10px]">
                    <tr>
                      <th className="p-3">Organization</th>
                      <th className="p-3">Type</th>
                      <th className="p-3">Status</th>
                      <th className="p-3">Members</th>
                      <th className="p-3">Active Cohorts</th>
                      <th className="p-3">Lab Completions</th>
                      <th className="p-3 text-right">Verified XP</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-border">
                    {platformOrgsSummary.map((org) => (
                      <tr key={org.organization_id} className="hover:bg-muted/10 transition-colors">
                        <td className="p-3 font-semibold text-foreground">{org.name}</td>
                        <td className="p-3 uppercase font-mono text-[10px] text-muted-foreground">{org.type}</td>
                        <td className="p-3">
                          <span className={`px-2 py-0.5 rounded-full text-[10px] font-bold ${
                            org.status === "active" ? "bg-emerald-500/10 text-emerald-400" : "bg-red-500/10 text-red-400"
                          }`}>
                            {org.status}
                          </span>
                        </td>
                        <td className="p-3 font-mono">{org.member_count}</td>
                        <td className="p-3 font-mono">{org.cohort_count}</td>
                        <td className="p-3 font-mono">{org.lab_completions_count}</td>
                        <td className="p-3 text-right font-mono text-amber-400 font-bold">{org.total_verified_xp} XP</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </Card>
          </div>
        )}

        {/* ========================================================================= */}
        {/* TAB 3: Platform Users & Granular RBAC                                     */}
        {/* ========================================================================= */}
        {activeTab === "staff" && (
          <div className="space-y-6">
            <div className="flex items-center justify-between gap-4 flex-wrap">
              <div>
                <h3 className="font-bold text-lg text-foreground">Platform Operators & RBAC</h3>
                <p className="text-xs text-muted-foreground mt-0.5">
                  Granular permission management for platform governance. No rigid role archetypes.
                </p>
              </div>

              {hasPerm("platform.permissions.manage") && (
                <Button
                  size="sm"
                  onClick={() => setShowAddUserModal(true)}
                  className="rounded-xl bg-[var(--accent-primary)] text-black hover:opacity-90 font-bold text-xs gap-1.5 cursor-pointer"
                >
                  <Plus className="h-3.5 w-3.5" />
                  <span>Grant Platform Access</span>
                </Button>
              )}
            </div>

            <div className="rounded-2xl border border-border overflow-hidden bg-card shadow-sm">
              <div className="p-4 border-b border-border bg-muted/20 flex items-center justify-between">
                <span className="font-bold text-xs text-muted-foreground uppercase font-mono">Current Platform Operators</span>
                <span className="text-xs font-mono text-muted-foreground">{platformUsers.length} Operators</span>
              </div>
              <div className="divide-y divide-border">
                {platformUsers.map((pUser) => {
                  const isSelf = user?.id === pUser.id || user?.username === pUser.username;

                  return (
                    <div key={pUser.id} className="p-4 flex items-center justify-between gap-4 hover:bg-muted/10 transition-colors flex-wrap sm:flex-nowrap">
                      <div className="flex items-center gap-3">
                        <div className="h-10 w-10 rounded-xl bg-purple-500/10 text-purple-400 flex items-center justify-center font-bold shrink-0">
                          <Shield className="h-5 w-5" />
                        </div>
                        <div>
                          <div className="flex items-center gap-2">
                            <h4 className="font-bold text-xs text-foreground">{pUser.username}</h4>
                            {isSelf && (
                              <span className="text-[9px] font-mono px-2 py-0.5 rounded-full bg-amber-500/10 text-amber-500 dark:text-amber-400 border border-amber-500/20 font-bold uppercase">
                                You
                              </span>
                            )}
                          </div>
                          <p className="text-[11px] text-muted-foreground font-mono">{pUser.email}</p>
                          <div className="flex items-center gap-1.5 mt-1.5 flex-wrap">
                            <span className="text-[11px] font-mono font-medium text-muted-foreground">
                              {pUser.permissions.length} active permissions:
                            </span>
                            {pUser.permissions.slice(0, 3).map((pk) => (
                              <span
                                key={pk}
                                className="text-[10px] font-mono font-medium px-2 py-0.5 rounded-md bg-muted text-foreground border border-border"
                              >
                                {pk.replace("platform.", "")}
                              </span>
                            ))}
                            {pUser.permissions.length > 3 && (
                              <span className="text-[10px] font-mono text-muted-foreground font-medium">
                                +{pUser.permissions.length - 3} more
                              </span>
                            )}
                          </div>
                        </div>
                      </div>

                      <div className="flex items-center gap-2 shrink-0">
                        {hasPerm("platform.permissions.manage") && (
                          <Button
                            variant="outline"
                            size="sm"
                            onClick={() => router.push(`/platform/users/${pUser.id}`)}
                            className="rounded-xl text-xs font-bold gap-1.5 h-8 cursor-pointer hover:border-[var(--accent-primary)]/50"
                          >
                            <KeyRound className="h-3.5 w-3.5 text-[var(--accent-primary)]" />
                            <span>Configure Permissions</span>
                          </Button>
                        )}

                        {!isSelf && hasPerm("platform.permissions.manage") && (
                          <Button
                            variant="ghost"
                            size="icon"
                            onClick={() => handleRevokePlatformUser(pUser.id, pUser.username)}
                            className="h-8 w-8 text-muted-foreground hover:text-red-400 hover:bg-red-500/10 rounded-xl cursor-pointer"
                            title="Revoke all platform access"
                          >
                            <Trash2 className="h-4 w-4" />
                          </Button>
                        )}
                      </div>
                    </div>
                  );
                })}
              </div>
            </div>
          </div>
        )}

        {/* ========================================================================= */}
        {/* TAB 4: Curriculum Review & Interactive XP Calibrator                     */}
        {/* ========================================================================= */}
        {activeTab === "curriculum" && (
          <div className="space-y-6">
            <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
              {/* Module Review List */}
              <div className="space-y-3">
                <h3 className="font-bold text-sm text-foreground">Pending Review Submissions</h3>
                {unverifiedModules.length === 0 ? (
                  <div className="p-8 text-center border border-dashed border-border rounded-2xl bg-card/20 space-y-2">
                    <CheckCircle className="h-8 w-8 mx-auto text-emerald-400" />
                    <p className="text-xs font-bold text-foreground">Review Queue Empty</p>
                    <p className="text-[11px] text-muted-foreground">All submitted modules have been verified or resolved.</p>
                  </div>
                ) : (
                  unverifiedModules.map((mod) => (
                    <div
                      key={mod.id}
                      onClick={() => handleSelectModule(mod.id)}
                      className={`p-4 rounded-2xl border transition-all cursor-pointer ${
                        selectedModule?.id === mod.id
                          ? "border-[var(--accent-primary)] bg-[var(--accent-primary)]/[0.03]"
                          : "border-border bg-card hover:border-[var(--accent-primary)]/40"
                      }`}
                    >
                      <div className="flex items-start justify-between gap-2">
                        <h4 className="font-bold text-xs text-foreground">{mod.title}</h4>
                        <span className="text-[10px] font-mono uppercase px-2 py-0.5 rounded-full bg-amber-500/10 text-amber-400 font-bold">
                          {mod.status || "submitted"}
                        </span>
                      </div>
                      <p className="text-[11px] text-muted-foreground line-clamp-2 mt-1">
                        {mod.description || "No description provided."}
                      </p>
                      <div className="flex items-center gap-2 mt-2 text-[10px] font-mono text-muted-foreground">
                        <span>{mod.total_sections} sections</span>
                        <span>•</span>
                        <span>{mod.total_xp} XP</span>
                      </div>
                    </div>
                  ))
                )}
              </div>

              {/* Detail & Interactive XP Calibrator */}
              <div className="lg:col-span-2">
                {loadingDetail ? (
                  <div className="h-64 flex items-center justify-center border border-border rounded-2xl bg-card">
                    <LoadingSpinner />
                  </div>
                ) : selectedModule ? (
                  <div className="p-6 rounded-2xl border border-border bg-card space-y-6">
                    <div className="flex items-start justify-between gap-4">
                      <div>
                        <h3 className="font-bold text-lg text-foreground">{selectedModule.title}</h3>
                        <p className="text-xs text-muted-foreground mt-1">{selectedModule.description}</p>
                      </div>
                      <div className="flex items-center gap-2">
                        {hasPerm("platform.modules.reject") && (
                          <Button
                            variant="outline"
                            size="sm"
                            onClick={() => handleReject(selectedModule.id, selectedModule.title)}
                            className="rounded-xl text-xs font-bold text-red-400 border-red-500/20 hover:bg-red-500/10 cursor-pointer"
                          >
                            Reject
                          </Button>
                        )}
                        {hasPerm("platform.modules.verify") && (
                          <Button
                            size="sm"
                            onClick={() => handleApprove(selectedModule.id, selectedModule.title)}
                            className="rounded-xl bg-emerald-500 hover:bg-emerald-600 text-black font-bold text-xs cursor-pointer"
                          >
                            Verify & Publish
                          </Button>
                        )}
                      </div>
                    </div>

                    <div className="space-y-4">
                      <div className="flex items-center justify-between">
                        <h4 className="font-bold text-xs uppercase tracking-wider text-muted-foreground">
                          Calibrate Section & Lab XP Weights:
                        </h4>
                        <span className="text-xs font-mono font-bold text-[var(--accent-primary)]">
                          Total Calibrated:{" "}
                          {selectedModule.sections.reduce(
                            (acc: number, sec: any) =>
                              acc +
                              (xpState[sec.id] ?? sec.xp ?? 10) +
                              (sec.labs?.reduce((lacc: number, l: any) => lacc + (xpState[l.id] ?? l.xp ?? 30), 0) ?? 0),
                            0
                          )}{" "}
                          XP
                        </span>
                      </div>

                      {selectedModule.sections.map((sec: any) => (
                        <div key={sec.id} className="p-4 rounded-xl bg-muted/20 border border-border/60 space-y-3 text-xs">
                          <div className="flex items-center justify-between gap-3">
                            <div>
                              <span className="font-bold text-foreground">{sec.title}</span>
                              <p className="text-[10px] text-muted-foreground font-mono">Section Completion Reward</p>
                            </div>
                            <div className="flex items-center gap-2">
                              <NumberStepper
                                value={xpState[sec.id] ?? sec.xp ?? 10}
                                min={0}
                                max={500}
                                step={5}
                                unit="XP"
                                disabled={!hasPerm("platform.modules.calibrate_xp")}
                                onChange={(val) => setXpState((prev) => ({ ...prev, [sec.id]: val }))}
                              />
                            </div>
                          </div>

                          {sec.labs?.map((lab: any) => (
                            <div key={lab.id} className="pl-4 border-l-2 border-border/80 flex items-center justify-between gap-3 py-1 text-muted-foreground text-[11px]">
                              <div>
                                <span className="font-medium text-foreground">🧪 {lab.title}</span>
                                <span className="text-[10px] font-mono text-zinc-400 block">{lab.id}</span>
                              </div>
                              <div className="flex items-center gap-2">
                                <NumberStepper
                                  value={xpState[lab.id] ?? lab.xp ?? 30}
                                  min={0}
                                  max={1000}
                                  step={10}
                                  unit="XP"
                                  disabled={!hasPerm("platform.modules.calibrate_xp")}
                                  onChange={(val) => setXpState((prev) => ({ ...prev, [lab.id]: val }))}
                                />
                              </div>
                            </div>
                          ))}
                        </div>
                      ))}
                    </div>
                  </div>
                ) : (
                  <div className="h-64 flex flex-col items-center justify-center border border-dashed border-border rounded-2xl bg-card/20 space-y-2 text-center p-6">
                    <BookOpen className="h-8 w-8 text-muted-foreground" />
                    <p className="text-xs font-bold text-foreground">Select a Module to Review</p>
                    <p className="text-[11px] text-muted-foreground max-w-xs">
                      Inspect validator scripts, test commands, and calibrate official XP reward weights.
                    </p>
                  </div>
                )}
              </div>
            </div>
          </div>
        )}

        {/* ========================================================================= */}
        {/* TAB 5: Security & Platform-Wide Audit Logs                                */}
        {/* ========================================================================= */}
        {activeTab === "audit" && (
          <div className="space-y-6">
            <div className="flex items-center justify-between gap-4 flex-wrap">
              <div className="flex items-center gap-3">
                <div className="relative w-64">
                  <Search className="absolute left-3 top-2.5 h-4 w-4 text-muted-foreground" />
                  <Input
                    placeholder="Search audit events..."
                    value={auditSearch}
                    onChange={(e) => setAuditSearch(e.target.value)}
                    className="pl-9 h-9 text-xs rounded-xl"
                  />
                </div>
                <Button size="sm" variant="outline" onClick={loadAuditLogs} className="h-9 rounded-xl text-xs font-bold">
                  Filter
                </Button>
              </div>

              <span className="text-xs font-mono text-muted-foreground">{auditLogs.length} events logged</span>
            </div>

            <Card className="rounded-2xl border-border bg-card overflow-hidden">
              <div className="overflow-x-auto">
                <table className="w-full text-xs text-left">
                  <thead className="bg-muted/30 text-muted-foreground font-mono uppercase text-[10px]">
                    <tr>
                      <th className="p-3">Timestamp</th>
                      <th className="p-3">Actor</th>
                      <th className="p-3">Action</th>
                      <th className="p-3">Target Entity</th>
                      <th className="p-3">Metadata</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-border">
                    {auditLogs.length === 0 ? (
                      <tr>
                        <td colSpan={5} className="p-8 text-center text-muted-foreground text-xs font-mono">
                          No audit events recorded matching current filters.
                        </td>
                      </tr>
                    ) : (
                      auditLogs.map((log) => (
                        <tr key={log.id} className="hover:bg-muted/10 transition-colors">
                          <td className="p-3 font-mono text-[11px] text-muted-foreground">
                            {new Date(log.created_at).toLocaleString()}
                          </td>
                          <td className="p-3 font-semibold text-foreground">{log.actor_username}</td>
                          <td className="p-3 font-mono text-[11px] text-[var(--accent-primary)] font-bold">
                            {log.action}
                          </td>
                          <td className="p-3 font-mono text-[11px] text-zinc-300">
                            {log.entity_type} {log.entity_id ? `(${log.entity_id})` : ""}
                          </td>
                          <td className="p-3 font-mono text-[10px] text-muted-foreground truncate max-w-xs">
                            {JSON.stringify(log.metadata)}
                          </td>
                        </tr>
                      ))
                    )}
                  </tbody>
                </table>
              </div>
            </Card>
          </div>
        )}
      </div>

      {/* ========================================================================= */}
      {/* MODAL 1: Tenant Platform Configuration Modal ("Manage Org")               */}
      {/* ========================================================================= */}
      {selectedOrgForSettings && (
        <div className="fixed inset-0 z-50 bg-black/70 backdrop-blur-sm flex items-center justify-center p-4">
          <Card className="max-w-2xl w-full max-h-[85vh] flex flex-col rounded-3xl shadow-2xl border-border bg-card overflow-hidden">
            <CardHeader className="pb-3 border-b border-border flex flex-row items-center justify-between shrink-0">
              <div>
                <div className="flex items-center gap-2">
                  <CardTitle className="text-base font-bold">
                    Platform Settings: {selectedOrgForSettings.name}
                  </CardTitle>
                  <span className="text-[10px] font-mono uppercase px-2 py-0.5 rounded-full bg-muted font-bold text-muted-foreground">
                    {selectedOrgForSettings.slug}
                  </span>
                </div>
                <CardDescription className="text-xs mt-1">
                  Configure feature availability and platform default/override values for this organization.
                </CardDescription>
              </div>
              <Button
                variant="ghost"
                size="icon"
                onClick={() => setSelectedOrgForSettings(null)}
                className="h-8 w-8 rounded-xl text-muted-foreground hover:text-foreground cursor-pointer"
              >
                <X className="h-4 w-4" />
              </Button>
            </CardHeader>

            <CardContent className="p-6 overflow-y-auto space-y-4 flex-1">
              {settingsSaveMsg && (
                <div className="p-3 rounded-xl bg-emerald-500/10 border border-emerald-500/20 text-emerald-400 text-xs flex items-center gap-2">
                  <CheckCircle2 className="h-4 w-4 shrink-0" />
                  <span>{settingsSaveMsg}</span>
                </div>
              )}

              {loadingSettings ? (
                <div className="h-48 flex items-center justify-center">
                  <LoadingSpinner />
                </div>
              ) : (
                <div className="divide-y divide-border">
                  {orgSettingsList.map((st) => {
                    const isBool = st.data_type === "boolean";
                    const isInt = st.data_type === "integer";
                    const val = editingValues[st.key];

                    return (
                      <div key={st.key} className="py-4 space-y-2 first:pt-0 last:pb-0">
                        <div className="flex items-start justify-between gap-4">
                          <div className="space-y-1">
                            <div className="flex items-center gap-2">
                              <span className="font-bold text-xs text-foreground">{st.key}</span>
                              <span className="text-[9px] font-mono uppercase px-1.5 py-0.5 rounded bg-muted text-muted-foreground font-bold">
                                {st.category}
                              </span>
                            </div>
                            <p className="text-[11px] text-muted-foreground leading-relaxed">{st.description}</p>
                            <span className="text-[10px] font-mono text-zinc-400 block">
                              Registry Default: <strong className="text-zinc-200">{String(st.default)}</strong>
                            </span>
                          </div>

                          <div className="flex items-center gap-2 shrink-0">
                            <span className={`text-[10px] font-mono font-bold ${
                              st.is_enabled ? "text-emerald-400" : "text-muted-foreground"
                            }`}>
                              {st.is_enabled ? "Enabled" : "Disabled"}
                            </span>
                            <Button
                              size="sm"
                              variant={st.is_enabled ? "outline" : "default"}
                              onClick={() => handleToggleSettingAvailability(st.key, st.is_enabled)}
                              className={`h-7 px-2.5 rounded-xl text-[11px] font-bold cursor-pointer ${
                                !st.is_enabled ? "bg-[var(--accent-primary)] text-black" : ""
                              }`}
                            >
                              {st.is_enabled ? "Disable" : "Enable"}
                            </Button>
                          </div>
                        </div>

                        {/* Value / Override Editor */}
                        <div className="flex items-center justify-between gap-4 pt-1 bg-muted/20 p-2.5 rounded-xl border border-border/40">
                          <span className="text-[11px] font-semibold text-zinc-300">Default / Override Value:</span>
                          <div className="flex items-center gap-2">
                            {isBool ? (
                              <Select
                                value={val === true ? "true" : "false"}
                                onValueChange={(newVal) => setEditingValues((prev) => ({ ...prev, [st.key]: newVal === "true" }))}
                              >
                                <SelectTrigger className="h-7 w-24 text-[11px]">
                                  <SelectValue />
                                </SelectTrigger>
                                <SelectContent>
                                  <SelectItem value="true">True</SelectItem>
                                  <SelectItem value="false">False</SelectItem>
                                </SelectContent>
                              </Select>
                            ) : isInt ? (
                              <NumberStepper
                                value={typeof val === "number" ? val : parseInt(val || "0", 10)}
                                min={1}
                                max={500}
                                step={1}
                                onChange={(newVal) => setEditingValues((prev) => ({ ...prev, [st.key]: newVal }))}
                              />
                            ) : (
                              <Input
                                value={val ?? ""}
                                onChange={(e) => setEditingValues((prev) => ({ ...prev, [st.key]: e.target.value }))}
                                className="h-7 w-40 text-[11px] rounded-lg"
                              />
                            )}

                            <Button
                              size="sm"
                              onClick={() => handleSaveSettingValue(st.key)}
                              className="h-7 px-3 rounded-lg bg-[var(--accent-primary)] text-black font-bold text-[11px] cursor-pointer"
                            >
                              Save
                            </Button>
                          </div>
                        </div>
                      </div>
                    );
                  })}
                </div>
              )}
            </CardContent>
          </Card>
        </div>
      )}

      {/* ========================================================================= */}
      {/* MODAL 2: Permissions Configuration Modal (Granular RBAC)                  */}
      {/* ========================================================================= */}
      {selectedUserForPerms && (
        <div className="fixed inset-0 z-50 bg-black/70 backdrop-blur-sm flex items-center justify-center p-4">
          <Card className="max-w-xl w-full max-h-[85vh] flex flex-col rounded-3xl shadow-2xl border-border bg-card overflow-hidden">
            <CardHeader className="pb-3 border-b border-border flex flex-row items-center justify-between shrink-0">
              <div>
                <div className="flex items-center gap-2">
                  <CardTitle className="text-base font-bold">
                    Configure Permissions: {selectedUserForPerms.username}
                  </CardTitle>
                </div>
                <CardDescription className="text-xs mt-1">
                  Toggle granular platform permissions. Enabled permissions take effect immediately.
                </CardDescription>
              </div>
              <Button
                variant="ghost"
                size="icon"
                onClick={() => setSelectedUserForPerms(null)}
                className="h-8 w-8 rounded-xl text-muted-foreground hover:text-foreground cursor-pointer"
              >
                <X className="h-4 w-4" />
              </Button>
            </CardHeader>

            <CardContent className="p-6 overflow-y-auto space-y-3 flex-1">
              <div className="p-3 rounded-xl bg-purple-500/10 border border-purple-500/20 text-purple-300 text-xs flex items-center justify-between">
                <div>
                  <span className="font-bold block">Delegation Switch</span>
                  <span className="text-[10px] text-purple-400/80">
                    Granting <code>platform.permissions.manage</code> permits this user to configure permissions for others.
                  </span>
                </div>
              </div>

              <div className="space-y-2">
                {availablePermissions.map((perm) => {
                  const isChecked = userPermsDraft.includes(perm.key);
                  const isDelegationPerm = perm.key === "platform.permissions.manage";

                  return (
                    <div
                      key={perm.key}
                      onClick={() => handleToggleDraftPerm(perm.key)}
                      className={`p-3 rounded-xl border transition-all cursor-pointer flex items-center justify-between gap-3 ${
                        isChecked
                          ? isDelegationPerm
                            ? "bg-purple-500/10 border-purple-500/40"
                            : "bg-[var(--accent-primary)]/[0.05] border-[var(--accent-primary)]/40"
                          : "border-border bg-muted/10 hover:border-border/80"
                      }`}
                    >
                      <div>
                        <div className="flex items-center gap-2">
                          <span className="font-bold text-xs text-foreground font-mono">{perm.key}</span>
                          {isDelegationPerm && (
                            <span className="text-[9px] font-mono px-1.5 py-0.5 rounded bg-purple-500/20 text-purple-300 font-bold uppercase">
                              Key Authority
                            </span>
                          )}
                        </div>
                        <p className="text-[11px] text-muted-foreground mt-0.5 leading-relaxed">
                          {perm.description}
                        </p>
                      </div>

                      <div className={`h-5 w-5 rounded-md flex items-center justify-center shrink-0 border transition-all ${
                        isChecked
                          ? "bg-[var(--accent-primary)] border-[var(--accent-primary)] text-black"
                          : "border-border bg-card"
                      }`}>
                        {isChecked && <Check className="h-3.5 w-3.5 stroke-[3]" />}
                      </div>
                    </div>
                  );
                })}
              </div>
            </CardContent>

            <div className="p-4 border-t border-border bg-muted/20 flex items-center justify-between shrink-0">
              <span className="text-xs font-mono text-muted-foreground">
                {userPermsDraft.length} permissions active
              </span>
              <div className="flex items-center gap-2">
                <Button
                  variant="outline"
                  size="sm"
                  onClick={() => setSelectedUserForPerms(null)}
                  className="rounded-xl text-xs font-bold"
                >
                  Cancel
                </Button>
                <Button
                  size="sm"
                  onClick={handleSaveUserPermissions}
                  disabled={savingPerms}
                  className="rounded-xl bg-[var(--accent-primary)] text-black font-bold text-xs cursor-pointer"
                >
                  {savingPerms ? "Saving..." : "Save Permissions"}
                </Button>
              </div>
            </div>
          </Card>
        </div>
      )}

      {/* ========================================================================= */}
      {/* MODAL 3: Add Platform User Modal                                          */}
      {/* ========================================================================= */}
      {showAddUserModal && (
        <div className="fixed inset-0 z-50 bg-black/70 backdrop-blur-sm flex items-center justify-center p-4">
          <Card className="max-w-md w-full rounded-2xl shadow-2xl border-border bg-card">
            <CardHeader className="pb-3">
              <CardTitle className="text-base font-bold">Grant Platform Operator Access</CardTitle>
              <CardDescription className="text-xs">
                Enter an existing user's username or email to grant them platform privileges.
              </CardDescription>
            </CardHeader>
            <form onSubmit={handleAddPlatformUserSubmit}>
              <CardContent className="space-y-3">
                <Input
                  placeholder="Enter username or email..."
                  value={newUserIdentity}
                  onChange={(e) => setNewUserIdentity(e.target.value)}
                  className="h-9 text-xs rounded-xl"
                  required
                />
              </CardContent>
              <div className="p-4 border-t border-border flex items-center justify-end gap-2">
                <Button
                  type="button"
                  variant="outline"
                  size="sm"
                  onClick={() => setShowAddUserModal(false)}
                  className="rounded-xl text-xs font-bold"
                >
                  Cancel
                </Button>
                <Button
                  type="submit"
                  size="sm"
                  className="rounded-xl bg-[var(--accent-primary)] text-black font-bold text-xs"
                >
                  Add Operator
                </Button>
              </div>
            </form>
          </Card>
        </div>
      )}

      {/* ========================================================================= */}
      {/* MODAL 4: Provision Organization Modal                                     */}
      {/* ========================================================================= */}
      {showCreateOrgModal && (
        <div className="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4">
          <Card className="max-w-md w-full rounded-2xl shadow-2xl border-border bg-card">
            <CardHeader className="pb-3">
              <CardTitle className="text-base font-bold">Provision New Organization</CardTitle>
              <CardDescription className="text-xs">
                Create a tenant workspace for an educational institution or enterprise.
              </CardDescription>
            </CardHeader>
            <form onSubmit={handleCreateOrg}>
              <CardContent className="space-y-3.5">
                {createOrgError && (
                  <div className="p-2.5 rounded-xl bg-red-500/10 border border-red-500/20 text-red-400 text-xs flex items-center gap-2">
                    <AlertCircle className="h-4 w-4 shrink-0" />
                    <span>{createOrgError}</span>
                  </div>
                )}

                <div className="space-y-1">
                  <label className="text-xs font-semibold text-foreground">Organization Name</label>
                  <Input
                    placeholder="e.g. Stanford University"
                    value={newOrgName}
                    onChange={(e) => {
                      setNewOrgName(e.target.value);
                      if (!newOrgSlug) {
                        setNewOrgSlug(e.target.value.toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/(^-|-$)/g, ""));
                      }
                    }}
                    className="h-9 text-xs rounded-xl"
                  />
                </div>

                <div className="space-y-1">
                  <label className="text-xs font-semibold text-foreground">Workspace Slug</label>
                  <Input
                    placeholder="e.g. stanford"
                    value={newOrgSlug}
                    onChange={(e) => setNewOrgSlug(e.target.value)}
                    className="h-9 text-xs font-mono rounded-xl"
                  />
                </div>

                <div className="space-y-1">
                  <label className="text-xs font-semibold text-foreground">Organization Type</label>
                  <Select value={newOrgType} onValueChange={(val) => setNewOrgType(val)}>
                    <SelectTrigger className="w-full h-9 text-xs">
                      <SelectValue placeholder="Select type" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="company">Enterprise / Company</SelectItem>
                      <SelectItem value="university">Higher Education Institution</SelectItem>
                      <SelectItem value="other">Non-profit / Community</SelectItem>
                    </SelectContent>
                  </Select>
                </div>

                <div className="space-y-1">
                  <label className="text-xs font-semibold text-foreground">Verified Email Domains</label>
                  <Input
                    placeholder="e.g. stanford.edu, cs.stanford.edu"
                    value={newOrgDomain}
                    onChange={(e) => setNewOrgDomain(e.target.value)}
                    className="h-9 text-xs font-mono rounded-xl"
                  />
                  <p className="text-[10px] text-muted-foreground">Comma-separated domain list for automatic onboarding eligibility.</p>
                </div>
              </CardContent>

              <div className="p-4 border-t border-border flex items-center justify-end gap-2">
                <Button
                  type="button"
                  variant="outline"
                  size="sm"
                  onClick={() => setShowCreateOrgModal(false)}
                  className="rounded-xl text-xs font-bold"
                >
                  Cancel
                </Button>
                <Button
                  type="submit"
                  size="sm"
                  disabled={createOrgLoading}
                  className="rounded-xl bg-[var(--accent-primary)] text-black font-bold text-xs"
                >
                  {createOrgLoading ? "Provisioning..." : "Provision Workspace"}
                </Button>
              </div>
            </form>
          </Card>
        </div>
      )}

      {/* Confirmation Modal */}
      <ConfirmModal
        isOpen={modalConfig.isOpen}
        title={modalConfig.title}
        message={modalConfig.message}
        confirmText={modalConfig.confirmText}
        type={modalConfig.type}
        onConfirm={modalConfig.onConfirm}
        onCancel={modalConfig.onCancel}
      />
    </div>
  );
}
