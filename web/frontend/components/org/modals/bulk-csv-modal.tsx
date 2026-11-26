"use client";

import React from "react";
import { Upload, XCircle } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Modal, ModalBody, ModalFooter, ModalHeader } from "@/components/shared/modal";
import type { CohortResponse } from "@/lib/types";

interface BulkCsvModalProps {
  isOpen: boolean;
  bulkFile: File | null;
  bulkLoading: boolean;
  bulkResult: { successful: number; skipped_existing: number; failed: number } | null;
  inviteCohortId: number | null;
  cohorts: CohortResponse[];
  onClose: () => void;
  onFileChange: (file: File | null) => void;
  onCohortChange: (cohortId: number | null) => void;
  onSubmit: (e: React.FormEvent) => void;
}

export function BulkCsvModal({
  isOpen,
  bulkFile,
  bulkLoading,
  bulkResult,
  inviteCohortId,
  cohorts,
  onClose,
  onFileChange,
  onCohortChange,
  onSubmit,
}: BulkCsvModalProps) {
  return (
    <Modal isOpen={isOpen} onClose={onClose} maxWidthClass="max-w-lg">
      <ModalHeader
        title="Bulk CSV Invitations"
        description={
          <>
            Upload a CSV file containing an <code>email</code> column to batch invite students.
          </>
        }
        onClose={onClose}
      />
      <form onSubmit={onSubmit} className="flex flex-col flex-1 overflow-hidden">
        <ModalBody>
          <div className="border-2 border-dashed border-border rounded-none p-6 text-center space-y-2">
            <Upload className="h-8 w-8 text-muted-foreground mx-auto" />
            <div className="text-xs text-foreground font-semibold">Select CSV file</div>
            <input
              type="file"
              accept=".csv"
              onChange={(e) => {
                if (e.target.files && e.target.files[0]) onFileChange(e.target.files[0]);
              }}
              required
              className="text-xs text-muted-foreground mx-auto block"
            />
          </div>

          <div className="space-y-1.5">
            <label className="text-xs font-semibold text-foreground">
              Target Cohort (Optional)
            </label>
            <Select
              value={inviteCohortId ? String(inviteCohortId) : "none"}
              onValueChange={(val) => onCohortChange(val === "none" ? null : parseInt(val, 10))}
            >
              <SelectTrigger className="w-full h-9 text-xs rounded-none">
                <SelectValue placeholder="Whole Organization" />
              </SelectTrigger>
              <SelectContent className="rounded-none">
                <SelectItem value="none" className="rounded-none">
                  Whole Organization
                </SelectItem>
                {cohorts.map((c) => (
                  <SelectItem key={c.id} value={String(c.id)} className="rounded-none">
                    {c.name}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          {bulkResult && (
            <div className="p-3 rounded-none bg-muted/40 border border-border text-xs space-y-2">
              <div className="font-bold text-foreground">Results Summary:</div>
              <div className="grid grid-cols-3 gap-2 text-center">
                <div className="p-2 rounded-none bg-emerald-500/10 text-emerald-400 font-bold">
                  {bulkResult.successful} Sent
                </div>
                <div className="p-2 rounded-none bg-amber-500/10 text-amber-400 font-bold">
                  {bulkResult.skipped_existing} Existing
                </div>
                <div className="p-2 rounded-none bg-destructive/10 text-destructive font-bold">
                  {bulkResult.failed} Invalid
                </div>
              </div>
            </div>
          )}
        </ModalBody>
        <ModalFooter>
          <Button
            type="button"
            variant="outline"
            onClick={onClose}
            className="rounded-none text-xs cursor-pointer gap-1.5"
          >
            <XCircle className="h-3.5 w-3.5" />
            <span>Close</span>
          </Button>
          <Button
            type="submit"
            disabled={bulkLoading || !bulkFile}
            className="rounded-none bg-[var(--accent-primary)] text-white dark:text-black font-bold text-xs cursor-pointer gap-1.5"
          >
            <Upload className="h-3.5 w-3.5" />
            <span>{bulkLoading ? "Processing..." : "Process Batch"}</span>
          </Button>
        </ModalFooter>
      </form>
    </Modal>
  );
}
