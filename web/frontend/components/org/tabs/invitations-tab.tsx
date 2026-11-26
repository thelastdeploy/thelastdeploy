"use client";

import React from "react";
import { Plus } from "lucide-react";
import { Button } from "@/components/ui/button";
import { KpiStrip } from "@/components/shared/kpi-strip";
import type { InvitationResponse, InvitationStatsResponse } from "@/lib/types";

interface OrgInvitationsTabProps {
  invitations: InvitationResponse[];
  invitationStats: InvitationStatsResponse | null;
  onOpenInviteModal: () => void;
  onRevokeInvite: (id: number, email?: string) => void;
}

export function OrgInvitationsTab({
  invitations,
  invitationStats,
  onOpenInviteModal,
  onRevokeInvite,
}: OrgInvitationsTabProps) {
  return (
    <div className="space-y-6">
      {invitationStats && (
        <KpiStrip
          items={[
            { label: "Total Issued", value: invitationStats.total },
            { label: "Pending", value: invitationStats.pending, valueClassName: "text-amber-500" },
            { label: "Accepted", value: invitationStats.accepted, valueClassName: "text-emerald-500" },
            { label: "Expired", value: invitationStats.expired, valueClassName: "text-zinc-500" },
          ]}
        />
      )}

      <div className="flex items-center justify-between">
        <h3 className="text-sm font-bold text-foreground">Active &amp; Past Invitations</h3>
        <Button
          size="sm"
          onClick={onOpenInviteModal}
          className="rounded-none bg-[var(--accent-primary)] text-black hover:opacity-90 font-bold text-xs h-8 cursor-pointer gap-1.5"
        >
          <Plus className="h-3.5 w-3.5" />
          <span>New Invite</span>
        </Button>
      </div>

      <div className="relative overflow-visible">
        <div className="relative">
          <div className="grid grid-cols-12 gap-3 px-4 py-3 text-muted-foreground font-mono uppercase text-[10px] font-semibold">
            <div className="col-span-3">Recipient Email</div>
            <div className="col-span-2">Code</div>
            <div className="col-span-1">Role</div>
            <div className="col-span-2">Target Cohort</div>
            <div className="col-span-2">Status</div>
            <div className="col-span-1">Expires</div>
            <div className="col-span-1 text-right">Actions</div>
          </div>
          <div className="matrix-line-h bottom-0" />
        </div>

        <div className="flex flex-col relative">
          {invitations.length === 0 ? (
            <div className="p-8 text-center text-muted-foreground text-xs font-mono">
              No invitations issued yet.
            </div>
          ) : (
            invitations.map((inv, idx) => (
              <div key={inv.id} className="relative">
                <div className="grid grid-cols-12 gap-3 px-4 py-3.5 items-center text-xs">
                  <div className="col-span-3 font-mono font-medium text-foreground truncate">
                    {inv.email}
                  </div>
                  <div className="col-span-2 font-mono text-[11px] text-muted-foreground truncate">
                    {inv.invitation_code || "—"}
                  </div>
                  <div className="col-span-1 capitalize truncate">{inv.role}</div>
                  <div className="col-span-2 truncate">{inv.cohort_name || "Whole Org"}</div>
                  <div className="col-span-2">
                    <span
                      className={`px-2 py-0.5 rounded-none text-[10px] font-mono font-bold uppercase ${
                        inv.status === "accepted"
                          ? "bg-emerald-500/10 text-emerald-500"
                          : inv.status === "pending"
                          ? "bg-amber-500/10 text-amber-500"
                          : inv.status === "revoked"
                          ? "bg-destructive/10 text-destructive"
                          : "bg-muted text-muted-foreground"
                      }`}
                    >
                      {inv.status}
                    </span>
                  </div>
                  <div className="col-span-1 font-mono text-[11px] text-muted-foreground">
                    {new Date(inv.expires_at).toLocaleDateString()}
                  </div>
                  <div className="col-span-1 text-right">
                    {inv.status === "pending" && (
                      <Button
                        size="sm"
                        variant="ghost"
                        onClick={() => onRevokeInvite(inv.id, inv.email)}
                        className="h-7 text-xs text-destructive hover:bg-destructive/10 rounded-none cursor-pointer"
                      >
                        Revoke
                      </Button>
                    )}
                  </div>
                </div>
                {idx < invitations.length - 1 && <div className="matrix-line-h bottom-0" />}
              </div>
            ))
          )}
        </div>
      </div>
    </div>
  );
}
