"use client";

import React from "react";
import { GraduationCap, Settings, UserPlus } from "lucide-react";
import { Button } from "@/components/ui/button";
import { KpiStrip } from "@/components/shared/kpi-strip";
import type {
  AccessRequestResponse,
  CohortResponse,
  InvitationStatsResponse,
  OrganizationMemberResponse,
  OrganizationResponse,
} from "@/lib/types";

export type OrgTabKey =
  | "overview"
  | "analytics"
  | "members"
  | "roles"
  | "invitations"
  | "requests"
  | "cohorts"
  | "paths"
  | "curriculum"
  | "settings"
  | "audit";

interface OrgOverviewTabProps {
  org: OrganizationResponse;
  members: OrganizationMemberResponse[];
  cohorts: CohortResponse[];
  invitationStats: InvitationStatsResponse | null;
  accessRequests: AccessRequestResponse[];
  onNavigateTab: (tab: OrgTabKey) => void;
  onOpenInviteModal: () => void;
  onOpenCohortModal: () => void;
}

export function OrgOverviewTab({
  org,
  members,
  cohorts,
  invitationStats,
  accessRequests,
  onNavigateTab,
  onOpenInviteModal,
  onOpenCohortModal,
}: OrgOverviewTabProps) {
  return (
    <div className="space-y-8">
      <KpiStrip
        items={[
          { label: "Members", value: members.length },
          {
            label: "Active Cohorts",
            value: cohorts.length,
            valueClassName: "text-[var(--accent-primary)]",
          },
          {
            label: "Pending Invites",
            value: invitationStats?.pending || 0,
            valueClassName: "text-amber-500",
          },
          {
            label: "Pending Requests",
            value: accessRequests.filter((r) => r.status === "pending").length,
            valueClassName: "text-blue-500",
          },
        ]}
      />

      <div className="grid grid-cols-1 md:grid-cols-2 relative overflow-visible">
        <div className="p-6 relative space-y-4">
          <div>
            <h3 className="text-sm font-bold text-foreground">Organization Details</h3>
            <p className="text-xs text-muted-foreground">Context and platform identifier</p>
          </div>
          <div className="space-y-2.5 text-xs">
            <div className="flex justify-between py-2 border-b border-border/50">
              <span className="text-muted-foreground font-mono">Display Name</span>
              <span className="font-bold text-foreground">{org.name}</span>
            </div>
            <div className="flex justify-between py-2 border-b border-border/50">
              <span className="text-muted-foreground font-mono">Slug</span>
              <span className="font-mono text-foreground">{org.slug}</span>
            </div>
            <div className="flex justify-between py-2 border-b border-border/50">
              <span className="text-muted-foreground font-mono">Type</span>
              <span className="capitalize text-foreground">{org.type}</span>
            </div>
            <div className="flex justify-between py-2 border-b border-border/50">
              <span className="text-muted-foreground font-mono">Joined At</span>
              <span className="font-mono text-foreground">
                {new Date(org.joined_at).toLocaleDateString()}
              </span>
            </div>
          </div>
          <div className="matrix-line-v right-0 hidden md:block" />
        </div>

        <div className="p-6 space-y-4">
          <div>
            <h3 className="text-sm font-bold text-foreground">Quick Shortcuts</h3>
            <p className="text-xs text-muted-foreground">Frequent administrative actions</p>
          </div>
          <div className="space-y-2">
            <Button
              variant="outline"
              onClick={() => {
                onNavigateTab("members");
                onOpenInviteModal();
              }}
              className="w-full justify-start text-xs font-semibold rounded-none border-border h-10 gap-2.5 cursor-pointer"
            >
              <UserPlus className="h-4 w-4 text-[var(--accent-primary)]" />
              <span>Send an individual invitation code</span>
            </Button>
            <Button
              variant="outline"
              onClick={() => {
                onNavigateTab("cohorts");
                onOpenCohortModal();
              }}
              className="w-full justify-start text-xs font-semibold rounded-none border-border h-10 gap-2.5 cursor-pointer"
            >
              <GraduationCap className="h-4 w-4 text-[var(--accent-primary)]" />
              <span>Create a student cohort</span>
            </Button>
            <Button
              variant="outline"
              onClick={() => onNavigateTab("settings")}
              className="w-full justify-start text-xs font-semibold rounded-none border-border h-10 gap-2.5 cursor-pointer"
            >
              <Settings className="h-4 w-4 text-[var(--accent-primary)]" />
              <span>Configure domain verification &amp; approval mode</span>
            </Button>
          </div>
        </div>
      </div>
    </div>
  );
}
