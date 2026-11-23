// web/frontend/app/join/setup/page.tsx

"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { api } from "@/lib/api";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card";
import { UserCheck, Lock, AlertCircle, ArrowRight, ShieldCheck, Check } from "lucide-react";
import Link from "next/link";

export default function JoinSetupPage() {
  const router = useRouter();
  const [onboardingToken, setOnboardingToken] = useState<string | null>(null);
  const [email, setEmail] = useState<string>("");
  const [orgName, setOrgName] = useState<string>("");

  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (typeof window !== "undefined") {
      const token = sessionStorage.getItem("tld:onboarding_token");
      const savedEmail = sessionStorage.getItem("tld:onboarding_email") || "";
      const savedOrg = sessionStorage.getItem("tld:onboarding_org") || "";

      if (!token) {
        router.push("/join");
        return;
      }

      setOnboardingToken(token);
      setEmail(savedEmail);
      setOrgName(savedOrg);

      // Pre-fill a suggestion for username from email
      if (savedEmail && !username) {
        const prefix = savedEmail.split("@")[0].replace(/[^a-zA-Z0-9_-]/g, "");
        setUsername(prefix);
      }
    }
  }, [router]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!onboardingToken) return;

    if (!username.trim() || username.length < 3) {
      setError("Username must be at least 3 characters.");
      return;
    }

    if (password.length < 8) {
      setError("Password must be at least 8 characters.");
      return;
    }

    if (password !== confirmPassword) {
      setError("Passwords do not match.");
      return;
    }

    setLoading(true);
    setError(null);

    try {
      const res = await api.completeOnboardingSetup(onboardingToken, username.trim(), password);
      // Clean up session storage
      sessionStorage.removeItem("tld:onboarding_token");
      sessionStorage.removeItem("tld:onboarding_email");
      sessionStorage.removeItem("tld:onboarding_org");

      // Save active session token and navigate to dashboard
      localStorage.setItem("token", res.access_token);
      window.location.href = "/dashboard";
    } catch (err: any) {
      setError(err.message || "Failed to complete setup. The invitation session may have expired.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-[calc(100vh-64px)] flex items-center justify-center px-4 py-12 relative overflow-hidden">
      {/* Background radial effects */}
      <div className="absolute inset-0 bg-[radial-gradient(ellipse_70%_50%_at_50%_-20%,rgba(22,163,74,0.07),transparent)] dark:bg-[radial-gradient(ellipse_70%_50%_at_50%_-20%,rgba(22,163,74,0.04),transparent)]" />
      <div className="absolute top-0 left-1/2 -translate-x-1/2 w-96 h-48 bg-[var(--accent-primary)]/5 blur-3xl rounded-full pointer-events-none" />

      <div className="w-full max-w-md relative z-10 space-y-6">
        <div className="text-center space-y-2">
          <div className="inline-flex items-center justify-center p-3 rounded-2xl bg-[var(--accent-primary)]/10 text-[var(--accent-primary)] mb-1">
            <UserCheck className="h-7 w-7" />
          </div>
          <h1 className="text-2xl sm:text-3xl font-black text-foreground">Welcome to {orgName || "TLD"}</h1>
          <p className="text-muted-foreground text-xs sm:text-sm max-w-sm mx-auto">
            Set your username and password to finalize your workspace account.
          </p>
        </div>

        <Card className="border-border bg-card/95 backdrop-blur-sm shadow-xl rounded-2xl overflow-hidden">
          <form onSubmit={handleSubmit}>
            <CardHeader className="pb-4">
              <CardTitle className="text-base font-bold text-foreground">Account Setup</CardTitle>
              <CardDescription className="text-xs text-muted-foreground font-mono">
                {email ? `Account email: ${email}` : "Create your credentials"}
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              {error && (
                <div className="p-3 rounded-xl bg-destructive/10 border border-destructive/20 text-destructive text-xs flex items-start gap-2">
                  <AlertCircle className="h-4 w-4 shrink-0 mt-0.5" />
                  <span>{error}</span>
                </div>
              )}

              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-foreground">Choose Username</label>
                <Input
                  type="text"
                  placeholder="e.g. alex_dev"
                  value={username}
                  onChange={(e) => setUsername(e.target.value)}
                  required
                  minLength={3}
                  className="bg-muted/30 rounded-xl"
                />
              </div>

              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-foreground">Set Password</label>
                <Input
                  type="password"
                  placeholder="At least 8 characters"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  required
                  minLength={8}
                  className="bg-muted/30 rounded-xl"
                />
              </div>

              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-foreground">Confirm Password</label>
                <Input
                  type="password"
                  placeholder="Re-enter password"
                  value={confirmPassword}
                  onChange={(e) => setConfirmPassword(e.target.value)}
                  required
                  minLength={8}
                  className="bg-muted/30 rounded-xl"
                />
              </div>

              <div className="p-3 rounded-xl bg-muted/40 text-[11px] text-muted-foreground space-y-1">
                <div className="flex items-center gap-1.5">
                  <ShieldCheck className="h-3.5 w-3.5 text-[var(--accent-primary)]" />
                  <span>Your account will be scoped exclusively to <strong>{orgName || "this organization"}</strong>.</span>
                </div>
              </div>
            </CardContent>

            <CardFooter>
              <Button
                type="submit"
                disabled={loading}
                className="w-full rounded-xl bg-[var(--accent-primary)] text-black hover:opacity-90 font-bold text-xs h-10 cursor-pointer shadow-md shadow-[var(--accent-primary)]/10 flex items-center justify-center gap-2"
              >
                {loading ? (
                  "Setting up your account..."
                ) : (
                  <>
                    <span>Complete Setup & Enter Dashboard</span>
                    <ArrowRight className="h-4 w-4" />
                  </>
                )}
              </Button>
            </CardFooter>
          </form>
        </Card>
      </div>
    </div>
  );
}
