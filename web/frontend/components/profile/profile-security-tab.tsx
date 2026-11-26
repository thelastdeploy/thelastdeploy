"use client";

import { useEffect, useState } from "react";
import { api } from "@/lib/api";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import type { SessionResponse } from "@/lib/types";
import { Laptop, Terminal, ShieldCheck, Clock, Check } from "lucide-react";

export function ProfileSecurityTab() {
  const [oldPassword, setOldPassword] = useState("");
  const [newPassword, setNewPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [passwordLoading, setPasswordLoading] = useState(false);
  const [passwordError, setPasswordError] = useState<string | null>(null);
  const [passwordSuccess, setPasswordSuccess] = useState<string | null>(null);

  const [sessions, setSessions] = useState<SessionResponse[]>([]);
  const [sessionsLoading, setSessionsLoading] = useState(false);
  const [sessionError, setSessionError] = useState<string | null>(null);

  useEffect(() => {
    const loadSessions = async () => {
      setSessionsLoading(true);
      try {
        const data = await api.getSessions();
        setSessions(data);
      } catch (err) {
        console.error("Failed to load sessions:", err);
      } finally {
        setSessionsLoading(false);
      }
    };
    loadSessions();
  }, []);

  const handleRevokeSession = async (sessionId: number) => {
    setSessionError(null);
    try {
      await api.revokeSession(sessionId);
      setSessions((prev) => prev.filter((s) => s.id !== sessionId));
    } catch (err: unknown) {
      setSessionError(
        err instanceof Error ? err.message : "Failed to revoke session."
      );
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

  return (
    <div className="space-y-6 max-w-xl">
      <div className="bg-card border border-border rounded-2xl p-6 md:p-8 shadow-md">
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

      {/* Active Sessions & Devices */}
      <div className="bg-card border border-border rounded-2xl p-6 md:p-8 shadow-md max-w-xl mt-6">
        <div className="mb-6 flex items-center justify-between">
          <div>
            <h2 className="text-xl font-black text-foreground">Active Sessions & Devices</h2>
            <p className="text-xs text-muted-foreground mt-0.5">Manage authenticated browser and CLI sessions.</p>
          </div>
          <ShieldCheck className="h-5 w-5 text-[var(--accent-primary)]" />
        </div>

        {sessionError && (
          <div className="mb-4 text-xs text-red-500 bg-red-500/10 border border-red-500/20 px-3 py-2 rounded-none">
            {sessionError}
          </div>
        )}

        {sessionsLoading ? (
          <div className="py-6 text-center text-xs font-mono text-muted-foreground animate-pulse">
            Loading sessions...
          </div>
        ) : sessions.length === 0 ? (
          <div className="py-6 text-center text-xs text-muted-foreground">
            No active sessions found.
          </div>
        ) : (
          <div className="space-y-3">
            {sessions.map((s) => {
              const isCli = s.client_type === "cli";
              return (
                <div
                  key={s.id}
                  className="p-3.5 rounded-xl border border-border/70 bg-muted/20 flex items-center justify-between gap-3 text-xs"
                >
                  <div className="flex items-center gap-3">
                    <div className="p-2 rounded-lg bg-muted text-foreground">
                      {isCli ? (
                        <Terminal className="h-4 w-4 text-[var(--accent-primary)]" />
                      ) : (
                        <Laptop className="h-4 w-4 text-[var(--accent-primary)]" />
                      )}
                    </div>
                    <div>
                      <div className="flex items-center gap-2">
                        <span className="font-bold text-foreground capitalize">
                          {s.client_type} Session
                        </span>
                        {s.is_current && (
                          <span className="text-[10px] font-mono px-2 py-0.2 rounded-full bg-emerald-500/10 text-emerald-400 font-bold flex items-center gap-1">
                            <Check className="h-2.5 w-2.5" /> This Device
                          </span>
                        )}
                      </div>
                      <p className="text-[11px] text-muted-foreground font-mono mt-0.5">
                        {s.ip_address || "Unknown IP"} •{" "}
                        {s.user_agent
                          ? s.user_agent.length > 35
                            ? s.user_agent.slice(0, 35) + "..."
                            : s.user_agent
                          : "TLD Client"}
                      </p>
                      <p className="text-[10px] text-muted-foreground/60 flex items-center gap-1 mt-0.5">
                        <Clock className="h-2.5 w-2.5" />
                        Active: {s.last_used_at ? new Date(s.last_used_at).toLocaleDateString() : "Just now"}
                      </p>
                    </div>
                  </div>

                  {!s.is_current && (
                    <button
                      type="button"
                      onClick={() => handleRevokeSession(s.id)}
                      className="px-2.5 py-1.5 rounded-lg border border-border/80 hover:border-destructive text-destructive hover:bg-destructive/10 text-xs font-semibold cursor-pointer transition-colors"
                      title="Revoke session"
                    >
                      Revoke
                    </button>
                  )}
                </div>
              );
            })}
          </div>
        )}
      </div>
    </div>
  );
}

