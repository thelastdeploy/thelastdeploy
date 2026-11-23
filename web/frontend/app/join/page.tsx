// web/frontend/app/join/page.tsx

"use client";

import { useEffect, useState, Suspense } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import { useAuth } from "@/lib/auth";
import { api } from "@/lib/api";
import { InvitationVerifyResponse } from "@/lib/types";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card";
import { Building2, GraduationCap, ArrowRight, CheckCircle2, AlertCircle, KeyRound, Clock, Mail } from "lucide-react";
import Link from "next/link";

function JoinContent() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const { user } = useAuth();

  const tokenParam = searchParams.get("token") || "";
  const codeParam = searchParams.get("code") || "";

  const [inputCode, setInputCode] = useState(codeParam || tokenParam);
  const [loading, setLoading] = useState(false);
  const [verifying, setVerifying] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [invitation, setInvitation] = useState<InvitationVerifyResponse | null>(null);

  // Auto-verify if token or code provided in URL
  useEffect(() => {
    const raw = tokenParam || codeParam;
    if (raw) {
      handleVerify(raw);
    }
  }, [tokenParam, codeParam]);

  const handleVerify = async (val: string) => {
    const clean = val.trim();
    if (!clean) return;
    setVerifying(true);
    setError(null);

    try {
      // Check if it looks like a formatted code or a raw URL token
      const isCode = clean.toUpperCase().startsWith("TLD-") || clean.length < 24;
      const res = await api.verifyInvitation(
        isCode ? undefined : clean,
        isCode ? clean.toUpperCase() : undefined
      );

      if (!res.valid) {
        setError("This invitation is invalid or has expired.");
        setInvitation(null);
      } else {
        setInvitation(res);
      }
    } catch (err: any) {
      setError(err.message || "Failed to verify invitation. Please check the code.");
      setInvitation(null);
    } finally {
      setVerifying(false);
    }
  };

  const handleRedeem = async () => {
    if (!invitation) return;
    setLoading(true);
    setError(null);

    try {
      const clean = inputCode.trim();
      const isCode = clean.toUpperCase().startsWith("TLD-") || clean.length < 24;
      const res = await api.redeemInvitation(
        isCode ? undefined : clean,
        isCode ? clean.toUpperCase() : undefined
      );

      if (res.requires_password_setup && res.onboarding_token) {
        // New user password setup flow
        sessionStorage.setItem("tld:onboarding_token", res.onboarding_token);
        sessionStorage.setItem("tld:onboarding_email", invitation.email);
        sessionStorage.setItem("tld:onboarding_org", invitation.organization_name);
        router.push("/join/setup");
      } else if (res.access_token) {
        // Authenticated session established
        localStorage.setItem("token", res.access_token);
        api.setSelectedOrg(invitation.organization_slug);
        window.location.href = "/dashboard";
      } else {
        // Existing user redeemed invitation while logged in
        api.setSelectedOrg(invitation.organization_slug);
        router.push("/dashboard");
      }
    } catch (err: any) {
      setError(err.message || "Failed to redeem invitation.");
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
            <KeyRound className="h-7 w-7" />
          </div>
          <h1 className="text-2xl sm:text-3xl font-black text-foreground">Join Organization</h1>
          <p className="text-muted-foreground text-xs sm:text-sm max-w-sm mx-auto">
            Redeem an invitation code to enter an institutional workspace or cohort.
          </p>
        </div>

        <Card className="border-border bg-card/95 backdrop-blur-sm shadow-xl rounded-2xl overflow-hidden">
          <CardHeader className="pb-4">
            <CardTitle className="text-base font-bold text-foreground">Invitation Code</CardTitle>
            <CardDescription className="text-xs text-muted-foreground">
              Enter the invitation code or token provided in your invitation email.
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="flex gap-2">
              <Input
                placeholder="e.g. TLD-ABCD-1234 or paste link"
                value={inputCode}
                onChange={(e) => setInputCode(e.target.value)}
                onKeyDown={(e) => {
                  if (e.key === "Enter") handleVerify(inputCode);
                }}
                className="font-mono text-sm bg-muted/30 uppercase placeholder:normal-case rounded-xl"
              />
              <Button
                variant="outline"
                onClick={() => handleVerify(inputCode)}
                disabled={verifying || !inputCode.trim()}
                className="rounded-xl px-4 cursor-pointer font-bold text-xs"
              >
                {verifying ? "Checking..." : "Verify"}
              </Button>
            </div>

            {error && (
              <div className="p-3 rounded-xl bg-destructive/10 border border-destructive/20 text-destructive text-xs flex items-start gap-2">
                <AlertCircle className="h-4 w-4 shrink-0 mt-0.5" />
                <span>{error}</span>
              </div>
            )}

            {invitation && (
              <div className="p-4 rounded-xl border border-[var(--accent-primary)]/30 bg-[var(--accent-primary)]/[0.04] space-y-3">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-2">
                    <Building2 className="h-4 w-4 text-[var(--accent-primary)]" />
                    <span className="font-bold text-foreground text-sm">{invitation.organization_name}</span>
                  </div>
                  <span className="text-[10px] uppercase font-mono px-2 py-0.5 rounded-full bg-[var(--accent-primary)]/10 text-[var(--accent-primary)] font-bold">
                    {invitation.role}
                  </span>
                </div>

                <div className="text-xs space-y-1.5 text-muted-foreground pt-1 border-t border-border/50">
                  <div className="flex items-center justify-between">
                    <span className="flex items-center gap-1.5">
                      <Mail className="h-3 w-3" /> Recipient:
                    </span>
                    <span className="font-mono text-foreground">{invitation.email}</span>
                  </div>

                  {invitation.cohort_name && (
                    <div className="flex items-center justify-between">
                      <span className="flex items-center gap-1.5">
                        <GraduationCap className="h-3 w-3" /> Cohort:
                      </span>
                      <span className="font-bold text-foreground">{invitation.cohort_name}</span>
                    </div>
                  )}

                  <div className="flex items-center justify-between text-[11px] text-muted-foreground/80">
                    <span className="flex items-center gap-1.5">
                      <Clock className="h-3 w-3" /> Expires:
                    </span>
                    <span>{new Date(invitation.expires_at).toLocaleDateString()}</span>
                  </div>
                </div>

                {invitation.is_existing_user && !user && (
                  <p className="text-[11px] text-amber-500/90 pt-1">
                    An account exists for this email. You can log in first or accept to join directly.
                  </p>
                )}
              </div>
            )}
          </CardContent>

          {invitation && (
            <CardFooter className="pt-0">
              <Button
                onClick={handleRedeem}
                disabled={loading}
                className="w-full rounded-xl bg-[var(--accent-primary)] text-black hover:opacity-90 font-bold text-xs h-10 cursor-pointer shadow-md shadow-[var(--accent-primary)]/10 flex items-center justify-center gap-2"
              >
                {loading ? (
                  "Activating..."
                ) : invitation.is_existing_user ? (
                  <>
                    <span>Accept & Enter Workspace</span>
                    <ArrowRight className="h-4 w-4" />
                  </>
                ) : (
                  <>
                    <span>Continue to Account Setup</span>
                    <ArrowRight className="h-4 w-4" />
                  </>
                )}
              </Button>
            </CardFooter>
          )}
        </Card>

        <div className="text-center space-y-2">
          <p className="text-xs text-muted-foreground">
            Looking for your institution's access request page?{" "}
            <Link href="/request-access" className="text-[var(--accent-primary)] hover:underline font-semibold">
              Request Access
            </Link>
          </p>
        </div>
      </div>
    </div>
  );
}

export default function JoinPage() {
  return (
    <Suspense fallback={<div className="min-h-screen flex items-center justify-center text-sm font-mono text-muted-foreground">Loading invitation...</div>}>
      <JoinContent />
    </Suspense>
  );
}
