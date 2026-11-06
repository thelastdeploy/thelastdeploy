// web/frontend/components/modules/module-detail-skeleton.tsx

export function ModuleDetailSkeleton() {
  return (
    <div className="flex flex-col h-[calc(100vh-64px)] animate-pulse">
      {/* Header */}
      <div className="border-b border-border px-4 py-4 flex items-center justify-between gap-4 shrink-0 bg-card">
        <div className="flex items-center gap-4">
          <div className="h-4 w-16 bg-muted rounded-lg" />
          <div className="w-px h-4 bg-border" />
          <div className="h-5 w-8 bg-muted rounded-lg" />
          <div className="h-5 w-48 bg-muted rounded-lg" />
        </div>
        <div className="flex items-center gap-4">
          <div className="h-5 w-16 bg-muted rounded-full" />
          <div className="h-1.5 w-24 bg-muted rounded-full" />
          <div className="h-4 w-12 bg-muted rounded-lg" />
        </div>
      </div>

      {/* Body */}
      <div className="flex flex-1 overflow-hidden">
        {/* Sidebar */}
        <aside className="w-64 shrink-0 border-r border-border bg-card hidden md:block p-4">
          <div className="h-3 w-24 bg-muted rounded mb-5" />
          <div className="flex flex-col gap-1">
            {Array.from({ length: 5 }).map((_, i) => (
              <div key={i} className="flex items-start gap-4 px-3 py-3.5">
                <div className="w-5 h-5 rounded-full bg-muted shrink-0 mt-0.5" />
                <div className="flex-1 space-y-2">
                  <div className="h-3 bg-muted rounded w-full" />
                  <div className="h-2.5 bg-muted/60 rounded w-2/3" />
                </div>
              </div>
            ))}
          </div>
        </aside>

        {/* Content */}
        <main className="flex-1 overflow-y-auto bg-background/50">
          <div className="max-w-3xl mx-auto px-6 py-8 space-y-3">
            <div className="h-7 bg-muted rounded w-2/3 mb-8" />
            {Array.from({ length: 8 }).map((_, i) => (
              <div
                key={i}
                className="h-4 bg-muted rounded"
                style={{ width: `${70 + Math.sin(i * 1.7) * 25}%` }}
              />
            ))}
            <div className="h-32 bg-muted/50 rounded-xl mt-6" />
            {Array.from({ length: 5 }).map((_, i) => (
              <div
                key={i + 10}
                className="h-4 bg-muted rounded"
                style={{ width: `${60 + Math.sin(i * 2.3) * 30}%` }}
              />
            ))}
          </div>
        </main>
      </div>
    </div>
  );
}
