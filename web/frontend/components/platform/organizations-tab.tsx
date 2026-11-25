// web/frontend/components/platform/organizations-tab.tsx

"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import {
  Search,
  Plus,
  GraduationCap,
  Globe,
  Building2,
  Power,
  ExternalLink,
  Settings2,
} from "lucide-react";
import { OrganizationResponse } from "@/lib/types";
import { ConfirmModal } from "@/components/shared/confirm-modal";
import { ProvisionOrgModal } from "./modals/provision-org-modal";
import { usePlatformOrgs } from "@/lib/platform/hooks/use-platform-orgs";

interface OrganizationsTabProps {
  hasPerm: (perm: string) => boolean;
}

export function OrganizationsTab({ hasPerm }: OrganizationsTabProps) {
  const router = useRouter();
  const {
    filteredOrgs,
    myMembershipSlugs,
    orgSearch,
    setOrgSearch,
    toggleOrgStatus,
    loadOrgs,
  } = usePlatformOrgs();

  const [showProvisionModal, setShowProvisionModal] = useState(false);
  const [modalConfig, setModalConfig] = useState<{
    isOpen: boolean;
    title: string;
    message: string;
    confirmText?: string;
    type?: "danger" | "warning" | "info" | "success";
    onConfirm: () => void;
  }>({
    isOpen: false,
    title: "",
    message: "",
    onConfirm: () => {},
  });

  const handleToggleOrgStatus = (org: OrganizationResponse) => {
    const isSuspended = org.status === "suspended";
    setModalConfig({
      isOpen: true,
      title: isSuspended ? "Reactivate Organization" : "Suspend Organization",
      message: isSuspended
        ? `Are you sure you want to reactivate "${org.name}"? Members will regain access to their workspace.`
        : `Are you sure you want to suspend "${org.name}"? Tenant access will be immediately deactivated for all members.`,
      confirmText: isSuspended ? "Reactivate Tenant" : "Suspend Tenant",
      type: isSuspended ? "info" : "danger",
      onConfirm: async () => {
        setModalConfig((prev) => ({ ...prev, isOpen: false }));
        try {
          await toggleOrgStatus(org);
        } catch (err: any) {
          alert("Status update failed: " + err.message);
        }
      },
    });
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between gap-4 flex-wrap">
        <div className="relative w-72">
          <Search className="absolute left-3 top-2.5 h-4 w-4 text-muted-foreground" />
          <Input
            placeholder="Search organizations..."
            value={orgSearch}
            onChange={(e) => setOrgSearch(e.target.value)}
            className="pl-9 h-9 text-xs rounded-none"
          />
        </div>

        {hasPerm("platform.organizations.create") && (
          <Button
            size="sm"
            onClick={() => setShowProvisionModal(true)}
            className="rounded-none bg-[var(--accent-primary)] text-white dark:text-black hover:opacity-90 font-bold text-xs gap-1.5 cursor-pointer"
          >
            <Plus className="h-3.5 w-3.5" />
            <span>Provision Organization</span>
          </Button>
        )}
      </div>

      {/* 3-Column Open Matrix Grid with Continuous Extending Lines */}
      <div className="relative overflow-visible">
        <div className="matrix-line-v left-1/3 hidden lg:block" />
        <div className="matrix-line-v left-2/3 hidden lg:block" />

        <div className="flex flex-col relative">
          {Array.from({ length: Math.ceil(filteredOrgs.length / 3) }, (_, rIdx) => {
            const row = filteredOrgs.slice(rIdx * 3, rIdx * 3 + 3);
            const isLastRow = rIdx === Math.ceil(filteredOrgs.length / 3) - 1;

            return (
              <div key={rIdx} className="relative">
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3">
                  {row.map((org, cIdx) => {
                    const isPlatform = org.type === "platform" || org.is_platform;
                    const isSuspended = org.status === "suspended";
                    const isMemberOfOrg = myMembershipSlugs.has(org.slug);
                    const isLastInColMobile = isLastRow && cIdx === row.length - 1;

                    return (
                      <div
                        key={org.slug}
                        className={`group relative p-2.5 sm:p-3 text-left transition-colors border-0 ${
                          !isLastInColMobile ? "max-lg:border-b max-lg:border-border/40" : ""
                        }`}
                      >
                        {/* Sharp-Cornered Inset Tile (idle frameless, no card-level hover) */}
                        <div
                          className="w-full h-full min-h-[220px] p-5 sm:p-6 rounded-none flex flex-col justify-between"
                          style={{
                            border: "none",
                            boxShadow: "none",
                            backgroundColor: "transparent",
                          }}
                        >
                          <div className="space-y-2.5">
                            <div className="flex items-start justify-between gap-3">
                              <div className="flex items-center gap-3">
                                <div className="h-10 w-10 rounded-none bg-[var(--accent-primary)]/10 text-[var(--accent-primary)] flex items-center justify-center shrink-0 font-bold">
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
                              <span className="text-[10px] font-mono uppercase px-2 py-0.5 rounded-none bg-muted font-bold text-muted-foreground">
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
                                  <span className="font-mono text-foreground text-[10px] truncate max-w-[140px]">
                                    {org.domains.join(", ")}
                                  </span>
                                </div>
                              )}
                              <div className="flex items-center justify-between">
                                <span>Your Membership:</span>
                                <span className="font-mono text-foreground text-[11px]">
                                  {isMemberOfOrg ? (
                                    <span className="text-emerald-400 font-semibold">Active Member</span>
                                  ) : (
                                    <span className="text-muted-foreground">Not Enrolled</span>
                                  )}
                                </span>
                              </div>
                            </div>
                          </div>

                          {/* Scoped Actions Footer with Inset Button Hovers */}
                          <div className="pt-3 border-t border-border/40 flex items-center justify-between gap-2">
                            <div className="flex items-center gap-1.5">
                              {hasPerm("platform.organizations.suspend") && !isPlatform && (
                                <Button
                                  variant="ghost"
                                  size="sm"
                                  onClick={() => handleToggleOrgStatus(org)}
                                  className={`rounded-none text-[11px] font-bold h-7 cursor-pointer px-2 transition-all duration-150 ${
                                    isSuspended ? "text-emerald-400" : "text-red-400"
                                  }`}
                                  style={{ border: "none", boxShadow: "none", backgroundColor: "transparent" }}
                                  onMouseEnter={(e) => {
                                    const col = isSuspended ? "#10b981" : "#ef4444";
                                    e.currentTarget.style.boxShadow = `inset 0 0 0 2px ${col}`;
                                    e.currentTarget.style.backgroundColor = isSuspended
                                      ? "rgba(16, 185, 129, 0.12)"
                                      : "rgba(239, 68, 68, 0.12)";
                                  }}
                                  onMouseLeave={(e) => {
                                    e.currentTarget.style.boxShadow = "none";
                                    e.currentTarget.style.backgroundColor = "transparent";
                                  }}
                                  title={isSuspended ? "Reactivate Organization" : "Suspend Organization"}
                                >
                                  <Power className="h-3.5 w-3.5" />
                                </Button>
                              )}
                            </div>

                            <div className="flex items-center gap-1.5">
                              {hasPerm("platform.organizations.manage") && (
                                <Button
                                  variant="ghost"
                                  size="sm"
                                  onClick={() => router.push(`/org/${org.slug}`)}
                                  className="rounded-none text-[11px] font-bold text-foreground h-7 cursor-pointer gap-1 transition-all duration-150"
                                  style={{ border: "none", boxShadow: "none", backgroundColor: "transparent" }}
                                  onMouseEnter={(e) => {
                                    const isDark = document.documentElement.classList.contains("dark");
                                    e.currentTarget.style.boxShadow = "inset 0 0 0 2px var(--accent-primary)";
                                    e.currentTarget.style.backgroundColor = isDark
                                      ? "rgba(var(--accent-primary-rgb), 0.12)"
                                      : "rgba(var(--accent-primary-rgb), 0.05)";
                                  }}
                                  onMouseLeave={(e) => {
                                    e.currentTarget.style.boxShadow = "none";
                                    e.currentTarget.style.backgroundColor = "transparent";
                                  }}
                                >
                                  <ExternalLink className="h-3 w-3" />
                                  <span>Workspace</span>
                                </Button>
                              )}
                              {(hasPerm("platform.organizations.settings") || hasPerm("platform.organizations.manage")) && (
                                <Button
                                  variant="ghost"
                                  size="sm"
                                  onClick={() => router.push(`/platform/organizations/${org.slug}`)}
                                  className="rounded-none text-[11px] font-bold text-[var(--accent-primary)] h-7 cursor-pointer gap-1 transition-all duration-150"
                                  style={{ border: "none", boxShadow: "none", backgroundColor: "transparent" }}
                                  onMouseEnter={(e) => {
                                    const isDark = document.documentElement.classList.contains("dark");
                                    e.currentTarget.style.boxShadow = "inset 0 0 0 2px var(--accent-primary)";
                                    e.currentTarget.style.backgroundColor = isDark
                                      ? "rgba(var(--accent-primary-rgb), 0.12)"
                                      : "rgba(var(--accent-primary-rgb), 0.05)";
                                  }}
                                  onMouseLeave={(e) => {
                                    e.currentTarget.style.boxShadow = "none";
                                    e.currentTarget.style.backgroundColor = "transparent";
                                  }}
                                >
                                  <Settings2 className="h-3 w-3" />
                                  <span>Manage Org</span>
                                </Button>
                              )}
                            </div>
                          </div>
                        </div>
                      </div>
                    );
                  })}
                </div>

                {/* Continuous Horizontal Row Divider Line */}
                {!isLastRow && (
                  <div className="matrix-line-h bottom-0 hidden lg:block" />
                )}
              </div>
            );
          })}
        </div>
      </div>

      {/* Provision Organization Modal */}
      <ProvisionOrgModal
        isOpen={showProvisionModal}
        onClose={() => setShowProvisionModal(false)}
        onSuccess={loadOrgs}
      />

      {/* Confirmation Modal */}
      <ConfirmModal
        isOpen={modalConfig.isOpen}
        title={modalConfig.title}
        message={modalConfig.message}
        confirmText={modalConfig.confirmText}
        type={modalConfig.type}
        onConfirm={modalConfig.onConfirm}
        onCancel={() => setModalConfig((prev) => ({ ...prev, isOpen: false }))}
      />
    </div>
  );
}

