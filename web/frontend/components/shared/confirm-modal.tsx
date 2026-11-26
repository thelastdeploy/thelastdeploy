// web/frontend/components/shared/confirm-modal.tsx

"use client";

import { X, ShieldAlert, AlertTriangle, Info, Check, Trash2, Power } from "lucide-react";
import { Button } from "@/components/ui/button";

interface ConfirmModalProps {
  isOpen: boolean;
  title: string;
  message: string;
  onConfirm: () => void;
  onCancel?: () => void;
  confirmText?: string;
  cancelText?: string;
  type?: "danger" | "warning" | "info" | "success";
}

export function ConfirmModal({
  isOpen,
  title,
  message,
  onConfirm,
  onCancel,
  confirmText = "Confirm",
  cancelText = "Cancel",
  type = "warning",
}: ConfirmModalProps) {
  if (!isOpen) return null;

  const colorStyles = {
    danger: {
      bgIcon: "bg-red-500/10 border-red-500/20",
      textIcon: "text-red-400",
    },
    warning: {
      bgIcon: "bg-amber-500/10 border-amber-500/20",
      textIcon: "text-amber-400",
    },
    info: {
      bgIcon: "bg-blue-500/10 border-blue-500/20",
      textIcon: "text-blue-400",
    },
    success: {
      bgIcon: "bg-emerald-500/10 border-emerald-500/20",
      textIcon: "text-emerald-400",
    },
  };

  const style = colorStyles[type] || colorStyles.warning;

  // Determine contextual icon for confirm button
  const isSuspend = title.toLowerCase().includes("suspend") || confirmText.toLowerCase().includes("suspend");
  const isReactivate = title.toLowerCase().includes("reactivate") || confirmText.toLowerCase().includes("reactivate");
  const isDelete = type === "danger" || title.toLowerCase().includes("delete") || title.toLowerCase().includes("revoke");

  const ConfirmIcon = isSuspend || isReactivate ? Power : isDelete ? Trash2 : Check;

  return (
    <div className="fixed inset-0 z-[100] flex items-center justify-center bg-black/70 backdrop-blur-sm p-4">
      <div className="w-full max-w-sm rounded-none border border-border bg-card shadow-2xl p-6 relative flex flex-col animate-in fade-in zoom-in-95 duration-150">
        {/* Close Button */}
        {onCancel && (
          <button
            onClick={onCancel}
            className="absolute top-4 right-4 text-muted-foreground hover:text-foreground transition-colors cursor-pointer"
          >
            <X className="h-4 w-4" />
          </button>
        )}

        {/* Header Icon + Title */}
        <div className="flex items-start gap-3.5 mb-4">
          <div className={`w-10 h-10 rounded-none border flex items-center justify-center shrink-0 ${style.bgIcon}`}>
            {type === "danger" && <ShieldAlert className={`h-5 w-5 ${style.textIcon}`} />}
            {type === "warning" && <AlertTriangle className={`h-5 w-5 ${style.textIcon}`} />}
            {type === "info" && <Info className={`h-5 w-5 ${style.textIcon}`} />}
            {type === "success" && <Info className={`h-5 w-5 ${style.textIcon}`} />}
          </div>
          <div className="space-y-1">
            <h3 className="font-bold text-sm text-foreground">{title}</h3>
            <p className="text-xs text-muted-foreground leading-relaxed whitespace-pre-line">{message}</p>
          </div>
        </div>

        {/* Action Buttons */}
        <div className="flex items-center justify-end gap-2.5 mt-4 pt-3 border-t border-border/50">
          {onCancel && (
            <Button
              variant="outline"
              size="sm"
              onClick={onCancel}
              className="h-9 px-3.5 text-xs font-semibold text-muted-foreground hover:text-foreground rounded-none border-border cursor-pointer gap-1.5"
            >
              <X className="h-4 w-4" />
              <span>{cancelText}</span>
            </Button>
          )}
          <Button
            size="sm"
            onClick={onConfirm}
            className={`h-9 px-3.5 text-xs font-bold rounded-none cursor-pointer gap-1.5 ${
              type === "danger"
                ? "bg-red-600 text-white hover:bg-red-700"
                : isReactivate
                ? "bg-emerald-600 text-white hover:bg-emerald-700"
                : "bg-[var(--accent-primary)] text-white dark:text-black hover:opacity-90"
            }`}
          >
            <ConfirmIcon className="h-4 w-4" />
            <span>{confirmText}</span>
          </Button>
        </div>
      </div>
    </div>
  );
}
