// web/frontend/components/platform/modals/provision-org-modal.tsx

"use client";

import { useState } from "react";
import { api } from "@/lib/api";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { AlertCircle, X, Building2 } from "lucide-react";

interface ProvisionOrgModalProps {
  isOpen: boolean;
  onClose: () => void;
  onSuccess: () => void;
}

export function ProvisionOrgModal({ isOpen, onClose, onSuccess }: ProvisionOrgModalProps) {
  const [newOrgName, setNewOrgName] = useState("");
  const [newOrgSlug, setNewOrgSlug] = useState("");
  const [newOrgType, setNewOrgType] = useState("company");
  const [newOrgDomain, setNewOrgDomain] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  if (!isOpen) return null;

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!newOrgName.trim() || !newOrgSlug.trim()) {
      setError("Organization name and slug are required");
      return;
    }

    setLoading(true);
    setError(null);
    try {
      const domains = newOrgDomain.trim()
        ? newOrgDomain.split(",").map((d) => d.trim()).filter(Boolean)
        : [];
      await api.createOrganization({
        name: newOrgName.trim(),
        slug: newOrgSlug.trim().toLowerCase(),
        type: newOrgType,
        domains,
      });

      setNewOrgName("");
      setNewOrgSlug("");
      setNewOrgDomain("");
      onClose();
      onSuccess();
    } catch (err: any) {
      setError(err.message || "Failed to provision organization");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4">
      <div className="max-w-md w-full rounded-none shadow-2xl border border-border bg-card">
        <div className="p-6 pb-3">
          <h2 className="text-base font-bold text-foreground">Provision New Organization</h2>
          <p className="text-xs text-muted-foreground mt-1">
            Create a tenant workspace for an educational institution or enterprise.
          </p>
        </div>
        <form onSubmit={handleSubmit}>
          <div className="px-6 py-3 space-y-3.5">
            {error && (
              <div className="p-2.5 rounded-none bg-red-500/10 border border-red-500/20 text-red-400 text-xs flex items-center gap-2">
                <AlertCircle className="h-4 w-4 shrink-0" />
                <span>{error}</span>
              </div>
            )}

            <div className="space-y-1">
              <label className="text-xs font-semibold text-foreground">Organization Name</label>
              <Input
                placeholder="e.g. Stanford University"
                value={newOrgName}
                onChange={(e) => {
                  setNewOrgName(e.target.value);
                  if (!newOrgSlug) {
                    setNewOrgSlug(e.target.value.toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/(^-|-$)/g, ""));
                  }
                }}
                className="h-9 text-xs rounded-none"
              />
            </div>

            <div className="space-y-1">
              <label className="text-xs font-semibold text-foreground">Workspace Slug</label>
              <Input
                placeholder="e.g. stanford"
                value={newOrgSlug}
                onChange={(e) => setNewOrgSlug(e.target.value)}
                className="h-9 text-xs font-mono rounded-none"
              />
            </div>

            <div className="space-y-1">
              <label className="text-xs font-semibold text-foreground">Organization Type</label>
              <Select value={newOrgType} onValueChange={(val) => setNewOrgType(val)}>
                <SelectTrigger className="w-full h-9 text-xs rounded-none">
                  <SelectValue placeholder="Select type" />
                </SelectTrigger>
                <SelectContent className="rounded-none">
                  <SelectItem value="company" className="rounded-none">Enterprise / Company</SelectItem>
                  <SelectItem value="university" className="rounded-none">Higher Education Institution</SelectItem>
                  <SelectItem value="other" className="rounded-none">Non-profit / Community</SelectItem>
                </SelectContent>
              </Select>
            </div>

            <div className="space-y-1">
              <label className="text-xs font-semibold text-foreground">Verified Email Domains</label>
              <Input
                placeholder="e.g. stanford.edu, cs.stanford.edu"
                value={newOrgDomain}
                onChange={(e) => setNewOrgDomain(e.target.value)}
                className="h-9 text-xs font-mono rounded-none"
              />
              <p className="text-[10px] text-muted-foreground">Comma-separated domain list for automatic onboarding eligibility.</p>
            </div>
          </div>

          <div className="p-4 border-t border-border flex items-center justify-end gap-2">
            <Button
              type="button"
              variant="outline"
              size="sm"
              onClick={onClose}
              className="h-9 px-3.5 text-xs font-semibold text-muted-foreground hover:text-foreground rounded-none border-border cursor-pointer gap-1.5"
            >
              <X className="h-4 w-4" />
              <span>Cancel</span>
            </Button>
            <Button
              type="submit"
              size="sm"
              disabled={loading}
              className="h-9 px-3.5 text-xs font-bold rounded-none bg-[var(--accent-primary)] text-white dark:text-black hover:opacity-90 cursor-pointer gap-1.5"
            >
              <Building2 className="h-4 w-4" />
              <span>{loading ? "Provisioning..." : "Provision Workspace"}</span>
            </Button>
          </div>
        </form>
      </div>
    </div>
  );
}

