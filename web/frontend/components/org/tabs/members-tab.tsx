"use client";

import React from "react";
import { RotateCcw, Save, Search, Trash2, UserPlus, X } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { DatePicker } from "@/components/ui/date-picker";
import { MatrixCheckbox } from "@/components/ui/matrix-checkbox";
import type { OrganizationMemberResponse, OrgRole } from "@/lib/types";

interface OrgMembersTabProps {
  members: OrganizationMemberResponse[];
  filteredMembers: OrganizationMemberResponse[];
  orgRoles: OrgRole[];
  currentUserId?: number;
  memberSearch: string;
  memberRoleFilter: string;
  memberJoinedFrom: string;
  memberJoinedTo: string;
  draftRoles: Record<number, string>;
  pendingRoleCount: number;
  savingMemberRoles: boolean;
  selectedMemberIds: number[];
  bulkRoleTarget: string;
  onSearchChange: (value: string) => void;
  onRoleFilterChange: (value: string) => void;
  onJoinedFromChange: (value: string) => void;
  onJoinedToChange: (value: string) => void;
  onClearFilters: () => void;
  onDraftRoleChange: (userId: number, roleSlug: string) => void;
  onResetMemberRoles: () => void;
  onSaveMemberRoles: () => void;
  onOpenInviteModal: () => void;
  onSelectMembersChange: (ids: number[]) => void;
  onBulkRoleSelect: (roleSlug: string) => void;
  onOpenBulkDeleteConfirm: () => void;
  onRemoveMember: (userId: number, username: string) => void;
}

export function OrgMembersTab({
  members,
  filteredMembers,
  orgRoles,
  currentUserId,
  memberSearch,
  memberRoleFilter,
  memberJoinedFrom,
  memberJoinedTo,
  draftRoles,
  pendingRoleCount,
  savingMemberRoles,
  selectedMemberIds,
  bulkRoleTarget,
  onSearchChange,
  onRoleFilterChange,
  onJoinedFromChange,
  onJoinedToChange,
  onClearFilters,
  onDraftRoleChange,
  onResetMemberRoles,
  onSaveMemberRoles,
  onOpenInviteModal,
  onSelectMembersChange,
  onBulkRoleSelect,
  onOpenBulkDeleteConfirm,
  onRemoveMember,
}: OrgMembersTabProps) {
  const allSelected =
    filteredMembers.length > 0 &&
    filteredMembers.every((m) => selectedMemberIds.includes(m.user_id));
  const someSelected =
    !allSelected && filteredMembers.some((m) => selectedMemberIds.includes(m.user_id));

  const rolesManageSlugs = new Set(
    orgRoles.filter((r) => r.permissions?.includes("roles.manage")).map((r) => r.slug)
  );
  const rolesManageHoldersCount = members.filter((mem) =>
    mem.roles?.some((slug) => rolesManageSlugs.has(slug))
  ).length;

  return (
    <div className="space-y-4">
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
        <div>
          <h3 className="text-sm font-bold text-foreground">Organization Members</h3>
          <p className="text-xs text-muted-foreground">
            Change member roles and click Save Changes to apply, or use checkboxes for bulk actions.
          </p>
        </div>
        <div className="flex items-center gap-2 shrink-0">
          {pendingRoleCount > 0 && (
            <span className="text-xs font-mono text-amber-500 font-semibold mr-1">
              {pendingRoleCount} unsaved {pendingRoleCount === 1 ? "change" : "changes"}
            </span>
          )}
          <Button
            variant="outline"
            size="sm"
            disabled={pendingRoleCount === 0 || savingMemberRoles}
            onClick={onResetMemberRoles}
            className="rounded-none border-border h-9 px-3.5 text-xs font-semibold gap-1.5 cursor-pointer disabled:opacity-40 disabled:cursor-not-allowed"
          >
            <RotateCcw className="h-3.5 w-3.5" />
            <span>Reset</span>
          </Button>
          <Button
            size="sm"
            disabled={pendingRoleCount === 0 || savingMemberRoles}
            onClick={onSaveMemberRoles}
            className="rounded-none bg-[var(--accent-primary)] text-white dark:text-black hover:opacity-90 h-9 px-3.5 text-xs font-bold gap-1.5 cursor-pointer disabled:opacity-40 disabled:cursor-not-allowed"
          >
            <Save className="h-3.5 w-3.5" />
            <span>{savingMemberRoles ? "Saving..." : "Save Changes"}</span>
          </Button>
          <Button
            size="sm"
            onClick={onOpenInviteModal}
            className="rounded-none border border-border bg-card text-foreground hover:bg-muted/40 font-bold text-xs h-9 px-3.5 cursor-pointer gap-1.5"
          >
            <UserPlus className="h-3.5 w-3.5" />
            <span>Invite</span>
          </Button>
        </div>
      </div>

      <div className="flex flex-wrap items-center gap-3 p-3 border border-border bg-card/50">
        <div className="relative flex-1 min-w-[200px]">
          <Search className="absolute left-3 top-2.5 h-4 w-4 text-muted-foreground" />
          <Input
            placeholder="Search username or email..."
            value={memberSearch}
            onChange={(e) => onSearchChange(e.target.value)}
            className="pl-9 h-9 text-xs rounded-none border-border bg-transparent"
          />
        </div>

        <Select value={memberRoleFilter} onValueChange={onRoleFilterChange}>
          <SelectTrigger className="w-40 h-9 text-xs rounded-none">
            <SelectValue placeholder="All Roles" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All Roles</SelectItem>
            {orgRoles.length > 0 ? (
              orgRoles.map((r) => (
                <SelectItem key={r.id} value={r.slug}>
                  {r.name}
                </SelectItem>
              ))
            ) : (
              <>
                <SelectItem value="owner">Owner</SelectItem>
                <SelectItem value="admin">Admin</SelectItem>
                <SelectItem value="instructor">Instructor</SelectItem>
                <SelectItem value="learner">Learner</SelectItem>
              </>
            )}
          </SelectContent>
        </Select>

        <div className="flex items-center gap-2 text-xs">
          <span className="text-[11px] font-mono text-muted-foreground">Joined:</span>
          <DatePicker
            value={memberJoinedFrom}
            onChange={onJoinedFromChange}
            placeholder="From date"
          />
          <span className="text-muted-foreground">–</span>
          <DatePicker
            value={memberJoinedTo}
            onChange={onJoinedToChange}
            placeholder="To date"
          />
        </div>

        {(memberSearch || memberRoleFilter !== "all" || memberJoinedFrom || memberJoinedTo) && (
          <Button
            variant="ghost"
            size="sm"
            onClick={onClearFilters}
            className="h-9 px-3 text-xs rounded-none text-muted-foreground hover:text-foreground cursor-pointer"
          >
            Clear Filters
          </Button>
        )}
      </div>

      {selectedMemberIds.length > 0 && (
        <div className="flex flex-wrap items-center justify-between gap-3 px-4 py-3 border border-border bg-muted/30">
          <div className="flex items-center gap-3">
            <span className="px-2.5 py-1 text-black dark:text-white font-mono font-bold text-xs">
              {selectedMemberIds.length} Selected{" "}
              {selectedMemberIds.length === 1 ? "member" : "members"}
            </span>
            <Button
              type="button"
              size="sm"
              variant="outline"
              onClick={() => onSelectMembersChange([])}
              className="h-7 px-2.5 text-[11px] font-mono rounded-none border-border gap-1 cursor-pointer"
            >
              <X className="h-3 w-3" />
              <span>Clear</span>
            </Button>
          </div>
          <div className="flex items-center gap-2 flex-wrap">
            <Select value={bulkRoleTarget} onValueChange={onBulkRoleSelect}>
              <SelectTrigger className="h-8 w-44 text-xs rounded-none bg-card">
                <SelectValue placeholder="Select role..." />
              </SelectTrigger>
              <SelectContent>
                {orgRoles.map((r) => (
                  <SelectItem key={r.id} value={r.slug}>
                    {r.name}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
            <Button
              size="sm"
              variant="ghost"
              onClick={onOpenBulkDeleteConfirm}
              className="h-8 px-3 text-xs font-semibold rounded-none text-red-500 hover:text-red-400 hover:bg-red-500/10 gap-1.5 cursor-pointer"
            >
              <Trash2 className="h-3.5 w-3.5" />
              <span>Delete Selected</span>
            </Button>
          </div>
        </div>
      )}

      <div className="relative overflow-visible">
        <div className="relative">
          <div className="grid grid-cols-12 gap-3 px-4 py-3 text-muted-foreground font-mono uppercase text-[10px] font-semibold items-center">
            <div className="col-span-1">
              <MatrixCheckbox
                checked={allSelected}
                indeterminate={someSelected}
                onCheckedChange={() =>
                  onSelectMembersChange(
                    allSelected ? [] : filteredMembers.map((m) => m.user_id)
                  )
                }
                title={allSelected ? "Deselect all visible members" : "Select all visible members"}
              />
            </div>
            <div className="col-span-4">Member</div>
            <div className="col-span-3">Role</div>
            <div className="col-span-2">Joined Date</div>
            <div className="col-span-2 text-right">Actions</div>
          </div>
          <div className="matrix-line-h bottom-0" />
        </div>

        <div className="flex flex-col relative">
          {filteredMembers.length === 0 ? (
            <div className="p-8 text-center text-muted-foreground text-xs font-mono">
              No matching members found.
            </div>
          ) : (
            filteredMembers.map((m, idx) => {
              const isSelf = currentUserId === m.user_id;
              const memberHasRolesManage = m.roles?.some((slug) => rolesManageSlugs.has(slug));
              const isLastRolesManageHolder =
                memberHasRolesManage && rolesManageHoldersCount <= 1;
              const cannotRemove = isSelf || isLastRolesManageHolder;
              const isLast = idx === filteredMembers.length - 1;
              const currentRole = m.roles[0] || "learner";
              const displayedRole = draftRoles[m.user_id] ?? currentRole;
              const isModified =
                draftRoles[m.user_id] !== undefined && draftRoles[m.user_id] !== currentRole;
              const isChecked = selectedMemberIds.includes(m.user_id);

              return (
                <div key={m.user_id} className="relative">
                  <div
                    className={`grid grid-cols-12 gap-3 px-4 py-3.5 items-center text-xs ${
                      isChecked ? "bg-[var(--accent-primary)]/5" : ""
                    }`}
                  >
                    <div className="col-span-1">
                      <MatrixCheckbox
                        checked={isChecked}
                        onCheckedChange={() =>
                          onSelectMembersChange(
                            isChecked
                              ? selectedMemberIds.filter((id) => id !== m.user_id)
                              : [...selectedMemberIds, m.user_id]
                          )
                        }
                        title={`Select ${m.username}`}
                      />
                    </div>
                    <div className="col-span-4 min-w-0">
                      <div className="font-bold text-foreground truncate">{m.username}</div>
                      <div className="text-[11px] text-muted-foreground font-mono truncate">
                        {m.email}
                      </div>
                    </div>
                    <div className="col-span-3">
                      <Select
                        value={displayedRole}
                        disabled={savingMemberRoles}
                        onValueChange={(val) => onDraftRoleChange(m.user_id, val)}
                      >
                        <SelectTrigger
                          className={`h-8 w-44 text-xs rounded-none ${
                            isModified
                              ? "border-[var(--accent-primary)] bg-[var(--accent-primary)]/10"
                              : ""
                          }`}
                        >
                          <SelectValue />
                        </SelectTrigger>
                        <SelectContent>
                          {orgRoles.length > 0 ? (
                            orgRoles.map((r) => (
                              <SelectItem key={r.id} value={r.slug}>
                                {r.name}
                              </SelectItem>
                            ))
                          ) : (
                            <>
                              <SelectItem value="owner">Owner</SelectItem>
                              <SelectItem value="admin">Admin</SelectItem>
                              <SelectItem value="instructor">Instructor</SelectItem>
                              <SelectItem value="learner">Learner</SelectItem>
                            </>
                          )}
                        </SelectContent>
                      </Select>
                    </div>
                    <div className="col-span-2 font-mono text-[11px] text-muted-foreground">
                      {new Date(m.joined_at).toLocaleDateString()}
                    </div>
                    <div className="col-span-2 flex items-center justify-end gap-2">
                      <Button
                        size="sm"
                        variant="ghost"
                        disabled={cannotRemove}
                        onClick={() => !cannotRemove && onRemoveMember(m.user_id, m.username)}
                        className="h-8 px-2.5 text-xs font-semibold text-red-500 hover:text-red-400 hover:bg-red-500/10 rounded-none cursor-pointer gap-1.5 disabled:opacity-40 disabled:cursor-not-allowed"
                        title={
                          isSelf
                            ? "You cannot remove yourself from the organization"
                            : isLastRolesManageHolder
                            ? "Cannot remove the last member holding 'roles.manage'"
                            : "Delete Member"
                        }
                      >
                        <Trash2 className="h-3.5 w-3.5" />
                        <span>Delete</span>
                      </Button>
                    </div>
                  </div>
                  {!isLast && <div className="matrix-line-h bottom-0" />}
                </div>
              );
            })
          )}
        </div>
      </div>
    </div>
  );
}
