"use client";

import React from "react";
import { Pencil, Plus, Trash2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import type { OrgRole } from "@/lib/types";

interface OrgRolesTabProps {
  orgRoles: OrgRole[];
  rolesLoading: boolean;
  onCreateRole: () => void;
  onEditRole: (role: OrgRole) => void;
  onDeleteRole: (role: OrgRole) => void;
}

export function OrgRolesTab({
  orgRoles,
  rolesLoading,
  onCreateRole,
  onEditRole,
  onDeleteRole,
}: OrgRolesTabProps) {
  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h3 className="text-sm font-bold text-foreground">
            Organization Roles &amp; Permissions
          </h3>
          <p className="text-xs text-muted-foreground">
            Create custom roles with granular permissions or rename default roles for your
            organization.
          </p>
        </div>
        <Button
          size="sm"
          onClick={onCreateRole}
          className="rounded-none bg-[var(--accent-primary)] text-white dark:text-black font-bold text-xs gap-1.5 cursor-pointer h-9"
        >
          <Plus className="h-3.5 w-3.5" />
          <span>Create Role</span>
        </Button>
      </div>

      {rolesLoading ? (
        <div className="py-12 text-center text-xs text-muted-foreground font-mono">
          Loading roles...
        </div>
      ) : (
        <div className="border-y border-border/60 divide-y divide-border/50">
          {orgRoles.map((role) => (
            <div key={role.id} className="py-5 px-2 hover:bg-muted/20 transition-colors">
              <div className="flex flex-col sm:flex-row sm:items-start justify-between gap-4">
                <div className="space-y-2 flex-1 min-w-0">
                  <div className="flex items-center gap-2 flex-wrap">
                    <h4 className="font-bold text-sm text-foreground">{role.name}</h4>
                    <span className="text-[10px] font-mono px-2 py-0.5 bg-muted text-muted-foreground">
                      {role.slug}
                    </span>
                    <span className="text-[11px] font-mono text-muted-foreground">
                      {role.member_count} {role.member_count === 1 ? "member" : "members"}
                    </span>
                  </div>
                  {role.description && (
                    <p className="text-xs text-muted-foreground">{role.description}</p>
                  )}
                </div>

                <div className="flex items-center gap-2 shrink-0">
                  <Button
                    variant="outline"
                    size="sm"
                    onClick={() => onEditRole(role)}
                    className="rounded-none border-border h-8 px-3 text-xs font-semibold gap-1.5 cursor-pointer"
                  >
                    <Pencil className="h-3 w-3" />
                    <span>Edit</span>
                  </Button>
                  <Button
                    variant="ghost"
                    size="sm"
                    disabled={role.can_delete === false}
                    onClick={() => onDeleteRole(role)}
                    title={
                      role.is_caller_role
                        ? "You cannot delete your own role"
                        : role.member_count > 0
                        ? "Reassign members before deleting this role"
                        : role.can_delete === false
                        ? "Cannot delete the last role holding 'roles.manage' or the last role in the org"
                        : "Delete role"
                    }
                    className="rounded-none h-8 px-3 text-xs font-semibold text-red-500 hover:text-red-400 hover:bg-red-500/10 cursor-pointer gap-1.5 disabled:opacity-40 disabled:cursor-not-allowed"
                  >
                    <Trash2 className="h-3.5 w-3.5" />
                    <span>Delete</span>
                  </Button>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
