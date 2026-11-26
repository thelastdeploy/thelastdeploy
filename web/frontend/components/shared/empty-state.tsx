"use client";

import React from "react";
import { cn } from "@/lib/utils";

interface EmptyStateProps {
  icon?: React.ReactNode;
  title?: string;
  description: React.ReactNode;
  action?: React.ReactNode;
  className?: string;
}

export function EmptyState({
  icon,
  title,
  description,
  action,
  className,
}: EmptyStateProps) {
  return (
    <div
      className={cn(
        "py-12 px-6 text-center border border-dashed border-border rounded-none space-y-3",
        className
      )}
    >
      {icon && (
        <div className="flex justify-center text-muted-foreground/60">
          {icon}
        </div>
      )}
      {title && <p className="text-sm font-bold text-foreground">{title}</p>}
      <p className="text-xs text-muted-foreground font-mono max-w-md mx-auto">
        {description}
      </p>
      {action && <div className="pt-1 flex justify-center">{action}</div>}
    </div>
  );
}
