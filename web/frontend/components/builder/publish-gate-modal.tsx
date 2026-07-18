// web/frontend/components/builder/publish-gate-modal.tsx

"use client";

import { X, ShieldAlert, Award, Loader2, CheckCircle2 } from "lucide-react";
import { BuilderModuleInput } from "@/lib/types";

interface Props {
  isOpen: boolean;
  onClose: () => void;
  onConfirm: () => void;
  draft: BuilderModuleInput;
  publishing: boolean;
}

export function PublishGateModal({ isOpen, onClose, onConfirm, draft, publishing }: Props) {
  if (!isOpen) return null;

  // Run validation checks client-side
  const errors: string[] = [];
  if (!draft.title.trim()) {
    errors.push("Module title is required.");
  }
  if (draft.sections.length === 0) {
    errors.push("At least one section is required to publish.");
  }

  draft.sections.forEach((s) => {
    if (!s.title.trim()) {
      errors.push("All sections must have a title.");
    }
    if (!s.content || !s.content.trim()) {
      errors.push(`Section '${s.title || "Untitled"}' is missing learning content.`);
    }
    s.labs.forEach((lab) => {
      if (lab.xp <= 0) {
        errors.push(`Lab '${lab.title || lab.id}' must reward more than 0 XP.`);
      }
      if (!lab.validator_script || !lab.validator_script.trim()) {
        errors.push(`Lab '${lab.title || lab.id}' is missing a validator script.`);
      }
    });
  });

  const totalSections = draft.sections.length;
  const totalXp = draft.sections.reduce((sum, s) => sum + s.xp, 0);

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm p-4">
      <div className="w-full max-w-lg rounded-2xl border border-border bg-card shadow-2xl p-6 relative flex flex-col max-h-[90vh]">
        {/* Close Button */}
        <button
          onClick={onClose}
          className="absolute top-4 right-4 text-muted-foreground hover:text-foreground transition-colors cursor-pointer"
        >
          <X className="h-5 w-5" />
        </button>

        {/* Modal Header */}
        <div className="flex items-center gap-3 mb-6">
          <div className="w-10 h-10 rounded-xl bg-amber-500/10 border border-amber-500/20 flex items-center justify-center shrink-0">
            <ShieldAlert className="h-5 w-5 text-amber-400" />
          </div>
          <div>
            <h3 className="font-black text-lg text-foreground">Publish Module</h3>
            <p className="text-xs text-muted-foreground">Pre-publish validation gate & summary</p>
          </div>
        </div>

        {/* Modal Body */}
        <div className="flex-1 overflow-y-auto min-h-0 space-y-6 pr-1">
          {errors.length > 0 ? (
            <div className="space-y-3">
              <div className="p-4 rounded-xl bg-rose-500/10 border border-rose-500/20 text-rose-400 text-sm">
                <p className="font-bold mb-1.5 flex items-center gap-1.5">
                  <ShieldAlert className="h-4 w-4 shrink-0" />
                  Please fix the following validation errors:
                </p>
                <ul className="list-disc pl-5 space-y-1 text-xs text-rose-300/90 font-mono">
                  {errors.map((err, i) => (
                    <li key={i}>{err}</li>
                  ))}
                </ul>
              </div>
            </div>
          ) : (
            <div className="space-y-4">
              <div className="p-4 rounded-xl bg-emerald-500/10 border border-emerald-500/20 text-emerald-400 text-sm">
                <p className="font-bold flex items-center gap-1.5">
                  <CheckCircle2 className="h-4 w-4 shrink-0" />
                  All publication checks passed!
                </p>
              </div>

              {/* Module Summary */}
              <div className="border border-border rounded-xl bg-muted/40 p-4 space-y-3">
                <p className="font-bold text-xs uppercase tracking-wider text-muted-foreground">Module Summary</p>
                <div className="grid grid-cols-2 gap-4 text-center">
                  <div className="bg-background rounded-xl p-3 border border-border/60">
                    <p className="text-xs text-muted-foreground font-semibold">Sections</p>
                    <p className="text-lg font-black text-foreground mt-0.5">{totalSections}</p>
                  </div>
                  <div className="bg-background rounded-xl p-3 border border-border/60">
                    <p className="text-xs text-muted-foreground font-semibold">Total XP</p>
                    <p className="text-lg font-black text-[var(--accent-primary)] mt-0.5">+{totalXp}</p>
                  </div>
                </div>
              </div>

              <div className="text-sm text-muted-foreground leading-relaxed bg-muted/20 border border-border p-4 rounded-xl">
                <p className="font-bold text-foreground mb-1">What happens next?</p>
                <ul className="list-decimal pl-4 space-y-1.5 text-xs text-muted-foreground/90">
                  <li>Your module status becomes <span className="font-bold text-amber-400">Published</span> and goes live for all users instantly.</li>
                  <li>Users completing this module will earn <span className="font-bold text-[var(--accent-primary)]">Pending XP</span> until verified.</li>
                  <li>Once verified by a platform maintainer, this module receives a Verified badge, and all users' progress is converted to verified XP.</li>
                </ul>
              </div>
            </div>
          )}
        </div>

        {/* Modal Footer */}
        <div className="mt-6 pt-4 border-t border-border flex items-center justify-end gap-3 shrink-0">
          <button
            onClick={onClose}
            className="px-4 py-2 rounded-xl text-sm font-bold border border-border text-foreground hover:bg-muted transition-colors cursor-pointer"
          >
            Cancel
          </button>
          {errors.length === 0 && (
            <button
              onClick={onConfirm}
              disabled={publishing}
              className="flex items-center gap-1.5 px-5 py-2 rounded-xl text-sm font-bold text-white bg-[var(--accent-primary)] hover:opacity-90 transition-opacity disabled:opacity-50 cursor-pointer"
            >
              {publishing ? (
                <>
                  <Loader2 className="h-4 w-4 animate-spin" /> Publishing...
                </>
              ) : (
                <>
                  <Award className="h-4 w-4" /> Publish Now
                </>
              )}
            </button>
          )}
        </div>
      </div>
    </div>
  );
}
