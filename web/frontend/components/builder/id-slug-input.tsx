// web/frontend/components/builder/id-slug-input.tsx

"use client";

import { useEffect, useState, useRef } from "react";
import { CheckCircle, XCircle, Loader2 } from "lucide-react";
import { api } from "@/lib/api";

interface Props {
  value: string;
  onChange: (val: string) => void;
  currentId: string;
  disabled?: boolean;
  label?: string;
  placeholder?: string;
}

export function IdSlugInput({ value, onChange, currentId, disabled = false, label = "ID / Slug", placeholder = "my-awesome-slug" }: Props) {
  const [status, setStatus] = useState<"idle" | "checking" | "available" | "taken">("idle");
  const [error, setError] = useState<string | null>(null);
  const debounceRef = useRef<NodeJS.Timeout | null>(null);

  const formatSlug = (val: string) => {
    return val
      .toLowerCase()
      .replace(/\s+/g, "-") // spaces to hyphens
      .replace(/[^a-z0-9-_]/g, ""); // strip non-alphanumeric and underscores/hyphens
  };

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const formatted = formatSlug(e.target.value);
    onChange(formatted);
    setError(null);

    if (formatted === currentId || formatted.trim() === "") {
      setStatus("idle");
      return;
    }

    setStatus("checking");
    if (debounceRef.current) clearTimeout(debounceRef.current);

    debounceRef.current = setTimeout(async () => {
      try {
        // Query the module detail endpoint
        await api.getModule(formatted);
        // If it succeeds (200 OK), the module already exists!
        setStatus("taken");
      } catch (err: any) {
        // If it throws a 404 (Module not found), then the slug is available!
        if (err.message && err.message.toLowerCase().includes("not found")) {
          setStatus("available");
        } else {
          setStatus("idle");
        }
      }
    }, 400);
  };

  useEffect(() => {
    return () => {
      if (debounceRef.current) clearTimeout(debounceRef.current);
    };
  }, []);

  return (
    <div className="space-y-1.5 w-full">
      <label className="text-xs font-bold text-muted-foreground uppercase tracking-wider block">
        {label}
      </label>
      <div className="relative flex items-center">
        <input
          type="text"
          value={value}
          onChange={handleInputChange}
          disabled={disabled}
          placeholder={placeholder}
          className="w-full pl-3 pr-10 py-2.5 rounded-xl border border-border bg-background text-sm font-mono text-foreground focus:outline-none focus:border-[var(--accent-primary)] focus:ring-1 focus:ring-[var(--accent-primary)] transition-all disabled:opacity-60 disabled:cursor-not-allowed"
        />
        <div className="absolute right-3 flex items-center justify-center pointer-events-none">
          {status === "checking" && <Loader2 className="h-4 w-4 text-[var(--accent-primary)] animate-spin" />}
          {status === "available" && <CheckCircle className="h-4 w-4 text-emerald-400" />}
          {status === "taken" && <XCircle className="h-4 w-4 text-rose-500" />}
        </div>
      </div>
      {status === "taken" && (
        <p className="text-xs text-rose-400 font-medium">This ID is already taken. Please choose another one.</p>
      )}
      {status === "available" && (
        <p className="text-xs text-emerald-400 font-medium">ID is available!</p>
      )}
    </div>
  );
}
