"use client";

import {
  Lock,
  Search,
  Copy,
  Check,
  RotateCcw,
  Sliders,
  SlidersHorizontal,
  X,
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { EmptyState } from "@/components/shared/empty-state";
import type { PlatformPermissionItem } from "@/lib/types";
import {
  PERMISSION_TAXONOMY,
  DOMAIN_SECTIONS,
  type DomainKey,
} from "@/lib/platform/permission-taxonomy";

interface UserPermissionsMatrixProps {
  catalog: PlatformPermissionItem[];
  filteredCatalog: PlatformPermissionItem[];
  activePerms: Set<string>;
  domainCounts: Record<DomainKey, { granted: number; total: number }>;
  selectedDomain: DomainKey;
  onSelectDomain: (domain: DomainKey) => void;
  statusFilter: "all" | "granted" | "revoked";
  onStatusFilterChange: (filter: "all" | "granted" | "revoked") => void;
  searchQuery: string;
  onSearchQueryChange: (query: string) => void;
  isSelf: boolean;
  copiedKey: string | null;
  onCopyKey: (key: string) => void;
  onTogglePerm: (key: string) => void;
  onGrantDomain: (domain: DomainKey) => void;
  onRevokeDomain: (domain: DomainKey) => void;
  onClearFilters: () => void;
}

export function UserPermissionsMatrix({
  filteredCatalog,
  activePerms,
  domainCounts,
  selectedDomain,
  onSelectDomain,
  statusFilter,
  onStatusFilterChange,
  searchQuery,
  onSearchQueryChange,
  isSelf,
  copiedKey,
  onCopyKey,
  onTogglePerm,
  onGrantDomain,
  onRevokeDomain,
  onClearFilters,
}: UserPermissionsMatrixProps) {
  return (
    <div className="grid grid-cols-1 lg:grid-cols-4 gap-8">
      {/* Left Column: Domain Selector & Filters */}
      <div className="space-y-6">
        <div className="rounded-none border border-border bg-card">
          <div className="p-4 pb-3">
            <h3 className="text-sm font-bold uppercase tracking-wider text-muted-foreground flex items-center gap-2">
              <Sliders className="h-4 w-4 text-[var(--accent-primary)]" /> Capability Domains
            </h3>
          </div>
          <div className="space-y-1.5 p-3 pt-0">
            {DOMAIN_SECTIONS.map((sec) => {
              const Icon = sec.icon;
              const count = domainCounts[sec.id] || { granted: 0, total: 0 };
              const isSelected = selectedDomain === sec.id;
              return (
                <button
                  key={sec.id}
                  onClick={() => onSelectDomain(sec.id)}
                  className={`w-full flex items-center justify-between p-2.5 rounded-none border text-xs font-medium transition-all text-left cursor-pointer ${
                    isSelected
                      ? "bg-[var(--accent-primary)]/10 text-foreground border-[var(--accent-primary)]"
                      : "bg-transparent text-muted-foreground border-transparent hover:text-foreground hover:border-border"
                  }`}
                >
                  <div className="flex items-center gap-2.5 truncate">
                    <Icon
                      className={`h-4 w-4 shrink-0 ${
                        isSelected ? "text-[var(--accent-primary)]" : "text-muted-foreground"
                      }`}
                    />
                    <span className="truncate">{sec.label}</span>
                  </div>
                  <Badge
                    variant="secondary"
                    className={`text-[10px] font-mono shrink-0 ml-2 rounded-none ${
                      count.granted === count.total && count.total > 0
                        ? "bg-emerald-500/10 text-emerald-400 border border-emerald-500/30"
                        : count.granted > 0
                        ? "bg-purple-500/10 text-purple-400 border border-purple-500/30"
                        : ""
                    }`}
                  >
                    {count.granted}/{count.total}
                  </Badge>
                </button>
              );
            })}
          </div>
        </div>

        {/* Quick Actions Panel */}
        <div className="rounded-none border border-border bg-card">
          <div className="p-4 pb-3">
            <h3 className="text-sm font-bold uppercase tracking-wider text-muted-foreground">
              Domain Actions
            </h3>
            <p className="text-xs text-muted-foreground mt-1">
              Apply batch grants or revocations to the active domain filter.
            </p>
          </div>
          <div className="space-y-2 p-3 pt-0">
            <Button
              variant="outline"
              size="sm"
              onClick={() => onGrantDomain(selectedDomain)}
              className="w-full h-9 text-xs font-semibold rounded-none border-border cursor-pointer text-emerald-500 hover:text-emerald-400 hover:bg-emerald-500/10 gap-1.5 justify-center"
            >
              <Check className="h-3.5 w-3.5" />
              <span>Grant All in Domain</span>
            </Button>
            <Button
              variant="outline"
              size="sm"
              onClick={() => onRevokeDomain(selectedDomain)}
              className="w-full h-9 text-xs font-semibold rounded-none border-border cursor-pointer text-red-500 hover:text-red-400 hover:bg-red-500/10 gap-1.5 justify-center"
            >
              <X className="h-3.5 w-3.5" />
              <span>Revoke All in Domain</span>
            </Button>
          </div>
        </div>
      </div>

      {/* Right 3 Columns: Search, Filters & Permission Grid */}
      <div className="lg:col-span-3 space-y-6">
        <div className="flex flex-col sm:flex-row items-center gap-3">
          <div className="relative flex-1 w-full">
            <Search className="absolute left-3.5 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
            <Input
              type="text"
              placeholder="Filter permissions by key (e.g. 'platform.organizations'), title, or keywords..."
              value={searchQuery}
              onChange={(e) => onSearchQueryChange(e.target.value)}
              className="pl-10 h-10 text-xs font-mono rounded-none border-border bg-transparent focus-visible:ring-0 focus-visible:border-[var(--accent-primary)]"
            />
          </div>

          <div className="flex items-center gap-1 border border-border p-1 rounded-none shrink-0">
            {(["all", "granted", "revoked"] as const).map((filter) => (
              <button
                key={filter}
                onClick={() => onStatusFilterChange(filter)}
                className={`px-3 py-1.5 text-xs font-mono capitalize rounded-none transition-all cursor-pointer ${
                  statusFilter === filter
                    ? "bg-[var(--accent-primary)]/15 text-[var(--accent-primary)] font-bold"
                    : "text-muted-foreground hover:text-foreground hover:bg-muted/40"
                }`}
              >
                {filter}
              </button>
            ))}
          </div>
        </div>

        {filteredCatalog.length === 0 ? (
          <EmptyState
            icon={<SlidersHorizontal className="h-10 w-10 text-muted-foreground/40" />}
            title="No permissions match criteria"
            description="No platform capabilities matched your active domain filter, status selection, or search query."
            className="bg-card border-solid"
            action={
              <Button
                variant="outline"
                size="sm"
                onClick={onClearFilters}
                className="h-9 px-3.5 text-xs font-semibold rounded-none border-border cursor-pointer gap-1.5"
              >
                <RotateCcw className="h-3.5 w-3.5" />
                <span>Clear All Filters</span>
              </Button>
            }
          />
        ) : (
          <div className="relative overflow-visible">
            <div className="flex flex-col relative">
              {filteredCatalog.map((item, idx) => {
                const isLast = idx === filteredCatalog.length - 1;
                const isGranted = activePerms.has(item.key);
                const isLockedSelf = isSelf && item.key === "platform.permissions.manage";
                const meta = PERMISSION_TAXONOMY[item.key] || {
                  domain: "system",
                  risk: "standard",
                  humanName: item.key,
                  categoryLabel: "General",
                };

                const riskColor =
                  meta.risk === "critical"
                    ? "#ef4444"
                    : meta.risk === "elevated"
                    ? "#f59e0b"
                    : meta.risk === "readonly"
                    ? "#64748b"
                    : "#3b82f6";

                const riskRgb =
                  meta.risk === "critical"
                    ? "239, 68, 68"
                    : meta.risk === "elevated"
                    ? "245, 158, 11"
                    : meta.risk === "readonly"
                    ? "100, 116, 139"
                    : "59, 130, 246";

                const riskBadge =
                  meta.risk === "critical" ? (
                    <Badge variant="outline" className="text-[10px] bg-red-500/10 text-red-400 border-red-500/30 font-mono rounded-none">
                      Critical Risk
                    </Badge>
                  ) : meta.risk === "elevated" ? (
                    <Badge variant="outline" className="text-[10px] bg-amber-500/10 text-amber-400 border-amber-500/30 font-mono rounded-none">
                      Elevated
                    </Badge>
                  ) : meta.risk === "readonly" ? (
                    <Badge variant="outline" className="text-[10px] bg-slate-500/10 text-slate-400 border-slate-500/30 font-mono rounded-none">
                      Read Only
                    </Badge>
                  ) : (
                    <Badge variant="outline" className="text-[10px] bg-blue-500/10 text-blue-400 border-blue-500/30 font-mono rounded-none">
                      Standard
                    </Badge>
                  );

                return (
                  <div key={item.key} className="relative">
                    <div className="p-2.5 sm:p-3 text-left border-0">
                      <div
                        onClick={() => !isLockedSelf && onTogglePerm(item.key)}
                        className={`p-4 sm:p-5 rounded-none flex items-start justify-between gap-4 transition-all duration-150 ${
                          isLockedSelf ? "cursor-not-allowed opacity-90" : "cursor-pointer"
                        }`}
                        style={{
                          border: "none",
                          boxShadow: isGranted ? `inset 0 0 0 2px ${riskColor}` : "none",
                          backgroundColor: isGranted
                            ? `rgba(${riskRgb}, 0.08)`
                            : isLockedSelf
                            ? "rgba(245, 158, 11, 0.04)"
                            : "transparent",
                        }}
                        onMouseEnter={(e) => {
                          if (!isGranted && !isLockedSelf) {
                            e.currentTarget.style.boxShadow = `inset 0 0 0 2px ${riskColor}`;
                            e.currentTarget.style.backgroundColor = `rgba(${riskRgb}, 0.05)`;
                          }
                        }}
                        onMouseLeave={(e) => {
                          if (!isGranted && !isLockedSelf) {
                            e.currentTarget.style.boxShadow = "none";
                            e.currentTarget.style.backgroundColor = "transparent";
                          }
                        }}
                      >
                        <div className="space-y-1.5 flex-1 min-w-0">
                          <div className="flex items-center gap-2 flex-wrap">
                            <span className="text-sm font-bold text-foreground">
                              {meta.humanName}
                            </span>
                            {riskBadge}
                            <Badge variant="secondary" className="text-[10px] font-mono rounded-none">
                              {meta.categoryLabel}
                            </Badge>
                            {isLockedSelf && (
                              <Badge variant="outline" className="text-[10px] bg-amber-500/10 text-amber-500 dark:text-amber-400 border-amber-500/30 font-mono flex items-center gap-1 rounded-none">
                                <Lock className="h-2.5 w-2.5" /> Locked
                              </Badge>
                            )}
                          </div>

                          <div className="flex items-center gap-2 text-xs font-mono text-muted-foreground">
                            <code className="bg-muted px-1.5 py-0.5 text-[11px] text-foreground font-semibold rounded-none">
                              {item.key}
                            </code>
                            <button
                              type="button"
                              onClick={(e) => {
                                e.stopPropagation();
                                onCopyKey(item.key);
                              }}
                              className="hover:text-foreground transition-colors p-1"
                              title="Copy permission key"
                            >
                              {copiedKey === item.key ? (
                                <Check className="h-3 w-3 text-emerald-400" />
                              ) : (
                                <Copy className="h-3 w-3" />
                              )}
                            </button>
                          </div>

                          <p className="text-xs text-muted-foreground leading-relaxed pt-0.5">
                            {item.description || "Grants authority to execute operations associated with this platform capability."}
                          </p>
                        </div>

                        <div className="shrink-0 flex items-center pt-1" onClick={(e) => e.stopPropagation()}>
                          {isLockedSelf ? (
                            <div className="flex items-center gap-1.5 px-3 py-1.5 rounded-none bg-amber-500/10 border border-amber-500/30 text-amber-600 dark:text-amber-400 text-xs font-mono font-bold">
                              <Lock className="h-3.5 w-3.5" />
                              <span>LOCKED</span>
                            </div>
                          ) : (
                            <button
                              type="button"
                              onClick={() => onTogglePerm(item.key)}
                              className={`h-6 w-6 rounded-none flex items-center justify-center shrink-0 border transition-all cursor-pointer ${
                                isGranted
                                  ? "border-transparent text-white dark:text-black font-bold"
                                  : "border-border bg-card hover:border-muted-foreground/60"
                              }`}
                              style={{
                                backgroundColor: isGranted ? riskColor : undefined,
                              }}
                              role="switch"
                              aria-checked={isGranted}
                            >
                              {isGranted && <Check className="h-4 w-4 stroke-[3]" />}
                            </button>
                          )}
                        </div>
                      </div>
                    </div>

                    {!isLast && <div className="matrix-line-h bottom-0" />}
                  </div>
                );
              })}
            </div>
          </div>
        )}
      </div>
    </div>
  );
}

