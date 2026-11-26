"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { api } from "@/lib/api";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import type { User } from "@/lib/types";

interface ProfileSettingsTabProps {
  user: User;
  logout: () => void;
  refreshUser: () => Promise<void>;
}

export function ProfileSettingsTab({
  user,
  logout,
  refreshUser,
}: ProfileSettingsTabProps) {
  const router = useRouter();
  const [username, setUsername] = useState(user.username);
  const [email, setEmail] = useState(user.email);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);

  useEffect(() => {
    setUsername(user.username);
    setEmail(user.email);
  }, [user.username, user.email]);

  const handleUpdateProfile = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setSuccess(null);
    setLoading(true);

    try {
      const emailChanged = email !== user.email;
      const res = await api.updateProfile(username, email);

      if (emailChanged) {
        setSuccess("Email updated! You will be logged out to verify your new email.");
        setTimeout(() => {
          logout();
          router.push("/login");
        }, 3000);
      } else {
        setSuccess(res.detail);
        await refreshUser();
      }
    } catch (err: unknown) {
      setError(err instanceof Error ? err.message : "Failed to update profile");
    } finally {
      setLoading(false);
    }
  };

  return (
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

        {error && (
          <div className="text-sm text-red-500 bg-red-500/10 border border-red-500/20 px-4 py-3 rounded-xl">
            {error}
          </div>
        )}

        {success && (
          <div className="text-sm text-emerald-500 bg-emerald-500/10 border border-emerald-500/20 px-4 py-3 rounded-xl">
            {success}
          </div>
        )}

        <button
          type="submit"
          disabled={loading}
          className="h-12 rounded-xl font-bold text-background bg-[var(--accent-primary)] hover:opacity-90 px-6 disabled:opacity-50 disabled:cursor-not-allowed mt-2 transition-all text-white dark:text-black cursor-pointer shadow-sm shadow-[rgba(var(--accent-primary-rgb),0.1)]"
        >
          {loading ? "Saving changes..." : "Save Changes"}
        </button>
      </form>
    </div>
  );
}

