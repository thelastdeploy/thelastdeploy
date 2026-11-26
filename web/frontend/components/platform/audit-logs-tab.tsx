// web/frontend/components/platform/audit-logs-tab.tsx

"use client";

import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Search } from "lucide-react";
import { usePlatformAudit } from "@/lib/platform/hooks/use-platform-audit";

export function AuditLogsTab() {
  const {
    auditLogs,
    auditSearch,
    setAuditSearch,
    loadAuditLogs,
  } = usePlatformAudit();

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between gap-4 flex-wrap">
        <div className="relative w-72">
          <Search className="absolute left-3 top-2.5 h-4 w-4 text-muted-foreground" />
          <Input
            placeholder="Search audit events..."
            value={auditSearch}
            onChange={(e) => setAuditSearch(e.target.value)}
            className="pl-9 h-9 text-xs rounded-none border-border bg-transparent focus-visible:ring-0 focus-visible:border-[var(--accent-primary)]"
          />
        </div>

        <span className="text-xs font-mono text-muted-foreground">{auditLogs.length} events logged</span>
      </div>

      {/* Single-Column Open Matrix with Continuous Horizontal Lines (No Outer Border) */}
      <div className="relative overflow-visible">
        {/* Header Row */}
        <div className="relative">
          <div className="grid grid-cols-12 gap-3 px-4 py-3 text-muted-foreground font-mono uppercase text-[10px] font-semibold">
            <div className="col-span-2">Timestamp</div>
            <div className="col-span-2">Actor</div>
            <div className="col-span-3">Action</div>
            <div className="col-span-2">Target Entity</div>
            <div className="col-span-3">Metadata</div>
          </div>
          <div className="matrix-line-h bottom-0" />
        </div>

        {/* Audit Event Stream */}
        <div className="flex flex-col relative">
          {auditLogs.length === 0 ? (
            <div className="p-8 text-center text-muted-foreground text-xs font-mono">
              No audit events recorded matching current filters.
            </div>
          ) : (
            auditLogs.map((log, idx) => {
              const isLast = idx === auditLogs.length - 1;
              return (
                <div key={log.id} className="relative">
                  <div className="grid grid-cols-12 gap-3 px-4 py-3.5 items-center text-xs">
                    <div className="col-span-2 font-mono text-[11px] text-muted-foreground truncate">
                      {new Date(log.created_at).toLocaleString()}
                    </div>
                    <div className="col-span-2 font-semibold text-foreground truncate">
                      {log.actor_username}
                    </div>
                    <div className="col-span-3 font-mono text-[11px] text-[var(--accent-primary)] font-bold truncate">
                      {log.action}
                    </div>
                    <div className="col-span-2 font-mono text-[11px] text-foreground dark:text-zinc-200 font-medium truncate">
                      {log.entity_type} {log.entity_id ? `(${log.entity_id})` : ""}
                    </div>
                    <div className="col-span-3 font-mono text-[10px] text-muted-foreground truncate" title={JSON.stringify(log.metadata)}>
                      {JSON.stringify(log.metadata)}
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

