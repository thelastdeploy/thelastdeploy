"use client";

import React, { useEffect } from "react";
import { XCircle } from "lucide-react";
import { cn } from "@/lib/utils";

interface ModalProps {
  isOpen: boolean;
  onClose: () => void;
  children: React.ReactNode;
  maxWidthClass?: string;
  className?: string;
}

export function Modal({
  isOpen,
  onClose,
  children,
  maxWidthClass = "max-w-md",
  className,
}: ModalProps) {
  useEffect(() => {
    if (!isOpen) return;
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === "Escape") onClose();
    };
    window.addEventListener("keydown", handleKeyDown);
    return () => window.removeEventListener("keydown", handleKeyDown);
  }, [isOpen, onClose]);

  if (!isOpen) return null;

  return (
    <div
      className="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4"
      onClick={(e) => {
        if (e.target === e.currentTarget) onClose();
      }}
    >
      <div
        className={cn(
          "w-full rounded-none border border-border bg-card shadow-2xl flex flex-col max-h-[90vh] overflow-hidden",
          maxWidthClass,
          className
        )}
      >
        {children}
      </div>
    </div>
  );
}

interface ModalHeaderProps {
  title: React.ReactNode;
  description?: React.ReactNode;
  onClose?: () => void;
  className?: string;
}

export function ModalHeader({
  title,
  description,
  onClose,
  className,
}: ModalHeaderProps) {
  return (
    <div
      className={cn(
        "p-5 border-b border-border flex items-start justify-between gap-4 shrink-0",
        className
      )}
    >
      <div className="space-y-1 min-w-0">
        <h3 className="text-base font-bold text-foreground">{title}</h3>
        {description && (
          <p className="text-xs text-muted-foreground">{description}</p>
        )}
      </div>
      {onClose && (
        <button
          type="button"
          onClick={onClose}
          className="text-muted-foreground hover:text-foreground cursor-pointer p-1 rounded-none hover:bg-muted shrink-0 transition-colors"
          aria-label="Close modal"
        >
          <XCircle className="h-4 w-4" />
        </button>
      )}
    </div>
  );
}

export function ModalBody({
  children,
  className,
}: {
  children: React.ReactNode;
  className?: string;
}) {
  return (
    <div className={cn("p-5 overflow-y-auto space-y-4 flex-1", className)}>
      {children}
    </div>
  );
}

export function ModalFooter({
  children,
  className,
}: {
  children: React.ReactNode;
  className?: string;
}) {
  return (
    <div
      className={cn(
        "p-4 border-t border-border flex items-center justify-end gap-2 shrink-0",
        className
      )}
    >
      {children}
    </div>
  );
}
