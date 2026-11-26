"use client";

import React from "react";
import { XCircle } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Modal, ModalBody, ModalFooter, ModalHeader } from "@/components/shared/modal";

interface RejectRequestModalProps {
  isOpen: boolean;
  reason: string;
  onReasonChange: (value: string) => void;
  onClose: () => void;
  onConfirm: () => void;
}

export function RejectRequestModal({
  isOpen,
  reason,
  onReasonChange,
  onClose,
  onConfirm,
}: RejectRequestModalProps) {
  return (
    <Modal isOpen={isOpen} onClose={onClose} maxWidthClass="max-w-sm">
      <ModalHeader
        title="Reject Access Request"
        description="Provide an optional reason for the applicant."
        onClose={onClose}
      />
      <ModalBody>
        <Input
          placeholder="Reason (optional)"
          value={reason}
          onChange={(e) => onReasonChange(e.target.value)}
          className="rounded-none text-xs"
        />
      </ModalBody>
      <ModalFooter>
        <Button
          variant="outline"
          onClick={onClose}
          className="rounded-none text-xs cursor-pointer gap-1.5"
        >
          <XCircle className="h-3.5 w-3.5" />
          <span>Cancel</span>
        </Button>
        <Button
          onClick={onConfirm}
          className="rounded-none bg-destructive text-destructive-foreground font-bold text-xs cursor-pointer gap-1.5"
        >
          <XCircle className="h-3.5 w-3.5" />
          <span>Confirm Rejection</span>
        </Button>
      </ModalFooter>
    </Modal>
  );
}
