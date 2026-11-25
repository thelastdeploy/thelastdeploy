// web/frontend/components/platform/modals/configure-perms-modal.tsx

"use client";

import { useState, useEffect } from "react";
import { Button } from "@/components/ui/button";
import { PlatformUserPermissionSummary, PlatformPermissionItem } from "@/lib/types";
import { X, Check } from "lucide-react";

interface ConfigurePermsModalProps {
  operator: PlatformUserPermissionSummary | null;
  availablePermissions: PlatformPermissionItem[];
  onClose: () => void;
  onSave: (userId: number, permissions: string[]) => Promise<void>;
}

export function ConfigurePermsModal({
  operator,
  availablePermissions,
  onClose,
  onSave,
}: ConfigurePermsModalProps) {
  const [draftPerms, setDraftPerms] = useState<string[]>([]);
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    if (operator) {
      setDraftPerms([...operator.permissions]);
    }
  }, [operator]);

  if (!operator) return null;

  const handleToggle = (permKey: string) => {
    setDraftPerms((prev) =>
      prev.includes(permKey) ? prev.filter((k) => k !== permKey) : [...prev, permKey]
    );
  };

  const handleSave = async () => {
    setSaving(true);
    try {
      await onSave(operator.id, draftPerms);
      onClose();
    } catch (err: any) {
      alert("Failed to update permissions: " + err.message);
    } finally {
      setSaving(false);
    }
  };

  return (
    <div className="fixed inset-0 z-50 bg-black/70 backdrop-blur-sm flex items-center justify-center p-4">
      <div className="max-w-xl w-full max-h-[85vh] flex flex-col rounded-none shadow-2xl border border-border bg-card overflow-hidden">
        <div className="p-6 pb-4 border-b border-border flex flex-row items-center justify-between shrink-0">
          <div>
            <h2 className="text-base font-bold text-foreground">
              Configure Permissions: {operator.username}
            </h2>
            <p className="text-xs text-muted-foreground mt-1">
              Toggle granular platform permissions. Enabled permissions take effect immediately.
            </p>
          </div>
          <Button
            variant="ghost"
            size="icon"
            onClick={onClose}
            className="h-8 w-8 rounded-none text-muted-foreground hover:text-foreground cursor-pointer"
          >
            <X className="h-4 w-4" />
          </Button>
        </div>

        <div className="p-6 overflow-y-auto space-y-3 flex-1">
          <div className="p-3 rounded-none bg-purple-500/10 border border-purple-500/20 text-purple-300 text-xs flex items-center justify-between">
            <div>
              <span className="font-bold block">Delegation Switch</span>
              <span className="text-[10px] text-purple-400/80">
                Granting <code>platform.permissions.manage</code> permits this user to configure permissions for others.
              </span>
            </div>
          </div>

          <div className="space-y-2">
            {availablePermissions.map((perm) => {
              const isChecked = draftPerms.includes(perm.key);
              const isDelegationPerm = perm.key === "platform.permissions.manage";

              return (
                <div
                  key={perm.key}
                  onClick={() => handleToggle(perm.key)}
                  className={`p-3 rounded-none border transition-all cursor-pointer flex items-center justify-between gap-3 ${
                    isChecked
                      ? isDelegationPerm
                        ? "bg-purple-500/10 border-purple-500/40"
                        : "bg-[var(--accent-primary)]/[0.05] border-[var(--accent-primary)]/40"
                      : "border-border bg-muted/10 hover:border-border/80"
                  }`}
                >
                  <div>
                    <div className="flex items-center gap-2">
                      <span className="font-bold text-xs text-foreground font-mono">{perm.key}</span>
                      {isDelegationPerm && (
                        <span className="text-[9px] font-mono px-1.5 py-0.5 rounded-none bg-purple-500/20 text-purple-300 font-bold uppercase">
                          Key Authority
                        </span>
                      )}
                    </div>
                    <p className="text-[11px] text-muted-foreground mt-0.5 leading-relaxed">
                      {perm.description}
                    </p>
                  </div>

                  <div
                    className={`h-5 w-5 rounded-none flex items-center justify-center shrink-0 border transition-all ${
                      isChecked
                        ? "bg-[var(--accent-primary)] border-[var(--accent-primary)] text-black"
                        : "border-border bg-card"
                    }`}
                  >
                    {isChecked && <Check className="h-3.5 w-3.5 stroke-[3]" />}
                  </div>
                </div>
              );
            })}
          </div>
        </div>

        <div className="p-4 border-t border-border bg-muted/20 flex items-center justify-between shrink-0">
          <span className="text-xs font-mono text-muted-foreground">
            {draftPerms.length} permissions active
          </span>
          <div className="flex items-center gap-2">
            <Button
              variant="outline"
              size="sm"
              onClick={onClose}
              className="rounded-none text-xs font-bold cursor-pointer"
            >
              Cancel
            </Button>
            <Button
              size="sm"
              onClick={handleSave}
              disabled={saving}
              className="rounded-none bg-[var(--accent-primary)] text-white dark:text-black font-bold text-xs cursor-pointer"
            >
              {saving ? "Saving..." : "Save Permissions"}
            </Button>
          </div>
        </div>
      </div>
    </div>
  );
}

