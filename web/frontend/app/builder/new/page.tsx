// web/frontend/app/builder/new/page.tsx

"use client";

import { useEffect, useRef } from "react";
import { useRouter } from "next/navigation";
import { api } from "@/lib/api";
import { useAuth } from "@/lib/auth";
import { LoadingSpinner } from "@/components/shared/loading-spinner";

export default function CreateNewModuleRedirect() {
  const { user, loading: authLoading } = useAuth();
  const router = useRouter();
  const startedRef = useRef(false);

  useEffect(() => {
    if (authLoading) return;
    if (!user) {
      router.push("/login");
      return;
    }

    if (startedRef.current) return;
    startedRef.current = true;

    const createPlaceholderDraft = async () => {
      try {
        const randomId = `community-module-${Math.random().toString(36).substring(2, 9)}`;
        const payload = {
          id: randomId,
          title: "My New Module",
          description: "Describe what this module teaches.",
          topic: "docker",
          difficulty: "beginner",
          estimated_minutes: 30,
          tags: [],
          sections: [],
        };
        await api.createModule(payload);
        router.push(`/builder/${randomId}/edit`);
      } catch (err) {
        console.error("Failed to initialize draft module:", err);
        alert("Failed to initialize draft module. Please try again.");
        router.push("/builder");
      }
    };

    createPlaceholderDraft();
  }, [user, authLoading, router]);

  return (
    <div className="flex flex-col items-center justify-center min-h-[60vh] gap-4">
      <LoadingSpinner />
      <p className="text-sm text-muted-foreground font-mono">Initializing your builder environment...</p>
    </div>
  );
}
