// web/frontend/app/maintainer/page.tsx

"use client";

import { useEffect } from "react";
import { useRouter } from "next/navigation";
import { LoadingSpinner } from "@/components/shared/loading-spinner";

export default function MaintainerRedirect() {
  const router = useRouter();

  useEffect(() => {
    router.replace("/platform?tab=curriculum");
  }, [router]);

  return (
    <div className="min-h-[calc(100vh-64px)] flex items-center justify-center">
      <LoadingSpinner />
    </div>
  );
}
