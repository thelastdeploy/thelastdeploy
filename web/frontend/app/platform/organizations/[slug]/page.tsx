// web/frontend/app/platform/organizations/[slug]/page.tsx

"use client";

import { useEffect, useState, useMemo } from "react";
import { useRouter, useParams } from "next/navigation";
import Link from "next/link";
import { useAuth } from "@/lib/auth";
import { api } from "@/lib/api";
import { OrganizationResponse, OrgSettingAdminItemResponse } from "@/lib/types";
import { LoadingSpinner } from "@/components/shared/loading-spinner";
import {
  ArrowLeft,
  Building2,
  GraduationCap,
  Globe,
  Save,
  RotateCcw,
  AlertCircle,
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { NumberStepper } from "@/components/ui/number-stepper";

const SETTING_CHOICES: Record<string, { value: string; label: string }[]> = {
  "onboarding.access_approval_mode": [
    { value: "automatic", label: "Automatic" },
    { value: "manual", label: "Manual (Review Queue)" },
  ],
  "learning_paths.default_visibility": [
    { value: "public", label: "Public" },
    { value: "private", label: "Private" },
  ],
};

export default function PlatformOrgSettingsPage() {
  const { user, loading: authLoading } = useAuth();
  const router = useRouter();
  const params = useParams();
  const slug = (params?.slug as string) || "";

  const [org, setOrg] = useState<OrganizationResponse | null>(null);
  const [settings, setSettings] = useState<OrgSettingAdminItemResponse[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // Initial pristine state
  const [initialEnabled, setInitialEnabled] = useState<Record<string, boolean>>({});
  const [initialValues, setInitialValues] = useState<Record<string, any>>({});

  // Draft editing state
  const [draftEnabled, setDraftEnabled] = useState<Record<string, boolean>>({});
  const [draftValues, setDraftValues] = useState<Record<string, any>>({});

  const [saving, setSaving] = useState(false);
  const [selectedCategory, setSelectedCategory] = useState<string>("all");

  const hasPerm = (perm: string) => {
    if (!user) return false;
    if (user.platform_roles?.includes("platform_admin")) return true;
    return Boolean(user.platform_permissions?.includes(perm));
  };

  const canManageSettings =
    hasPerm("platform.organizations.settings") || hasPerm("platform.organizations.manage");

  useEffect(() => {
    if (authLoading) return;
    if (!user) {
      router.push("/login");
      return;
    }
    if (!canManageSettings) {
      setError("You do not have permission to manage platform organization settings.");
      setLoading(false);
      return;
    }

    loadOrgAndSettings();
  }, [user, authLoading, slug]);

  const loadOrgAndSettings = async () => {
    setLoading(true);
    setError(null);
    try {
      const [allOrgs, settingsList] = await Promise.all([
        api.getOrganizations().catch(() => []),
        api.getPlatformOrgSettings(slug),
      ]);

      const foundOrg = allOrgs.find((o) => o.slug === slug) || null;
      setOrg(foundOrg);
      setSettings(settingsList);

      const initEn: Record<string, boolean> = {};
      const initVal: Record<string, any> = {};

      settingsList.forEach((st) => {
        initEn[st.key] = st.is_enabled;
        initVal[st.key] = st.value !== null && st.value !== undefined ? st.value : st.default;
      });

      setInitialEnabled(initEn);
      setInitialValues(initVal);
      setDraftEnabled(initEn);
      setDraftValues(initVal);
    } catch (err: any) {
      setError(err.message || "Failed to load platform settings for organization.");
    } finally {
      setLoading(false);
    }
  };

  // Change detection
  const hasChanges = useMemo(() => {
    if (settings.length === 0) return false;
    for (const st of settings) {
      if (draftEnabled[st.key] !== initialEnabled[st.key]) return true;
      if (JSON.stringify(draftValues[st.key]) !== JSON.stringify(initialValues[st.key])) return true;
    }
    return false;
  }, [settings, draftEnabled, initialEnabled, draftValues, initialValues]);

  // Changed keys list for visual indicators
  const modifiedKeys = useMemo(() => {
    const keys = new Set<string>();
    for (const st of settings) {
      if (
        draftEnabled[st.key] !== initialEnabled[st.key] ||
        JSON.stringify(draftValues[st.key]) !== JSON.stringify(initialValues[st.key])
      ) {
        keys.add(st.key);
      }
    }
    return keys;
  }, [settings, draftEnabled, initialEnabled, draftValues, initialValues]);

  // Categories extraction
  const categories = useMemo(() => {
    const cats = Array.from(new Set(settings.map((s) => s.category))).filter(Boolean);
    return ["all", ...cats];
  }, [settings]);

  const filteredSettings = useMemo(() => {
    if (selectedCategory === "all") return settings;
    return settings.filter((s) => s.category.toLowerCase() === selectedCategory.toLowerCase());
  }, [settings, selectedCategory]);

  const handleToggleAvailability = (key: string) => {
    setDraftEnabled((prev) => ({
      ...prev,
      [key]: !prev[key],
    }));
  };

  const handleValueChange = (key: string, val: any) => {
    setDraftValues((prev) => ({
      ...prev,
      [key]: val,
    }));
  };

  const handleReset = () => {
    setDraftEnabled(initialEnabled);
    setDraftValues(initialValues);
  };

  const handleSave = async () => {
    if (!hasChanges || saving) return;
    setSaving(true);
    setError(null);

    try {
      for (const st of settings) {
        const wasEnabled = initialEnabled[st.key];
        const nowEnabled = draftEnabled[st.key] ?? wasEnabled;
        const origVal = initialValues[st.key];
        const currentVal = draftValues[st.key];

        // 1. Availability change
        if (wasEnabled !== nowEnabled) {
          if (nowEnabled) {
            await api.enablePlatformOrgSetting(slug, st.key, currentVal);
          } else {
            await api.disablePlatformOrgSetting(slug, st.key);
          }
        }

        // 2. Value overrides (if enabled and value changed)
        if (nowEnabled && JSON.stringify(origVal) !== JSON.stringify(currentVal)) {
          await api.overridePlatformOrgSetting(slug, st.key, currentVal);
        }
      }

      // Refresh to sync state
      const updated = await api.getPlatformOrgSettings(slug);
      setSettings(updated);
      const initEn: Record<string, boolean> = {};
      const initVal: Record<string, any> = {};
      updated.forEach((st) => {
        initEn[st.key] = st.is_enabled;
        initVal[st.key] = st.value !== null && st.value !== undefined ? st.value : st.default;
      });
      setInitialEnabled(initEn);
      setInitialValues(initVal);
      setDraftEnabled(initEn);
      setDraftValues(initVal);

    } catch (err: any) {
      setError(err.message || "Failed to save organization settings.");
    } finally {
      setSaving(false);
    }
  };

  if (authLoading || loading) {
    return (
      <div className="min-h-[calc(100vh-64px)] flex items-center justify-center">
        <div className="text-muted-foreground text-sm font-mono flex items-center gap-2">
          <LoadingSpinner />
          <span>Loading organization settings...</span>
        </div>
      </div>
    );
  }

  if (error && !canManageSettings) {
    return (
      <div className="max-w-4xl mx-auto px-4 py-16 text-center space-y-4">
        <AlertCircle className="h-10 w-10 text-red-400 mx-auto" />
        <h1 className="text-xl font-bold text-foreground">Access Restricted</h1>
        <p className="text-sm text-muted-foreground">{error}</p>
        <Link href="/platform">
          <Button variant="outline" className="rounded-xl text-xs font-mono">
            Return to Platform Console
          </Button>
        </Link>
      </div>
    );
  }

  const isPlatformOrg = org?.type === "platform" || org?.is_platform;
  const displayName = isPlatformOrg ? "The Last Deploy (Personal)" : org?.name || slug;

  return (
    <div className="min-h-[calc(100vh-64px)] py-8 relative">
      <div className="max-w-5xl mx-auto px-4 sm:px-6 space-y-6">
        {/* Navigation Breadcrumb */}
        <div>
          <Link
            href="/platform"
            className="inline-flex items-center gap-1.5 text-xs text-muted-foreground hover:text-foreground font-mono transition-colors"
          >
            <ArrowLeft className="h-3.5 w-3.5" />
            <span>Return to Platform Console</span>
          </Link>
        </div>

        {/* Header Block with Actions */}
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 pb-6 border-b border-border/40">
          <div className="flex items-start gap-3.5">
            <div className="h-11 w-11 rounded-none bg-[var(--accent-primary)]/10 text-[var(--accent-primary)] flex items-center justify-center shrink-0 font-bold mt-0.5">
              {org?.type === "university" ? (
                <GraduationCap className="h-6 w-6" />
              ) : isPlatformOrg ? (
                <Globe className="h-6 w-6" />
              ) : (
                <Building2 className="h-6 w-6" />
              )}
            </div>

            <div>
              <div className="flex items-center gap-2 flex-wrap">
                <h1 className="text-2xl font-black tracking-tight text-foreground">{displayName}</h1>
                <span className="text-[11px] font-mono uppercase px-2 py-0.5 rounded-none bg-muted font-bold text-muted-foreground">
                  {slug}
                </span>
                {org?.type && (
                  <span className="text-[11px] font-mono uppercase px-2 py-0.5 rounded-none bg-muted font-bold text-muted-foreground">
                    {org.type}
                  </span>
                )}
                {org?.status && (
                  <span
                    className={`text-[11px] font-mono px-2 py-0.5 rounded-none font-bold capitalize ${
                      org.status === "suspended"
                        ? "bg-red-500/10 text-red-400 border border-red-500/30"
                        : "bg-emerald-500/10 text-emerald-400 border border-emerald-500/30"
                    }`}
                  >
                    {org.status}
                  </span>
                )}
              </div>
              <p className="text-xs text-muted-foreground mt-1 max-w-xl">
                Configure feature availability and platform default/override values for this organization.
              </p>
            </div>
          </div>

          {/* Action Buttons: Save & Reset */}
          <div className="flex items-center gap-2.5 shrink-0 self-start md:self-center">
            {hasChanges && (
              <span className="text-xs font-mono font-semibold text-amber-400 animate-pulse hidden sm:inline mr-1">
                Unsaved edits
              </span>
            )}

            <Button
              variant="outline"
              size="sm"
              onClick={handleReset}
              disabled={!hasChanges || saving}
              className="rounded-none text-xs font-mono h-9 cursor-pointer disabled:opacity-40 disabled:cursor-not-allowed"
            >
              <RotateCcw className="h-3.5 w-3.5 mr-1.5" />
              Reset
            </Button>

            <Button
              size="sm"
              onClick={handleSave}
              disabled={!hasChanges || saving}
              className={`rounded-none text-xs font-bold h-9 px-4 cursor-pointer transition-all ${
                hasChanges
                  ? "bg-[var(--accent-primary)] text-white dark:text-black hover:opacity-90"
                  : "bg-muted text-muted-foreground opacity-40 cursor-not-allowed"
              }`}
            >
              {saving ? (
                <>
                  <span className="ml-1.5">Saving...</span>
                </>
              ) : (
                <>
                  <Save className="h-3.5 w-3.5 mr-1.5" />
                  <span>Save Changes</span>
                </>
              )}
            </Button>
          </div>
        </div>

        {error && (
          <div className="p-3.5 rounded-none bg-red-500/10 border border-red-500/20 text-red-400 text-xs flex items-center gap-2 animate-in fade-in">
            <AlertCircle className="h-4 w-4 shrink-0" />
            <span>{error}</span>
          </div>
        )}

        {/* Category Filter Tabs */}
        {categories.length > 2 && (
          <div className="flex items-center gap-1 overflow-x-auto pb-1">
            {categories.map((cat) => (
              <button
                key={cat}
                type="button"
                onClick={() => setSelectedCategory(cat)}
                className={`px-3 py-1.5 rounded-none text-xs font-mono font-bold capitalize transition-all cursor-pointer whitespace-nowrap border ${
                  selectedCategory.toLowerCase() === cat.toLowerCase()
                    ? "bg-[var(--accent-primary)] text-white dark:text-black border-[var(--accent-primary)]"
                    : "text-muted-foreground hover:text-foreground hover:bg-muted/40 border-border/40"
                }`}
              >
                {cat}
              </button>
            ))}
          </div>
        )}

        {/* Single-Column Open Matrix with Continuous Horizontal Lines */}
        {filteredSettings.length === 0 ? (
          <div className="rounded-none border border-border bg-card p-8 text-center text-xs text-muted-foreground font-mono">
            No settings found for category &quot;{selectedCategory}&quot;.
          </div>
        ) : (
          <div className="relative overflow-visible">
            <div className="flex flex-col relative">
              {filteredSettings.map((st, idx) => {
                const isLast = idx === filteredSettings.length - 1;
                const isBool = st.data_type === "boolean";
                const isInt = st.data_type === "integer";
                const isEnabled = draftEnabled[st.key] ?? st.is_enabled;
                const val = draftValues[st.key];
                const isModified = modifiedKeys.has(st.key);
                const choices =
                  SETTING_CHOICES[st.key] ||
                  (st.allowed_values && st.allowed_values.length > 0
                    ? st.allowed_values.map((v: any) => ({
                        value: String(v),
                        label: String(v).charAt(0).toUpperCase() + String(v).slice(1),
                      }))
                    : null);

                return (
                  <div key={st.key} className="relative">
                    <div className="p-2.5 sm:p-3 text-left border-0">
                      {/* Frameless Idle -> Sharp Amber Inset on Modified / Emerald on Hover */}
                      <div
                        className="p-4 sm:p-5 rounded-none flex flex-col sm:flex-row sm:items-center justify-between gap-4 transition-all duration-150"
                        style={{
                          border: "none",
                          boxShadow: isModified ? "inset 0 0 0 2px #f59e0b" : "none",
                          backgroundColor: isModified
                            ? "rgba(245, 158, 11, 0.08)"
                            : "transparent",
                        }}
                        onMouseEnter={(e) => {
                          if (!isModified) {
                            const isDark = document.documentElement.classList.contains("dark");
                            e.currentTarget.style.boxShadow = "inset 0 0 0 2px var(--accent-primary)";
                            e.currentTarget.style.backgroundColor = isDark
                              ? "rgba(var(--accent-primary-rgb), 0.12)"
                              : "rgba(var(--accent-primary-rgb), 0.05)";
                          }
                        }}
                        onMouseLeave={(e) => {
                          if (!isModified) {
                            e.currentTarget.style.boxShadow = "none";
                            e.currentTarget.style.backgroundColor = "transparent";
                          }
                        }}
                      >
                        {/* Left: Info & Description */}
                        <div className="space-y-1.5 max-w-xl">
                          <div className="flex items-center gap-2 flex-wrap">
                            <span className="font-mono font-bold text-xs sm:text-sm text-foreground">
                              {st.key}
                            </span>
                            <span className="text-[10px] font-mono uppercase px-1.5 py-0.5 rounded-none bg-muted text-muted-foreground font-bold">
                              {st.category}
                            </span>
                            {isModified && (
                              <span className="text-[10px] font-mono text-amber-400 font-semibold">
                                • Modified
                              </span>
                            )}
                          </div>
                          <p className="text-xs text-muted-foreground leading-relaxed">{st.description}</p>
                          <div className="text-[11px] font-mono text-muted-foreground/75 flex items-center gap-1.5">
                            <span>Registry Default:</span>
                            <span className="text-zinc-300 font-semibold">{String(st.default)}</span>
                          </div>
                        </div>

                        {/* Right: Inline Flat Sharp Controls */}
                        <div className="flex items-center gap-3 shrink-0 justify-between sm:justify-end">
                          {/* Value / Override Editor */}
                          <div className="flex items-center gap-2">
                            <span className="text-xs text-muted-foreground hidden lg:inline">Value:</span>
                            {isBool ? (
                              <Select
                                value={val === true ? "true" : "false"}
                                onValueChange={(newVal) => handleValueChange(st.key, newVal === "true")}
                                disabled={!isEnabled}
                              >
                                <SelectTrigger className="h-8 w-24 text-xs font-mono rounded-none">
                                  <SelectValue />
                                </SelectTrigger>
                                <SelectContent className="rounded-none">
                                  <SelectItem value="true" className="rounded-none">True</SelectItem>
                                  <SelectItem value="false" className="rounded-none">False</SelectItem>
                                </SelectContent>
                              </Select>
                            ) : isInt ? (
                              <NumberStepper
                                value={typeof val === "number" ? val : parseInt(val || "0", 10)}
                                min={1}
                                max={500}
                                step={1}
                                onChange={(newVal) => handleValueChange(st.key, newVal)}
                                disabled={!isEnabled}
                              />
                            ) : choices ? (
                              <Select
                                value={String(val ?? st.default ?? "")}
                                onValueChange={(newVal) => handleValueChange(st.key, newVal)}
                                disabled={!isEnabled}
                              >
                                <SelectTrigger className="h-8 min-w-[140px] text-xs font-mono rounded-none">
                                  <SelectValue />
                                </SelectTrigger>
                                <SelectContent className="rounded-none">
                                  {choices.map((choice) => (
                                    <SelectItem key={choice.value} value={choice.value} className="rounded-none">
                                      {choice.label}
                                    </SelectItem>
                                  ))}
                                </SelectContent>
                              </Select>
                            ) : (
                              <Input
                                value={val ?? ""}
                                onChange={(e) => handleValueChange(st.key, e.target.value)}
                                disabled={!isEnabled}
                                className="h-8 w-40 text-xs font-mono rounded-none"
                              />
                            )}
                          </div>

                          {/* Availability Toggle */}
                          <button
                            type="button"
                            onClick={() => handleToggleAvailability(st.key)}
                            className={`px-3 py-1.5 rounded-none text-xs font-mono font-bold transition-all cursor-pointer ${
                              isEnabled
                                ? "bg-emerald-500/15 text-emerald-400 border border-emerald-500/30 hover:bg-emerald-500/25"
                                : "bg-muted text-muted-foreground border border-border/40 hover:bg-muted/80"
                            }`}
                          >
                            {isEnabled ? "Enabled" : "Disabled"}
                          </button>
                        </div>
                      </div>
                    </div>

                    {/* Continuous Horizontal Line */}
                    {!isLast && (
                      <div className="matrix-line-h bottom-0" />
                    )}
                  </div>
                );
              })}
            </div>
          </div>
        )}

        {/* Bottom Save Bar (Visible when scrolled if changes exist) */}
        {hasChanges && (
          <div className="sticky bottom-4 z-20 p-3 sm:p-4 rounded-none bg-background/95 border border-border shadow-xl backdrop-blur-md flex items-center justify-between gap-4 animate-in slide-in-from-bottom-2">
            <div className="flex items-center gap-2 text-xs font-mono">
              <span className="h-2 w-2 rounded-full bg-amber-400 animate-ping" />
              <span className="text-foreground font-semibold">
                You have {modifiedKeys.size} unsaved change{modifiedKeys.size === 1 ? "" : "s"}
              </span>
            </div>

            <div className="flex items-center gap-2">
              <Button
                variant="outline"
                size="sm"
                onClick={handleReset}
                disabled={saving}
                className="rounded-none text-xs font-mono h-8 cursor-pointer"
              >
                Reset
              </Button>
              <Button
                size="sm"
                onClick={handleSave}
                disabled={saving}
                className="rounded-none bg-[var(--accent-primary)] text-white dark:text-black hover:opacity-90 font-bold text-xs h-8 px-4 cursor-pointer"
              >
                {saving ? "Saving..." : "Save Changes"}
              </Button>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}

