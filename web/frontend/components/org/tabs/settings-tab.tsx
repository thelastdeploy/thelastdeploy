"use client";

import React from "react";
import { Lock } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { NumberStepper } from "@/components/ui/number-stepper";
import type { OrgSettingItemResponse } from "@/lib/types";

interface OrgSettingsTabProps {
  settingsList: OrgSettingItemResponse[];
  settingUpdating: string | null;
  onUpdateSetting: (key: string, value: any) => void;
}

export function OrgSettingsTab({
  settingsList,
  settingUpdating,
  onUpdateSetting,
}: OrgSettingsTabProps) {
  return (
    <div className="space-y-6">
      <div>
        <h3 className="text-sm font-bold text-foreground">Organization Configuration</h3>
        <p className="text-xs text-muted-foreground">
          Configure values for settings enabled by The Last Deploy platform. Your role determines
          which settings you can edit.
        </p>
      </div>

      <div className="relative overflow-visible">
        <div className="flex flex-col relative">
          {settingsList.map((st, idx) => {
            const canEdit = st.can_edit !== false;
            const isLast = idx === settingsList.length - 1;
            return (
              <div key={st.key} className="relative">
                <div className="py-5 px-4 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                  <div>
                    <div className="flex items-center gap-2 flex-wrap">
                      <h4 className="font-bold text-sm font-mono text-foreground">{st.key}</h4>
                      <span className="text-[10px] uppercase font-mono px-2 py-0.5 bg-muted text-muted-foreground">
                        {st.category}
                      </span>
                      {!canEdit && (
                        <span className="inline-flex items-center gap-1 text-[10px] font-mono px-2 py-0.5 bg-amber-500/10 text-amber-500 border border-amber-500/20">
                          <Lock className="h-2.5 w-2.5" />
                          Requires {st.required_permission || "settings.manage"}
                        </span>
                      )}
                    </div>
                    <p className="text-xs text-muted-foreground mt-1">{st.description}</p>
                  </div>

                  <div className="shrink-0 flex items-center gap-2">
                    {st.data_type === "boolean" ? (
                      <Button
                        size="sm"
                        variant={st.value ? "default" : "outline"}
                        disabled={!canEdit || settingUpdating === st.key}
                        onClick={() => onUpdateSetting(st.key, !st.value)}
                        className={`rounded-none text-xs font-bold h-8 cursor-pointer disabled:opacity-50 disabled:cursor-not-allowed ${
                          st.value ? "bg-[var(--accent-primary)] text-black" : ""
                        }`}
                      >
                        {st.value ? "Enabled" : "Disabled"}
                      </Button>
                    ) : st.key === "onboarding.access_approval_mode" ? (
                      <Select
                        value={String(st.value)}
                        disabled={!canEdit || settingUpdating === st.key}
                        onValueChange={(val) => onUpdateSetting(st.key, val)}
                      >
                        <SelectTrigger className="h-8 w-48 text-xs font-mono rounded-none">
                          <SelectValue />
                        </SelectTrigger>
                        <SelectContent>
                          <SelectItem value="automatic">Automatic</SelectItem>
                          <SelectItem value="manual">Manual (Review Queue)</SelectItem>
                        </SelectContent>
                      </Select>
                    ) : st.key === "learning_paths.default_visibility" ? (
                      <Select
                        value={String(st.value)}
                        disabled={!canEdit || settingUpdating === st.key}
                        onValueChange={(val) => onUpdateSetting(st.key, val)}
                      >
                        <SelectTrigger className="h-8 w-40 text-xs font-mono rounded-none">
                          <SelectValue />
                        </SelectTrigger>
                        <SelectContent>
                          <SelectItem value="public">Public</SelectItem>
                          <SelectItem value="private">Private</SelectItem>
                        </SelectContent>
                      </Select>
                    ) : st.data_type === "integer" ? (
                      <NumberStepper
                        defaultValue={
                          typeof st.value === "number"
                            ? st.value
                            : parseInt(String(st.value), 10) || 0
                        }
                        disabled={!canEdit || settingUpdating === st.key}
                        unit={st.key.includes("days") ? "days" : ""}
                        min={1}
                        max={500}
                        onChange={(newVal) => {
                          if (newVal !== st.value) onUpdateSetting(st.key, newVal);
                        }}
                      />
                    ) : (
                      <span className="font-mono text-xs text-foreground">
                        {JSON.stringify(st.value)}
                      </span>
                    )}
                  </div>
                </div>
                {!isLast && <div className="matrix-line-h bottom-0" />}
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
}
