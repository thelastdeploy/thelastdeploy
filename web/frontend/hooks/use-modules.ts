// web/frontend/hooks/use-modules.ts
//
// Memory-cached modules list.
// - Scoped to the currently active organization workspace
// - Same tab navigation (client-side routing) → served from memory for current org
// - Workspace switch / manual reload → fetches fresh modules for that workspace

import { useEffect, useState } from "react";
import { api } from "@/lib/api";
import { Module, ModuleDetail } from "@/lib/types";

// In-memory cache surviving client-side navigation, keyed by organization slug
let memoryModulesCache: { org: string | null; modules: Module[] } | null = null;

export function clearModulesMemoryCache(): void {
  memoryModulesCache = null;
}

export function patchModulesMemoryCache(moduleId: string, completedSectionsOrSectionId: number | string): void {
  if (!memoryModulesCache) return;
  memoryModulesCache.modules = memoryModulesCache.modules.map((m) => {
    if (m.id === moduleId) {
      if (typeof completedSectionsOrSectionId === "number") {
        return { ...m, completed_sections: completedSectionsOrSectionId };
      } else {
        const newCompleted = Math.min(m.completed_sections + 1, m.total_sections);
        return { ...m, completed_sections: newCompleted };
      }
    }
    return m;
  });
}

export function updateModuleInMemoryCache(updated: ModuleDetail | Module): void {
  if (!memoryModulesCache) return;
  memoryModulesCache.modules = memoryModulesCache.modules.map((m) => {
    if (m.id === updated.id) {
      const completedSections = "sections" in updated
        ? updated.sections.filter((s) => s.section_completed).length
        : updated.completed_sections;

      return {
        ...m,
        title: updated.title,
        description: updated.description,
        topic: updated.topic,
        difficulty: updated.difficulty,
        estimated_minutes: updated.estimated_minutes,
        total_xp: updated.total_xp,
        total_sections: updated.total_sections,
        completed_sections: completedSections,
      };
    }
    return m;
  });
}

export function useModules() {
  const currentOrg = typeof window !== "undefined" ? api.getSelectedOrg() : null;
  const isCacheValid = memoryModulesCache && memoryModulesCache.org === currentOrg;
  const [modules, setModules] = useState<Module[]>(isCacheValid ? memoryModulesCache!.modules : []);
  const [loading, setLoading] = useState(!isCacheValid);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const activeOrg = api.getSelectedOrg();
    if (memoryModulesCache && memoryModulesCache.org === activeOrg) {
      setModules(memoryModulesCache.modules);
      setLoading(false);
      return;
    }

    setLoading(true);
    api.getModules()
      .then(({ modules }) => {
        memoryModulesCache = { org: activeOrg, modules };
        setModules(modules);
      })
      .catch((e) => setError(e.message))
      .finally(() => setLoading(false));
  }, [currentOrg]);

  return { modules, loading, error };
}
