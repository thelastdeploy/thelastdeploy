// web/frontend/app/platform/page.tsx

"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { useAuth } from "@/lib/auth";
import { api } from "@/lib/api";
import { LoadingSpinner } from "@/components/shared/loading-spinner";
import { 
  Building2, Users, Award, ShieldAlert, Shield, CheckCircle, 
  ExternalLink, Plus, Trash2, Clock, Globe, GraduationCap, 
  Search, AlertCircle, CheckCircle2, ChevronRight, BookOpen, 
  Terminal, Sparkles, KeyRound, BarChart3, Download, TrendingUp, RefreshCw
} from "lucide-react";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { ConfirmModal } from "@/components/builder/confirm-modal";
import {
  Module,
  ModuleDetail,
  OrganizationMembershipInfo,
  PlatformOverviewAnalyticsResponse,
  PlatformTrendsAnalyticsResponse,
  PlatformOrgSummaryItem,
} from "@/lib/types";

export default function PlatformConsolePage() {
  const { user, loading: authLoading } = useAuth();
  const router = useRouter();

  // Active tab state
  const [activeTab, setActiveTab] = useState<"organizations" | "analytics" | "staff" | "curriculum">("organizations");

  // Loading & error states
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // Organizations state
  const [orgs, setOrgs] = useState<OrganizationMembershipInfo[]>([]);
  const [orgSearch, setOrgSearch] = useState("");
  const [showCreateOrgModal, setShowCreateOrgModal] = useState(false);
  const [newOrgName, setNewOrgName] = useState("");
  const [newOrgSlug, setNewOrgSlug] = useState("");
  const [newOrgType, setNewOrgType] = useState("company");
  const [newOrgDomain, setNewOrgDomain] = useState("");
  const [createOrgLoading, setCreateOrgLoading] = useState(false);
  const [createOrgError, setCreateOrgError] = useState<string | null>(null);

  // Staff state
  const [maintainers, setMaintainers] = useState<{ id: number; username: string; email: string }[]>([]);
  const [newMaintainerIdentity, setNewMaintainerIdentity] = useState("");
  const [loadingStaff, setLoadingStaff] = useState(false);

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
    user && (user.is_admin || user.is_maintainer || (user.platform_roles && user.platform_roles.length > 0))
  );

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

    loadInitialData();
  }, [user, authLoading, isPlatformStaff]);

  useEffect(() => {
    if (activeTab === "analytics") {
      loadPlatformAnalytics();
    }
  }, [activeTab]);

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

  const loadInitialData = async () => {
    setLoading(true);
    try {
      const [orgsData, modulesRes] = await Promise.all([
        api.getOrganizations().catch(() => []),
        api.getModules().catch(() => ({ modules: [] })),
      ]);
      setOrgs(orgsData);
      const unverified = (modulesRes.modules || []).filter((m: any) => m.status !== "verified");
      setUnverifiedModules(unverified);

      if (user?.is_admin) {
        const staffList = await api.adminGetMaintainers().catch(() => []);
        setMaintainers(staffList);
      }
    } catch (err: any) {
      setError(err.message || "Failed to load platform data");
    } finally {
      setLoading(false);
    }
  };

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

  const handleAddStaff = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!newMaintainerIdentity.trim()) return;
    try {
      await api.adminAddMaintainer(newMaintainerIdentity.trim());
      setNewMaintainerIdentity("");
      const list = await api.adminGetMaintainers();
      setMaintainers(list);
    } catch (err: any) {
      alert("Error adding staff: " + err.message);
    }
  };

  const handleRemoveStaff = async (userId: number, username: string) => {
    setModalConfig({
      isOpen: true,
      title: "Remove Platform Staff",
      message: `Are you sure you want to remove '${username}' from platform staff? They will lose access to global operations.`,
      confirmText: "Remove Staff",
      type: "danger",
      onCancel: () => setModalConfig((prev) => ({ ...prev, isOpen: false })),
      onConfirm: async () => {
        setModalConfig((prev) => ({ ...prev, isOpen: false }));
        try {
          await api.adminRemoveMaintainer(userId);
          const list = await api.adminGetMaintainers();
          setMaintainers(list);
        } catch (err: any) {
          alert("Error removing staff: " + err.message);
        }
      },
    });
  };

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
      message: `Approve and officially verify "${title}"? This makes it part of official TLD verified curriculum.`,
      confirmText: "Verify & Publish",
      type: "success",
      onCancel: () => setModalConfig((prev) => ({ ...prev, isOpen: false })),
      onConfirm: async () => {
        setModalConfig((prev) => ({ ...prev, isOpen: false }));
        try {
          await api.verifyModule(id, xpState);
          setSelectedModule(null);
          const res = await api.getModules();
          setUnverifiedModules((res.modules || []).filter((m: any) => m.status !== "verified"));
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
        const res = await api.getModules();
        setUnverifiedModules((res.modules || []).filter((m: any) => m.status !== "verified"));
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

  if (!isPlatformStaff) {
    return (
      <div className="min-h-[calc(100vh-64px)] flex items-center justify-center px-4">
        <div className="max-w-md w-full text-center space-y-4 p-8 rounded-3xl border border-border bg-card shadow-xl">
          <div className="h-16 w-16 mx-auto rounded-2xl bg-destructive/10 text-destructive flex items-center justify-center">
            <ShieldAlert className="h-8 w-8" />
          </div>
          <h2 className="text-xl font-black text-foreground">Access Restricted</h2>
          <p className="text-xs text-muted-foreground leading-relaxed">
            The Platform Console is restricted to authorized platform operations staff. 
            If you need tenant workspace access, visit your assigned workspace.
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
        <div className="max-w-6xl mx-auto px-4 py-10">
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
                Global governance for The Last Deploy: manage tenant organizations, platform staff roles, and curriculum verification.
              </p>
            </div>

            <div className="flex items-center gap-2">
              <Button
                variant={activeTab === "organizations" ? "default" : "outline"}
                size="sm"
                onClick={() => setActiveTab("organizations")}
                className={`rounded-xl text-xs font-bold gap-1.5 cursor-pointer ${
                  activeTab === "organizations" ? "bg-[var(--accent-primary)] text-black" : ""
                }`}
              >
                <Building2 className="h-3.5 w-3.5" />
                <span>Organizations ({orgs.length})</span>
              </Button>
              <Button
                variant={activeTab === "analytics" ? "default" : "outline"}
                size="sm"
                onClick={() => setActiveTab("analytics")}
                className={`rounded-xl text-xs font-bold gap-1.5 cursor-pointer ${
                  activeTab === "analytics" ? "bg-[var(--accent-primary)] text-black" : ""
                }`}
              >
                <BarChart3 className="h-3.5 w-3.5" />
                <span>Global Analytics</span>
              </Button>
              <Button
                variant={activeTab === "staff" ? "default" : "outline"}
                size="sm"
                onClick={() => setActiveTab("staff")}
                className={`rounded-xl text-xs font-bold gap-1.5 cursor-pointer ${
                  activeTab === "staff" ? "bg-[var(--accent-primary)] text-black" : ""
                }`}
              >
                <Shield className="h-3.5 w-3.5" />
                <span>Platform Staff ({maintainers.length})</span>
              </Button>
              <Button
                variant={activeTab === "curriculum" ? "default" : "outline"}
                size="sm"
                onClick={() => setActiveTab("curriculum")}
                className={`rounded-xl text-xs font-bold gap-1.5 cursor-pointer ${
                  activeTab === "curriculum" ? "bg-[var(--accent-primary)] text-black" : ""
                }`}
              >
                <Award className="h-3.5 w-3.5" />
                <span>Curriculum Review ({unverifiedModules.length})</span>
              </Button>
            </div>
          </div>
        </div>
      </div>

      {/* Main Content Area */}
      <div className="max-w-6xl mx-auto px-4 py-8">
        {/* ========================================================================= */}
        {/* TAB: Global Analytics & Platform Intelligence                             */}
        {/* ========================================================================= */}
        {activeTab === "analytics" && (
          <div className="space-y-6">
            {/* Controls Bar */}
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
            </div>

            {/* Top Metrics Grid */}
            <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
              <Card className="rounded-2xl border-border bg-card">
                <CardContent className="p-5">
                  <span className="text-xs text-muted-foreground font-semibold uppercase tracking-wider">Total Users</span>
                  <p className="text-3xl font-black font-mono text-foreground mt-2">
                    {platformOverview?.total_users ?? "—"}
                  </p>
                  <p className="text-[11px] text-muted-foreground mt-1">
                    {platformOverview?.total_memberships ?? 0} total memberships
                  </p>
                </CardContent>
              </Card>

              <Card className="rounded-2xl border-border bg-card">
                <CardContent className="p-5">
                  <span className="text-xs text-muted-foreground font-semibold uppercase tracking-wider">Organizations</span>
                  <p className="text-3xl font-black font-mono text-[var(--accent-primary)] mt-2">
                    {platformOverview?.total_organizations ?? "—"}
                  </p>
                  <p className="text-[11px] text-muted-foreground mt-1">
                    {platformOverview?.total_cohorts ?? 0} active cohorts
                  </p>
                </CardContent>
              </Card>

              <Card className="rounded-2xl border-border bg-card">
                <CardContent className="p-5">
                  <span className="text-xs text-muted-foreground font-semibold uppercase tracking-wider">Curriculum Catalog</span>
                  <p className="text-3xl font-black font-mono text-foreground mt-2">
                    {platformOverview?.total_modules ?? "—"}
                  </p>
                  <p className="text-[11px] text-muted-foreground mt-1">
                    <span className="text-emerald-500 font-bold">{platformOverview?.total_verified_modules ?? 0} verified</span> • {platformOverview?.total_unverified_modules ?? 0} custom
                  </p>
                </CardContent>
              </Card>

              <Card className="rounded-2xl border-border bg-card">
                <CardContent className="p-5">
                  <span className="text-xs text-muted-foreground font-semibold uppercase tracking-wider">Global Platform XP</span>
                  <p className="text-3xl font-black font-mono text-emerald-500 mt-2">
                    {platformOverview?.total_verified_xp ?? "—"}
                  </p>
                  <p className="text-[11px] text-muted-foreground mt-1">
                    {platformOverview?.total_lab_completions ?? 0} labs validated
                  </p>
                </CardContent>
              </Card>
            </div>

            {/* Platform Activity Trends */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <Card className="rounded-2xl border-border bg-card">
                <CardHeader className="pb-3">
                  <CardTitle className="text-base font-bold">Registration & Growth Trends</CardTitle>
                  <CardDescription className="text-xs">New user registrations ({platformPeriod})</CardDescription>
                </CardHeader>
                <CardContent>
                  {platformTrends && platformTrends.user_registrations.filter((p) => p.count > 0).length > 0 ? (
                    <div className="space-y-2 max-h-56 overflow-y-auto pr-1">
                      {platformTrends.user_registrations
                        .filter((p) => p.count > 0)
                        .slice(-10)
                        .reverse()
                        .map((pt) => (
                          <div key={pt.date} className="flex items-center justify-between py-1.5 border-b border-border/40 text-xs">
                            <span className="font-mono text-muted-foreground">{pt.date}</span>
                            <span className="font-bold font-mono text-foreground">+{pt.count} user{pt.count > 1 ? "s" : ""}</span>
                          </div>
                        ))}
                    </div>
                  ) : (
                    <p className="py-6 text-center text-xs text-muted-foreground">No registrations in selected period.</p>
                  )}
                </CardContent>
              </Card>

              <Card className="rounded-2xl border-border bg-card">
                <CardHeader className="pb-3">
                  <CardTitle className="text-base font-bold">Platform Lab Validations</CardTitle>
                  <CardDescription className="text-xs">Successful completions across all tenants ({platformPeriod})</CardDescription>
                </CardHeader>
                <CardContent>
                  {platformTrends && platformTrends.lab_completions.filter((p) => p.count > 0).length > 0 ? (
                    <div className="space-y-2 max-h-56 overflow-y-auto pr-1">
                      {platformTrends.lab_completions
                        .filter((p) => p.count > 0)
                        .slice(-10)
                        .reverse()
                        .map((pt) => (
                          <div key={pt.date} className="flex items-center justify-between py-1.5 border-b border-border/40 text-xs">
                            <span className="font-mono text-muted-foreground">{pt.date}</span>
                            <span className="font-bold font-mono text-[var(--accent-primary)]">{pt.count} validation{pt.count > 1 ? "s" : ""}</span>
                          </div>
                        ))}
                    </div>
                  ) : (
                    <p className="py-6 text-center text-xs text-muted-foreground">No completions recorded in selected period.</p>
                  )}
                </CardContent>
              </Card>
            </div>

            {/* Organizations Performance Table */}
            <Card className="rounded-2xl border-border bg-card overflow-hidden">
              <CardHeader className="pb-3">
                <CardTitle className="text-base font-bold">Tenants Summary</CardTitle>
                <CardDescription className="text-xs">Adoption, completions, and authoritative XP across organizations</CardDescription>
              </CardHeader>
              <div className="overflow-x-auto">
                <table className="w-full text-xs text-left">
                  <thead className="bg-muted/40 text-muted-foreground uppercase font-mono text-[10px] border-b border-border">
                    <tr>
                      <th className="px-4 py-3">Organization</th>
                      <th className="px-4 py-3">Slug</th>
                      <th className="px-4 py-3">Type</th>
                      <th className="px-4 py-3">Members</th>
                      <th className="px-4 py-3">Cohorts</th>
                      <th className="px-4 py-3">Labs Done</th>
                      <th className="px-4 py-3">Verified XP</th>
                      <th className="px-4 py-3">Created</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-border/60">
                    {platformOrgsSummary.length > 0 ? (
                      platformOrgsSummary.map((po) => (
                        <tr key={po.organization_id} className="hover:bg-muted/20 transition-colors">
                          <td className="px-4 py-3 font-bold text-foreground">{po.name}</td>
                          <td className="px-4 py-3 font-mono text-muted-foreground">{po.slug}</td>
                          <td className="px-4 py-3 capitalize">{po.type}</td>
                          <td className="px-4 py-3 font-mono font-bold">{po.member_count}</td>
                          <td className="px-4 py-3 font-mono">{po.cohort_count}</td>
                          <td className="px-4 py-3 font-mono text-[var(--accent-primary)] font-bold">{po.lab_completions_count}</td>
                          <td className="px-4 py-3 font-mono text-emerald-500 font-bold">{po.total_verified_xp} XP</td>
                          <td className="px-4 py-3 text-muted-foreground">
                            {new Date(po.created_at).toLocaleDateString()}
                          </td>
                        </tr>
                      ))
                    ) : (
                      <tr>
                        <td colSpan={8} className="px-4 py-8 text-center text-muted-foreground">
                          No organizations found.
                        </td>
                      </tr>
                    )}
                  </tbody>
                </table>
              </div>
            </Card>
          </div>
        )}

        {/* ========================================================================= */}
        {/* TAB 1: Organizations Directory & Provisioning                             */}
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

              <Button
                size="sm"
                onClick={() => setShowCreateOrgModal(true)}
                className="rounded-xl bg-[var(--accent-primary)] text-black hover:opacity-90 font-bold text-xs gap-1.5 cursor-pointer"
              >
                <Plus className="h-3.5 w-3.5" />
                <span>Provision Organization</span>
              </Button>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
              {filteredOrgs.map((org) => {
                const isPlatform = org.type === "platform" || org.is_platform;
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

                      <div className="space-y-1 text-xs text-muted-foreground">
                        <div className="flex items-center justify-between">
                          <span>Status:</span>
                          <span className="text-emerald-400 font-mono font-semibold flex items-center gap-1 text-[11px]">
                            <span className="h-1.5 w-1.5 rounded-full bg-emerald-400" />
                            Active
                          </span>
                        </div>
                        <div className="flex items-center justify-between">
                          <span>Assigned Roles:</span>
                          <span className="font-mono text-zinc-300 text-[11px]">
                            {org.roles && org.roles.length > 0 ? org.roles.join(", ") : "Member"}
                          </span>
                        </div>
                      </div>
                    </div>

                    <div className="pt-3 border-t border-border flex items-center justify-between">
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

                      <Button
                        variant="ghost"
                        size="sm"
                        asChild
                        className="rounded-xl text-[11px] font-bold text-[var(--accent-primary)] hover:bg-[var(--accent-primary)]/10 h-7 cursor-pointer gap-1"
                      >
                        <Link href={`/org/${org.slug}`}>
                          <span>Manage Org</span>
                          <ExternalLink className="h-3 w-3" />
                        </Link>
                      </Button>
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        )}

        {/* ========================================================================= */}
        {/* TAB 2: Platform Staff Management                                          */}
        {/* ========================================================================= */}
        {activeTab === "staff" && (
          <div className="space-y-6">
            <Card className="rounded-2xl border-border bg-card shadow-sm">
              <CardHeader className="pb-3">
                <CardTitle className="text-base font-bold">Assign Platform Staff Member</CardTitle>
                <CardDescription className="text-xs">
                  Grant root superadmin or maintainer capabilities across the platform.
                </CardDescription>
              </CardHeader>
              <CardContent>
                <form onSubmit={handleAddStaff} className="flex gap-2 max-w-md">
                  <Input
                    placeholder="Enter username or email..."
                    value={newMaintainerIdentity}
                    onChange={(e) => setNewMaintainerIdentity(e.target.value)}
                    className="h-9 text-xs rounded-xl"
                  />
                  <Button
                    type="submit"
                    size="sm"
                    className="rounded-xl bg-[var(--accent-primary)] text-black hover:opacity-90 font-bold text-xs shrink-0 cursor-pointer"
                  >
                    Add Staff
                  </Button>
                </form>
              </CardContent>
            </Card>

            <div className="rounded-2xl border border-border overflow-hidden bg-card shadow-sm">
              <div className="p-4 border-b border-border bg-muted/20">
                <h3 className="font-bold text-sm text-foreground">Current Platform Operations Staff</h3>
              </div>
              <div className="divide-y divide-border">
                {maintainers.map((staff) => (
                  <div key={staff.id} className="p-4 flex items-center justify-between hover:bg-muted/10 transition-colors">
                    <div className="flex items-center gap-3">
                      <div className="h-9 w-9 rounded-xl bg-purple-500/10 text-purple-400 flex items-center justify-center font-bold">
                        <Shield className="h-4 w-4" />
                      </div>
                      <div>
                        <h4 className="font-bold text-xs text-foreground">{staff.username}</h4>
                        <p className="text-[11px] text-muted-foreground font-mono">{staff.email}</p>
                      </div>
                    </div>

                    <div className="flex items-center gap-3">
                      <span className="text-[10px] font-mono px-2 py-0.5 rounded-full bg-purple-500/10 text-purple-400 font-bold">
                        Platform Staff
                      </span>
                      {staff.username !== user?.username && (
                        <Button
                          variant="ghost"
                          size="icon"
                          onClick={() => handleRemoveStaff(staff.id, staff.username)}
                          className="h-8 w-8 text-muted-foreground hover:text-red-400 hover:bg-red-500/10 rounded-xl"
                        >
                          <Trash2 className="h-4 w-4" />
                        </Button>
                      )}
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>
        )}

        {/* ========================================================================= */}
        {/* TAB 3: Curriculum Review & Official Verification Gate                     */}
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

              {/* Detail & Calibrator */}
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
                        <Button
                          variant="outline"
                          size="sm"
                          onClick={() => handleReject(selectedModule.id, selectedModule.title)}
                          className="rounded-xl text-xs font-bold text-red-400 border-red-500/20 hover:bg-red-500/10 cursor-pointer"
                        >
                          Reject
                        </Button>
                        <Button
                          size="sm"
                          onClick={() => handleApprove(selectedModule.id, selectedModule.title)}
                          className="rounded-xl bg-emerald-500 hover:bg-emerald-600 text-black font-bold text-xs cursor-pointer"
                        >
                          Verify & Publish
                        </Button>
                      </div>
                    </div>

                    <div className="space-y-3">
                      <h4 className="font-bold text-xs uppercase tracking-wider text-muted-foreground">
                        Calibrate Module Sections & Labs XP:
                      </h4>
                      {selectedModule.sections.map((sec: any) => (
                        <div key={sec.id} className="p-3 rounded-xl bg-muted/30 border border-border/50 space-y-2 text-xs">
                          <div className="flex items-center justify-between">
                            <span className="font-semibold text-foreground">{sec.title}</span>
                            <span className="font-mono text-[11px] text-[var(--accent-primary)] font-bold">
                              {xpState[sec.id] || 10} XP
                            </span>
                          </div>
                          {sec.labs?.map((lab: any) => (
                            <div key={lab.id} className="pl-3 border-l-2 border-border/60 flex items-center justify-between text-muted-foreground text-[11px]">
                              <span>🧪 {lab.title}</span>
                              <span className="font-mono text-zinc-300 font-bold">{xpState[lab.id] || 30} XP</span>
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
                      Inspect validator scripts, test commands, and assign official XP reward weights.
                    </p>
                  </div>
                )}
              </div>
            </div>
          </div>
        )}
      </div>

      {/* Provision Organization Modal */}
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
                      <SelectItem value="university">University / Higher Ed</SelectItem>
                      <SelectItem value="open_source">Open Source Community</SelectItem>
                      <SelectItem value="other">Other</SelectItem>
                    </SelectContent>
                  </Select>
                </div>

                <div className="space-y-1">
                  <label className="text-xs font-semibold text-foreground">Verified Email Domains (Comma-separated)</label>
                  <Input
                    placeholder="e.g. stanford.edu, cs.stanford.edu"
                    value={newOrgDomain}
                    onChange={(e) => setNewOrgDomain(e.target.value)}
                    className="h-9 text-xs font-mono rounded-xl"
                  />
                </div>
              </CardContent>

              <div className="p-4 pt-0 flex justify-end gap-2">
                <Button
                  type="button"
                  variant="outline"
                  onClick={() => setShowCreateOrgModal(false)}
                  className="rounded-xl text-xs"
                >
                  Cancel
                </Button>
                <Button
                  type="submit"
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

      {/* Confirm Modal */}
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

