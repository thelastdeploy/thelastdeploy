"use client";

import * as React from "react";
import { ChevronUp, ChevronDown } from "lucide-react";
import { cn } from "@/lib/utils";

interface NumberStepperProps {
  value?: number;
  defaultValue?: number;
  min?: number;
  max?: number;
  step?: number;
  unit?: string;
  disabled?: boolean;
  onChange?: (value: number) => void;
  className?: string;
}

export function NumberStepper({
  value: controlledValue,
  defaultValue = 0,
  min = 0,
  max = 999999,
  step = 1,
  unit,
  disabled = false,
  onChange,
  className,
}: NumberStepperProps) {
  const isControlled = controlledValue !== undefined;
  const [internalValue, setInternalValue] = React.useState<number>(defaultValue);
  const currentVal = isControlled ? controlledValue! : internalValue;

  const updateVal = (newVal: number) => {
    const clamped = Math.min(Math.max(newVal, min), max);
    if (!isControlled) {
      setInternalValue(clamped);
    }
    onChange?.(clamped);
  };

  return (
    <div className={cn("inline-flex items-center gap-2", className)}>
      <div className="inline-flex items-center rounded-none border border-border bg-card shadow-sm hover:border-[var(--accent-primary)]/40 transition-all overflow-hidden h-8">
        <input
          type="number"
          disabled={disabled}
          value={currentVal}
          onChange={(e) => {
            const parsed = parseInt(e.target.value, 10);
            if (!isNaN(parsed)) updateVal(parsed);
          }}
          className="w-12 bg-transparent text-center font-mono text-xs font-semibold text-foreground outline-none [appearance:textfield] [&::-webkit-outer-spin-button]:appearance-none [&::-webkit-inner-spin-button]:appearance-none"
        />
        <div className="flex flex-col border-l border-border h-full w-5">
          <button
            type="button"
            disabled={disabled || currentVal >= max}
            onClick={() => updateVal(currentVal + step)}
            className="flex-1 flex items-center justify-center text-muted-foreground hover:text-foreground hover:bg-muted/80 disabled:opacity-30 disabled:pointer-events-none transition-colors border-b border-border/50 cursor-pointer"
            aria-label="Increase"
          >
            <ChevronUp className="h-2.5 w-2.5" />
          </button>
          <button
            type="button"
            disabled={disabled || currentVal <= min}
            onClick={() => updateVal(currentVal - step)}
            className="flex-1 flex items-center justify-center text-muted-foreground hover:text-foreground hover:bg-muted/80 disabled:opacity-30 disabled:pointer-events-none transition-colors cursor-pointer"
            aria-label="Decrease"
          >
            <ChevronDown className="h-2.5 w-2.5" />
          </button>
        </div>
      </div>
      {unit && <span className="text-xs text-muted-foreground font-mono">{unit}</span>}
    </div>
  );
}

