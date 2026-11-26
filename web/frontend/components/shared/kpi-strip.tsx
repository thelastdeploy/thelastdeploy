"use client";

import React from "react";
import { cn } from "@/lib/utils";

export interface KpiItem {
  label: string;
  value: React.ReactNode;
  sublabel?: React.ReactNode;
  valueClassName?: string;
}

interface KpiStripProps {
  items: KpiItem[];
  columns?: 2 | 3 | 4;
  className?: string;
}

export function KpiStrip({ items, columns = 4, className }: KpiStripProps) {
  const gridCols =
    columns === 2
      ? "grid-cols-1 sm:grid-cols-2"
      : columns === 3
      ? "grid-cols-1 sm:grid-cols-3"
      : "grid-cols-2 lg:grid-cols-4";

  return (
    <div className={cn("relative border-y border-border/60", className)}>
      <div
        className={cn(
          "grid divide-y sm:divide-y-0 sm:divide-x divide-border/50",
          gridCols
        )}
      >
        {items.map((item, idx) => (
          <div key={idx} className="p-5 flex flex-col justify-between gap-2">
            <span className="text-[11px] font-mono uppercase tracking-wider text-muted-foreground font-semibold">
              {item.label}
            </span>
            <p
              className={cn(
                "text-2xl font-black font-mono text-foreground",
                item.valueClassName
              )}
            >
              {item.value}
            </p>
            {item.sublabel && (
              <span className="text-[11px] text-muted-foreground font-mono">
                {item.sublabel}
              </span>
            )}
          </div>
        ))}
      </div>
    </div>
  );
}
