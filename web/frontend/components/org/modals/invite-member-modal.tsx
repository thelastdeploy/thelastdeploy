"use client";

import React from "react";
import { Mail, XCircle } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Modal, ModalBody, ModalFooter, ModalHeader } from "@/components/shared/modal";
import type { CohortResponse, OrgRole } from "@/lib/types";

interface InviteMemberModalProps {
  isOpen: boolean;
  orgName: string;
  inviteEmail: string;
  inviteRole: string;
  inviteCohortId: number | null;
  inviteLoading: boolean;
  orgRoles: OrgRole[];
  cohorts: CohortResponse[];
  onClose: () => void;
  onEmailChange: (value: string) => void;
  onRoleChange: (value: string) => void;
  onCohortChange: (cohortId: number | null) => void;
  onSubmit: (e: React.FormEvent) => void;
}

export function InviteMemberModal({
  isOpen,
  orgName,
  inviteEmail,
  inviteRole,
  inviteCohortId,
  inviteLoading,
  orgRoles,
  cohorts,
  onClose,
  onEmailChange,
  onRoleChange,
  onCohortChange,
  onSubmit,
}: InviteMemberModalProps) {
  return (
    <Modal isOpen={isOpen} onClose={onClose} maxWidthClass="max-w-md">
      <ModalHeader
        title="Invite New Member"
        description={`Issue a single-use invitation code to enter ${orgName}.`}
        onClose={onClose}
      />
      <form onSubmit={onSubmit} className="flex flex-col flex-1 overflow-hidden">
        <ModalBody>
          <div className="space-y-1.5">
            <label className="text-xs font-semibold text-foreground">Recipient Email</label>
            <Input
              type="email"
              placeholder="student@example.com"
              value={inviteEmail}
              onChange={(e) => onEmailChange(e.target.value)}
              required
              className="rounded-none text-xs"
            />
          </div>
          <div className="space-y-1.5">
            <label className="text-xs font-semibold text-foreground">Assigned Role</label>
            <Select value={inviteRole} onValueChange={onRoleChange}>
              <SelectTrigger className="w-full h-9 text-xs rounded-none">
                <SelectValue placeholder="Select a role" />
              </SelectTrigger>
              <SelectContent className="rounded-none">
                {orgRoles.length > 0 ? (
                  orgRoles
                    .filter((r) => r.slug !== "owner")
                    .map((r) => (
                      <SelectItem key={r.id} value={r.slug} className="rounded-none">
                        {r.name}
                      </SelectItem>
                    ))
                ) : (
                  <>
                    <SelectItem value="learner" className="rounded-none">
                      Learner (Student)
                    </SelectItem>
                    <SelectItem value="instructor" className="rounded-none">
                      Instructor
                    </SelectItem>
                    <SelectItem value="admin" className="rounded-none">
                      Administrator
                    </SelectItem>
                  </>
                )}
              </SelectContent>
            </Select>
          </div>
          <div className="space-y-1.5">
            <label className="text-xs font-semibold text-foreground">Target Cohort (Optional)</label>
            <Select
              value={inviteCohortId ? String(inviteCohortId) : "none"}
              onValueChange={(val) => onCohortChange(val === "none" ? null : parseInt(val, 10))}
            >
              <SelectTrigger className="w-full h-9 text-xs rounded-none">
                <SelectValue placeholder="Whole Organization (No specific cohort)" />
              </SelectTrigger>
              <SelectContent className="rounded-none">
                <SelectItem value="none" className="rounded-none">
                  Whole Organization (No specific cohort)
                </SelectItem>
                {cohorts.map((c) => (
                  <SelectItem key={c.id} value={String(c.id)} className="rounded-none">
                    {c.name}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
        </ModalBody>
        <ModalFooter>
          <Button
            type="button"
            variant="outline"
            onClick={onClose}
            className="rounded-none text-xs cursor-pointer gap-1.5"
          >
            <XCircle className="h-3.5 w-3.5" />
            <span>Cancel</span>
          </Button>
          <Button
            type="submit"
            disabled={inviteLoading}
            className="rounded-none bg-[var(--accent-primary)] text-white dark:text-black font-bold text-xs cursor-pointer gap-1.5"
          >
            <Mail className="h-3.5 w-3.5" />
            <span>{inviteLoading ? "Sending..." : "Send Invitation"}</span>
          </Button>
        </ModalFooter>
      </form>
    </Modal>
  );
}
