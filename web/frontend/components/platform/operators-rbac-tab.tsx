// web/frontend/components/platform/operators-rbac-tab.tsx

"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { Button } from "@/components/ui/button";
import { Plus, Shield, KeyRound, Trash2 } from "lucide-react";
import { PlatformUserPermissionSummary } from "@/lib/types";
import { ConfirmModal } from "@/components/shared/confirm-modal";
import { AddOperatorModal } from "./modals/add-operator-modal";
import { ConfigurePermsModal } from "./modals/configure-perms-modal";
import { usePlatformOperators } from "@/lib/platform/hooks/use-platform-operators";

interface OperatorsRbacTabProps {
  hasPerm: (perm: string) => boolean;
  currentUserId?: number;
  currentUsername?: string;
}

export function OperatorsRbacTab({
  hasPerm,
  currentUserId,
  currentUsername,
}: OperatorsRbacTabProps) {
  const router = useRouter();
  const {
    platformUsers,
    availablePermissions,
    addPlatformUser,
    updateUserPermissions,
    revokePlatformUser,
    loadOperatorsData,
  } = usePlatformOperators();

  const [showAddModal, setShowAddModal] = useState(false);
  const [selectedUserForPerms, setSelectedUserForPerms] = useState<PlatformUserPermissionSummary | null>(null);

  const [modalConfig, setModalConfig] = useState<{
    isOpen: boolean;
    title: string;
    message: string;
    confirmText?: string;
    type?: "danger" | "warning" | "info" | "success";
    onConfirm: () => void;
  }>({
    isOpen: false,
    title: "",
    message: "",
    onConfirm: () => {},
  });

  const handleAddSubmit = async (identity: string) => {
    const added = await addPlatformUser(identity);
    if (hasPerm("platform.permissions.manage") && added?.id) {
      router.push(`/platform/users/${added.id}`);
    }
  };

  const handleRevoke = (userId: number, username: string) => {
    if (currentUserId === userId || currentUsername === username) {
      alert("Self-Protection Guard: You cannot delete or revoke your own platform operator account.");
      return;
    }

    setModalConfig({
      isOpen: true,
      title: "Revoke Platform Operator Access",
      message: `Are you sure you want to revoke all platform permissions for '${username}'? They will lose access to global governance operations.`,
      confirmText: "Revoke Access",
      type: "danger",
      onConfirm: async () => {
        setModalConfig((prev) => ({ ...prev, isOpen: false }));
        try {
          await revokePlatformUser(userId);
        } catch (err: any) {
          alert("Error revoking operator: " + err.message);
        }
      },
    });
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between gap-4 flex-wrap">
        <div>
          <h3 className="font-bold text-lg text-foreground">Platform Operators & RBAC</h3>
          <p className="text-xs text-muted-foreground mt-0.5">
            Granular permission management for platform governance. No rigid role archetypes.
          </p>
        </div>

        {(hasPerm("platform.users.manage") || hasPerm("platform.permissions.manage")) && (
          <Button
            size="sm"
            onClick={() => setShowAddModal(true)}
            className="rounded-none bg-[var(--accent-primary)] text-white dark:text-black hover:opacity-90 font-bold text-xs gap-1.5 cursor-pointer"
          >
            <Plus className="h-3.5 w-3.5" />
            <span>Add Platform User</span>
          </Button>
        )}
      </div>

      {/* Single-Column Open Matrix with Continuous Horizontal Lines */}
      <div className="relative overflow-visible">
        <div className="flex flex-col relative">
          {platformUsers.map((pUser, pIdx) => {
            const isSelf = currentUserId === pUser.id || currentUsername === pUser.username;
            const isLast = pIdx === platformUsers.length - 1;

            return (
              <div key={pUser.id} className="relative">
                <div className="p-2.5 sm:p-3 text-left border-0">
                  {/* Frameless Idle (No row-level hover) */}
                  <div
                    className="p-4 sm:p-5 rounded-none flex items-center justify-between gap-4 flex-wrap sm:flex-nowrap"
                    style={{
                      border: "none",
                      boxShadow: "none",
                      backgroundColor: "transparent",
                    }}
                  >
                    <div className="flex items-center gap-3">
                      <div className="h-10 w-10 rounded-none bg-purple-500/10 text-purple-400 flex items-center justify-center font-bold shrink-0">
                        <Shield className="h-5 w-5" />
                      </div>
                      <div>
                        <div className="flex items-center gap-2">
                          <h4 className="font-bold text-xs text-foreground">{pUser.username}</h4>
                          {isSelf && (
                            <span className="text-[9px] font-mono px-2 py-0.5 rounded-none bg-amber-500/10 text-amber-500 dark:text-amber-400 border border-amber-500/20 font-bold uppercase">
                              You
                            </span>
                          )}
                        </div>
                        <p className="text-[11px] text-muted-foreground font-mono">{pUser.email}</p>
                        <div className="flex items-center gap-1.5 mt-1.5 flex-wrap">
                          <span className="text-[11px] font-mono font-medium text-muted-foreground">
                            {pUser.permissions.length} active permissions:
                          </span>
                          {pUser.permissions.slice(0, 3).map((pk) => (
                            <span
                              key={pk}
                              className="text-[10px] font-mono font-medium px-2 py-0.5 rounded-none bg-muted text-foreground border border-border"
                            >
                              {pk.replace("platform.", "")}
                            </span>
                          ))}
                          {pUser.permissions.length > 3 && (
                            <span className="text-[10px] font-mono text-muted-foreground font-medium">
                              +{pUser.permissions.length - 3} more
                            </span>
                          )}
                        </div>
                      </div>
                    </div>

                    <div className="flex items-center gap-2 shrink-0">
                      {hasPerm("platform.permissions.manage") && (
                        <Button
                          variant="outline"
                          size="sm"
                          onClick={() => router.push(`/platform/users/${pUser.id}`)}
                          className="text-xs font-semibold gap-1.5 h-9 px-3.5 cursor-pointer rounded-none border-border"
                        >
                          <KeyRound className="h-3.5 w-3.5 text-[var(--accent-primary)]" />
                          <span>Configure Permissions</span>
                        </Button>
                      )}

                      {hasPerm("platform.permissions.manage") && (
                        <Button
                          variant="ghost"
                          size="sm"
                          disabled={isSelf}
                          onClick={() => !isSelf && handleRevoke(pUser.id, pUser.username)}
                          className="h-9 px-3.5 text-xs font-semibold text-red-500 hover:text-red-400 hover:bg-red-500/10 cursor-pointer rounded-none gap-1.5 disabled:opacity-40 disabled:cursor-not-allowed"
                          title={isSelf ? "You cannot delete your own account" : "Delete User"}
                        >
                          <Trash2 className="h-3.5 w-3.5" />
                          <span>Delete User</span>
                        </Button>
                      )}
                    </div>
                  </div>
                </div>

                {/* Continuous Horizontal Line */}
                {!isLast && (
                  <div className="matrix-line-h bottom-0" />
                )}
              </div>
            );
          })}
        </div>
      </div>

      {/* Add Operator Modal */}
      <AddOperatorModal
        isOpen={showAddModal}
        onClose={() => setShowAddModal(false)}
        onSubmit={handleAddSubmit}
      />

      {/* Quick Permissions Modal */}
      <ConfigurePermsModal
        operator={selectedUserForPerms}
        availablePermissions={availablePermissions}
        onClose={() => setSelectedUserForPerms(null)}
        onSave={updateUserPermissions}
      />

      {/* Revoke Confirmation Modal */}
      <ConfirmModal
        isOpen={modalConfig.isOpen}
        title={modalConfig.title}
        message={modalConfig.message}
        confirmText={modalConfig.confirmText}
        type={modalConfig.type}
        onConfirm={modalConfig.onConfirm}
        onCancel={() => setModalConfig((prev) => ({ ...prev, isOpen: false }))}
      />
    </div>
  );
}

