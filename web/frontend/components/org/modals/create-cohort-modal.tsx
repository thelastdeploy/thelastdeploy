"use client";

import React from "react";
import { Plus, XCircle } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { DatePicker } from "@/components/ui/date-picker";
import { Modal, ModalBody, ModalFooter, ModalHeader } from "@/components/shared/modal";

interface CreateCohortModalProps {
  isOpen: boolean;
  cohortName: string;
  cohortDesc: string;
  cohortStartsAt: string;
  cohortEndsAt: string;
  cohortLoading: boolean;
  onClose: () => void;
  onNameChange: (value: string) => void;
  onDescChange: (value: string) => void;
  onStartsAtChange: (value: string) => void;
  onEndsAtChange: (value: string) => void;
  onSubmit: (e: React.FormEvent) => void;
}

export function CreateCohortModal({
  isOpen,
  cohortName,
  cohortDesc,
  cohortStartsAt,
  cohortEndsAt,
  cohortLoading,
  onClose,
  onNameChange,
  onDescChange,
  onStartsAtChange,
  onEndsAtChange,
  onSubmit,
}: CreateCohortModalProps) {
  return (
    <Modal isOpen={isOpen} onClose={onClose} maxWidthClass="max-w-md">
      <ModalHeader
        title="Create Student Cohort"
        description="Group students into a specific class or time-bound batch."
        onClose={onClose}
      />
      <form onSubmit={onSubmit} className="flex flex-col flex-1 overflow-hidden">
        <ModalBody>
          <div className="space-y-1.5">
            <label className="text-xs font-semibold text-foreground">Cohort Name</label>
            <Input
              placeholder="e.g. Fall 2026 DevOps Batch A"
              value={cohortName}
              onChange={(e) => onNameChange(e.target.value)}
              required
              className="rounded-none text-xs"
            />
          </div>
          <div className="space-y-1.5">
            <label className="text-xs font-semibold text-foreground">Description</label>
            <Input
              placeholder="e.g. Computer Science seniors containerization track"
              value={cohortDesc}
              onChange={(e) => onDescChange(e.target.value)}
              className="rounded-none text-xs"
            />
          </div>
          <div className="grid grid-cols-2 gap-3">
            <div className="space-y-1.5">
              <label className="text-xs font-semibold text-foreground">Start Date</label>
              <DatePicker
                value={cohortStartsAt}
                onChange={onStartsAtChange}
                placeholder="Select start date"
              />
            </div>
            <div className="space-y-1.5">
              <label className="text-xs font-semibold text-foreground">End Date</label>
              <DatePicker
                value={cohortEndsAt}
                onChange={onEndsAtChange}
                placeholder="Select end date"
              />
            </div>
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
            disabled={cohortLoading}
            className="rounded-none bg-[var(--accent-primary)] text-white dark:text-black font-bold text-xs cursor-pointer gap-1.5"
          >
            <Plus className="h-3.5 w-3.5" />
            <span>{cohortLoading ? "Creating..." : "Create Cohort"}</span>
          </Button>
        </ModalFooter>
      </form>
    </Modal>
  );
}
