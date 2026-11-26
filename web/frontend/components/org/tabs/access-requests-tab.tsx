"use client";

import React from "react";
import { Check, X } from "lucide-react";
import { Button } from "@/components/ui/button";
import type { AccessRequestResponse } from "@/lib/types";

interface OrgAccessRequestsTabProps {
  accessRequests: AccessRequestResponse[];
  onApprove: (id: number) => void;
  onOpenRejectModal: (id: number) => void;
}

export function OrgAccessRequestsTab({
  accessRequests,
  onApprove,
  onOpenRejectModal,
}: OrgAccessRequestsTabProps) {
  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between">
        <div>
          <h3 className="text-sm font-bold text-foreground">Pending Approval Queue</h3>
          <p className="text-xs text-muted-foreground">
            Students requesting access using institutional email.
          </p>
        </div>
      </div>

      <div className="relative overflow-visible">
        <div className="relative">
          <div className="grid grid-cols-12 gap-3 px-4 py-3 text-muted-foreground font-mono uppercase text-[10px] font-semibold">
            <div className="col-span-4">Applicant Email</div>
            <div className="col-span-3">Requested At</div>
            <div className="col-span-2">Status</div>
            <div className="col-span-3 text-right">Decision</div>
          </div>
          <div className="matrix-line-h bottom-0" />
        </div>

        <div className="flex flex-col relative">
          {accessRequests.length === 0 ? (
            <div className="p-8 text-center text-muted-foreground text-xs font-mono">
              No pending access requests.
            </div>
          ) : (
            accessRequests.map((req, idx) => (
              <div key={req.id} className="relative">
                <div className="grid grid-cols-12 gap-3 px-4 py-3.5 items-center text-xs">
                  <div className="col-span-4 font-mono font-bold text-foreground truncate">
                    {req.email}
                  </div>
                  <div className="col-span-3 font-mono text-[11px] text-muted-foreground">
                    {new Date(req.requested_at).toLocaleString()}
                  </div>
                  <div className="col-span-2">
                    <span
                      className={`px-2 py-0.5 rounded-none text-[10px] font-mono font-bold uppercase ${
                        req.status === "approved"
                          ? "bg-emerald-500/10 text-emerald-500"
                          : req.status === "rejected"
                          ? "bg-destructive/10 text-destructive"
                          : "bg-amber-500/10 text-amber-500"
                      }`}
                    >
                      {req.status}
                    </span>
                  </div>
                  <div className="col-span-3 flex items-center justify-end gap-2">
                    {req.status === "pending" ? (
                      <>
                        <Button
                          size="sm"
                          onClick={() => onApprove(req.id)}
                          className="h-7 px-2.5 text-xs font-bold rounded-none bg-[var(--accent-primary)] text-black hover:opacity-90 cursor-pointer gap-1"
                        >
                          <Check className="h-3 w-3" />
                          <span>Approve</span>
                        </Button>
                        <Button
                          size="sm"
                          variant="outline"
                          onClick={() => onOpenRejectModal(req.id)}
                          className="h-7 px-2.5 text-xs text-destructive hover:bg-destructive/10 rounded-none cursor-pointer gap-1"
                        >
                          <X className="h-3 w-3" />
                          <span>Reject</span>
                        </Button>
                      </>
                    ) : (
                      <span className="text-[11px] text-muted-foreground font-mono">Processed</span>
                    )}
                  </div>
                </div>
                {idx < accessRequests.length - 1 && <div className="matrix-line-h bottom-0" />}
              </div>
            ))
          )}
        </div>
      </div>
    </div>
  );
}
