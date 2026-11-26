import type { ModuleDetail, User } from "@/lib/types";

export function isModuleComplete(module: ModuleDetail, user: User): boolean {
  const allLabs = module.sections.flatMap((s) => s.labs);
  const allSections = module.sections;
  const labsDone =
    allLabs.length === 0 || allLabs.every((l) => user.completed_labs.includes(l.id));
  const readingDone = allSections
    .filter((s) => s.labs.length === 0)
    .every((s) => user.completed_sections.includes(s.id));
  return labsDone && readingDone && allSections.length > 0;
}

export function isModuleInProgress(module: ModuleDetail, user: User): boolean {
  const allLabs = module.sections.flatMap((s) => s.labs);
  const hasLabProgress = allLabs.some((l) => user.completed_labs.includes(l.id));
  const hasSectionProgress = module.sections.some((s) =>
    user.completed_sections.includes(s.id)
  );
  return (hasLabProgress || hasSectionProgress) && !isModuleComplete(module, user);
}

export function getModuleRecencyIndex(module: ModuleDetail, user: User): number {
  const allLabs = module.sections.flatMap((s) => s.labs);
  const allSections = module.sections;

  let minIdx = Infinity;
  allLabs.forEach((l) => {
    const idx = user.completed_labs.indexOf(l.id);
    if (idx !== -1 && idx < minIdx) {
      minIdx = idx;
    }
  });
  allSections.forEach((s) => {
    const idx = user.completed_sections.indexOf(s.id);
    if (idx !== -1 && idx < minIdx) {
      minIdx = idx;
    }
  });

  return minIdx;
}
