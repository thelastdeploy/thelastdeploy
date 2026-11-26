// web/frontend/app/org/[slug]/page.tsx

"use client";

import { useEffect, useState } from "react";
import { useRouter, useParams } from "next/navigation";
import { useAuth } from "@/lib/auth";
import { api } from "@/lib/api";
import type {
  OrganizationResponse,
  OrganizationMemberResponse,
  CohortResponse,
  CohortMemberResponse,
  LearningPathResponse,
  InvitationResponse,
  InvitationStatsResponse,
  AccessRequestResponse,
  OrgSettingItemResponse,
  OrgPermissionItem,
  OrgRole,
  AuditLogResponse,
  Module,
  AnalyticsOverviewResponse,
  AnalyticsTrendsResponse,
  CohortAnalyticsItem,
  ContentAnalyticsResponse,
  XpAnalyticsResponse,
  LearnerDetailAnalyticsResponse,
} from "@/lib/types";
import { Button } from "@/components/ui/button";
import { ConfirmModal } from "@/components/shared/confirm-modal";
import { AccessRestricted } from "@/components/shared/access-restricted";
import { OrgOverviewTab, type OrgTabKey } from "@/components/org/tabs/overview-tab";
import { OrgAnalyticsTab } from "@/components/org/tabs/analytics-tab";
import { OrgMembersTab } from "@/components/org/tabs/members-tab";
import { OrgInvitationsTab } from "@/components/org/tabs/invitations-tab";
import { OrgAccessRequestsTab } from "@/components/org/tabs/access-requests-tab";
import { OrgCohortsTab } from "@/components/org/tabs/cohorts-tab";
import { OrgLearningPathsTab } from "@/components/org/tabs/learning-paths-tab";
import { OrgCurriculumTab } from "@/components/org/tabs/curriculum-tab";
import { OrgSettingsTab } from "@/components/org/tabs/settings-tab";
import { OrgRolesTab } from "@/components/org/tabs/roles-tab";
import { OrgAuditLogsTab } from "@/components/org/tabs/audit-logs-tab";
import { InviteMemberModal } from "@/components/org/modals/invite-member-modal";
import { BulkCsvModal } from "@/components/org/modals/bulk-csv-modal";
import { CreateCohortModal } from "@/components/org/modals/create-cohort-modal";
import { CohortRosterModal } from "@/components/org/modals/cohort-roster-modal";
import { RoleEditorModal } from "@/components/org/modals/role-editor-modal";
import { RejectRequestModal } from "@/components/org/modals/reject-request-modal";
import { LearnerProgressModal } from "@/components/org/modals/learner-progress-modal";
import { AdoptModuleModal } from "@/components/org/modals/adopt-module-modal";
import {
  Building2,
  GraduationCap,
  Users,
  Mail,
  UserPlus,
  ShieldCheck,
  Settings,
  FileText,
  Upload,
  BookOpen,
  BarChart3,
  Layers,
  KeyRound,
} from "lucide-react";

export default function OrgAdminPage() {
  const router = useRouter();
  const params = useParams();
  const orgSlug = (params?.slug as string) || "";
  const { user, loading: authLoading, refreshUser } = useAuth();

  const [org, setOrg] = useState<OrganizationResponse | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [activeTab, setActiveTab] = useState<OrgTabKey>("overview");

  // Domain Data States
  const [members, setMembers] = useState<OrganizationMemberResponse[]>([]);
  const [orgRoles, setOrgRoles] = useState<OrgRole[]>([]);
  const [orgPermissions, setOrgPermissions] = useState<OrgPermissionItem[]>([]);
  const [rolesLoading, setRolesLoading] = useState(false);
  const [invitations, setInvitations] = useState<InvitationResponse[]>([]);
  const [invitationStats, setInvitationStats] = useState<InvitationStatsResponse | null>(null);
  const [accessRequests, setAccessRequests] = useState<AccessRequestResponse[]>([]);
  const [cohorts, setCohorts] = useState<CohortResponse[]>([]);
  const [learningPaths, setLearningPaths] = useState<LearningPathResponse[]>([]);
  const [curriculumModules, setCurriculumModules] = useState<Module[]>([]);
  const [curriculumLoading, setCurriculumLoading] = useState(false);
  const [availableTLDModules, setAvailableTLDModules] = useState<Module[]>([]);
  const [settingsList, setSettingsList] = useState<OrgSettingItemResponse[]>([]);
  const [auditLogs, setAuditLogs] = useState<AuditLogResponse[]>([]);
  const [auditSearch, setAuditSearch] = useState("");

  // Analytics States
  const [analyticsOverview, setAnalyticsOverview] = useState<AnalyticsOverviewResponse | null>(null);
  const [analyticsTrends, setAnalyticsTrends] = useState<AnalyticsTrendsResponse | null>(null);
  const [analyticsCohorts, setAnalyticsCohorts] = useState<CohortAnalyticsItem[]>([]);
  const [analyticsContent, setAnalyticsContent] = useState<ContentAnalyticsResponse | null>(null);
  const [analyticsXp, setAnalyticsXp] = useState<XpAnalyticsResponse | null>(null);
  const [analyticsPeriod, setAnalyticsPeriod] = useState<string>("30d");
  const [analyticsLoading, setAnalyticsLoading] = useState(false);
  const [exportLoading, setExportLoading] = useState<string | null>(null);

  // Members Filter & Batch Edit States
  const [memberSearch, setMemberSearch] = useState("");
  const [memberRoleFilter, setMemberRoleFilter] = useState("all");
  const [memberJoinedFrom, setMemberJoinedFrom] = useState("");
  const [memberJoinedTo, setMemberJoinedTo] = useState("");
  const [draftRoles, setDraftRoles] = useState<Record<number, string>>({});
  const [savingMemberRoles, setSavingMemberRoles] = useState(false);
  const [selectedMemberIds, setSelectedMemberIds] = useState<number[]>([]);
  const [bulkDeleteConfirm, setBulkDeleteConfirm] = useState(false);

  // Role Modal States
  const [showRoleModal, setShowRoleModal] = useState(false);
  const [editingRole, setEditingRole] = useState<OrgRole | null>(null);
  const [roleFormName, setRoleFormName] = useState("");
  const [roleFormDesc, setRoleFormDesc] = useState("");
  const [roleFormPerms, setRoleFormPerms] = useState<string[]>([]);
  const [roleFormSaving, setRoleFormSaving] = useState(false);
  const [roleFormError, setRoleFormError] = useState<string | null>(null);

  // Delete Confirmation Modal
  const [deleteConfirm, setDeleteConfirm] = useState<{
    kind: "role" | "member" | "invite" | "module";
    id: number | string;
    name: string;
  } | null>(null);

  // Invite / Bulk / Cohort / Adopt / Reject / Learner Modals
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

  const [showAdoptModal, setShowAdoptModal] = useState(false);
  const [adoptLoading, setAdoptLoading] = useState(false);
  const [adoptSearch, setAdoptSearch] = useState("");
  const [selectedAdoptModule, setSelectedAdoptModule] = useState<Module | null>(null);
  const [customAdoptId, setCustomAdoptId] = useState("");
  const [customAdoptTitle, setCustomAdoptTitle] = useState("");
  const [adoptError, setAdoptError] = useState<string | null>(null);

  const [rejectReqId, setRejectReqId] = useState<number | null>(null);
  const [rejectReason, setRejectReason] = useState("");
  const [settingUpdating, setSettingUpdating] = useState<string | null>(null);

  const [selectedLearnerUserId, setSelectedLearnerUserId] = useState<number | null>(null);
  const [selectedLearnerDetail, setSelectedLearnerDetail] =
    useState<LearnerDetailAnalyticsResponse | null>(null);
  const [learnerDetailLoading, setLearnerDetailLoading] = useState(false);

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
    if (activeTab === "members") {
      loadMembers();
      loadRolesAndPerms();
    }
    if (activeTab === "roles") loadRolesAndPerms();
    if (activeTab === "invitations") {
      loadInvitations();
      loadRolesAndPerms();
    }
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
      if (orgData.status === "suspended") {
        setError(
          `Organization workspace '${orgData.name || orgSlug}' is currently suspended. Access to manage this workspace is blocked for all users.`
        );
        setLoading(false);
        return;
      }

      const canManageWorkspace = Boolean(
        user?.can_manage_workspaces ||
          user?.platform_permissions?.includes("platform.organizations.manage") ||
          orgData.roles?.some((r: string) => ["owner", "admin", "platform_admin"].includes(r))
      );

      if (!canManageWorkspace) {
        setError(
          `Access Restricted: Managing workspace '${orgSlug}' requires organization administrator or owner privileges, or the 'platform.organizations.manage' platform permission.`
        );
        setLoading(false);
        return;
      }

      setOrg(orgData);
      const [membersData, cohortsData, invStats, currData, rolesData] = await Promise.all([
        api.getOrganizationMembers(orgSlug).catch(() => []),
        api.getCohorts(orgSlug).catch(() => []),
        api.getInvitationStats(orgSlug).catch(() => null),
        api.getOrgCurriculum(orgSlug).catch(() => []),
        api.getOrgRoles(orgSlug).catch(() => []),
      ]);
      setMembers(membersData);
      setCohorts(cohortsData);
      setInvitationStats(invStats);
      setCurriculumModules(currData);
      setOrgRoles(rolesData);
    } catch (err: any) {
      setError(err.message || "Failed to load organization.");
    } finally {
      setLoading(false);
    }
  };

  const loadCurriculum = async () => {
    if (!orgSlug) return;
    setCurriculumLoading(true);
    try {
      setCurriculumModules(await api.getOrgCurriculum(orgSlug));
    } catch (err) {
      console.error("Failed to load curriculum:", err);
    } finally {
      setCurriculumLoading(false);
    }
  };

  const loadAvailableTLD = async () => {
    if (!orgSlug) return;
    try {
      setAvailableTLDModules(await api.getAvailableTLDModules(orgSlug));
    } catch (err) {
      console.error("Failed to load available TLD modules:", err);
    }
  };

  const loadRolesAndPerms = async () => {
    if (!orgSlug) return;
    setRolesLoading(true);
    try {
      const [rolesData, permsData] = await Promise.all([
        api.getOrgRoles(orgSlug),
        api.getOrgPermissions(orgSlug).catch(() => []),
      ]);
      setOrgRoles(rolesData);
      setOrgPermissions(permsData);
    } catch (err) {
      console.error("Failed to load org roles:", err);
    } finally {
      setRolesLoading(false);
    }
  };

  const loadMembers = async () => {
    if (!orgSlug) return;
    try {
      setMembers(await api.getOrganizationMembers(orgSlug));
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
      setAccessRequests(await api.getAccessRequests(orgSlug));
    } catch (err) {
      console.error(err);
    }
  };

  const loadCohorts = async () => {
    try {
      setCohorts(await api.getCohorts(orgSlug));
    } catch (err) {
      console.error(err);
    }
  };

  const loadLearningPaths = async () => {
    try {
      setLearningPaths(await api.getLearningPaths(orgSlug));
    } catch (err) {
      console.error(err);
    }
  };

  const loadSettings = async () => {
    try {
      setSettingsList(await api.getOrgSettings(orgSlug));
    } catch (err) {
      console.error(err);
    }
  };

  const loadAuditLogs = async () => {
    try {
      setAuditLogs(await api.getOrgAuditLogs(orgSlug));
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

  const handleSaveRole = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!orgSlug || !roleFormName.trim()) return;
    setRoleFormSaving(true);
    setRoleFormError(null);
    try {
      if (editingRole) {
        await api.updateOrgRole(orgSlug, editingRole.id, {
          name: roleFormName.trim(),
          description: roleFormDesc.trim(),
          permissions: roleFormPerms,
        });
      } else {
        await api.createOrgRole(orgSlug, {
          name: roleFormName.trim(),
          description: roleFormDesc.trim() || undefined,
          permissions: roleFormPerms,
        });
      }
      setShowRoleModal(false);
      await loadRolesAndPerms();
    } catch (err: any) {
      setRoleFormError(err.message || "Failed to save role.");
    } finally {
      setRoleFormSaving(false);
    }
  };

  const handleConfirmDelete = async () => {
    if (!orgSlug || !deleteConfirm) return;
    const target = deleteConfirm;
    setDeleteConfirm(null);
    try {
      if (target.kind === "role") {
        await api.deleteOrgRole(orgSlug, Number(target.id));
        await loadRolesAndPerms();
      } else if (target.kind === "member") {
        await api.removeMember(orgSlug, Number(target.id));
        await Promise.all([loadMembers(), loadRolesAndPerms()]);
      } else if (target.kind === "invite") {
        await api.revokeInvitation(Number(target.id), orgSlug);
        await loadInvitations();
      } else if (target.kind === "module") {
        await api.removeOrgModule(orgSlug, String(target.id));
        await loadCurriculum();
      }
    } catch (err: any) {
      alert(err.message || "Failed to complete action.");
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

  const handleSingleInvite = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!inviteEmail.trim()) return;
    setInviteLoading(true);
    try {
      await api.createInvitation(
        { email: inviteEmail.trim(), role: inviteRole, cohort_id: inviteCohortId },
        orgSlug
      );
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
      setBulkResult(await api.uploadBulkInvitations(bulkFile, inviteCohortId, orgSlug));
      loadInvitations();
    } catch (err: any) {
      alert("Bulk upload failed: " + err.message);
    } finally {
      setBulkLoading(false);
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
      setCohortRoster(await api.getCohortMembers(orgSlug, cohort.id));
    } catch (err) {
      console.error(err);
    } finally {
      setRosterLoading(false);
    }
  };

  const pendingRoleUpdates = members
    .filter((m) => {
      const current = m.roles[0] || "learner";
      const draft = draftRoles[m.user_id];
      return draft !== undefined && draft !== current;
    })
    .map((m) => ({ user_id: m.user_id, role: draftRoles[m.user_id] }));

  const handleSaveMemberRoles = async () => {
    if (!orgSlug || pendingRoleUpdates.length === 0) return;
    setSavingMemberRoles(true);
    try {
      await api.batchUpdateMemberRoles(orgSlug, pendingRoleUpdates);
      setDraftRoles({});
      await Promise.all([loadMembers(), loadRolesAndPerms()]);
    } catch (err: any) {
      alert("Failed to save role changes: " + err.message);
    } finally {
      setSavingMemberRoles(false);
    }
  };

  const handleConfirmBulkDelete = async () => {
    if (!orgSlug || selectedMemberIds.length === 0) return;
    setBulkDeleteConfirm(false);
    try {
      await api.bulkRemoveMembers(orgSlug, selectedMemberIds);
      setSelectedMemberIds([]);
      await Promise.all([loadMembers(), loadRolesAndPerms()]);
    } catch (err: any) {
      alert("Failed to remove selected members: " + err.message);
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
      <AccessRestricted
        message={error || "Organization not found or you lack workspace management authority."}
        icon={<ShieldCheck className="h-7 w-7 text-destructive" />}
      />
    );
  }

  const isUniversity = org.type === "university";
  const filteredMembers = members.filter((m) => {
    const matchesSearch =
      m.username.toLowerCase().includes(memberSearch.toLowerCase()) ||
      m.email.toLowerCase().includes(memberSearch.toLowerCase());
    const effectiveRole = draftRoles[m.user_id] ?? m.roles[0] ?? "";
    const matchesRole =
      memberRoleFilter === "all" ||
      m.roles.includes(memberRoleFilter.toLowerCase()) ||
      effectiveRole === memberRoleFilter.toLowerCase();
    const joinedTime = new Date(m.joined_at).getTime();
    const matchesFrom = !memberJoinedFrom || joinedTime >= new Date(memberJoinedFrom).getTime();
    const matchesTo =
      !memberJoinedTo || joinedTime <= new Date(memberJoinedTo + "T23:59:59").getTime();
    return matchesSearch && matchesRole && matchesFrom && matchesTo;
  });

  const sidebarSections: {
    heading: string;
    items: { key: OrgTabKey; label: string; icon: any; count?: number }[];
  }[] = [
    {
      heading: "Workspace",
      items: [
        { key: "overview", label: "Overview", icon: Building2 },
        { key: "analytics", label: "Analytics", icon: BarChart3 },
      ],
    },
    {
      heading: "People & Access",
      items: [
        { key: "members", label: "Members", count: members.length, icon: Users },
        { key: "roles", label: "Roles", count: orgRoles.length, icon: KeyRound },
        { key: "invitations", label: "Invitations", count: invitationStats?.pending, icon: Mail },
        {
          key: "requests",
          label: "Access Requests",
          count: accessRequests.filter((r) => r.status === "pending").length,
          icon: ShieldCheck,
        },
      ],
    },
    {
      heading: "Learning",
      items: [
        { key: "cohorts", label: "Cohorts", count: cohorts.length, icon: GraduationCap },
        { key: "paths", label: "Learning Paths", count: learningPaths.length, icon: BookOpen },
        { key: "curriculum", label: "Curriculum", count: curriculumModules.length, icon: Layers },
      ],
    },
    {
      heading: "Governance",
      items: [
        { key: "settings", label: "Settings", icon: Settings },
        { key: "audit", label: "Audit Logs", icon: FileText },
      ],
    },
  ];

  return (
    <div className="min-h-[calc(100vh-4rem)] flex flex-col lg:flex-row">
      <aside className="w-full lg:w-72 shrink-0">
        <div className="lg:sticky lg:top-16 lg:max-h-[calc(100vh-4rem)] lg:overflow-y-auto px-6 py-8">
          <div className="hidden lg:block space-y-7">
            {sidebarSections.map((section) => (
              <div key={section.heading} className="space-y-2">
                <div className="px-3.5 text-xs font-mono font-bold uppercase tracking-wider text-muted-foreground">
                  {section.heading}
                </div>
                <div className="space-y-1">
                  {section.items.map((tab) => {
                    const Icon = tab.icon;
                    const isActive = activeTab === tab.key;
                    return (
                      <button
                        key={tab.key}
                        onClick={() => setActiveTab(tab.key)}
                        className={`w-full flex items-center justify-between px-3.5 py-2.5 rounded-none text-sm font-medium transition-all cursor-pointer border-l-2 ${
                          isActive
                            ? "bg-[var(--accent-primary)]/10 text-[var(--accent-primary)] border-[var(--accent-primary)] font-bold"
                            : "text-muted-foreground hover:text-foreground hover:bg-muted/40 border-transparent"
                        }`}
                      >
                        <div className="flex items-center gap-3 min-w-0">
                          <Icon className="h-4 w-4 shrink-0" />
                          <span className="truncate">{tab.label}</span>
                        </div>
                        {tab.count !== undefined && tab.count > 0 && (
                          <span
                            className={`text-[11px] font-mono px-2 py-0.5 font-bold shrink-0 ${
                              isActive
                                ? "bg-[var(--accent-primary)] text-black"
                                : "bg-muted text-muted-foreground"
                            }`}
                          >
                            {tab.count}
                          </span>
                        )}
                      </button>
                    );
                  })}
                </div>
              </div>
            ))}
          </div>

          <div className="flex lg:hidden items-center gap-1.5 overflow-x-auto pb-1 scrollbar-none">
            {sidebarSections
              .flatMap((s) => s.items)
              .map((tab) => {
                const Icon = tab.icon;
                const isActive = activeTab === tab.key;
                return (
                  <button
                    key={tab.key}
                    onClick={() => setActiveTab(tab.key)}
                    className={`flex items-center gap-1.5 px-3 py-2 rounded-none text-xs font-bold whitespace-nowrap cursor-pointer border ${
                      isActive
                        ? "bg-[var(--accent-primary)]/10 text-[var(--accent-primary)] border-[var(--accent-primary)]"
                        : "text-muted-foreground hover:text-foreground border-border/50"
                    }`}
                  >
                    <Icon className="h-3.5 w-3.5" />
                    <span>{tab.label}</span>
                    {tab.count !== undefined && tab.count > 0 && (
                      <span
                        className={`text-[10px] font-mono px-1.5 py-0.5 font-bold ${
                          isActive
                            ? "bg-[var(--accent-primary)] text-black"
                            : "bg-muted text-muted-foreground"
                        }`}
                      >
                        {tab.count}
                      </span>
                    )}
                  </button>
                );
              })}
          </div>
        </div>
      </aside>

      <main className="flex-1 min-w-0">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
          <div className="relative pb-6 mb-8 flex flex-col md:flex-row items-start md:items-center justify-between gap-6">
            <div className="flex items-center gap-4">
              <div className="h-12 w-12 rounded-none border border-[var(--accent-primary)]/30 bg-[var(--accent-primary)]/10 text-[var(--accent-primary)] flex items-center justify-center font-black">
                {isUniversity ? (
                  <GraduationCap className="h-6 w-6" />
                ) : (
                  <Building2 className="h-6 w-6" />
                )}
              </div>
              <div>
                <h1 className="text-2xl font-black text-foreground tracking-tight">{org.name}</h1>
                <p className="text-xs font-mono text-muted-foreground mt-0.5">
                  {org.slug} • <span className="capitalize">{org.type}</span>
                </p>
              </div>
            </div>

            <div className="flex items-center gap-2.5">
              <Button
                size="sm"
                onClick={() => setShowInviteModal(true)}
                className="rounded-none bg-[var(--accent-primary)] text-black hover:opacity-90 font-bold text-xs h-9 px-3.5 cursor-pointer gap-1.5"
              >
                <UserPlus className="h-4 w-4" />
                <span>Invite Member</span>
              </Button>
              <Button
                size="sm"
                variant="outline"
                onClick={() => setShowBulkModal(true)}
                className="rounded-none border-border font-bold text-xs h-9 px-3.5 cursor-pointer gap-1.5"
              >
                <Upload className="h-4 w-4" />
                <span>Bulk CSV</span>
              </Button>
            </div>
            <div className="matrix-line-h bottom-0" />
          </div>

          {activeTab === "overview" && (
            <OrgOverviewTab
              org={org}
              members={members}
              cohorts={cohorts}
              invitationStats={invitationStats}
              accessRequests={accessRequests}
              onNavigateTab={setActiveTab}
              onOpenInviteModal={() => setShowInviteModal(true)}
              onOpenCohortModal={() => setShowCohortModal(true)}
            />
          )}

          {activeTab === "analytics" && (
            <OrgAnalyticsTab
              analyticsPeriod={analyticsPeriod}
              analyticsLoading={analyticsLoading}
              exportLoading={exportLoading}
              analyticsOverview={analyticsOverview}
              analyticsTrends={analyticsTrends}
              analyticsCohorts={analyticsCohorts}
              analyticsContent={analyticsContent}
              analyticsXp={analyticsXp}
              onChangePeriod={(p) => {
                setAnalyticsPeriod(p);
                loadAnalytics(p);
              }}
              onRefresh={() => loadAnalytics(analyticsPeriod)}
              onExport={handleExport}
            />
          )}

          {activeTab === "members" && (
            <OrgMembersTab
              members={members}
              filteredMembers={filteredMembers}
              orgRoles={orgRoles}
              currentUserId={user?.id}
              memberSearch={memberSearch}
              memberRoleFilter={memberRoleFilter}
              memberJoinedFrom={memberJoinedFrom}
              memberJoinedTo={memberJoinedTo}
              draftRoles={draftRoles}
              pendingRoleCount={pendingRoleUpdates.length}
              savingMemberRoles={savingMemberRoles}
              selectedMemberIds={selectedMemberIds}
              bulkRoleTarget=""
              onSearchChange={setMemberSearch}
              onRoleFilterChange={setMemberRoleFilter}
              onJoinedFromChange={setMemberJoinedFrom}
              onJoinedToChange={setMemberJoinedTo}
              onClearFilters={() => {
                setMemberSearch("");
                setMemberRoleFilter("all");
                setMemberJoinedFrom("");
                setMemberJoinedTo("");
              }}
              onDraftRoleChange={(uid, roleSlug) =>
                setDraftRoles((prev) => ({ ...prev, [uid]: roleSlug }))
              }
              onResetMemberRoles={() => setDraftRoles({})}
              onSaveMemberRoles={handleSaveMemberRoles}
              onOpenInviteModal={() => setShowInviteModal(true)}
              onSelectMembersChange={setSelectedMemberIds}
              onBulkRoleSelect={(val) => {
                setDraftRoles((prev) => {
                  const next = { ...prev };
                  for (const uid of selectedMemberIds) next[uid] = val;
                  return next;
                });
              }}
              onOpenBulkDeleteConfirm={() => setBulkDeleteConfirm(true)}
              onRemoveMember={(uid, username) =>
                setDeleteConfirm({ kind: "member", id: uid, name: username })
              }
            />
          )}

          {activeTab === "invitations" && (
            <OrgInvitationsTab
              invitations={invitations}
              invitationStats={invitationStats}
              onOpenInviteModal={() => setShowInviteModal(true)}
              onRevokeInvite={(id, email) =>
                setDeleteConfirm({ kind: "invite", id, name: email || `#${id}` })
              }
            />
          )}

          {activeTab === "requests" && (
            <OrgAccessRequestsTab
              accessRequests={accessRequests}
              onApprove={handleApproveRequest}
              onOpenRejectModal={setRejectReqId}
            />
          )}

          {activeTab === "cohorts" && (
            <OrgCohortsTab
              cohorts={cohorts}
              onOpenCohortModal={() => setShowCohortModal(true)}
              onViewRoster={handleViewCohortRoster}
              onInviteToCohort={(cohortId) => {
                setInviteCohortId(cohortId);
                setShowInviteModal(true);
              }}
            />
          )}

          {activeTab === "paths" && <OrgLearningPathsTab learningPaths={learningPaths} />}

          {activeTab === "curriculum" && (
            <OrgCurriculumTab
              modules={curriculumModules}
              loading={curriculumLoading}
              onOpenAdoptModal={() => {
                setSelectedAdoptModule(null);
                setCustomAdoptId("");
                setCustomAdoptTitle("");
                setAdoptError(null);
                setShowAdoptModal(true);
                loadAvailableTLD();
              }}
              onViewModule={(moduleId) => router.push(`/modules/${moduleId}`)}
              onRemoveModule={(moduleId) =>
                setDeleteConfirm({ kind: "module", id: moduleId, name: moduleId })
              }
            />
          )}

          {activeTab === "settings" && (
            <OrgSettingsTab
              settingsList={settingsList}
              settingUpdating={settingUpdating}
              onUpdateSetting={handleUpdateSetting}
            />
          )}

          {activeTab === "roles" && (
            <OrgRolesTab
              orgRoles={orgRoles}
              rolesLoading={rolesLoading}
              onCreateRole={() => {
                setEditingRole(null);
                setRoleFormName("");
                setRoleFormDesc("");
                setRoleFormPerms(["members.view"]);
                setRoleFormError(null);
                setShowRoleModal(true);
              }}
              onEditRole={(role) => {
                setEditingRole(role);
                setRoleFormName(role.name);
                setRoleFormDesc(role.description || "");
                setRoleFormPerms([...(role.permissions || [])]);
                setRoleFormError(null);
                setShowRoleModal(true);
              }}
              onDeleteRole={(role) =>
                setDeleteConfirm({ kind: "role", id: role.id, name: role.name })
              }
            />
          )}

          {activeTab === "audit" && (
            <OrgAuditLogsTab
              auditLogs={auditLogs}
              auditSearch={auditSearch}
              onSearchChange={setAuditSearch}
            />
          )}

          {/* Modals */}
          <InviteMemberModal
            isOpen={showInviteModal}
            orgName={org.name}
            inviteEmail={inviteEmail}
            inviteRole={inviteRole}
            inviteCohortId={inviteCohortId}
            inviteLoading={inviteLoading}
            orgRoles={orgRoles}
            cohorts={cohorts}
            onClose={() => setShowInviteModal(false)}
            onEmailChange={setInviteEmail}
            onRoleChange={setInviteRole}
            onCohortChange={setInviteCohortId}
            onSubmit={handleSingleInvite}
          />

          <BulkCsvModal
            isOpen={showBulkModal}
            bulkFile={bulkFile}
            bulkLoading={bulkLoading}
            bulkResult={bulkResult}
            inviteCohortId={inviteCohortId}
            cohorts={cohorts}
            onClose={() => {
              setShowBulkModal(false);
              setBulkResult(null);
            }}
            onFileChange={setBulkFile}
            onCohortChange={setInviteCohortId}
            onSubmit={handleBulkUpload}
          />

          <CreateCohortModal
            isOpen={showCohortModal}
            cohortName={cohortName}
            cohortDesc={cohortDesc}
            cohortStartsAt={cohortStartsAt}
            cohortEndsAt={cohortEndsAt}
            cohortLoading={cohortLoading}
            onClose={() => setShowCohortModal(false)}
            onNameChange={setCohortName}
            onDescChange={setCohortDesc}
            onStartsAtChange={setCohortStartsAt}
            onEndsAtChange={setCohortEndsAt}
            onSubmit={handleCreateCohort}
          />

          <CohortRosterModal
            cohort={selectedCohortForRoster}
            roster={cohortRoster}
            loading={rosterLoading}
            onClose={() => setSelectedCohortForRoster(null)}
          />

          <RoleEditorModal
            isOpen={showRoleModal}
            editingRole={editingRole}
            roleFormName={roleFormName}
            roleFormDesc={roleFormDesc}
            roleFormPerms={roleFormPerms}
            roleFormSaving={roleFormSaving}
            roleFormError={roleFormError}
            orgPermissions={orgPermissions}
            onClose={() => setShowRoleModal(false)}
            onNameChange={setRoleFormName}
            onDescChange={setRoleFormDesc}
            onTogglePerm={(key) =>
              setRoleFormPerms((prev) =>
                prev.includes(key) ? prev.filter((k) => k !== key) : [...prev, key]
              )
            }
            onSubmit={handleSaveRole}
          />

          <ConfirmModal
            isOpen={Boolean(deleteConfirm)}
            type="danger"
            title={
              deleteConfirm?.kind === "role"
                ? "Delete Role"
                : deleteConfirm?.kind === "invite"
                ? "Revoke Invitation"
                : deleteConfirm?.kind === "module"
                ? "Remove Curriculum Module"
                : "Remove Member"
            }
            message={
              deleteConfirm?.kind === "role"
                ? `Are you sure you want to delete the role "${deleteConfirm?.name}"? This action cannot be undone.`
                : deleteConfirm?.kind === "invite"
                ? `Are you sure you want to revoke the pending invitation for "${deleteConfirm?.name}"?`
                : deleteConfirm?.kind === "module"
                ? `Remove "${deleteConfirm?.name}" from ${org?.name}'s curriculum? Learners will no longer see it in this workspace.`
                : `Are you sure you want to remove "${deleteConfirm?.name}" from ${org?.name}?`
            }
            confirmText={
              deleteConfirm?.kind === "role"
                ? "Delete Role"
                : deleteConfirm?.kind === "invite"
                ? "Revoke Invitation"
                : deleteConfirm?.kind === "module"
                ? "Remove Module"
                : "Remove Member"
            }
            cancelText="Cancel"
            onConfirm={handleConfirmDelete}
            onCancel={() => setDeleteConfirm(null)}
          />

          <ConfirmModal
            isOpen={bulkDeleteConfirm}
            type="danger"
            title="Remove Selected Members"
            message={`Are you sure you want to remove ${selectedMemberIds.length} selected member(s) from ${org?.name}?`}
            confirmText="Delete Selected"
            cancelText="Cancel"
            onConfirm={handleConfirmBulkDelete}
            onCancel={() => setBulkDeleteConfirm(false)}
          />

          <RejectRequestModal
            isOpen={Boolean(rejectReqId)}
            reason={rejectReason}
            onReasonChange={setRejectReason}
            onClose={() => setRejectReqId(null)}
            onConfirm={handleRejectRequest}
          />

          <LearnerProgressModal
            isOpen={Boolean(selectedLearnerUserId)}
            loading={learnerDetailLoading}
            detail={selectedLearnerDetail}
            onClose={() => {
              setSelectedLearnerUserId(null);
              setSelectedLearnerDetail(null);
            }}
          />

          <AdoptModuleModal
            isOpen={showAdoptModal}
            availableModules={availableTLDModules}
            selectedModule={selectedAdoptModule}
            search={adoptSearch}
            customId={customAdoptId}
            customTitle={customAdoptTitle}
            loading={adoptLoading}
            error={adoptError}
            onClose={() => setShowAdoptModal(false)}
            onSearchChange={setAdoptSearch}
            onSelectModule={setSelectedAdoptModule}
            onCustomIdChange={setCustomAdoptId}
            onCustomTitleChange={setCustomAdoptTitle}
            onSubmit={handleAdoptModule}
          />
        </div>
      </main>
    </div>
  );
}
