// web/frontend/components/platform/modals/add-operator-modal.tsx

"use client";

import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";

interface AddOperatorModalProps {
  isOpen: boolean;
  onClose: () => void;
  onSubmit: (identity: string) => Promise<void>;
}

export function AddOperatorModal({ isOpen, onClose, onSubmit }: AddOperatorModalProps) {
  const [identity, setIdentity] = useState("");
  const [loading, setLoading] = useState(false);

  if (!isOpen) return null;

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!identity.trim()) return;
    setLoading(true);
    try {
      await onSubmit(identity.trim());
      setIdentity("");
      onClose();
    } catch (err: any) {
      alert("Error adding operator: " + err.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="fixed inset-0 z-50 bg-black/70 backdrop-blur-sm flex items-center justify-center p-4">
      <div className="max-w-md w-full rounded-none shadow-2xl border border-border bg-card">
        <div className="p-6 pb-3">
          <h2 className="text-base font-bold text-foreground">Add Platform User</h2>
          <p className="text-xs text-muted-foreground mt-1">
            Enter an existing user's username or email. They will initially be provisioned with standard platform viewer access (<code>analytics.view</code>, <code>users.view</code>).
          </p>
        </div>
        <form onSubmit={handleSubmit}>
          <div className="px-6 py-3 space-y-3">
            <Input
              placeholder="Enter username or email..."
              value={identity}
              onChange={(e) => setIdentity(e.target.value)}
              className="h-9 text-xs rounded-none"
              required
            />
          </div>
          <div className="p-4 border-t border-border flex items-center justify-end gap-2">
            <Button
              type="button"
              variant="outline"
              size="sm"
              onClick={onClose}
              className="rounded-none text-xs font-bold cursor-pointer"
            >
              Cancel
            </Button>
            <Button
              type="submit"
              size="sm"
              disabled={loading}
              className="rounded-none bg-[var(--accent-primary)] text-white dark:text-black font-bold text-xs cursor-pointer"
            >
              {loading ? "Adding..." : "Add Operator"}
            </Button>
          </div>
        </form>
      </div>
    </div>
  );
}

