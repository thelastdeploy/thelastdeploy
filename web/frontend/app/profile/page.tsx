// web/frontend/app/profile/page.tsx

"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { useAuth } from "@/lib/auth";
import { api } from "@/lib/api";
import { LoadingSpinner } from "@/components/shared/loading-spinner";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { getRank, getNextRank, getXpProgress } from "@/lib/ranks";

export default function ProfilePage() {
  const { user, loading, logout, refreshUser } = useAuth();
  const router = useRouter();

  // Active tab state
  const [activeTab, setActiveTab] = useState<"overview" | "settings" | "security">("overview");

  // Lab search state
  const [labSearch, setLabSearch] = useState("");

  // Profile update states
  const [username, setUsername] = useState("");
  const [email, setEmail] = useState("");
  const [profileLoading, setProfileLoading] = useState(false);
  const [profileError, setProfileError] = useState<string | null>(null);
  const [profileSuccess, setProfileSuccess] = useState<string | null>(null);

  // Password update states
  const [oldPassword, setOldPassword] = useState("");
  const [newPassword, setNewPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [passwordLoading, setPasswordLoading] = useState(false);
  const [passwordError, setPasswordError] = useState<string | null>(null);
  const [passwordSuccess, setPasswordSuccess] = useState<string | null>(null);

  // Sync inputs with user data once loaded
  useEffect(() => {
    if (user) {
      setUsername(user.username);
      setEmail(user.email);
    }
  }, [user]);

  useEffect(() => {
    if (!loading && !user) router.push("/login");
  }, [user, loading, router]);

  if (loading || !user) return <LoadingSpinner className="py-40" />;

  const rank = getRank(user.xp);
  const nextRank = getNextRank(user.xp);
  const xpProgress = getXpProgress(user.xp);

  // Helper to extract clean initials (e.g. "0xShreyansh" -> "S" or "SH")
  const getInitials = (name: string) => {
    const cleanName = name.startsWith("0x") ? name.slice(2) : name;
    if (!cleanName) return name.slice(0, 1).toUpperCase();
    return cleanName.slice(0, 2).toUpperCase();
  };

  // Helper to determine lab topic from ID prefix
  const getTopicBadge = (labId: string) => {
    if (labId.startsWith("dkr-")) {
      return { label: "Docker", color: "text-blue-400 bg-blue-500/10 border-blue-500/20" };
    }
    if (labId.startsWith("k8s-")) {
      return { label: "Kubernetes", color: "text-indigo-400 bg-indigo-500/10 border-indigo-500/20" };
    }
    if (labId.startsWith("lnx-")) {
      return { label: "Linux", color: "text-orange-400 bg-orange-500/10 border-orange-500/20" };
    }
    if (labId.startsWith("git-")) {
      return { label: "Git", color: "text-red-400 bg-red-500/10 border-red-500/20" };
    }
    return { label: "System", color: "text-muted-foreground bg-muted border-border" };
  };

  const handleUpdateProfile = async (e: React.FormEvent) => {
    e.preventDefault();
    setProfileError(null);
    setProfileSuccess(null);
    setProfileLoading(true);

    try {
      const emailChanged = email !== user.email;
      const res = await api.updateProfile(username, email);
      
      if (emailChanged) {
        setProfileSuccess("Email updated! You will be logged out to verify your new email.");
        setTimeout(() => {
          logout();
          router.push("/login");
        }, 3000);
      } else {
        setProfileSuccess(res.detail);
        await refreshUser();
      }
    } catch (err: unknown) {
      setProfileError(err instanceof Error ? err.message : "Failed to update profile");
    } finally {
      setProfileLoading(false);
    }
  };

  const handleUpdatePassword = async (e: React.FormEvent) => {
    e.preventDefault();
    setPasswordError(null);
    setPasswordSuccess(null);

    if (newPassword !== confirmPassword) {
      setPasswordError("Passwords do not match.");
      return;
    }

    if (newPassword.length < 8) {
      setPasswordError("New password must be at least 8 characters long.");
      return;
    }

    setPasswordLoading(true);

    try {
      const res = await api.updatePassword(oldPassword, newPassword);
      setPasswordSuccess(res.detail);
      setOldPassword("");
      setNewPassword("");
      setConfirmPassword("");
    } catch (err: unknown) {
      setPasswordError(err instanceof Error ? err.message : "Failed to update password");
    } finally {
      setPasswordLoading(false);
    }
  };

  // Filter completed labs by search query
  const filteredLabs = user.completed_labs.filter((labId) =>
    labId.toLowerCase().includes(labSearch.toLowerCase())
  );

  return (
    <div className="max-w-4xl mx-auto px-4 py-12 transition-colors duration-300">
      
      {/* Profile Header Dashboard Widget */}
      <div className="bg-card border border-border rounded-2xl p-6 md:p-8 shadow-xl flex flex-col md:flex-row items-center md:items-start gap-6 mb-10 relative overflow-hidden">
        {/* Subtle grid background decoration */}
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
              👑 {rank.label}
            </span>
            <span className="px-3.5 py-1 rounded-full text-xs font-black bg-card border border-border text-foreground flex items-center gap-1.5 shadow-sm">
              ⚡ {user.xp} Total XP
            </span>
          </div>

          {/* XP Progress Bar */}
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
        <button
          onClick={() => setActiveTab("overview")}
          className={`pb-3 font-bold text-sm border-b-2 transition-all cursor-pointer ${
            activeTab === "overview"
              ? "border-[var(--accent-primary)] text-foreground"
              : "border-transparent text-muted-foreground hover:text-foreground"
          }`}
        >
          Overview
        </button>
        <button
          onClick={() => setActiveTab("settings")}
          className={`pb-3 font-bold text-sm border-b-2 transition-all cursor-pointer ${
            activeTab === "settings"
              ? "border-[var(--accent-primary)] text-foreground"
              : "border-transparent text-muted-foreground hover:text-foreground"
          }`}
        >
          Account Settings
        </button>
        <button
          onClick={() => setActiveTab("security")}
          className={`pb-3 font-bold text-sm border-b-2 transition-all cursor-pointer ${
            activeTab === "security"
              ? "border-[var(--accent-primary)] text-foreground"
              : "border-transparent text-muted-foreground hover:text-foreground"
          }`}
        >
          Security
        </button>
      </div>

      {/* Tab Panels */}
      <div className="space-y-6">
        
        {/* TAB 1: OVERVIEW */}
        {activeTab === "overview" && (
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6 items-start">
            
            {/* Activity Summary Column */}
            <div className="md:col-span-1 space-y-6">
              <div className="bg-card border border-border rounded-2xl p-6 shadow-md space-y-5">
                <div>
                  <h2 className="text-lg font-black text-foreground">Activity Summary</h2>
                  <p className="text-xs text-muted-foreground mt-0.5">{rank.description}</p>
                </div>
                <div className="space-y-4">
                  <div className="flex justify-between items-center border-b border-border/50 pb-2">
                    <span className="text-sm text-muted-foreground">Labs Completed</span>
                    <span className="font-bold text-foreground font-mono text-base bg-muted px-2.5 py-0.5 rounded-lg border border-border/60">
                      {user.completed_labs.length}
                    </span>
                  </div>
                  <div className="flex justify-between items-center border-b border-border/50 pb-2">
                    <span className="text-sm text-muted-foreground">Reading Sections</span>
                    <span className="font-bold text-foreground font-mono text-base bg-muted px-2.5 py-0.5 rounded-lg border border-border/60">
                      {user.completed_sections.length}
                    </span>
                  </div>
                  <div className="flex justify-between items-center">
                    <span className="text-sm text-muted-foreground">Rank Tier</span>
                    <span className="font-bold text-xs uppercase tracking-wide px-2 py-0.5 rounded-lg bg-[var(--accent-primary)]/10 text-[var(--accent-primary)] border border-[var(--accent-primary)]/20">
                      {rank.label}
                    </span>
                  </div>
                </div>
              </div>
            </div>

            {/* Completed Labs Column */}
            <div className="md:col-span-2 space-y-4">
              <div className="bg-card border border-border rounded-2xl p-6 shadow-md space-y-6">
                <div className="flex flex-col sm:flex-row justify-between sm:items-center gap-3">
                  <h2 className="text-lg font-black text-foreground">Completed Labs & Progress</h2>
                  
                  {/* Premium Search Filter */}
                  {user.completed_labs.length > 0 && (
                    <div className="relative max-w-xs">
                      <input
                        type="text"
                        placeholder="Search labs..."
                        value={labSearch}
                        onChange={(e) => setLabSearch(e.target.value)}
                        className="w-full bg-background border border-border text-foreground text-xs placeholder:text-muted-foreground/45 h-9 px-3 rounded-lg focus:border-[var(--accent-primary)] focus:ring-0 outline-none"
                      />
                    </div>
                  )}
                </div>

                {user.completed_labs.length === 0 ? (
                  <div className="text-center py-16 text-muted-foreground text-sm space-y-3">
                    <p>No labs completed yet.</p>
                    <p className="text-xs">Go to your dashboard to sync and start practicing DevOps labs!</p>
                  </div>
                ) : filteredLabs.length === 0 ? (
                  <div className="text-center py-12 text-muted-foreground text-xs">
                    No completed labs match &quot;{labSearch}&quot;
                  </div>
                ) : (
                  <div className="space-y-3 max-h-[420px] overflow-y-auto pr-1">
                    {filteredLabs.map((labId) => {
                      const topic = getTopicBadge(labId);
                      return (
                        <div
                          key={labId}
                          className="flex items-center justify-between p-4 bg-background/50 hover:bg-background/90 hover:scale-[1.005] hover:border-[var(--accent-primary)]/45 transition-all duration-300 rounded-xl border border-border gap-4 group"
                        >
                          <div className="flex items-center gap-3.5">
                            <div className="w-9 h-9 rounded-xl bg-emerald-500/10 flex items-center justify-center text-emerald-500 border border-emerald-500/20 group-hover:scale-105 transition-all">
                              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M5 13l4 4L19 7" />
                              </svg>
                            </div>
                            <div className="space-y-1">
                              <p className="font-bold text-foreground text-sm tracking-wide group-hover:text-[var(--accent-primary)] transition-all">{labId}</p>
                              <span className={`inline-block px-2 py-0.5 rounded text-[9px] font-black tracking-wider uppercase border ${topic.color}`}>
                                {topic.label}
                              </span>
                            </div>
                          </div>

                          <span className="px-3 py-1 rounded-full text-[10px] font-black uppercase bg-emerald-500/10 text-emerald-400 border border-emerald-500/20 select-none">
                            Completed
                          </span>
                        </div>
                      );
                    })}
                  </div>
                )}
              </div>
            </div>

          </div>
        )}

        {/* TAB 2: ACCOUNT SETTINGS */}
        {activeTab === "settings" && (
          <div className="bg-card border border-border rounded-2xl p-6 md:p-8 shadow-md max-w-xl">
            <div className="mb-6">
              <h2 className="text-xl font-black text-foreground">Profile Settings</h2>
              <p className="text-xs text-muted-foreground mt-0.5">Manage your user profile details.</p>
            </div>
            
            <form onSubmit={handleUpdateProfile} className="space-y-4">
              <div className="space-y-1.5">
                <Label htmlFor="username" className="text-muted-foreground/80 text-xs font-semibold uppercase tracking-wider">
                  Username
                </Label>
                <Input
                  id="username"
                  type="text"
                  value={username}
                  onChange={(e) => setUsername(e.target.value)}
                  required
                  className="bg-card border-border text-foreground placeholder:text-muted-foreground/45 h-12 rounded-xl focus:border-[var(--accent-primary)] focus:ring-0"
                />
              </div>

              <div className="space-y-1.5">
                <Label htmlFor="email" className="text-muted-foreground/80 text-xs font-semibold uppercase tracking-wider">
                  Email Address
                </Label>
                <Input
                  id="email"
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  required
                  className="bg-card border-border text-foreground placeholder:text-muted-foreground/45 h-12 rounded-xl focus:border-[var(--accent-primary)] focus:ring-0"
                />
                <p className="text-[10px] text-muted-foreground/60 italic mt-1.5 leading-relaxed">
                  Changing your email address will mark your account unverified. You will be logged out and a verification link will be sent to the new email address.
                </p>
              </div>

              {profileError && (
                <div className="text-sm text-red-500 bg-red-500/10 border border-red-500/20 px-4 py-3 rounded-xl">
                  {profileError}
                </div>
              )}

              {profileSuccess && (
                <div className="text-sm text-emerald-500 bg-emerald-500/10 border border-emerald-500/20 px-4 py-3 rounded-xl">
                  {profileSuccess}
                </div>
              )}

              <button
                type="submit"
                disabled={profileLoading}
                className="h-12 rounded-xl font-bold text-background bg-[var(--accent-primary)] hover:opacity-90 px-6 disabled:opacity-50 disabled:cursor-not-allowed mt-2 transition-all text-white dark:text-black cursor-pointer shadow-sm shadow-[rgba(var(--accent-primary-rgb),0.1)]"
              >
                {profileLoading ? "Saving changes..." : "Save Changes"}
              </button>
            </form>
          </div>
        )}

        {/* TAB 3: SECURITY / PASSWORD */}
        {activeTab === "security" && (
          <div className="bg-card border border-border rounded-2xl p-6 md:p-8 shadow-md max-w-xl">
            <div className="mb-6">
              <h2 className="text-xl font-black text-foreground">Change Password</h2>
              <p className="text-xs text-muted-foreground mt-0.5">Ensure your account stays secure.</p>
            </div>

            <form onSubmit={handleUpdatePassword} className="space-y-4">
              <div className="space-y-1.5">
                <Label htmlFor="oldPassword" className="text-muted-foreground/80 text-xs font-semibold uppercase tracking-wider">
                  Current Password
                </Label>
                <Input
                  id="oldPassword"
                  type="password"
                  value={oldPassword}
                  onChange={(e) => setOldPassword(e.target.value)}
                  required
                  placeholder="••••••••"
                  className="bg-card border-border text-foreground placeholder:text-muted-foreground/45 h-12 rounded-xl focus:border-[var(--accent-primary)] focus:ring-0"
                />
              </div>

              <div className="space-y-1.5">
                <Label htmlFor="newPassword" className="text-muted-foreground/80 text-xs font-semibold uppercase tracking-wider">
                  New Password
                </Label>
                <Input
                  id="newPassword"
                  type="password"
                  value={newPassword}
                  onChange={(e) => setNewPassword(e.target.value)}
                  required
                  placeholder="••••••••"
                  className="bg-card border-border text-foreground placeholder:text-muted-foreground/45 h-12 rounded-xl focus:border-[var(--accent-primary)] focus:ring-0"
                />
              </div>

              <div className="space-y-1.5">
                <Label htmlFor="confirmPassword" className="text-muted-foreground/80 text-xs font-semibold uppercase tracking-wider">
                  Confirm New Password
                </Label>
                <Input
                  id="confirmPassword"
                  type="password"
                  value={confirmPassword}
                  onChange={(e) => setConfirmPassword(e.target.value)}
                  required
                  placeholder="••••••••"
                  className="bg-card border-border text-foreground placeholder:text-muted-foreground/45 h-12 rounded-xl focus:border-[var(--accent-primary)] focus:ring-0"
                />
              </div>

              {passwordError && (
                <div className="text-sm text-red-500 bg-red-500/10 border border-red-500/20 px-4 py-3 rounded-xl">
                  {passwordError}
                </div>
              )}

              {passwordSuccess && (
                <div className="text-sm text-emerald-500 bg-emerald-500/10 border border-emerald-500/20 px-4 py-3 rounded-xl">
                  {passwordSuccess}
                </div>
              )}

              <button
                type="submit"
                disabled={passwordLoading}
                className="h-12 rounded-xl font-bold text-background bg-[var(--accent-primary)] hover:opacity-90 px-6 disabled:opacity-50 disabled:cursor-not-allowed mt-2 transition-all text-white dark:text-black cursor-pointer shadow-sm shadow-[rgba(var(--accent-primary-rgb),0.1)]"
              >
                {passwordLoading ? "Updating password..." : "Update Password"}
              </button>
            </form>
          </div>
        )}

      </div>
    </div>
  );
}