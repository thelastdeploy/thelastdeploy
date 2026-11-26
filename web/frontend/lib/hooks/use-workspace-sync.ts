"use client";

import { useEffect, useState } from "react";
import { api } from "@/lib/api";

/**
 * Tracks the currently selected organization slug and re-syncs whenever
 * the user switches workspace via `tld:workspace-changed`.
 */
export function useWorkspaceSync(enabled: boolean = true): string | null {
  const [selectedOrg, setSelectedOrg] = useState<string | null>(() =>
    enabled ? api.getSelectedOrg() : null
  );

  useEffect(() => {
    if (!enabled) return;

    const sync = () => {
      setSelectedOrg(api.getSelectedOrg());
    };

    sync();
    window.addEventListener("tld:workspace-changed", sync);
    return () => window.removeEventListener("tld:workspace-changed", sync);
  }, [enabled]);

  return selectedOrg;
}
