"use client";

import React from "react";
import Link from "next/link";
import { ShieldAlert, ArrowLeft } from "lucide-react";
import { Button } from "@/components/ui/button";

interface AccessRestrictedProps {
  title?: string;
  message?: string;
  backHref?: string;
  backLabel?: string;
  icon?: React.ReactNode;
}

export function AccessRestricted({
  title = "Access Restricted",
  message = "You do not have permission to view this page.",
  backHref = "/dashboard",
  backLabel = "Return to Dashboard",
  icon,
}: AccessRestrictedProps) {
  return (
    <div className="min-h-[calc(100vh-64px)] flex items-center justify-center p-4">
      <div className="max-w-md w-full text-center space-y-4 p-8 rounded-none border border-border bg-card shadow-xl">
        <div className="h-14 w-14 mx-auto rounded-none bg-destructive/10 text-destructive flex items-center justify-center">
          {icon ?? <ShieldAlert className="h-7 w-7 text-destructive" />}
        </div>
        <h2 className="text-xl font-black text-foreground">{title}</h2>
        <p className="text-xs text-muted-foreground leading-relaxed">{message}</p>
        <Button
          asChild
          className="rounded-none text-xs font-bold w-full h-9 gap-1.5"
          style={{ backgroundColor: "var(--accent-primary)", color: "black" }}
        >
          <Link href={backHref}>
            <ArrowLeft className="h-3.5 w-3.5" />
            <span>{backLabel}</span>
          </Link>
        </Button>
      </div>
    </div>
  );
}
