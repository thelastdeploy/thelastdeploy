// web/frontend/app/builder/[id]/edit/page.tsx

"use client";

import { useEffect, useState, useCallback } from "react";
import { useParams, useRouter } from "next/navigation";
import { useAuth } from "@/lib/auth";
import { api } from "@/lib/api";
import { BuilderModuleInput } from "@/lib/types";
import { LoadingSpinner } from "@/components/shared/loading-spinner";
import { ModuleBuilderIDE } from "@/components/builder/module-builder-ide";

export default function EditModulePage() {
  const { id } = useParams<{ id: string }>();
  const { user, loading: authLoading } = useAuth();
  const router = useRouter();

  const [module, setModule] = useState<BuilderModuleInput | null>(null);
  const [status, setStatus] = useState<string>("draft");
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetchModule = useCallback(async () => {
    try {
      const data = await api.getBuilderModule(id);
      setModule(data);
      // Wait, getBuilderModule returns BuilderModuleDetail which contains status.
      // Let's typecast/read status safely.
      const detail = data as any;
      setStatus(detail.status || "draft");
    } catch (err: any) {
      setError(err.message || "Failed to load module details");
    } finally {
      setLoading(false);
    }
  }, [id]);

  useEffect(() => {
    if (authLoading) return;
    if (!user) {
      router.push("/login");
      return;
    }
    fetchModule();
  }, [user, authLoading, router, fetchModule]);

  if (authLoading || loading) {
    return <LoadingSpinner className="py-40" />;
  }

  if (error || !module) {
    return <div className="text-center py-40 text-red-400 text-sm">{error || "Module not found"}</div>;
  }

  return (
    <ModuleBuilderIDE
      initialData={module}
      moduleId={id}
      status={status}
      onRefresh={fetchModule}
    />
  );
}
