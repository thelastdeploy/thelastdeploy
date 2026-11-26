"use client";

import React from "react";
import { Check, Lock } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { MatrixCheckbox } from "@/components/ui/matrix-checkbox";
import { Modal, ModalBody, ModalFooter, ModalHeader } from "@/components/shared/modal";
import type { OrgPermissionItem, OrgRole } from "@/lib/types";

interface RoleEditorModalProps {
  isOpen: boolean;
  editingRole: OrgRole | null;
  roleFormName: string;
  roleFormDesc: string;
  roleFormPerms: string[];
  roleFormSaving: boolean;
  roleFormError: string | null;
  orgPermissions: OrgPermissionItem[];
  onClose: () => void;
  onNameChange: (value: string) => void;
  onDescChange: (value: string) => void;
  onTogglePerm: (key: string) => void;
  onSubmit: (e: React.FormEvent) => void;
}

export function RoleEditorModal({
  isOpen,
  editingRole,
  roleFormName,
  roleFormDesc,
  roleFormPerms,
  roleFormSaving,
  roleFormError,
  orgPermissions,
  onClose,
  onNameChange,
  onDescChange,
  onTogglePerm,
  onSubmit,
}: RoleEditorModalProps) {
  return (
    <Modal isOpen={isOpen} onClose={onClose} maxWidthClass="max-w-lg" className="max-h-[88vh]">
      <ModalHeader
        title={editingRole ? `Edit Role: ${editingRole.name}` : "Create Custom Role"}
        description={
          editingRole
            ? "Rename this role or customize which granular permissions it grants."
            : "Define a new organization role and select its permissions."
        }
        onClose={onClose}
      />
      <form onSubmit={onSubmit} className="flex flex-col flex-1 overflow-hidden">
        <ModalBody>
          {roleFormError && (
            <div className="p-3 bg-red-500/10 border border-red-500/20 text-red-400 text-xs">
              {roleFormError}
            </div>
          )}
          <div className="space-y-1.5">
            <label className="text-xs font-semibold text-foreground">Role Name</label>
            <Input
              value={roleFormName}
              onChange={(e) => onNameChange(e.target.value)}
              placeholder="e.g. Cohort Manager"
              required
              className="rounded-none text-xs h-9"
            />
          </div>
          <div className="space-y-1.5">
            <label className="text-xs font-semibold text-foreground">
              Description (Optional)
            </label>
            <Input
              value={roleFormDesc}
              onChange={(e) => onDescChange(e.target.value)}
              placeholder="Short summary of what this role manages"
              className="rounded-none text-xs h-9"
            />
          </div>
          <div className="space-y-2">
            <label className="text-xs font-semibold text-foreground">
              Permissions ({roleFormPerms.length} selected)
            </label>
            <div className="border border-border divide-y divide-border max-h-64 overflow-y-auto">
              {orgPermissions.length === 0 ? (
                <div className="p-4 text-xs text-muted-foreground font-mono">
                  You need &apos;roles.manage&apos; permission to view and assign permissions.
                </div>
              ) : (
                orgPermissions.map((perm) => {
                  const checked = roleFormPerms.includes(perm.key);
                  const isLockedRolesManage =
                    Boolean(editingRole) &&
                    perm.key === "roles.manage" &&
                    checked &&
                    editingRole?.can_remove_roles_manage === false;
                  return (
                    <div
                      key={perm.key}
                      onClick={() => !isLockedRolesManage && onTogglePerm(perm.key)}
                      className={`flex items-start gap-3 p-3 transition-colors ${
                        isLockedRolesManage
                          ? "opacity-75 cursor-not-allowed bg-muted/20"
                          : "cursor-pointer hover:bg-muted/30"
                      }`}
                    >
                      <MatrixCheckbox
                        size="sm"
                        checked={checked}
                        disabled={isLockedRolesManage}
                        onCheckedChange={() => !isLockedRolesManage && onTogglePerm(perm.key)}
                        className="mt-0.5"
                      />
                      <div className="min-w-0 flex-1">
                        <div className="flex items-center gap-2 flex-wrap">
                          <span className="font-mono text-xs font-semibold text-foreground">
                            {perm.key}
                          </span>
                          {isLockedRolesManage && (
                            <span className="inline-flex items-center gap-1 text-[10px] font-mono px-1.5 py-0.5 bg-amber-500/10 text-amber-500 border border-amber-500/20">
                              <Lock className="h-2.5 w-2.5" />
                              {editingRole?.is_caller_role
                                ? "Locked (Your Role)"
                                : "Locked (Last Critical Role)"}
                            </span>
                          )}
                        </div>
                        <div className="text-[11px] text-muted-foreground">
                          {perm.description}
                        </div>
                      </div>
                    </div>
                  );
                })
              )}
            </div>
          </div>
        </ModalBody>
        <ModalFooter>
          <Button
            type="button"
            variant="outline"
            onClick={onClose}
            className="rounded-none border-border text-xs h-9 cursor-pointer"
          >
            Cancel
          </Button>
          <Button
            type="submit"
            disabled={roleFormSaving}
            className="rounded-none bg-[var(--accent-primary)] text-white dark:text-black font-bold text-xs h-9 cursor-pointer gap-1.5"
          >
            <Check className="h-3.5 w-3.5" />
            <span>
              {roleFormSaving ? "Saving..." : editingRole ? "Save Changes" : "Create Role"}
            </span>
          </Button>
        </ModalFooter>
      </form>
    </Modal>
  );
}
