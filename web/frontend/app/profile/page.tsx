// web/frontend/app/profile/page.tsx

"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { useAuth } from "@/lib/auth";
import { LoadingSpinner } from "@/components/shared/loading-spinner";
import { getRank, getNextRank, getXpProgress } from "@/lib/ranks";
import { ProfileOverviewTab } from "@/components/profile/profile-overview-tab";
import { ProfileSettingsTab } from "@/components/profile/profile-settings-tab";
import { ProfileSecurityTab } from "@/components/profile/profile-security-tab";

export default function ProfilePage() {
  const { user, loading, logout, refreshUser } = useAuth();
  const router = useRouter();
  const [activeTab, setActiveTab] = useState<"overview" | "settings" | "security">("overview");

  useEffect(() => {
    if (!loading && !user) router.push("/login");
  }, [user, loading, router]);

  if (loading || !user) return <LoadingSpinner className="py-40" />;

  const rank = getRank(user.xp);
  const nextRank = getNextRank(user.xp);
  const xpProgress = getXpProgress(user.xp);

  const getInitials = (name: string) => {
    const cleanName = name.startsWith("0x") ? name.slice(2) : name;
    if (!cleanName) return name.slice(0, 1).toUpperCase();
    return cleanName.slice(0, 2).toUpperCase();
  };

  return (
    <div className="max-w-4xl mx-auto px-4 py-12 transition-colors duration-300">
      {/* Profile Header Dashboard Widget */}
      <div className="bg-card border border-border rounded-2xl p-6 md:p-8 shadow-xl flex flex-col md:flex-row items-center md:items-start gap-6 mb-10 relative overflow-hidden">
        <div className="absolute inset-0 bg-[radial-gradient(ellipse_at_top_right,rgba(var(--accent-primary-rgb),0.03),transparent_50%)] pointer-events-none" />

        <div className="w-24 h-24 rounded-full bg-gradient-to-tr from-[var(--accent-primary)] to-emerald-400 flex items-center justify-center border-4 border-card shadow-lg text-black font-black text-3xl select-none uppercase shrink-0">
          {getInitials(user.username)}
        </div>
        <div className="flex-1 w-full text-center md:text-left space-y-4 relative z-10">
          <div>
            <h1 className="text-3xl font-black text-foreground tracking-tight">{user.username}</h1>
            <p className="text-muted-foreground text-sm mt-1">{user.email}</p>
          </div>

          <div className="flex flex-wrap items-center justify-center md:justify-start gap-3">
            <span
              className="px-3.5 py-1 rounded-full text-xs font-black tracking-wide uppercase flex items-center gap-1.5"
              style={{ backgroundColor: `${rank.color}15`, color: rank.color, border: `1px solid ${rank.color}30` }}
            >
              {rank.label}
            </span>
            <span className="px-3.5 py-1 rounded-full text-xs font-black bg-card border border-border text-foreground flex items-center gap-1.5 shadow-sm">
              ⚡ {user.xp} Total XP
            </span>
          </div>

          <div className="space-y-1.5 pt-2">
            <div className="flex justify-between text-xs font-bold tracking-wide uppercase text-muted-foreground/80">
              <span>Progress to next rank</span>
              {nextRank ? (
                <span>
                  {user.xp} / {nextRank.minXp} XP
                </span>
              ) : (
                <span>MAX RANK REACHED</span>
              )}
            </div>
            <div className="w-full bg-border rounded-full h-3 overflow-hidden relative shadow-inner">
              <div
                className="h-full rounded-full transition-all duration-500 shadow-sm"
                style={{
                  width: `${xpProgress.pct}%`,
                  background: `linear-gradient(90deg, var(--accent-primary) 0%, ${rank.color} 100%)`,
                }}
              />
            </div>
            {nextRank && (
              <div className="text-[10px] text-muted-foreground/60 italic text-right">
                Next Rank: {nextRank.label} ({nextRank.minXp - user.xp} XP needed)
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Tabs Selector Navigation */}
      <div className="flex border-b border-border mb-8 gap-6 overflow-x-auto select-none">
        {(
          [
            { key: "overview", label: "Overview" },
            { key: "settings", label: "Account Settings" },
            { key: "security", label: "Security" },
          ] as const
        ).map((tab) => (
          <button
            key={tab.key}
            onClick={() => setActiveTab(tab.key)}
            className={`pb-3 font-bold text-sm border-b-2 transition-all cursor-pointer ${
              activeTab === tab.key
                ? "border-[var(--accent-primary)] text-foreground"
                : "border-transparent text-muted-foreground hover:text-foreground"
            }`}
          >
            {tab.label}
          </button>
        ))}
      </div>

      <div className="space-y-6">
        {activeTab === "overview" && <ProfileOverviewTab user={user} rank={rank} />}
        {activeTab === "settings" && (
          <ProfileSettingsTab user={user} logout={logout} refreshUser={refreshUser} />
        )}
        {activeTab === "security" && <ProfileSecurityTab />}
      </div>
    </div>
  );
}
