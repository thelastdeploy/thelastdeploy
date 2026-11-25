// web/frontend/app/org/[slug]/page.tsx

"use client";

import { useEffect, useState } from "react";
import { useRouter, useParams } from "next/navigation";
import { useAuth } from "@/lib/auth";
import { api } from "@/lib/api";
import {
  OrganizationResponse,
  OrganizationMemberResponse,
  CohortResponse,
  CohortMemberResponse,
  LearningPathResponse,
  InvitationResponse,
  InvitationStatsResponse,
  AccessRequestResponse,
  OrgSettingItemResponse,
  AuditLogResponse,
  ModuleDetail,
  Module,
  AnalyticsOverviewResponse,
  AnalyticsTrendsResponse,
  CohortAnalyticsItem,
  ContentAnalyticsResponse,
  XpAnalyticsResponse,
  LearnerDetailAnalyticsResponse,
} from "@/lib/types";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { NumberStepper } from "@/components/ui/number-stepper";
import {
  Building2,
  GraduationCap,
  Users,
  Mail,
  UserPlus,
  ShieldCheck,
  XCircle,
  AlertCircle,
  Settings,
  FileText,
  Upload,
  Trash2,
  Search,
  Plus,
  BookOpen,
  RefreshCw,
  BarChart3,
  Download,
  TrendingUp,
  Award,
  Eye,
  Layers,
  ExternalLink,
} from "lucide-react";
import Link from "next/link";

export default function OrgAdminPage() {
  const router = useRouter();
  const params = useParams();
  const orgSlug = (params?.slug as string) || "";
  const { user, loading: authLoading, refreshUser } = useAuth();

  const [org, setOrg] = useState<OrganizationResponse | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // Tab navigation
  type TabKey = "overview" | "analytics" | "members" | "invitations" | "requests" | "cohorts" | "paths" | "curriculum" | "settings" | "audit";
  const [activeTab, setActiveTab] = useState<TabKey>("overview");

  // Tab Data States
  const [members, setMembers] = useState<OrganizationMemberResponse[]>([]);
  const [invitations, setInvitations] = useState<InvitationResponse[]>([]);
  const [invitationStats, setInvitationStats] = useState<InvitationStatsResponse | null>(null);
  const [accessRequests, setAccessRequests] = useState<AccessRequestResponse[]>([]);
  const [cohorts, setCohorts] = useState<CohortResponse[]>([]);
  const [learningPaths, setLearningPaths] = useState<LearningPathResponse[]>([]);
  const [curriculumModules, setCurriculumModules] = useState<Module[]>([]);
  const [curriculumLoading, setCurriculumLoading] = useState(false);
  const [availableTLDModules, setAvailableTLDModules] = useState<Module[]>([]);
  const [showAdoptModal, setShowAdoptModal] = useState(false);
  const [adoptLoading, setAdoptLoading] = useState(false);
  const [adoptSearch, setAdoptSearch] = useState("");
  const [selectedAdoptModule, setSelectedAdoptModule] = useState<Module | null>(null);
  const [customAdoptId, setCustomAdoptId] = useState("");
  const [customAdoptTitle, setCustomAdoptTitle] = useState("");
  const [adoptError, setAdoptError] = useState<string | null>(null);
  const [settingsList, setSettingsList] = useState<OrgSettingItemResponse[]>([]);
  const [auditLogs, setAuditLogs] = useState<AuditLogResponse[]>([]);
  const [availableModules, setAvailableModules] = useState<ModuleDetail[]>([]);

  // Analytics Data States
  const [analyticsOverview, setAnalyticsOverview] = useState<AnalyticsOverviewResponse | null>(null);
  const [analyticsTrends, setAnalyticsTrends] = useState<AnalyticsTrendsResponse | null>(null);
  const [analyticsCohorts, setAnalyticsCohorts] = useState<CohortAnalyticsItem[]>([]);
  const [analyticsContent, setAnalyticsContent] = useState<ContentAnalyticsResponse | null>(null);
  const [analyticsXp, setAnalyticsXp] = useState<XpAnalyticsResponse | null>(null);
  const [analyticsPeriod, setAnalyticsPeriod] = useState<string>("30d");
  const [analyticsLoading, setAnalyticsLoading] = useState(false);
  const [exportLoading, setExportLoading] = useState<string | null>(null);

  // Learner Detail Modal State
  const [selectedLearnerUserId, setSelectedLearnerUserId] = useState<number | null>(null);
  const [selectedLearnerDetail, setSelectedLearnerDetail] = useState<LearnerDetailAnalyticsResponse | null>(null);
  const [learnerDetailLoading, setLearnerDetailLoading] = useState(false);

  // Search & Filters
  const [memberSearch, setMemberSearch] = useState("");
  const [memberRoleFilter, setMemberRoleFilter] = useState("all");

  // Modals & Action States
  const [showInviteModal, setShowInviteModal] = useState(false);
  const [inviteEmail, setInviteEmail] = useState("");
  const [inviteRole, setInviteRole] = useState("learner");
  const [inviteCohortId, setInviteCohortId] = useState<number | null>(null);
  const [inviteLoading, setInviteLoading] = useState(false);

  const [showBulkModal, setShowBulkModal] = useState(false);
  const [bulkFile, setBulkFile] = useState<File | null>(null);
  const [bulkLoading, setBulkLoading] = useState(false);
  const [bulkResult, setBulkResult] = useState<any | null>(null);

  const [showCohortModal, setShowCohortModal] = useState(false);
  const [cohortName, setCohortName] = useState("");
  const [cohortDesc, setCohortDesc] = useState("");
  const [cohortStartsAt, setCohortStartsAt] = useState("");
  const [cohortEndsAt, setCohortEndsAt] = useState("");
  const [cohortLoading, setCohortLoading] = useState(false);

  const [selectedCohortForRoster, setSelectedCohortForRoster] = useState<CohortResponse | null>(null);
  const [cohortRoster, setCohortRoster] = useState<CohortMemberResponse[]>([]);
  const [rosterLoading, setRosterLoading] = useState(false);

  const [showPathModal, setShowPathModal] = useState(false);
  const [pathName, setPathName] = useState("");
  const [pathSlug, setPathSlug] = useState("");
  const [pathDesc, setPathDesc] = useState("");
  const [pathSelectedModules, setPathSelectedModules] = useState<string[]>([]);
  const [pathLoading, setPathLoading] = useState(false);

  const [roleChangeUser, setRoleChangeUser] = useState<OrganizationMemberResponse | null>(null);
  const [newRole, setNewRole] = useState("learner");
  const [roleChangeLoading, setRoleChangeLoading] = useState(false);

  const [rejectReqId, setRejectReqId] = useState<number | null>(null);
  const [rejectReason, setRejectReason] = useState("");

  const [settingUpdating, setSettingUpdating] = useState<string | null>(null);

  useEffect(() => {
    refreshUser();
  }, []);

  useEffect(() => {
    if (authLoading) return;
    if (!user) {
      router.push("/login");
      return;
    }
    loadOrgData();
  }, [authLoading, user?.id, user?.platform_permissions, orgSlug]);

  useEffect(() => {
    if (!org) return;
    if (activeTab === "analytics") loadAnalytics();
    if (activeTab === "members") loadMembers();
    if (activeTab === "invitations") loadInvitations();
    if (activeTab === "requests") loadAccessRequests();
    if (activeTab === "cohorts") loadCohorts();
    if (activeTab === "paths") loadLearningPaths();
    if (activeTab === "curriculum") loadCurriculum();
    if (activeTab === "settings") loadSettings();
    if (activeTab === "audit") loadAuditLogs();
  }, [activeTab, org?.id]);

  const loadOrgData = async () => {
    if (!orgSlug) return;
    if (!org) setLoading(true);
    setError(null);
    try {
      const orgData = await api.getOrganization(orgSlug);

      const canManageWorkspace = Boolean(
        user?.can_manage_workspaces ||
        user?.platform_permissions?.includes("platform.organizations.manage") ||
        orgData.roles?.some((r: string) => ["owner", "admin", "platform_admin"].includes(r))
      );

      if (!canManageWorkspace) {
        setError(`Access Restricted: Managing workspace '${orgSlug}' requires organization administrator or owner privileges, or the 'platform.organizations.manage' platform permission.`);
        setLoading(false);
        return;
      }

      setOrg(orgData);

      // Pre-load overview stats passing orgSlug explicitly without mutating global workspace session
      const [membersData, cohortsData, invStats, currData] = await Promise.all([
        api.getOrganizationMembers(orgSlug).catch(() => []),
        api.getCohorts(orgSlug).catch(() => []),
        api.getInvitationStats(orgSlug).catch(() => null),
        api.getOrgCurriculum(orgSlug).catch(() => []),
      ]);
      setMembers(membersData);
      setCohorts(cohortsData);
      setInvitationStats(invStats);
      setCurriculumModules(currData);
    } catch (err: any) {
      setError(err.message || "Failed to load organization.");
    } finally {
      setLoading(false);
    }
  };

  const loadCurriculum = async () => {
    if (!orgSlug) return;
    try {
      setCurriculumLoading(true);
      const data = await api.getOrgCurriculum(orgSlug);
      setCurriculumModules(data);
    } catch (err: any) {
      console.error("Failed to load curriculum:", err);
    } finally {
      setCurriculumLoading(false);
    }
  };

  const loadAvailableTLD = async () => {
    if (!orgSlug) return;
    try {
      const data = await api.getAvailableTLDModules(orgSlug);
      setAvailableTLDModules(data);
    } catch (err: any) {
      console.error("Failed to load available TLD modules:", err);
    }
  };

  const handleAdoptModule = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!orgSlug || !selectedAdoptModule) return;
    setAdoptLoading(true);
    setAdoptError(null);
    try {
      await api.adoptTLDModule(orgSlug, {
        tld_module_id: selectedAdoptModule.id,
        custom_id: customAdoptId.trim() || undefined,
        custom_title: customAdoptTitle.trim() || undefined,
      });
      setShowAdoptModal(false);
      setSelectedAdoptModule(null);
      setCustomAdoptId("");
      setCustomAdoptTitle("");
      await loadCurriculum();
    } catch (err: any) {
      setAdoptError(err.message || "Failed to adopt module");
    } finally {
      setAdoptLoading(false);
    }
  };

  const handleRemoveModule = async (moduleId: string) => {
    if (!orgSlug) return;
    if (!confirm(`Are you sure you want to remove '${moduleId}' from this organization's workspace?`)) return;
    try {
      await api.removeOrgModule(orgSlug, moduleId);
      await loadCurriculum();
    } catch (err: any) {
      alert(err.message || "Failed to remove module");
    }
  };

  const loadMembers = async () => {
    if (!orgSlug) return;
    try {
      const res = await api.getOrganizationMembers(orgSlug);
      setMembers(res);
    } catch (err) {
      console.error(err);
    }
  };

  const loadInvitations = async () => {
    if (!orgSlug) return;
    try {
      const [invs, stats] = await Promise.all([
        api.getInvitations(orgSlug),
        api.getInvitationStats(orgSlug),
      ]);
      setInvitations(invs);
      setInvitationStats(stats);
    } catch (err) {
      console.error(err);
    }
  };

  const loadAccessRequests = async () => {
    if (!orgSlug) return;
    try {
      const reqs = await api.getAccessRequests(orgSlug);
      setAccessRequests(reqs);
    } catch (err) {
      console.error(err);
    }
  };

  const loadCohorts = async () => {
    try {
      const list = await api.getCohorts(orgSlug);
      setCohorts(list);
    } catch (err) {
      console.error(err);
    }
  };

  const loadLearningPaths = async () => {
    try {
      const [paths, modulesRes] = await Promise.all([
        api.getLearningPaths(orgSlug),
        api.getAllModulesFull(true).catch(() => []),
      ]);
      setLearningPaths(paths);
      setAvailableModules(modulesRes);
    } catch (err) {
      console.error(err);
    }
  };

  const loadSettings = async () => {
    try {
      const s = await api.getOrgSettings(orgSlug);
      setSettingsList(s);
    } catch (err) {
      console.error(err);
    }
  };

  const loadAuditLogs = async () => {
    try {
      const logs = await api.getOrgAuditLogs(orgSlug);
      setAuditLogs(logs);
    } catch (err) {
      console.error(err);
    }
  };

  const loadAnalytics = async (period: string = analyticsPeriod) => {
    setAnalyticsLoading(true);
    try {
      const [ov, tr, coh, con, xp] = await Promise.all([
        api.getOrgAnalyticsOverview(orgSlug).catch(() => null),
        api.getOrgAnalyticsTrends(orgSlug, period).catch(() => null),
        api.getOrgAnalyticsCohorts(orgSlug).catch(() => []),
        api.getOrgAnalyticsContent(orgSlug).catch(() => null),
        api.getOrgAnalyticsXp(orgSlug).catch(() => null),
      ]);
      setAnalyticsOverview(ov);
      setAnalyticsTrends(tr);
      setAnalyticsCohorts(coh);
      setAnalyticsContent(con);
      setAnalyticsXp(xp);
    } catch (err) {
      console.error(err);
    } finally {
      setAnalyticsLoading(false);
    }
  };

  const handleExport = async (type: "learners" | "activity" | "cohorts" | "content") => {
    setExportLoading(type);
    try {
      const blob = await api.exportOrgAnalyticsBlob(orgSlug, type);
      const url = window.URL.createObjectURL(blob);
      const a = document.createElement("a");
      a.href = url;
      a.download = `${type}_${orgSlug}.csv`;
      document.body.appendChild(a);
      a.click();
      window.URL.revokeObjectURL(url);
      document.body.removeChild(a);
    } catch (err: any) {
      alert(`Export failed: ${err.message || "Export disabled or unauthorized"}`);
    } finally {
      setExportLoading(null);
    }
  };

  const handleInspectLearner = async (userId: number) => {
    setSelectedLearnerUserId(userId);
    setLearnerDetailLoading(true);
    try {
      const detail = await api.getOrgAnalyticsLearnerDetail(orgSlug, userId);
      setSelectedLearnerDetail(detail);
    } catch (err: any) {
      alert("Failed to load learner progress: " + err.message);
      setSelectedLearnerUserId(null);
    } finally {
      setLearnerDetailLoading(false);
    }
  };

  // Actions
  const handleSingleInvite = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!inviteEmail.trim()) return;
    setInviteLoading(true);
    try {
      await api.createInvitation({
        email: inviteEmail.trim(),
        role: inviteRole,
        cohort_id: inviteCohortId,
      }, orgSlug);
      setShowInviteModal(false);
      setInviteEmail("");
      loadInvitations();
    } catch (err: any) {
      alert("Failed to send invitation: " + err.message);
    } finally {
      setInviteLoading(false);
    }
  };

  const handleBulkUpload = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!bulkFile) return;
    setBulkLoading(true);
    try {
      const res = await api.uploadBulkInvitations(bulkFile, inviteCohortId, orgSlug);
      setBulkResult(res);
      loadInvitations();
    } catch (err: any) {
      alert("Bulk upload failed: " + err.message);
    } finally {
      setBulkLoading(false);
    }
  };

  const handleRevokeInvite = async (id: number) => {
    if (!confirm("Are you sure you want to revoke this invitation?")) return;
    try {
      await api.revokeInvitation(id, orgSlug);
      loadInvitations();
    } catch (err: any) {
      alert("Failed to revoke: " + err.message);
    }
  };

  const handleApproveRequest = async (id: number) => {
    try {
      await api.approveAccessRequest(id, orgSlug);
      loadAccessRequests();
    } catch (err: any) {
      alert("Failed to approve request: " + err.message);
    }
  };

  const handleRejectRequest = async () => {
    if (!rejectReqId) return;
    try {
      await api.rejectAccessRequest(rejectReqId, rejectReason.trim() || undefined, orgSlug);
      setRejectReqId(null);
      setRejectReason("");
      loadAccessRequests();
    } catch (err: any) {
      alert("Failed to reject request: " + err.message);
    }
  };

  const handleCreateCohort = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!cohortName.trim() || !cohortStartsAt || !cohortEndsAt) return;
    setCohortLoading(true);
    try {
      await api.createCohort(orgSlug, {
        name: cohortName.trim(),
        description: cohortDesc.trim() || undefined,
        starts_at: new Date(cohortStartsAt).toISOString(),
        ends_at: new Date(cohortEndsAt).toISOString(),
      });
      setShowCohortModal(false);
      setCohortName("");
      setCohortDesc("");
      setCohortStartsAt("");
      setCohortEndsAt("");
      loadCohorts();
    } catch (err: any) {
      alert("Failed to create cohort: " + err.message);
    } finally {
      setCohortLoading(false);
    }
  };

  const handleViewCohortRoster = async (cohort: CohortResponse) => {
    setSelectedCohortForRoster(cohort);
    setRosterLoading(true);
    try {
      const roster = await api.getCohortMembers(orgSlug, cohort.id);
      setCohortRoster(roster);
    } catch (err) {
      console.error(err);
    } finally {
      setRosterLoading(false);
    }
  };

  const handleCreatePath = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!pathName.trim() || !pathSlug.trim()) return;
    setPathLoading(true);
    try {
      await api.createLearningPath(orgSlug, {
        name: pathName.trim(),
        slug: pathSlug.trim().toLowerCase(),
        description: pathDesc.trim() || undefined,
        modules: pathSelectedModules,
      });
      setShowPathModal(false);
      setPathName("");
      setPathSlug("");
      setPathDesc("");
      setPathSelectedModules([]);
      loadLearningPaths();
    } catch (err: any) {
      alert("Failed to create learning path: " + err.message);
    } finally {
      setPathLoading(false);
    }
  };

  const handleRoleChangeSubmit = async () => {
    if (!roleChangeUser) return;
    setRoleChangeLoading(true);
    try {
      await api.updateMemberRole(orgSlug, roleChangeUser.user_id, newRole);
      setRoleChangeUser(null);
      loadMembers();
    } catch (err: any) {
      alert("Failed to update role: " + err.message);
    } finally {
      setRoleChangeLoading(false);
    }
  };

  const handleRemoveMember = async (userId: number, username: string) => {
    if (!confirm(`Are you sure you want to remove ${username} from ${org?.name}?`)) return;
    try {
      await api.removeMember(orgSlug, userId);
      loadMembers();
    } catch (err: any) {
      alert("Failed to remove member: " + err.message);
    }
  };

  const handleUpdateSetting = async (key: string, val: any) => {
    setSettingUpdating(key);
    try {
      await api.updateOrgSetting(orgSlug, key, val);
      loadSettings();
    } catch (err: any) {
      alert("Failed to update setting: " + err.message);
    } finally {
      setSettingUpdating(null);
    }
  };

  if (authLoading || (loading && !org)) {
    return (
      <div className="min-h-[calc(100vh-64px)] flex items-center justify-center">
        <div className="text-muted-foreground animate-pulse text-sm font-mono">
          Loading organization workspace...
        </div>
      </div>
    );
  }

  if (error || !org) {
    return (
      <div className="min-h-[calc(100vh-64px)] flex items-center justify-center p-4">
        <div className="max-w-md w-full text-center space-y-4 p-8 rounded-3xl border border-border bg-card shadow-xl">
          <div className="h-16 w-16 mx-auto rounded-2xl bg-destructive/10 text-destructive flex items-center justify-center">
            <ShieldCheck className="h-8 w-8 text-destructive" />
          </div>
          <h2 className="text-xl font-black text-foreground">Access Restricted</h2>
          <p className="text-xs text-muted-foreground leading-relaxed">
            {error || "Organization not found or you lack workspace management authority."}
          </p>
          <Button asChild className="rounded-xl text-xs font-bold w-full" style={{ backgroundColor: "var(--accent-primary)", color: "black" }}>
            <Link href="/dashboard">Return to Dashboard</Link>
          </Button>
        </div>
      </div>
    );
  }

  const isUniversity = org.type === "university";
  const isDelegatedPlatformAdmin = Boolean(
    (user?.platform_permissions?.includes("platform.organizations.manage") || user?.can_manage_workspaces) &&
    org.roles?.includes("platform_admin")
  );
  const filteredMembers = members.filter((m) => {
    const matchesSearch =
      m.username.toLowerCase().includes(memberSearch.toLowerCase()) ||
      m.email.toLowerCase().includes(memberSearch.toLowerCase());
    const matchesRole =
      memberRoleFilter === "all" || m.roles.includes(memberRoleFilter.toLowerCase());
    return matchesSearch && matchesRole;
  });

  return (
    <div className="max-w-7xl mx-auto px-4 py-8">
      {/* Top Banner */}
      <div className="rounded-2xl border border-border bg-card p-6 mb-8 flex flex-col md:flex-row items-start md:items-center justify-between gap-6 shadow-sm">
        <div className="flex items-center gap-4">
          <div className="h-14 w-14 rounded-2xl bg-[var(--accent-primary)]/10 text-[var(--accent-primary)] flex items-center justify-center font-black">
            {isUniversity ? <GraduationCap className="h-8 w-8" /> : <Building2 className="h-8 w-8" />}
          </div>
          <div>
            <div className="flex items-center gap-2.5">
              <h1 className="text-2xl font-black text-foreground">{org.name}</h1>
              <span className="text-[10px] uppercase font-mono px-2 py-0.5 rounded-full bg-[var(--accent-primary)]/10 text-[var(--accent-primary)] font-bold">
                {org.type}
              </span>
              {isDelegatedPlatformAdmin && (
                <span className="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-[10px] font-mono font-bold bg-amber-500/10 text-amber-400 border border-amber-500/20">
                  <ShieldCheck className="h-3 w-3" />
                  <span>Platform Delegated</span>
                </span>
              )}
            </div>
            <p className="text-xs text-muted-foreground font-mono mt-1">
              Subdomain: <span className="text-foreground">{org.slug}.org.thelastdeploy.com</span>
              {org.domains && org.domains.length > 0 && !org.domains.includes("*") && (
                <> • Domains: <span className="text-[var(--accent-primary)]">{org.domains.join(", ")}</span></>
              )}
            </p>
          </div>
        </div>

        <div className="flex items-center gap-2.5">
          <Button
            size="sm"
            onClick={() => setShowInviteModal(true)}
            className="rounded-xl bg-[var(--accent-primary)] text-black hover:opacity-90 font-bold text-xs h-9 cursor-pointer gap-1.5 shadow-sm"
          >
            <UserPlus className="h-4 w-4" />
            <span>Invite Member</span>
          </Button>
          <Button
            size="sm"
            variant="outline"
            onClick={() => setShowBulkModal(true)}
            className="rounded-xl font-bold text-xs h-9 cursor-pointer gap-1.5"
          >
            <Upload className="h-4 w-4" />
            <span>Bulk CSV</span>
          </Button>
        </div>
      </div>

      {/* Navigation Tabs */}
      <div className="flex items-center gap-1.5 border-b border-border mb-8 overflow-x-auto pb-1 scrollbar-none">
        {[
          { key: "overview", label: "Overview", icon: Building2 },
          { key: "analytics", label: "Analytics", icon: BarChart3 },
          { key: "members", label: "Members", count: members.length, icon: Users },
          { key: "invitations", label: "Invitations", count: invitationStats?.pending, icon: Mail },
          { key: "requests", label: "Access Requests", count: accessRequests.filter((r) => r.status === "pending").length, icon: ShieldCheck },
          { key: "cohorts", label: "Cohorts", count: cohorts.length, icon: GraduationCap },
          { key: "paths", label: "Learning Paths", count: learningPaths.length, icon: BookOpen },
          { key: "curriculum", label: "Curriculum", count: curriculumModules.length, icon: Layers },
          { key: "settings", label: "Settings", icon: Settings },
          { key: "audit", label: "Audit Logs", icon: FileText },
        ].map((tab) => {
          const Icon = tab.icon;
          const isActive = activeTab === tab.key;
          return (
            <button
              key={tab.key}
              onClick={() => setActiveTab(tab.key as TabKey)}
              className={`flex items-center gap-2 px-4 py-2.5 rounded-xl text-xs font-bold transition-all whitespace-nowrap cursor-pointer border ${
                isActive
                  ? "bg-[rgba(var(--accent-primary-rgb),0.08)] text-[var(--accent-primary)] border-[rgba(var(--accent-primary-rgb),0.2)] shadow-sm"
                  : "text-muted-foreground hover:text-foreground hover:bg-muted/40 border-transparent"
              }`}
            >
              <Icon className="h-3.5 w-3.5" />
              <span>{tab.label}</span>
              {tab.count !== undefined && tab.count > 0 && (
                <span className={`text-[10px] font-mono px-1.5 py-0.2 rounded-full font-bold ${
                  isActive ? "bg-[var(--accent-primary)] text-black" : "bg-muted text-muted-foreground"
                }`}>
                  {tab.count}
                </span>
              )}
            </button>
          );
        })}
      </div>

      {/* TAB CONTENT */}

      {/* 1. OVERVIEW TAB */}
      {activeTab === "overview" && (
        <div className="space-y-6">
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            <Card className="rounded-2xl border-border bg-card">
              <CardContent className="p-5">
                <span className="text-xs text-muted-foreground font-semibold uppercase tracking-wider">Members</span>
                <p className="text-3xl font-black font-mono text-foreground mt-2">{members.length}</p>
              </CardContent>
            </Card>

            <Card className="rounded-2xl border-border bg-card">
              <CardContent className="p-5">
                <span className="text-xs text-muted-foreground font-semibold uppercase tracking-wider">Active Cohorts</span>
                <p className="text-3xl font-black font-mono text-[var(--accent-primary)] mt-2">{cohorts.length}</p>
              </CardContent>
            </Card>

            <Card className="rounded-2xl border-border bg-card">
              <CardContent className="p-5">
                <span className="text-xs text-muted-foreground font-semibold uppercase tracking-wider">Pending Invites</span>
                <p className="text-3xl font-black font-mono text-amber-500 mt-2">{invitationStats?.pending || 0}</p>
              </CardContent>
            </Card>

            <Card className="rounded-2xl border-border bg-card">
              <CardContent className="p-5">
                <span className="text-xs text-muted-foreground font-semibold uppercase tracking-wider">Pending Requests</span>
                <p className="text-3xl font-black font-mono text-blue-500 mt-2">
                  {accessRequests.filter((r) => r.status === "pending").length}
                </p>
              </CardContent>
            </Card>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <Card className="rounded-2xl border-border bg-card">
              <CardHeader>
                <CardTitle className="text-base font-bold">Organization Details</CardTitle>
                <CardDescription className="text-xs">Context and platform identifier</CardDescription>
              </CardHeader>
              <CardContent className="space-y-3 text-xs">
                <div className="flex justify-between py-1.5 border-b border-border/50">
                  <span className="text-muted-foreground">Display Name</span>
                  <span className="font-bold text-foreground">{org.name}</span>
                </div>
                <div className="flex justify-between py-1.5 border-b border-border/50">
                  <span className="text-muted-foreground">Slug</span>
                  <span className="font-mono text-foreground">{org.slug}</span>
                </div>
                <div className="flex justify-between py-1.5 border-b border-border/50">
                  <span className="text-muted-foreground">Type</span>
                  <span className="capitalize text-foreground">{org.type}</span>
                </div>
                <div className="flex justify-between py-1.5 border-b border-border/50">
                  <span className="text-muted-foreground">Joined At</span>
                  <span className="text-foreground">{new Date(org.joined_at).toLocaleDateString()}</span>
                </div>
              </CardContent>
            </Card>

            <Card className="rounded-2xl border-border bg-card">
              <CardHeader>
                <CardTitle className="text-base font-bold">Quick Shortcuts</CardTitle>
                <CardDescription className="text-xs">Frequent administrative actions</CardDescription>
              </CardHeader>
              <CardContent className="space-y-2">
                <Button
                  variant="outline"
                  onClick={() => { setActiveTab("members"); setShowInviteModal(true); }}
                  className="w-full justify-start text-xs font-semibold rounded-xl h-10 gap-2 cursor-pointer"
                >
                  <UserPlus className="h-4 w-4 text-[var(--accent-primary)]" />
                  <span>Send an individual invitation code</span>
                </Button>
                <Button
                  variant="outline"
                  onClick={() => { setActiveTab("cohorts"); setShowCohortModal(true); }}
                  className="w-full justify-start text-xs font-semibold rounded-xl h-10 gap-2 cursor-pointer"
                >
                  <GraduationCap className="h-4 w-4 text-[var(--accent-primary)]" />
                  <span>Create a student cohort</span>
                </Button>
                <Button
                  variant="outline"
                  onClick={() => { setActiveTab("settings"); }}
                  className="w-full justify-start text-xs font-semibold rounded-xl h-10 gap-2 cursor-pointer"
                >
                  <Settings className="h-4 w-4 text-[var(--accent-primary)]" />
                  <span>Configure domain verification & approval mode</span>
                </Button>
              </CardContent>
            </Card>
          </div>
        </div>
      )}

      {/* 2. ANALYTICS & REPORTING TAB */}
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
                  variant={analyticsPeriod === p ? "default" : "outline"}
                  onClick={() => {
                    setAnalyticsPeriod(p);
                    loadAnalytics(p);
                  }}
                  className={`h-8 px-3 rounded-xl text-xs font-bold ${
                    analyticsPeriod === p ? "bg-[var(--accent-primary)] text-black" : ""
                  }`}
                >
                  {p === "all" ? "All Time" : p.toUpperCase()}
                </Button>
              ))}
              <Button
                size="sm"
                variant="ghost"
                onClick={() => loadAnalytics(analyticsPeriod)}
                disabled={analyticsLoading}
                className="h-8 w-8 p-0 rounded-xl ml-1 text-muted-foreground hover:text-foreground cursor-pointer"
                title="Refresh Analytics"
              >
                <RefreshCw className={`h-3.5 w-3.5 ${analyticsLoading ? "animate-spin" : ""}`} />
              </Button>
            </div>

            <div className="flex items-center gap-2 flex-wrap">
              <span className="text-xs font-bold text-muted-foreground uppercase tracking-wider font-mono mr-1">Export:</span>
              {(["learners", "activity", "cohorts", "content"] as const).map((expType) => (
                <Button
                  key={expType}
                  size="sm"
                  variant="outline"
                  onClick={() => handleExport(expType)}
                  disabled={exportLoading === expType}
                  className="h-8 px-2.5 rounded-xl text-xs font-semibold gap-1.5 cursor-pointer"
                >
                  <Download className="h-3.5 w-3.5 text-[var(--accent-primary)]" />
                  <span className="capitalize">{expType}</span>
                </Button>
              ))}
            </div>
          </div>

          {/* Overview KPI Cards */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            <Card className="rounded-2xl border-border bg-card">
              <CardContent className="p-5">
                <span className="text-xs text-muted-foreground font-semibold uppercase tracking-wider">Learners Participation</span>
                <p className="text-3xl font-black font-mono text-foreground mt-2">
                  {analyticsOverview ? `${analyticsOverview.learners_started} / ${analyticsOverview.total_learners}` : "—"}
                </p>
                <p className="text-[11px] text-muted-foreground mt-1">
                  {analyticsOverview && analyticsOverview.total_learners > 0
                    ? `${Math.round((analyticsOverview.learners_started / analyticsOverview.total_learners) * 100)}% active learners`
                    : "0% active"}
                </p>
              </CardContent>
            </Card>

            <Card className="rounded-2xl border-border bg-card">
              <CardContent className="p-5">
                <span className="text-xs text-muted-foreground font-semibold uppercase tracking-wider">Labs Completed</span>
                <p className="text-3xl font-black font-mono text-[var(--accent-primary)] mt-2">
                  {analyticsOverview?.total_completed_labs ?? "—"}
                </p>
                <p className="text-[11px] text-muted-foreground mt-1">
                  {analyticsOverview?.total_completed_sections ?? 0} reading sections finished
                </p>
              </CardContent>
            </Card>

            <Card className="rounded-2xl border-border bg-card">
              <CardContent className="p-5">
                <span className="text-xs text-muted-foreground font-semibold uppercase tracking-wider">Verified XP</span>
                <p className="text-3xl font-black font-mono text-emerald-500 mt-2">
                  {analyticsOverview?.total_verified_xp ?? "—"}
                </p>
                <p className="text-[11px] text-muted-foreground mt-1">
                  Authoritative tenant score
                </p>
              </CardContent>
            </Card>

            <Card className="rounded-2xl border-border bg-card">
              <CardContent className="p-5">
                <span className="text-xs text-muted-foreground font-semibold uppercase tracking-wider">Unverified XP</span>
                <p className="text-3xl font-black font-mono text-amber-500 mt-2">
                  {analyticsOverview?.total_unverified_xp ?? "—"}
                </p>
                <p className="text-[11px] text-muted-foreground mt-1">
                  From custom/pending content
                </p>
              </CardContent>
            </Card>
          </div>

          {/* Activity Trends & XP Breakdown */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            {/* Recent Activity Table / Timeline */}
            <Card className="rounded-2xl border-border bg-card">
              <CardHeader className="pb-3">
                <div className="flex items-center justify-between">
                  <div>
                    <CardTitle className="text-base font-bold">Activity Trends</CardTitle>
                    <CardDescription className="text-xs">Lab completions & XP earned ({analyticsPeriod})</CardDescription>
                  </div>
                  <TrendingUp className="h-4 w-4 text-[var(--accent-primary)]" />
                </div>
              </CardHeader>
              <CardContent>
                {analyticsTrends && analyticsTrends.lab_completions.filter((p) => p.count > 0).length > 0 ? (
                  <div className="space-y-2 max-h-60 overflow-y-auto pr-1">
                    {analyticsTrends.lab_completions
                      .filter((p) => p.count > 0)
                      .slice(-10)
                      .reverse()
                      .map((pt) => {
                        const xpPoint = analyticsTrends.xp_earned.find((x) => x.date === pt.date);
                        return (
                          <div key={pt.date} className="flex items-center justify-between py-2 border-b border-border/40 text-xs">
                            <span className="font-mono text-muted-foreground">{pt.date}</span>
                            <div className="flex items-center gap-3">
                              <span className="font-bold text-foreground">{pt.count} lab{pt.count > 1 ? "s" : ""}</span>
                              {xpPoint && xpPoint.xp > 0 && (
                                <span className="font-mono text-[var(--accent-primary)] font-bold">+{xpPoint.xp} XP</span>
                              )}
                            </div>
                          </div>
                        );
                      })}
                  </div>
                ) : (
                  <div className="py-8 text-center text-xs text-muted-foreground">
                    No completion activity recorded in selected timeframe.
                  </div>
                )}
              </CardContent>
            </Card>

            {/* XP Statistics & Distribution */}
            <Card className="rounded-2xl border-border bg-card">
              <CardHeader className="pb-3">
                <div className="flex items-center justify-between">
                  <div>
                    <CardTitle className="text-base font-bold">XP Distribution</CardTitle>
                    <CardDescription className="text-xs">Summary metrics across organization members</CardDescription>
                  </div>
                  <Award className="h-4 w-4 text-emerald-500" />
                </div>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="grid grid-cols-4 gap-2 text-center">
                  <div className="p-2.5 rounded-xl bg-muted/30">
                    <span className="text-[10px] text-muted-foreground uppercase font-bold">Average</span>
                    <p className="text-sm font-black font-mono mt-1">{analyticsXp?.average_xp ?? 0}</p>
                  </div>
                  <div className="p-2.5 rounded-xl bg-muted/30">
                    <span className="text-[10px] text-muted-foreground uppercase font-bold">Median</span>
                    <p className="text-sm font-black font-mono mt-1">{analyticsXp?.median_xp ?? 0}</p>
                  </div>
                  <div className="p-2.5 rounded-xl bg-muted/30">
                    <span className="text-[10px] text-muted-foreground uppercase font-bold">Min</span>
                    <p className="text-sm font-black font-mono mt-1">{analyticsXp?.min_xp ?? 0}</p>
                  </div>
                  <div className="p-2.5 rounded-xl bg-muted/30">
                    <span className="text-[10px] text-muted-foreground uppercase font-bold">Max</span>
                    <p className="text-sm font-black font-mono mt-1 text-[var(--accent-primary)]">{analyticsXp?.max_xp ?? 0}</p>
                  </div>
                </div>

                {analyticsXp && analyticsXp.distribution.length > 0 && (
                  <div className="space-y-2 pt-2">
                    {analyticsXp.distribution.map((d) => (
                      <div key={d.range_label} className="flex items-center justify-between text-xs py-1 border-b border-border/40">
                        <span className="text-muted-foreground font-mono">{d.range_label}</span>
                        <span className="font-bold font-mono text-foreground">{d.learner_count} learners</span>
                      </div>
                    ))}
                  </div>
                )}
              </CardContent>
            </Card>
          </div>

          {/* Cohort Performance Table */}
          <Card className="rounded-2xl border-border bg-card overflow-hidden">
            <CardHeader className="pb-3">
              <CardTitle className="text-base font-bold">Cohort Performance</CardTitle>
              <CardDescription className="text-xs">Progress and XP generated by cohort cohorts</CardDescription>
            </CardHeader>
            <div className="overflow-x-auto">
              <table className="w-full text-xs text-left">
                <thead className="bg-muted/40 text-muted-foreground uppercase font-mono text-[10px] border-b border-border">
                  <tr>
                    <th className="px-4 py-3">Cohort</th>
                    <th className="px-4 py-3">Status</th>
                    <th className="px-4 py-3">Members</th>
                    <th className="px-4 py-3">Learners Active</th>
                    <th className="px-4 py-3">Completed Labs</th>
                    <th className="px-4 py-3">Verified XP</th>
                    <th className="px-4 py-3">Unverified XP</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-border/60">
                  {analyticsCohorts.length > 0 ? (
                    analyticsCohorts.map((c) => (
                      <tr key={c.cohort_id} className="hover:bg-muted/20 transition-colors">
                        <td className="px-4 py-3 font-bold text-foreground">{c.name}</td>
                        <td className="px-4 py-3">
                          <span className="capitalize font-mono px-2 py-0.5 rounded-full text-[10px] bg-muted font-bold">
                            {c.status}
                          </span>
                        </td>
                        <td className="px-4 py-3 font-mono">{c.member_count}</td>
                        <td className="px-4 py-3 font-mono text-[var(--accent-primary)] font-bold">{c.learners_started}</td>
                        <td className="px-4 py-3 font-mono">{c.completed_labs}</td>
                        <td className="px-4 py-3 font-mono text-emerald-500 font-bold">{c.total_verified_xp} XP</td>
                        <td className="px-4 py-3 font-mono text-amber-500">{c.total_unverified_xp} XP</td>
                      </tr>
                    ))
                  ) : (
                    <tr>
                      <td colSpan={7} className="px-4 py-8 text-center text-muted-foreground">
                        No cohorts configured in this organization.
                      </td>
                    </tr>
                  )}
                </tbody>
              </table>
            </div>
          </Card>

          {/* Content Usage Breakdown */}
          {analyticsContent && (
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <Card className="rounded-2xl border-border bg-card">
                <CardHeader className="pb-3">
                  <CardTitle className="text-base font-bold">Most Completed Modules</CardTitle>
                  <CardDescription className="text-xs">Top modules with recorded lab completions</CardDescription>
                </CardHeader>
                <CardContent>
                  {analyticsContent.most_completed_modules.filter((m) => m.completions_count > 0).length > 0 ? (
                    <div className="space-y-2">
                      {analyticsContent.most_completed_modules
                        .filter((m) => m.completions_count > 0)
                        .slice(0, 5)
                        .map((m) => (
                          <div key={m.id} className="flex items-center justify-between py-2 border-b border-border/40 text-xs">
                            <div>
                              <p className="font-bold text-foreground">{m.title}</p>
                              <span className="text-[10px] font-mono text-muted-foreground">
                                {m.is_tld_owned ? "TLD Core" : "Custom Org"} • {m.distinct_learners_count} learners
                              </span>
                            </div>
                            <span className="font-mono font-bold text-[var(--accent-primary)]">{m.completions_count} finished</span>
                          </div>
                        ))}
                    </div>
                  ) : (
                    <p className="py-6 text-center text-xs text-muted-foreground">No module completions recorded yet.</p>
                  )}
                </CardContent>
              </Card>

              <Card className="rounded-2xl border-border bg-card">
                <CardHeader className="pb-3">
                  <CardTitle className="text-base font-bold">Content Ownership & Verification</CardTitle>
                  <CardDescription className="text-xs">Module catalog breakdown for this organization</CardDescription>
                </CardHeader>
                <CardContent className="space-y-3 text-xs">
                  <div className="flex justify-between py-1.5 border-b border-border/50">
                    <span className="text-muted-foreground">Verified Modules Available</span>
                    <span className="font-bold text-emerald-500 font-mono">{analyticsContent.verified_modules_count}</span>
                  </div>
                  <div className="flex justify-between py-1.5 border-b border-border/50">
                    <span className="text-muted-foreground">Custom / Unverified Modules</span>
                    <span className="font-bold text-amber-500 font-mono">{analyticsContent.unverified_modules_count}</span>
                  </div>
                  <div className="flex justify-between py-1.5 border-b border-border/50">
                    <span className="text-muted-foreground">TLD-Owned Modules</span>
                    <span className="font-bold text-foreground font-mono">{analyticsContent.tld_owned_modules_count}</span>
                  </div>
                  <div className="flex justify-between py-1.5 border-b border-border/50">
                    <span className="text-muted-foreground">Organization-Owned Modules</span>
                    <span className="font-bold text-foreground font-mono">{analyticsContent.org_owned_modules_count}</span>
                  </div>
                  <div className="flex justify-between py-1.5 border-b border-border/50">
                    <span className="text-muted-foreground">Verified Lab Completions</span>
                    <span className="font-bold text-emerald-500 font-mono">{analyticsContent.verified_lab_completions}</span>
                  </div>
                </CardContent>
              </Card>
            </div>
          )}
        </div>
      )}

      {/* 3. MEMBERS TAB */}
      {activeTab === "members" && (
        <div className="space-y-4">
          <div className="flex flex-col sm:flex-row items-center justify-between gap-3">
            <div className="relative w-full sm:w-72">
              <Search className="absolute left-3 top-2.5 h-4 w-4 text-muted-foreground" />
              <Input
                placeholder="Search username or email..."
                value={memberSearch}
                onChange={(e) => setMemberSearch(e.target.value)}
                className="pl-9 h-9 text-xs rounded-xl bg-muted/30"
              />
            </div>
            <div className="flex items-center gap-2 w-full sm:w-auto">
              <Select value={memberRoleFilter} onValueChange={(val) => setMemberRoleFilter(val)}>
                <SelectTrigger className="w-32 h-9 text-xs">
                  <SelectValue placeholder="All Roles" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">All Roles</SelectItem>
                  <SelectItem value="owner">Owner</SelectItem>
                  <SelectItem value="admin">Admin</SelectItem>
                  <SelectItem value="instructor">Instructor</SelectItem>
                  <SelectItem value="learner">Learner</SelectItem>
                </SelectContent>
              </Select>
              <Button
                size="sm"
                onClick={() => setShowInviteModal(true)}
                className="rounded-xl bg-[var(--accent-primary)] text-black hover:opacity-90 font-bold text-xs h-9 cursor-pointer gap-1.5"
              >
                <UserPlus className="h-3.5 w-3.5" />
                <span>Invite</span>
              </Button>
            </div>
          </div>

          <Card className="rounded-2xl border-border bg-card overflow-hidden">
            <div className="overflow-x-auto">
              <table className="w-full text-xs text-left">
                <thead className="bg-muted/40 text-muted-foreground uppercase font-mono text-[10px] border-b border-border">
                  <tr>
                    <th className="px-4 py-3">Member</th>
                    <th className="px-4 py-3">Role</th>
                    <th className="px-4 py-3">Workspace XP</th>
                    <th className="px-4 py-3">Joined Date</th>
                    <th className="px-4 py-3 text-right">Actions</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-border/60">
                  {filteredMembers.map((m) => (
                    <tr key={m.membership_id} className="hover:bg-muted/20 transition-colors">
                      <td className="px-4 py-3">
                        <div className="font-bold text-foreground">{m.username}</div>
                        <div className="text-[11px] text-muted-foreground font-mono">{m.email}</div>
                      </td>
                      <td className="px-4 py-3">
                        <span className="capitalize font-mono px-2 py-0.5 rounded-full text-[10px] bg-muted font-bold">
                          {m.roles && m.roles.length > 0 ? m.roles.join(", ") : "Learner"}
                        </span>
                      </td>
                      <td className="px-4 py-3 font-mono font-bold text-[var(--accent-primary)]">
                        {m.total_xp} XP
                      </td>
                      <td className="px-4 py-3 text-muted-foreground">
                        {new Date(m.joined_at).toLocaleDateString()}
                      </td>
                      <td className="px-4 py-3 text-right">
                        <div className="flex items-center justify-end gap-2">
                          <Button
                            size="sm"
                            variant="ghost"
                            onClick={() => handleInspectLearner(m.user_id)}
                            className="h-7 px-2 text-[11px] font-semibold rounded-lg cursor-pointer text-[var(--accent-primary)] hover:bg-[var(--accent-primary)]/10 gap-1"
                          >
                            <Eye className="h-3 w-3" />
                            <span>Progress</span>
                          </Button>
                          <Button
                            size="sm"
                            variant="ghost"
                            onClick={() => {
                              setRoleChangeUser(m);
                              setNewRole(m.roles[0] || "learner");
                            }}
                            className="h-7 px-2 text-[11px] font-semibold rounded-lg cursor-pointer"
                          >
                            Change Role
                          </Button>
                          <Button
                            size="sm"
                            variant="ghost"
                            onClick={() => handleRemoveMember(m.user_id, m.username)}
                            className="h-7 w-7 p-0 text-destructive hover:bg-destructive/10 rounded-lg cursor-pointer"
                            title="Remove Member"
                          >
                            <Trash2 className="h-3.5 w-3.5" />
                          </Button>
                        </div>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </Card>
        </div>
      )}

      {/* 3. INVITATIONS TAB */}
      {activeTab === "invitations" && (
        <div className="space-y-6">
          {invitationStats && (
            <div className="grid grid-cols-2 sm:grid-cols-4 gap-4">
              <div className="p-4 rounded-2xl border border-border bg-card">
                <span className="text-[11px] text-muted-foreground uppercase font-mono">Total Issued</span>
                <p className="text-2xl font-black font-mono text-foreground mt-1">{invitationStats.total}</p>
              </div>
              <div className="p-4 rounded-2xl border border-border bg-card">
                <span className="text-[11px] text-muted-foreground uppercase font-mono">Pending</span>
                <p className="text-2xl font-black font-mono text-amber-500 mt-1">{invitationStats.pending}</p>
              </div>
              <div className="p-4 rounded-2xl border border-border bg-card">
                <span className="text-[11px] text-muted-foreground uppercase font-mono">Accepted</span>
                <p className="text-2xl font-black font-mono text-emerald-500 mt-1">{invitationStats.accepted}</p>
              </div>
              <div className="p-4 rounded-2xl border border-border bg-card">
                <span className="text-[11px] text-muted-foreground uppercase font-mono">Expired</span>
                <p className="text-2xl font-black font-mono text-zinc-500 mt-1">{invitationStats.expired}</p>
              </div>
            </div>
          )}

          <div className="flex items-center justify-between">
            <h3 className="text-sm font-bold text-foreground">Active & Past Invitations</h3>
            <div className="flex gap-2">
              <Button
                size="sm"
                onClick={() => setShowInviteModal(true)}
                className="rounded-xl bg-[var(--accent-primary)] text-black hover:opacity-90 font-bold text-xs h-8 cursor-pointer gap-1.5"
              >
                <Plus className="h-3.5 w-3.5" />
                <span>New Invite</span>
              </Button>
            </div>
          </div>

          <Card className="rounded-2xl border-border bg-card overflow-hidden">
            <div className="overflow-x-auto">
              <table className="w-full text-xs text-left">
                <thead className="bg-muted/40 text-muted-foreground uppercase font-mono text-[10px] border-b border-border">
                  <tr>
                    <th className="px-4 py-3">Recipient Email</th>
                    <th className="px-4 py-3">Code</th>
                    <th className="px-4 py-3">Role</th>
                    <th className="px-4 py-3">Target Cohort</th>
                    <th className="px-4 py-3">Status</th>
                    <th className="px-4 py-3">Expires</th>
                    <th className="px-4 py-3 text-right">Actions</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-border/60">
                  {invitations.map((inv) => (
                    <tr key={inv.id} className="hover:bg-muted/20 transition-colors">
                      <td className="px-4 py-3 font-mono font-medium text-foreground">{inv.email}</td>
                      <td className="px-4 py-3 font-mono text-[11px] text-muted-foreground">
                        {inv.invitation_code || "—"}
                      </td>
                      <td className="px-4 py-3 capitalize">{inv.role}</td>
                      <td className="px-4 py-3">{inv.cohort_name || "Whole Org"}</td>
                      <td className="px-4 py-3">
                        <span className={`px-2 py-0.5 rounded-full text-[10px] font-mono font-bold uppercase ${
                          inv.status === "accepted" ? "bg-emerald-500/10 text-emerald-400" :
                          inv.status === "pending" ? "bg-amber-500/10 text-amber-400" :
                          inv.status === "revoked" ? "bg-destructive/10 text-destructive" :
                          "bg-muted text-muted-foreground"
                        }`}>
                          {inv.status}
                        </span>
                      </td>
                      <td className="px-4 py-3 text-muted-foreground">
                        {new Date(inv.expires_at).toLocaleDateString()}
                      </td>
                      <td className="px-4 py-3 text-right">
                        {inv.status === "pending" && (
                          <Button
                            size="sm"
                            variant="ghost"
                            onClick={() => handleRevokeInvite(inv.id)}
                            className="h-7 text-xs text-destructive hover:bg-destructive/10 rounded-lg cursor-pointer"
                          >
                            Revoke
                          </Button>
                        )}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </Card>
        </div>
      )}

      {/* 4. ACCESS REQUESTS TAB */}
      {activeTab === "requests" && (
        <div className="space-y-4">
          <div className="flex items-center justify-between">
            <div>
              <h3 className="text-sm font-bold text-foreground">Pending Approval Queue</h3>
              <p className="text-xs text-muted-foreground">Students requesting access using institutional email.</p>
            </div>
          </div>

          <Card className="rounded-2xl border-border bg-card overflow-hidden">
            <div className="overflow-x-auto">
              <table className="w-full text-xs text-left">
                <thead className="bg-muted/40 text-muted-foreground uppercase font-mono text-[10px] border-b border-border">
                  <tr>
                    <th className="px-4 py-3">Applicant Email</th>
                    <th className="px-4 py-3">Requested At</th>
                    <th className="px-4 py-3">Status</th>
                    <th className="px-4 py-3 text-right">Decision</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-border/60">
                  {accessRequests.map((req) => (
                    <tr key={req.id} className="hover:bg-muted/20 transition-colors">
                      <td className="px-4 py-3 font-mono font-bold text-foreground">{req.email}</td>
                      <td className="px-4 py-3 text-muted-foreground">
                        {new Date(req.requested_at).toLocaleString()}
                      </td>
                      <td className="px-4 py-3">
                        <span className={`px-2 py-0.5 rounded-full text-[10px] font-mono font-bold uppercase ${
                          req.status === "approved" ? "bg-emerald-500/10 text-emerald-400" :
                          req.status === "rejected" ? "bg-destructive/10 text-destructive" :
                          "bg-amber-500/10 text-amber-400"
                        }`}>
                          {req.status}
                        </span>
                      </td>
                      <td className="px-4 py-3 text-right">
                        {req.status === "pending" ? (
                          <div className="flex items-center justify-end gap-2">
                            <Button
                              size="sm"
                              onClick={() => handleApproveRequest(req.id)}
                              className="h-7 px-2.5 text-xs font-bold rounded-lg bg-[var(--accent-primary)] text-black hover:opacity-90 cursor-pointer"
                            >
                              Approve
                            </Button>
                            <Button
                              size="sm"
                              variant="outline"
                              onClick={() => setRejectReqId(req.id)}
                              className="h-7 px-2.5 text-xs text-destructive hover:bg-destructive/10 rounded-lg cursor-pointer"
                            >
                              Reject
                            </Button>
                          </div>
                        ) : (
                          <span className="text-[11px] text-muted-foreground">Processed</span>
                        )}
                      </td>
                    </tr>
                  ))}
                  {accessRequests.length === 0 && (
                    <tr>
                      <td colSpan={4} className="py-8 text-center text-muted-foreground">
                        No pending access requests.
                      </td>
                    </tr>
                  )}
                </tbody>
              </table>
            </div>
          </Card>
        </div>
      )}

      {/* 5. COHORTS TAB */}
      {activeTab === "cohorts" && (
        <div className="space-y-4">
          <div className="flex items-center justify-between">
            <div>
              <h3 className="text-sm font-bold text-foreground">Cohorts & Batches</h3>
              <p className="text-xs text-muted-foreground">Group students into learning cohorts with start and end dates.</p>
            </div>
            <Button
              size="sm"
              onClick={() => setShowCohortModal(true)}
              className="rounded-xl bg-[var(--accent-primary)] text-black hover:opacity-90 font-bold text-xs h-8 cursor-pointer gap-1.5"
            >
              <Plus className="h-3.5 w-3.5" />
              <span>New Cohort</span>
            </Button>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {cohorts.map((c) => (
              <Card key={c.id} className="rounded-2xl border-border bg-card hover:border-[var(--accent-primary)]/50 transition-all">
                <CardHeader className="pb-3">
                  <div className="flex items-center justify-between">
                    <CardTitle className="text-base font-bold text-foreground">{c.name}</CardTitle>
                    <span className="text-[10px] uppercase font-mono px-2 py-0.5 rounded-full bg-emerald-500/10 text-emerald-400 font-bold">
                      {c.status}
                    </span>
                  </div>
                  {c.description && <CardDescription className="text-xs">{c.description}</CardDescription>}
                </CardHeader>
                <CardContent className="space-y-2 text-xs text-muted-foreground">
                  <div className="flex items-center justify-between">
                    <span>Timeline:</span>
                    <span className="font-mono text-foreground">
                      {new Date(c.starts_at).toLocaleDateString()} → {new Date(c.ends_at).toLocaleDateString()}
                    </span>
                  </div>
                  <div className="flex items-center justify-between">
                    <span>Assigned Curricula:</span>
                    <span className="font-bold text-foreground">{c.learning_paths?.length || 0} paths</span>
                  </div>
                </CardContent>
                <div className="p-4 pt-0 flex gap-2">
                  <Button
                    size="sm"
                    variant="outline"
                    onClick={() => handleViewCohortRoster(c)}
                    className="w-full text-xs font-bold rounded-xl h-8 cursor-pointer"
                  >
                    View Student Roster
                  </Button>
                  <Button
                    size="sm"
                    variant="outline"
                    onClick={() => {
                      setInviteCohortId(c.id);
                      setShowInviteModal(true);
                    }}
                    className="text-xs font-bold rounded-xl h-8 cursor-pointer"
                    title="Invite directly to this cohort"
                  >
                    <UserPlus className="h-3.5 w-3.5" />
                  </Button>
                </div>
              </Card>
            ))}
            {cohorts.length === 0 && (
              <div className="col-span-2 py-12 text-center text-muted-foreground border border-dashed border-border rounded-2xl">
                No cohorts created yet. Click "New Cohort" to create one.
              </div>
            )}
          </div>
        </div>
      )}

      {/* 6. LEARNING PATHS TAB */}
      {activeTab === "paths" && (
        <div className="space-y-4">
          <div className="flex items-center justify-between">
            <div>
              <h3 className="text-sm font-bold text-foreground">Custom Learning Paths</h3>
              <p className="text-xs text-muted-foreground">Curate ordered modules tailored for your organization.</p>
            </div>
            <Button
              size="sm"
              onClick={() => setShowPathModal(true)}
              className="rounded-xl bg-[var(--accent-primary)] text-black hover:opacity-90 font-bold text-xs h-8 cursor-pointer gap-1.5"
            >
              <Plus className="h-3.5 w-3.5" />
              <span>New Path</span>
            </Button>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {learningPaths.map((lp) => (
              <Card key={lp.id} className="rounded-2xl border-border bg-card">
                <CardHeader className="pb-3">
                  <div className="flex items-center justify-between">
                    <CardTitle className="text-base font-bold text-foreground">{lp.name}</CardTitle>
                    <span className="text-[10px] uppercase font-mono px-2 py-0.5 rounded-full bg-muted font-bold">
                      {lp.visibility}
                    </span>
                  </div>
                  <CardDescription className="text-xs font-mono">{lp.slug}</CardDescription>
                </CardHeader>
                <CardContent className="space-y-2 text-xs text-muted-foreground">
                  <p>{lp.description || "No description provided."}</p>
                  <div className="flex items-center justify-between pt-2 border-t border-border/50">
                    <span>Curated Modules:</span>
                    <span className="font-bold text-foreground">{lp.module_count} modules</span>
                  </div>
                  {lp.modules && lp.modules.length > 0 && (
                    <div className="flex flex-wrap gap-1 mt-1">
                      {lp.modules.map((m) => (
                        <span key={m} className="px-2 py-0.5 rounded-md bg-muted/60 text-[10px] font-mono">
                          {m}
                        </span>
                      ))}
                    </div>
                  )}
                </CardContent>
              </Card>
            ))}
            {learningPaths.length === 0 && (
              <div className="col-span-2 py-12 text-center text-muted-foreground border border-dashed border-border rounded-2xl">
                No custom learning paths created yet.
              </div>
            )}
          </div>
        </div>
      )}

      {/* CURRICULUM TAB */}
      {activeTab === "curriculum" && (
        <div className="space-y-6">
          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
            <div>
              <h3 className="text-sm font-bold text-foreground">Workspace Curriculum Catalog</h3>
              <p className="text-xs text-muted-foreground">
                Manage learning modules available to learners and cohorts in this organization.
              </p>
            </div>
            <Button
              size="sm"
              onClick={() => {
                setSelectedAdoptModule(null);
                setCustomAdoptId("");
                setCustomAdoptTitle("");
                setAdoptError(null);
                setShowAdoptModal(true);
                loadAvailableTLD();
              }}
              className="rounded-xl bg-[var(--accent-primary)] text-black hover:opacity-90 font-bold text-xs h-9 cursor-pointer gap-1.5 shadow-sm"
            >
              <Plus className="h-4 w-4" />
              <span>Adopt Platform Module</span>
            </Button>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            {curriculumModules.map((mod) => (
              <Card key={mod.id} className="rounded-2xl border-border bg-card flex flex-col justify-between hover:border-[var(--accent-primary)]/40 transition-all">
                <CardHeader className="pb-3">
                  <div className="flex items-start justify-between gap-2">
                    <span className="text-[10px] font-mono px-2 py-0.5 rounded-full bg-muted font-bold text-muted-foreground">
                      {mod.topic || "devops"}
                    </span>
                    <span className={`text-[10px] font-bold px-2 py-0.5 rounded-full ${
                      mod.is_official_verified
                        ? "bg-emerald-500/10 text-emerald-500 border border-emerald-500/20"
                        : "bg-blue-500/10 text-blue-500 border border-blue-500/20"
                    }`}>
                      {mod.is_official_verified ? "Official Verified" : mod.status}
                    </span>
                  </div>
                  <CardTitle className="text-base font-bold mt-2 leading-snug">{mod.title}</CardTitle>
                  <CardDescription className="text-xs line-clamp-2 mt-1">{mod.description || "No description provided."}</CardDescription>
                </CardHeader>
                <CardContent className="pt-0">
                  <div className="flex items-center justify-between text-xs text-muted-foreground pt-3 border-t border-border">
                    <div className="flex items-center gap-3">
                      <span>{mod.total_sections} sections</span>
                      <span>•</span>
                      <span>{mod.difficulty || "intermediate"}</span>
                    </div>
                    <div className="flex items-center gap-2">
                      <Button
                        size="sm"
                        variant="ghost"
                        onClick={() => router.push(`/modules/${mod.id}`)}
                        className="h-8 px-2 text-xs hover:text-[var(--accent-primary)] cursor-pointer"
                        title="View module syllabus"
                      >
                        <ExternalLink className="h-3.5 w-3.5" />
                      </Button>
                      <Button
                        size="sm"
                        variant="ghost"
                        onClick={() => handleRemoveModule(mod.id)}
                        className="h-8 px-2 text-xs text-rose-500 hover:text-rose-600 hover:bg-rose-500/10 cursor-pointer"
                        title="Remove module from workspace"
                      >
                        <Trash2 className="h-3.5 w-3.5" />
                      </Button>
                    </div>
                  </div>
                </CardContent>
              </Card>
            ))}

            {curriculumModules.length === 0 && !curriculumLoading && (
              <div className="col-span-full py-16 text-center border border-dashed border-border rounded-2xl bg-muted/20">
                <Layers className="h-10 w-10 text-muted-foreground/40 mx-auto mb-3" />
                <h4 className="text-sm font-bold text-foreground">No modules in this workspace yet</h4>
                <p className="text-xs text-muted-foreground mt-1 max-w-sm mx-auto">
                  Adopt official modules from the platform library or publish custom curriculum using the TLD CLI.
                </p>
                <Button
                  size="sm"
                  onClick={() => {
                    setSelectedAdoptModule(null);
                    setCustomAdoptId("");
                    setCustomAdoptTitle("");
                    setAdoptError(null);
                    setShowAdoptModal(true);
                    loadAvailableTLD();
                  }}
                  className="mt-4 rounded-xl bg-[var(--accent-primary)] text-black hover:opacity-90 font-bold text-xs h-9 cursor-pointer gap-1.5"
                >
                  <Plus className="h-4 w-4" />
                  <span>Browse & Adopt Modules</span>
                </Button>
              </div>
            )}
          </div>
        </div>
      )}

      {/* 7. SETTINGS TAB (Module E) */}
      {activeTab === "settings" && (
        <div className="space-y-6 max-w-2xl">
          <div>
            <h3 className="text-sm font-bold text-foreground">Organization Configuration</h3>
            <p className="text-xs text-muted-foreground">Control domain enforcement, approval policies, and invitation lifetimes.</p>
          </div>

          <div className="space-y-4">
            {settingsList.map((st) => (
              <Card key={st.key} className="rounded-2xl border-border bg-card p-5">
                <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                  <div>
                    <div className="flex items-center gap-2">
                      <h4 className="font-bold text-sm text-foreground">{st.key}</h4>
                      <span className="text-[10px] uppercase font-mono px-2 py-0.2 rounded-full bg-muted text-muted-foreground">
                        {st.category}
                      </span>
                    </div>
                    <p className="text-xs text-muted-foreground mt-1">{st.description}</p>
                  </div>

                  <div className="shrink-0 flex items-center gap-2">
                    {st.data_type === "boolean" ? (
                      <Button
                        size="sm"
                        variant={st.value ? "default" : "outline"}
                        disabled={settingUpdating === st.key}
                        onClick={() => handleUpdateSetting(st.key, !st.value)}
                        className={`rounded-xl text-xs font-bold h-8 cursor-pointer ${
                          st.value ? "bg-[var(--accent-primary)] text-black" : ""
                        }`}
                      >
                        {st.value ? "Enabled" : "Disabled"}
                      </Button>
                    ) : st.key === "onboarding.access_approval_mode" ? (
                      <Select
                        value={String(st.value)}
                        disabled={settingUpdating === st.key}
                        onValueChange={(val) => handleUpdateSetting(st.key, val)}
                      >
                        <SelectTrigger className="h-8 w-48 text-xs font-mono">
                          <SelectValue />
                        </SelectTrigger>
                        <SelectContent>
                          <SelectItem value="automatic">Automatic</SelectItem>
                          <SelectItem value="manual">Manual (Review Queue)</SelectItem>
                        </SelectContent>
                      </Select>
                    ) : st.data_type === "integer" ? (
                      <NumberStepper
                        defaultValue={typeof st.value === "number" ? st.value : parseInt(String(st.value), 10) || 0}
                        disabled={settingUpdating === st.key}
                        unit="days"
                        min={1}
                        max={365}
                        onChange={(newVal) => {
                          if (newVal !== st.value) handleUpdateSetting(st.key, newVal);
                        }}
                      />
                    ) : (
                      <span className="font-mono text-xs text-foreground">{JSON.stringify(st.value)}</span>
                    )}
                  </div>
                </div>
              </Card>
            ))}
          </div>
        </div>
      )}

      {/* 8. AUDIT LOGS TAB */}
      {activeTab === "audit" && (
        <div className="space-y-4">
          <div>
            <h3 className="text-sm font-bold text-foreground">Audit & Activity Trail</h3>
            <p className="text-xs text-muted-foreground">Immutable historical log of all organization management actions.</p>
          </div>

          <Card className="rounded-2xl border-border bg-card overflow-hidden">
            <div className="overflow-x-auto">
              <table className="w-full text-xs text-left">
                <thead className="bg-muted/40 text-muted-foreground uppercase font-mono text-[10px] border-b border-border">
                  <tr>
                    <th className="px-4 py-3">Timestamp</th>
                    <th className="px-4 py-3">Actor</th>
                    <th className="px-4 py-3">Action</th>
                    <th className="px-4 py-3">Entity</th>
                    <th className="px-4 py-3">Metadata</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-border/60 font-mono">
                  {auditLogs.map((log) => (
                    <tr key={log.id} className="hover:bg-muted/20 transition-colors">
                      <td className="px-4 py-3 text-muted-foreground whitespace-nowrap">
                        {new Date(log.created_at).toLocaleString()}
                      </td>
                      <td className="px-4 py-3 text-foreground font-semibold">
                        {log.actor_username || "System"}
                      </td>
                      <td className="px-4 py-3">
                        <span className="px-2 py-0.5 rounded-full text-[10px] bg-muted font-bold text-[var(--accent-primary)]">
                          {log.action}
                        </span>
                      </td>
                      <td className="px-4 py-3 text-muted-foreground">
                        {log.entity_type} {log.entity_id ? `(#${log.entity_id})` : ""}
                      </td>
                      <td className="px-4 py-3 text-[11px] text-muted-foreground truncate max-w-xs">
                        {JSON.stringify(log.metadata)}
                      </td>
                    </tr>
                  ))}
                  {auditLogs.length === 0 && (
                    <tr>
                      <td colSpan={5} className="py-8 text-center text-muted-foreground">
                        No audit events recorded yet.
                      </td>
                    </tr>
                  )}
                </tbody>
              </table>
            </div>
          </Card>
        </div>
      )}

      {/* MODALS */}

      {/* Single Invite Modal */}
      {showInviteModal && (
        <div className="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4">
          <Card className="max-w-md w-full rounded-2xl shadow-2xl border-border bg-card">
            <form onSubmit={handleSingleInvite}>
              <CardHeader>
                <CardTitle className="text-base font-bold">Invite New Member</CardTitle>
                <CardDescription className="text-xs">
                  Issue a single-use invitation code to enter {org.name}.
                </CardDescription>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-foreground">Recipient Email</label>
                  <Input
                    type="email"
                    placeholder="student@example.com"
                    value={inviteEmail}
                    onChange={(e) => setInviteEmail(e.target.value)}
                    required
                    className="rounded-xl bg-muted/30 text-xs"
                  />
                </div>
                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-foreground">Assigned Role</label>
                  <Select value={inviteRole} onValueChange={(val) => setInviteRole(val)}>
                    <SelectTrigger className="w-full h-9 text-xs">
                      <SelectValue placeholder="Select a role" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="learner">Learner (Student)</SelectItem>
                      <SelectItem value="instructor">Instructor</SelectItem>
                      <SelectItem value="admin">Administrator</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-foreground">Target Cohort (Optional)</label>
                  <Select
                    value={inviteCohortId ? String(inviteCohortId) : "none"}
                    onValueChange={(val) => setInviteCohortId(val === "none" ? null : parseInt(val, 10))}
                  >
                    <SelectTrigger className="w-full h-9 text-xs">
                      <SelectValue placeholder="Whole Organization (No specific cohort)" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="none">Whole Organization (No specific cohort)</SelectItem>
                      {cohorts.map((c) => (
                        <SelectItem key={c.id} value={String(c.id)}>{c.name}</SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>
              </CardContent>
              <div className="p-4 pt-0 flex justify-end gap-2">
                <Button type="button" variant="outline" onClick={() => setShowInviteModal(false)} className="rounded-xl text-xs">
                  Cancel
                </Button>
                <Button type="submit" disabled={inviteLoading} className="rounded-xl bg-[var(--accent-primary)] text-black font-bold text-xs">
                  {inviteLoading ? "Sending..." : "Send Invitation"}
                </Button>
              </div>
            </form>
          </Card>
        </div>
      )}

      {/* Bulk CSV Modal */}
      {showBulkModal && (
        <div className="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4">
          <Card className="max-w-lg w-full rounded-2xl shadow-2xl border-border bg-card">
            <form onSubmit={handleBulkUpload}>
              <CardHeader>
                <CardTitle className="text-base font-bold">Bulk CSV Invitations</CardTitle>
                <CardDescription className="text-xs">
                  Upload a CSV file containing an <code>email</code> column to batch invite students.
                </CardDescription>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="border-2 border-dashed border-border rounded-2xl p-6 text-center space-y-2">
                  <Upload className="h-8 w-8 text-muted-foreground mx-auto" />
                  <div className="text-xs text-foreground font-semibold">Select CSV file</div>
                  <input
                    type="file"
                    accept=".csv"
                    onChange={(e) => {
                      if (e.target.files && e.target.files[0]) setBulkFile(e.target.files[0]);
                    }}
                    required
                    className="text-xs text-muted-foreground mx-auto block"
                  />
                </div>

                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-foreground">Target Cohort (Optional)</label>
                  <Select
                    value={inviteCohortId ? String(inviteCohortId) : "none"}
                    onValueChange={(val) => setInviteCohortId(val === "none" ? null : parseInt(val, 10))}
                  >
                    <SelectTrigger className="w-full h-9 text-xs">
                      <SelectValue placeholder="Whole Organization" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="none">Whole Organization</SelectItem>
                      {cohorts.map((c) => (
                        <SelectItem key={c.id} value={String(c.id)}>{c.name}</SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>

                {bulkResult && (
                  <div className="p-3 rounded-xl bg-muted/40 text-xs space-y-2">
                    <div className="font-bold text-foreground">Results Summary:</div>
                    <div className="grid grid-cols-3 gap-2 text-center">
                      <div className="p-2 rounded-lg bg-emerald-500/10 text-emerald-400 font-bold">
                        {bulkResult.successful} Sent
                      </div>
                      <div className="p-2 rounded-lg bg-amber-500/10 text-amber-400 font-bold">
                        {bulkResult.skipped_existing} Existing
                      </div>
                      <div className="p-2 rounded-lg bg-destructive/10 text-destructive font-bold">
                        {bulkResult.failed} Invalid
                      </div>
                    </div>
                  </div>
                )}
              </CardContent>
              <div className="p-4 pt-0 flex justify-end gap-2">
                <Button type="button" variant="outline" onClick={() => { setShowBulkModal(false); setBulkResult(null); }} className="rounded-xl text-xs">
                  Close
                </Button>
                <Button type="submit" disabled={bulkLoading || !bulkFile} className="rounded-xl bg-[var(--accent-primary)] text-black font-bold text-xs">
                  {bulkLoading ? "Processing..." : "Process Batch"}
                </Button>
              </div>
            </form>
          </Card>
        </div>
      )}

      {/* Create Cohort Modal */}
      {showCohortModal && (
        <div className="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4">
          <Card className="max-w-md w-full rounded-2xl shadow-2xl border-border bg-card">
            <form onSubmit={handleCreateCohort}>
              <CardHeader>
                <CardTitle className="text-base font-bold">Create Student Cohort</CardTitle>
                <CardDescription className="text-xs">
                  Group students into a specific class or time-bound batch.
                </CardDescription>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-foreground">Cohort Name</label>
                  <Input
                    placeholder="e.g. Fall 2026 DevOps Batch A"
                    value={cohortName}
                    onChange={(e) => setCohortName(e.target.value)}
                    required
                    className="rounded-xl bg-muted/30 text-xs"
                  />
                </div>
                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-foreground">Description</label>
                  <Input
                    placeholder="e.g. Computer Science seniors containerization track"
                    value={cohortDesc}
                    onChange={(e) => setCohortDesc(e.target.value)}
                    className="rounded-xl bg-muted/30 text-xs"
                  />
                </div>
                <div className="grid grid-cols-2 gap-3">
                  <div className="space-y-1.5">
                    <label className="text-xs font-semibold text-foreground">Start Date</label>
                    <Input
                      type="date"
                      value={cohortStartsAt}
                      onChange={(e) => setCohortStartsAt(e.target.value)}
                      required
                      className="rounded-xl bg-muted/30 text-xs"
                    />
                  </div>
                  <div className="space-y-1.5">
                    <label className="text-xs font-semibold text-foreground">End Date</label>
                    <Input
                      type="date"
                      value={cohortEndsAt}
                      onChange={(e) => setCohortEndsAt(e.target.value)}
                      required
                      className="rounded-xl bg-muted/30 text-xs"
                    />
                  </div>
                </div>
              </CardContent>
              <div className="p-4 pt-0 flex justify-end gap-2">
                <Button type="button" variant="outline" onClick={() => setShowCohortModal(false)} className="rounded-xl text-xs">
                  Cancel
                </Button>
                <Button type="submit" disabled={cohortLoading} className="rounded-xl bg-[var(--accent-primary)] text-black font-bold text-xs">
                  {cohortLoading ? "Creating..." : "Create Cohort"}
                </Button>
              </div>
            </form>
          </Card>
        </div>
      )}

      {/* Cohort Roster Modal */}
      {selectedCohortForRoster && (
        <div className="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4">
          <Card className="max-w-2xl w-full rounded-2xl shadow-2xl border-border bg-card">
            <CardHeader className="flex flex-row items-center justify-between pb-3">
              <div>
                <CardTitle className="text-base font-bold">{selectedCohortForRoster.name} — Student Roster</CardTitle>
                <CardDescription className="text-xs">Enrolled students in this cohort.</CardDescription>
              </div>
              <Button size="sm" variant="ghost" onClick={() => setSelectedCohortForRoster(null)} className="h-8 w-8 p-0 rounded-lg">
                ✕
              </Button>
            </CardHeader>
            <CardContent className="space-y-4">
              {rosterLoading ? (
                <div className="py-8 text-center text-xs font-mono text-muted-foreground animate-pulse">
                  Loading roster...
                </div>
              ) : cohortRoster.length === 0 ? (
                <div className="py-8 text-center text-xs text-muted-foreground">
                  No students currently enrolled in this cohort.
                </div>
              ) : (
                <div className="overflow-x-auto max-h-80 divide-y divide-border/60">
                  <table className="w-full text-xs text-left">
                    <thead className="text-[10px] uppercase font-mono text-muted-foreground bg-muted/30">
                      <tr>
                        <th className="px-3 py-2">Student</th>
                        <th className="px-3 py-2">Email</th>
                        <th className="px-3 py-2">XP</th>
                        <th className="px-3 py-2">Enrolled Date</th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-border/40">
                      {cohortRoster.map((st) => (
                        <tr key={st.cohort_membership_id} className="hover:bg-muted/10">
                          <td className="px-3 py-2 font-bold text-foreground">{st.username}</td>
                          <td className="px-3 py-2 font-mono text-muted-foreground">{st.email}</td>
                          <td className="px-3 py-2 font-mono font-bold text-[var(--accent-primary)]">{st.total_xp} XP</td>
                          <td className="px-3 py-2 text-muted-foreground">{new Date(st.joined_at).toLocaleDateString()}</td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              )}
            </CardContent>
          </Card>
        </div>
      )}

      {/* Role Change Modal */}
      {roleChangeUser && (
        <div className="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4">
          <Card className="max-w-sm w-full rounded-2xl shadow-2xl border-border bg-card">
            <CardHeader>
              <CardTitle className="text-base font-bold">Change Role</CardTitle>
              <CardDescription className="text-xs">
                Update membership role for <strong>{roleChangeUser.username}</strong>
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-3">
              <Select value={newRole} onValueChange={(val) => setNewRole(val)}>
                <SelectTrigger className="w-full h-9 text-xs">
                  <SelectValue placeholder="Select a role" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="learner">Learner (Student)</SelectItem>
                  <SelectItem value="instructor">Instructor</SelectItem>
                  <SelectItem value="admin">Administrator</SelectItem>
                </SelectContent>
              </Select>
            </CardContent>
            <div className="p-4 pt-0 flex justify-end gap-2">
              <Button variant="outline" onClick={() => setRoleChangeUser(null)} className="rounded-xl text-xs">
                Cancel
              </Button>
              <Button onClick={handleRoleChangeSubmit} disabled={roleChangeLoading} className="rounded-xl bg-[var(--accent-primary)] text-black font-bold text-xs">
                {roleChangeLoading ? "Saving..." : "Save Role"}
              </Button>
            </div>
          </Card>
        </div>
      )}

      {/* Reject Request Modal */}
      {rejectReqId && (
        <div className="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4">
          <Card className="max-w-sm w-full rounded-2xl shadow-2xl border-border bg-card">
            <CardHeader>
              <CardTitle className="text-base font-bold">Reject Access Request</CardTitle>
              <CardDescription className="text-xs">Provide an optional reason for the applicant.</CardDescription>
            </CardHeader>
            <CardContent>
              <Input
                placeholder="Reason (optional)"
                value={rejectReason}
                onChange={(e) => setRejectReason(e.target.value)}
                className="rounded-xl bg-muted/30 text-xs"
              />
            </CardContent>
            <div className="p-4 pt-0 flex justify-end gap-2">
              <Button variant="outline" onClick={() => setRejectReqId(null)} className="rounded-xl text-xs">
                Cancel
              </Button>
              <Button onClick={handleRejectRequest} className="rounded-xl bg-destructive text-destructive-foreground font-bold text-xs">
                Confirm Rejection
              </Button>
            </div>
          </Card>
        </div>
      )}

      {/* Learner Progress Inspection Modal */}
      {selectedLearnerUserId && (
        <div className="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4">
          <Card className="max-w-2xl w-full rounded-2xl shadow-2xl border-border bg-card max-h-[85vh] flex flex-col">
            <CardHeader className="pb-3 border-b border-border">
              <div className="flex items-start justify-between">
                <div>
                  <CardTitle className="text-base font-bold">Learner Progress Report</CardTitle>
                  <CardDescription className="text-xs">
                    {selectedLearnerDetail ? (
                      <>
                        <strong>{selectedLearnerDetail.learner.username}</strong> ({selectedLearnerDetail.learner.email})
                      </>
                    ) : (
                      "Loading learner progress..."
                    )}
                  </CardDescription>
                </div>
                <Button
                  size="sm"
                  variant="ghost"
                  onClick={() => { setSelectedLearnerUserId(null); setSelectedLearnerDetail(null); }}
                  className="h-8 w-8 p-0 rounded-xl cursor-pointer"
                >
                  <XCircle className="h-4 w-4" />
                </Button>
              </div>
            </CardHeader>

            <CardContent className="p-5 overflow-y-auto space-y-4 flex-1">
              {learnerDetailLoading ? (
                <div className="py-12 text-center text-xs text-muted-foreground">Loading details...</div>
              ) : selectedLearnerDetail ? (
                <>
                  {/* Summary Grid */}
                  <div className="grid grid-cols-4 gap-2 text-center">
                    <div className="p-2.5 rounded-xl bg-muted/30">
                      <span className="text-[10px] text-muted-foreground uppercase font-bold">Total XP</span>
                      <p className="text-sm font-black font-mono text-[var(--accent-primary)] mt-1">
                        {selectedLearnerDetail.learner.total_xp}
                      </p>
                    </div>
                    <div className="p-2.5 rounded-xl bg-muted/30">
                      <span className="text-[10px] text-muted-foreground uppercase font-bold">Labs Done</span>
                      <p className="text-sm font-black font-mono mt-1">
                        {selectedLearnerDetail.learner.completed_labs_count}
                      </p>
                    </div>
                    <div className="p-2.5 rounded-xl bg-muted/30">
                      <span className="text-[10px] text-muted-foreground uppercase font-bold">Sections Done</span>
                      <p className="text-sm font-black font-mono mt-1">
                        {selectedLearnerDetail.learner.completed_sections_count}
                      </p>
                    </div>
                    <div className="p-2.5 rounded-xl bg-muted/30">
                      <span className="text-[10px] text-muted-foreground uppercase font-bold">Role</span>
                      <p className="text-sm font-black font-mono capitalize mt-1">
                        {selectedLearnerDetail.learner.role}
                      </p>
                    </div>
                  </div>

                  {/* Module Progress Breakdown */}
                  <div>
                    <h4 className="text-xs font-bold text-foreground mb-2">Module Progress</h4>
                    {selectedLearnerDetail.module_progress.length > 0 ? (
                      <div className="space-y-2">
                        {selectedLearnerDetail.module_progress.map((mp) => (
                          <div key={mp.module_id} className="p-3 rounded-xl bg-muted/20 border border-border/50 text-xs">
                            <div className="flex justify-between items-center mb-1">
                              <span className="font-bold text-foreground">{mp.title}</span>
                              <span className="font-mono text-[var(--accent-primary)] font-bold">{mp.percent_complete}%</span>
                            </div>
                            <div className="w-full bg-muted/50 rounded-full h-1.5 overflow-hidden">
                              <div
                                className="bg-[var(--accent-primary)] h-1.5 rounded-full transition-all"
                                style={{ width: `${mp.percent_complete}%` }}
                              />
                            </div>
                            <div className="flex justify-between text-[10px] text-muted-foreground font-mono mt-1">
                              <span>Labs: {mp.completed_labs} / {mp.total_labs}</span>
                              <span>Sections: {mp.completed_sections} / {mp.total_sections}</span>
                            </div>
                          </div>
                        ))}
                      </div>
                    ) : (
                      <p className="text-xs text-muted-foreground py-2">No module progress started yet.</p>
                    )}
                  </div>

                  {/* Completed Labs List */}
                  <div>
                    <h4 className="text-xs font-bold text-foreground mb-2">Completed Labs</h4>
                    {selectedLearnerDetail.completed_labs.length > 0 ? (
                      <div className="space-y-1.5 max-h-48 overflow-y-auto pr-1">
                        {selectedLearnerDetail.completed_labs.map((cl) => (
                          <div key={cl.lab_id + cl.completed_at} className="flex items-center justify-between py-1.5 px-2.5 rounded-lg bg-muted/30 text-xs">
                            <div>
                              <p className="font-bold text-foreground">{cl.title}</p>
                              {cl.module_title && (
                                <span className="text-[10px] text-muted-foreground">{cl.module_title}</span>
                              )}
                            </div>
                            <div className="text-right">
                              <span className="font-mono text-emerald-500 font-bold">+{cl.xp_awarded} XP</span>
                              <p className="text-[10px] text-muted-foreground font-mono">
                                {new Date(cl.completed_at).toLocaleDateString()}
                              </p>
                            </div>
                          </div>
                        ))}
                      </div>
                    ) : (
                      <p className="text-xs text-muted-foreground py-2">No labs completed yet.</p>
                    )}
                  </div>
                </>
              ) : null}
            </CardContent>

            <div className="p-4 border-t border-border flex justify-end">
              <Button
                variant="outline"
                size="sm"
                onClick={() => { setSelectedLearnerUserId(null); setSelectedLearnerDetail(null); }}
                className="rounded-xl text-xs font-semibold"
              >
                Close
              </Button>
            </div>
          </Card>
        </div>
      )}

      {/* ADOPT OFFICIAL MODULE MODAL */}
      {showAdoptModal && (
        <div className="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4">
          <div className="bg-card border border-border rounded-2xl w-full max-w-2xl max-h-[85vh] flex flex-col shadow-2xl overflow-hidden">
            <div className="p-6 border-b border-border flex items-center justify-between">
              <div>
                <h3 className="text-base font-bold text-foreground">Adopt Official Platform Module</h3>
                <p className="text-xs text-muted-foreground mt-0.5">
                  Directly add verified TLD curriculum to this organization without modifying underlying labs.
                </p>
              </div>
              <button
                onClick={() => setShowAdoptModal(false)}
                className="text-muted-foreground hover:text-foreground cursor-pointer p-1 rounded-lg hover:bg-muted"
              >
                <XCircle className="h-5 w-5" />
              </button>
            </div>

            <div className="p-6 overflow-y-auto space-y-4 flex-1">
              {adoptError && (
                <div className="p-3 rounded-xl bg-rose-500/10 border border-rose-500/20 text-rose-600 dark:text-rose-400 text-xs flex items-center gap-2">
                  <AlertCircle className="h-4 w-4 shrink-0" />
                  <span>{adoptError}</span>
                </div>
              )}

              {!selectedAdoptModule ? (
                <>
                  <div className="relative">
                    <Search className="absolute left-3 top-2.5 h-4 w-4 text-muted-foreground" />
                    <Input
                      placeholder="Search official modules by title or topic..."
                      value={adoptSearch}
                      onChange={(e) => setAdoptSearch(e.target.value)}
                      className="pl-9 rounded-xl text-xs h-9"
                    />
                  </div>

                  <div className="space-y-2 mt-3 max-h-[400px] overflow-y-auto pr-1">
                    {availableTLDModules
                      .filter((m) =>
                        m.title.toLowerCase().includes(adoptSearch.toLowerCase()) ||
                        (m.topic && m.topic.toLowerCase().includes(adoptSearch.toLowerCase()))
                      )
                      .map((mod) => (
                        <div
                          key={mod.id}
                          onClick={() => {
                            setSelectedAdoptModule(mod);
                            setCustomAdoptId(mod.id);
                            setCustomAdoptTitle(mod.title);
                          }}
                          className="p-4 rounded-xl border border-border hover:border-[var(--accent-primary)]/60 bg-muted/20 hover:bg-muted/40 transition-all cursor-pointer flex items-center justify-between gap-4"
                        >
                          <div className="space-y-1">
                            <div className="flex items-center gap-2">
                              <span className="text-sm font-bold text-foreground">{mod.title}</span>
                              <span className="text-[10px] font-mono px-2 py-0.5 rounded-full bg-muted font-bold text-muted-foreground">
                                {mod.topic}
                              </span>
                            </div>
                            <p className="text-xs text-muted-foreground line-clamp-1">{mod.description}</p>
                            <div className="flex items-center gap-3 text-[11px] text-muted-foreground">
                              <span>{mod.total_sections} sections</span>
                              <span>•</span>
                              <span>{mod.difficulty}</span>
                              <span>•</span>
                              <span>{mod.estimated_minutes} min</span>
                            </div>
                          </div>
                          <Button size="sm" variant="outline" className="rounded-xl text-xs font-bold shrink-0">
                            Select
                          </Button>
                        </div>
                      ))}

                    {availableTLDModules.length === 0 && (
                      <div className="py-8 text-center text-xs text-muted-foreground">
                        All official platform modules have already been adopted into this workspace!
                      </div>
                    )}
                  </div>
                </>
              ) : (
                <form onSubmit={handleAdoptModule} className="space-y-4">
                  <div className="p-4 rounded-xl border border-border bg-muted/30 flex items-center justify-between">
                    <div>
                      <div className="text-xs text-muted-foreground font-mono">Selected Source Module</div>
                      <div className="text-sm font-bold text-foreground mt-0.5">{selectedAdoptModule.title}</div>
                      <div className="text-xs text-muted-foreground font-mono">{selectedAdoptModule.id}</div>
                    </div>
                    <Button
                      type="button"
                      variant="ghost"
                      size="sm"
                      onClick={() => setSelectedAdoptModule(null)}
                      className="text-xs cursor-pointer"
                    >
                      Change
                    </Button>
                  </div>

                  <div className="space-y-3 pt-2">
                    <div>
                      <label className="text-xs font-bold text-foreground mb-1 block">Module ID in Workspace</label>
                      <Input
                        value={customAdoptId}
                        onChange={(e) => setCustomAdoptId(e.target.value)}
                        placeholder="e.g. linux-fundamentals"
                        className="rounded-xl text-xs font-mono h-9"
                        required
                      />
                      <p className="text-[11px] text-muted-foreground mt-1">
                        Defaults to the official ID. You can customize the identifier for this workspace.
                      </p>
                    </div>

                    <div>
                      <label className="text-xs font-bold text-foreground mb-1 block">Module Title in Workspace</label>
                      <Input
                        value={customAdoptTitle}
                        onChange={(e) => setCustomAdoptTitle(e.target.value)}
                        placeholder="e.g. Linux Fundamentals"
                        className="rounded-xl text-xs h-9"
                        required
                      />
                    </div>
                  </div>

                  <div className="pt-4 border-t border-border flex items-center justify-end gap-2.5">
                    <Button
                      type="button"
                      variant="outline"
                      onClick={() => setSelectedAdoptModule(null)}
                      className="rounded-xl text-xs font-bold h-9"
                    >
                      Back
                    </Button>
                    <Button
                      type="submit"
                      disabled={adoptLoading}
                      className="rounded-xl bg-[var(--accent-primary)] text-black hover:opacity-90 font-bold text-xs h-9"
                    >
                      {adoptLoading ? "Adopting..." : "Confirm & Add to Workspace"}
                    </Button>
                  </div>
                </form>
              )}
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
