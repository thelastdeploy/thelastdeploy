"use client";

import React from "react";
import { RefreshCw } from "lucide-react";
import { Button } from "@/components/ui/button";

export const DEFAULT_PERIOD_OPTIONS = [
  { key: "7d", label: "7D" },
  { key: "30d", label: "30D" },
  { key: "90d", label: "90D" },
  { key: "all", label: "All Time" },
] as const;

interface PeriodSelectorProps {
  value: string;
  onChange: (period: string) => void;
  onRefresh?: () => void;
  loading?: boolean;
  options?: ReadonlyArray<{ key: string; label: string }>;
}

export function PeriodSelector({
  value,
  onChange,
  onRefresh,
  loading = false,
  options = DEFAULT_PERIOD_OPTIONS,
}: PeriodSelectorProps) {
  return (
    <div className="flex items-center gap-2 flex-wrap">
      <span className="text-[10px] font-mono uppercase tracking-wider text-muted-foreground mr-1">
        PERIOD:
      </span>
      <div className="inline-flex border border-border bg-card">
        {options.map((p) => {
          const active = value === p.key;
          return (
            <button
              key={p.key}
              type="button"
              onClick={() => onChange(p.key)}
              className={`px-3 py-1.5 text-xs font-mono font-semibold transition-colors cursor-pointer border-r last:border-r-0 border-border ${
                active
                  ? "bg-[var(--accent-primary)] text-white dark:text-black"
                  : "text-muted-foreground hover:text-foreground hover:bg-muted/40"
              }`}
            >
              {p.label}
            </button>
          );
        })}
      </div>
      {onRefresh && (
        <Button
          type="button"
          size="sm"
          variant="outline"
          onClick={onRefresh}
          disabled={loading}
          className="rounded-none h-8 px-2.5 border-border cursor-pointer"
          title="Refresh data"
        >
          <RefreshCw className={`h-3.5 w-3.5 ${loading ? "animate-spin" : ""}`} />
        </Button>
      )}
    </div>
  );
}
