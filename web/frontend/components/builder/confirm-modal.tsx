// web/frontend/components/builder/confirm-modal.tsx

"use client";

import { X, ShieldAlert, AlertTriangle, Info } from "lucide-react";

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
      confirmBtn: "bg-red-500 hover:bg-red-600",
    },
    warning: {
      bgIcon: "bg-amber-500/10 border-amber-500/20",
      textIcon: "text-amber-400",
      confirmBtn: "bg-[var(--accent-primary)] hover:opacity-90 text-black",
    },
    info: {
      bgIcon: "bg-blue-500/10 border-blue-500/20",
      textIcon: "text-blue-400",
      confirmBtn: "bg-zinc-800 hover:bg-zinc-700",
    },
    success: {
      bgIcon: "bg-emerald-500/10 border-emerald-500/20",
      textIcon: "text-emerald-400",
      confirmBtn: "bg-emerald-500 hover:bg-emerald-600",
    },
  };

  const style = colorStyles[type] || colorStyles.warning;

  return (
    <div className="fixed inset-0 z-[100] flex items-center justify-center bg-black/70 backdrop-blur-sm p-4">
      <div className="w-full max-w-sm rounded-2xl border border-border bg-card shadow-2xl p-5 relative flex flex-col animate-in fade-in zoom-in-95 duration-200">
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
          <div className={`w-10 h-10 rounded-xl border flex items-center justify-center shrink-0 ${style.bgIcon}`}>
            {type === "danger" && <ShieldAlert className={`h-5 w-5 ${style.textIcon}`} />}
            {type === "warning" && <AlertTriangle className={`h-5 w-5 ${style.textIcon}`} />}
            {type === "info" && <Info className={`h-5 w-5 ${style.textIcon}`} />}
            {type === "success" && <Info className={`h-5 w-5 ${style.textIcon}`} />}
          </div>
          <div className="space-y-1">
            <h3 className="font-black text-sm text-foreground">{title}</h3>
            <p className="text-xs text-muted-foreground leading-relaxed whitespace-pre-line">{message}</p>
          </div>
        </div>

        {/* Action Buttons */}
        <div className="flex items-center justify-end gap-2.5 mt-3 pt-3 border-t border-border/40">
          {onCancel && (
            <button
              onClick={onCancel}
              className="px-4 py-2 rounded-xl text-xs font-bold border border-border text-foreground hover:bg-muted transition-colors cursor-pointer"
            >
              {cancelText}
            </button>
          )}
          <button
            onClick={() => {
              onConfirm();
            }}
            className={`px-4 py-2 rounded-xl text-xs font-bold text-white transition-all cursor-pointer ${style.confirmBtn}`}
          >
            {confirmText}
          </button>
        </div>
      </div>
    </div>
  );
}
