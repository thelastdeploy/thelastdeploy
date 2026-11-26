"use client";

import React from "react";
import { Check, Minus } from "lucide-react";
import { cn } from "@/lib/utils";

interface MatrixCheckboxProps {
  checked: boolean;
  indeterminate?: boolean;
  disabled?: boolean;
  onCheckedChange?: (checked: boolean) => void;
  title?: string;
  size?: "sm" | "md";
  className?: string;
}

export function MatrixCheckbox({
  checked,
  indeterminate = false,
  disabled = false,
  onCheckedChange,
  title,
  size = "md",
  className,
}: MatrixCheckboxProps) {
  const active = checked || indeterminate;
  const sizeClass = size === "sm" ? "h-4 w-4" : "h-5 w-5";
  const iconClass = size === "sm" ? "h-3 w-3 stroke-[3]" : "h-3.5 w-3.5 stroke-[3]";

  return (
    <button
      type="button"
      role="checkbox"
      aria-checked={indeterminate ? "mixed" : checked}
      disabled={disabled}
      title={title}
      onClick={() => {
        if (!disabled && onCheckedChange) {
          onCheckedChange(!checked);
        }
      }}
      className={cn(
        "rounded-none flex items-center justify-center shrink-0 border transition-all",
        sizeClass,
        active
          ? "bg-[var(--accent-primary)] border-[var(--accent-primary)] text-white dark:text-black"
          : "border-border bg-transparent hover:border-foreground/50",
        disabled ? "opacity-40 cursor-not-allowed" : "cursor-pointer",
        className
      )}
    >
      {checked ? (
        <Check className={iconClass} />
      ) : indeterminate ? (
        <Minus className={iconClass} />
      ) : null}
    </button>
  );
}
