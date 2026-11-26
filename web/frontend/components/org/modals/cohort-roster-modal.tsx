"use client";

import React from "react";
import { Modal, ModalBody, ModalHeader } from "@/components/shared/modal";
import type { CohortMemberResponse, CohortResponse } from "@/lib/types";

interface CohortRosterModalProps {
  cohort: CohortResponse | null;
  roster: CohortMemberResponse[];
  loading: boolean;
  onClose: () => void;
}

export function CohortRosterModal({
  cohort,
  roster,
  loading,
  onClose,
}: CohortRosterModalProps) {
  return (
    <Modal isOpen={Boolean(cohort)} onClose={onClose} maxWidthClass="max-w-2xl">
      <ModalHeader
        title={`${cohort?.name ?? ""} — Student Roster`}
        description="Enrolled students in this cohort."
        onClose={onClose}
      />
      <ModalBody>
        {loading ? (
          <div className="py-8 text-center text-xs font-mono text-muted-foreground animate-pulse">
            Loading cohort roster...
          </div>
        ) : roster.length === 0 ? (
          <div className="py-8 text-center text-xs text-muted-foreground font-mono">
            No students enrolled in this cohort yet.
          </div>
        ) : (
          <div className="border border-border overflow-hidden">
            <table className="w-full text-left text-xs">
              <thead className="text-[10px] uppercase font-mono text-muted-foreground bg-muted/30">
                <tr>
                  <th className="py-2.5 px-3">Student</th>
                  <th className="py-2.5 px-3">Total XP</th>
                  <th className="py-2.5 px-3">Joined</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-border/50">
                {roster.map((st) => (
                  <tr key={st.cohort_membership_id} className="hover:bg-muted/20">
                    <td className="py-2.5 px-3">
                      <div className="font-bold text-foreground">{st.username}</div>
                      <div className="text-[11px] font-mono text-muted-foreground">{st.email}</div>
                    </td>
                    <td className="py-2.5 px-3 font-mono font-bold text-[var(--accent-primary)]">
                      {st.total_xp} XP
                    </td>
                    <td className="py-2.5 px-3 font-mono text-[11px] text-muted-foreground">
                      {new Date(st.joined_at).toLocaleDateString()}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </ModalBody>
    </Modal>
  );
}
