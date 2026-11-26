import type { Module, ModuleDetail } from "../types";
import { request } from "./client";

export const modulesApi = {
  getModules: () => request<{ modules: Module[] }>("/modules"),

  getAllModulesFull: (excludeContent?: boolean) =>
    request<ModuleDetail[]>(`/modules/all/full?exclude_content=${excludeContent ?? false}`),

  getModule: (id: string) => request<ModuleDetail>(`/modules/${id}/full`),
};
