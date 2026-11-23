// web/frontend/app/request-access/page.tsx

"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { api } from "@/lib/api";
import { OrganizationPublicInfoResponse } from "@/lib/types";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card";
import { Building2, GraduationCap, ArrowRight, CheckCircle2, AlertCircle, Mail, Send, Check, Shield } from "lucide-react";
import Link from "next/link";

export default function RequestAccessPage() {
  const router = useRouter();
  const [orgInfo, setOrgInfo] = useState<OrganizationPublicInfoResponse | null>(null);
  const [email, setEmail] = useState("");
  const [loading, setLoading] = useState(false);
  const [loadingOrg, setLoadingOrg] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [submittedStatus, setSubmittedStatus] = useState<string | null>(null);
  const [submittedMessage, setSubmittedMessage] = useState<string | null>(null);

  useEffect(() => {
    loadOrgInfo();
  }, []);

  const loadOrgInfo = async () => {
    setLoadingOrg(true);
    try {
      const info = await api.getOrganizationInfo();
      setOrgInfo(info);
    } catch (err: any) {
      console.error("Failed to load organization public info:", err);
    } finally {
      setLoadingOrg(false);
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!email.trim()) return;

    setLoading(true);
    setError(null);
    setSubmittedStatus(null);

    try {
      const res = await api.requestAccess(email.trim());
      setSubmittedStatus(res.status);
      setSubmittedMessage(res.detail);
    } catch (err: any) {
      setError(err.message || "Failed to submit access request. Please check your email.");
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
            {orgInfo?.type === "university" ? (
              <GraduationCap className="h-7 w-7" />
            ) : (
              <Building2 className="h-7 w-7" />
            )}
          </div>
          <h1 className="text-2xl sm:text-3xl font-black text-foreground">
            {orgInfo ? orgInfo.name : "Institutional Access"}
          </h1>
          <p className="text-muted-foreground text-xs sm:text-sm max-w-sm mx-auto">
            {orgInfo
              ? `Request access to ${orgInfo.name} using your verified email address.`
              : "Enter your institutional email address to join your organization."}
          </p>
        </div>

        <Card className="border-border bg-card/95 backdrop-blur-sm shadow-xl rounded-2xl overflow-hidden">
          {submittedStatus ? (
            <CardContent className="pt-6 pb-6 space-y-4 text-center">
              <div className="inline-flex items-center justify-center p-3.5 rounded-full bg-[var(--accent-primary)]/10 text-[var(--accent-primary)] mb-1">
                <CheckCircle2 className="h-8 w-8" />
              </div>
              <h3 className="text-lg font-bold text-foreground">
                {submittedStatus === "approved" ? "Invitation Sent!" : "Request Submitted for Review"}
              </h3>
              <p className="text-xs text-muted-foreground max-w-sm mx-auto leading-relaxed">
                {submittedMessage ||
                  (submittedStatus === "approved"
                    ? "Check your inbox for your single-use invitation code to complete registration."
                    : "Your request is in the pending approval queue. You will receive an invitation once approved by an administrator.")}
              </p>

              <div className="pt-2">
                <Link href="/join">
                  <Button className="w-full rounded-xl bg-[var(--accent-primary)] text-black hover:opacity-90 font-bold text-xs h-10 cursor-pointer">
                    Have an invitation code? Redeem here
                  </Button>
                </Link>
              </div>
            </CardContent>
          ) : (
            <form onSubmit={handleSubmit}>
              <CardHeader className="pb-4">
                <CardTitle className="text-base font-bold text-foreground">Request Workspace Access</CardTitle>
                <CardDescription className="text-xs text-muted-foreground">
                  {orgInfo?.domains && orgInfo.domains.length > 0 && !orgInfo.domains.includes("*") ? (
                    <span>
                      Accepted domains:{" "}
                      <span className="font-mono text-[var(--accent-primary)] font-semibold">
                        {orgInfo.domains.map((d) => `@${d}`).join(", ")}
                      </span>
                    </span>
                  ) : (
                    "Enter your university or organization email."
                  )}
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
                  <label className="text-xs font-semibold text-foreground">Institutional Email</label>
                  <div className="relative">
                    <Mail className="absolute left-3 top-3 h-4 w-4 text-muted-foreground" />
                    <Input
                      type="email"
                      placeholder={
                        orgInfo?.domains && orgInfo.domains.length > 0 && orgInfo.domains[0] !== "*"
                          ? `student@${orgInfo.domains[0]}`
                          : "you@organization.edu"
                      }
                      value={email}
                      onChange={(e) => setEmail(e.target.value)}
                      required
                      className="pl-9 bg-muted/30 rounded-xl text-sm"
                    />
                  </div>
                </div>

                {orgInfo?.approval_mode === "manual" && (
                  <div className="p-3 rounded-xl bg-muted/40 text-[11px] text-muted-foreground flex items-center gap-2">
                    <Shield className="h-4 w-4 shrink-0 text-amber-500" />
                    <span>This organization requires administrator approval before issuing invitations.</span>
                  </div>
                )}
              </CardContent>

              <CardFooter className="flex flex-col gap-3">
                <Button
                  type="submit"
                  disabled={loading || !email.trim()}
                  className="w-full rounded-xl bg-[var(--accent-primary)] text-black hover:opacity-90 font-bold text-xs h-10 cursor-pointer shadow-md shadow-[var(--accent-primary)]/10 flex items-center justify-center gap-2"
                >
                  {loading ? (
                    "Checking eligibility..."
                  ) : (
                    <>
                      <span>Request Access</span>
                      <Send className="h-3.5 w-3.5" />
                    </>
                  )}
                </Button>

                <div className="text-center w-full">
                  <Link href="/join" className="text-xs text-muted-foreground hover:text-foreground font-mono transition-colors">
                    Already have an invite code? Redeem it here →
                  </Link>
                </div>
              </CardFooter>
            </form>
          )}
        </Card>
      </div>
    </div>
  );
}
