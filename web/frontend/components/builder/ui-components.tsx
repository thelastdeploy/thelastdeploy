// web/frontend/components/builder/ui-components.tsx

"use client";

import { useState, useRef, useEffect } from "react";
import { ChevronDown, Check, Minus, Plus } from "lucide-react";

export interface SelectOption {
  value: string;
  label: string;
}

// ── PremiumSelect ────────────────────────────────────────────────────────────
export function PremiumSelect({
  value,
  onChange,
  options,
  label,
  className = "",
}: {
  value: string;
  onChange: (val: string) => void;
  options: SelectOption[];
  label?: string;
  className?: string;
}) {
  const [isOpen, setIsOpen] = useState(false);
  const containerRef = useRef<HTMLDivElement>(null);

  const selectedOption = options.find((o) => o.value === value) || options[0];

  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (containerRef.current && !containerRef.current.contains(event.target as Node)) {
        setIsOpen(false);
      }
    }
    document.addEventListener("mousedown", handleClickOutside);
    return () => document.removeEventListener("mousedown", handleClickOutside);
  }, []);

  return (
    <div ref={containerRef} className={`relative ${className} w-full`}>
      {label && (
        <label className="text-xs font-bold text-muted-foreground uppercase tracking-wider block mb-1.5">
          {label}
        </label>
      )}
      <button
        type="button"
        onClick={() => setIsOpen(!isOpen)}
        className="w-full flex items-center justify-between px-3 py-2.5 rounded-xl border border-border bg-card text-sm text-foreground hover:border-[var(--accent-primary)] focus:outline-none transition-all cursor-pointer text-left shadow-sm"
      >
        <span className="font-semibold">{selectedOption?.label}</span>
        <ChevronDown className={`h-4 w-4 text-muted-foreground/60 transition-transform duration-200 ${isOpen ? "rotate-180" : ""}`} />
      </button>

      {isOpen && (
        <div className="absolute left-0 right-0 mt-1.5 rounded-xl border border-border bg-card shadow-xl z-50 overflow-hidden py-1 animate-in fade-in slide-in-from-top-1 duration-150">
          {options.map((option) => {
            const isSelected = option.value === value;
            return (
              <button
                key={option.value}
                type="button"
                onClick={() => {
                  onChange(option.value);
                  setIsOpen(false);
                }}
                className={`w-full flex items-center justify-between px-3.5 py-2.5 text-xs font-bold transition-all text-left cursor-pointer border-b border-border/20 last:border-0 ${
                  isSelected
                    ? "bg-[rgba(var(--accent-primary-rgb),0.08)] text-[var(--accent-primary)]"
                    : "text-muted-foreground hover:text-foreground hover:bg-muted/40"
                }`}
              >
                <span>{option.label}</span>
                {isSelected && <Check className="h-3.5 w-3.5 text-[var(--accent-primary)]" />}
              </button>
            );
          })}
        </div>
      )}
    </div>
  );
}

// ── PremiumStepper ────────────────────────────────────────────────────────────
export function PremiumStepper({
  value,
  onChange,
  min = 0,
  max = 1000,
  step = 5,
  label,
  className = "",
}: {
  value: number;
  onChange: (val: number) => void;
  min?: number;
  max?: number;
  step?: number;
  label?: string;
  className?: string;
}) {
  const handleDecrement = () => {
    onChange(Math.max(min, value - step));
  };
  const handleIncrement = () => {
    onChange(Math.min(max, value + step));
  };

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const val = parseInt(e.target.value);
    if (!isNaN(val)) {
      onChange(Math.min(max, Math.max(min, val)));
    }
  };

  return (
    <div className={`flex flex-col gap-1 w-full ${className}`}>
      {label && (
        <label className="text-xs font-bold text-muted-foreground uppercase tracking-wider block">
          {label}
        </label>
      )}
      <div className="flex items-center bg-card border border-border rounded-xl p-1 select-none shadow-sm w-full max-w-[180px]">
        <button
          type="button"
          onClick={handleDecrement}
          disabled={value <= min}
          className="w-8 h-8 rounded-lg flex items-center justify-center text-muted-foreground hover:text-foreground hover:bg-muted disabled:opacity-40 disabled:hover:bg-transparent transition-all cursor-pointer shrink-0"
        >
          <Minus className="h-4 w-4" />
        </button>

        <input
          type="number"
          value={value}
          onChange={handleInputChange}
          className="flex-1 bg-transparent text-sm font-black font-mono text-center text-foreground focus:outline-none no-spin min-w-0"
        />

        <button
          type="button"
          onClick={handleIncrement}
          disabled={value >= max}
          className="w-8 h-8 rounded-lg flex items-center justify-center text-muted-foreground hover:text-foreground hover:bg-muted disabled:opacity-40 disabled:hover:bg-transparent transition-all cursor-pointer shrink-0"
        >
          <Plus className="h-4 w-4" />
        </button>
      </div>
    </div>
  );
}
