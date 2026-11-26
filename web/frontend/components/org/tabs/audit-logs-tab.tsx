"use client";

import React from "react";
import { Search } from "lucide-react";
import { Input } from "@/components/ui/input";
import type { AuditLogResponse } from "@/lib/types";

interface OrgAuditLogsTabProps {
  auditLogs: AuditLogResponse[];
  auditSearch: string;
  onSearchChange: (value: string) => void;
}

export function OrgAuditLogsTab({
  auditLogs,
  auditSearch,
  onSearchChange,
}: OrgAuditLogsTabProps) {
  const filteredAudit = auditLogs.filter(
    (l) =>
      !auditSearch.trim() ||
      l.action.toLowerCase().includes(auditSearch.toLowerCase()) ||
      (l.actor_username || "").toLowerCase().includes(auditSearch.toLowerCase()) ||
      l.entity_type.toLowerCase().includes(auditSearch.toLowerCase())
  );

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div className="relative w-72">
          <Search className="absolute left-3 top-2.5 h-4 w-4 text-muted-foreground" />
          <Input
            placeholder="Search audit events..."
            value={auditSearch}
            onChange={(e) => onSearchChange(e.target.value)}
            className="pl-9 h-9 text-xs rounded-none border-border bg-transparent"
          />
        </div>
        <span className="text-xs font-mono text-muted-foreground">
          {filteredAudit.length} events logged
        </span>
      </div>

      <div className="relative overflow-visible">
        <div className="relative">
          <div className="grid grid-cols-12 gap-3 px-4 py-3 text-muted-foreground font-mono uppercase text-[10px] font-semibold">
            <div className="col-span-2">Timestamp</div>
            <div className="col-span-2">Actor</div>
            <div className="col-span-3">Action</div>
            <div className="col-span-2">Entity</div>
            <div className="col-span-3">Metadata</div>
          </div>
          <div className="matrix-line-h bottom-0" />
        </div>

        <div className="flex flex-col relative">
          {filteredAudit.length === 0 ? (
            <div className="p-8 text-center text-muted-foreground text-xs font-mono">
              No audit events recorded yet.
            </div>
          ) : (
            filteredAudit.map((log, idx) => (
              <div key={log.id} className="relative">
                <div className="grid grid-cols-12 gap-3 px-4 py-3.5 items-center text-xs">
                  <div className="col-span-2 font-mono text-[11px] text-muted-foreground truncate">
                    {new Date(log.created_at).toLocaleString()}
                  </div>
                  <div className="col-span-2 font-semibold text-foreground truncate">
                    {log.actor_username || "System"}
                  </div>
                  <div className="col-span-3 font-mono text-[11px] text-[var(--accent-primary)] font-bold truncate">
                    {log.action}
                  </div>
                  <div className="col-span-2 font-mono text-[11px] text-foreground truncate">
                    {log.entity_type} {log.entity_id ? `(${log.entity_id})` : ""}
                  </div>
                  <div
                    className="col-span-3 font-mono text-[10px] text-muted-foreground truncate"
                    title={JSON.stringify(log.metadata)}
                  >
                    {JSON.stringify(log.metadata)}
                  </div>
                </div>
                {idx < filteredAudit.length - 1 && <div className="matrix-line-h bottom-0" />}
              </div>
            ))
          )}
        </div>
      </div>
    </div>
  );
}
