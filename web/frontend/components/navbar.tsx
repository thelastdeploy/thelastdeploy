// web/frontend/components/navbar.tsx

"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { useAuth } from "@/lib/auth";
import { api } from "@/lib/api";
import { Button } from "@/components/ui/button";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { useRouter, usePathname } from "next/navigation";
import { Sun, Moon, Hammer, Shield, Building2, GraduationCap, ChevronDown, Globe, Check, Settings } from "lucide-react";
import { OrganizationMembershipInfo } from "@/lib/types";

export function Navbar() {
  const { user, loading, logout } = useAuth();
  const router = useRouter();
  const pathname = usePathname();
  const [theme, setTheme] = useState<"light" | "dark">("dark");
  const [activeOrg, setActiveOrg] = useState<string | null>(null);
  const [orgs, setOrgs] = useState<OrganizationMembershipInfo[]>([]);

  useEffect(() => {
    if (typeof window !== "undefined") {
      const isDark = document.documentElement.classList.contains("dark");
      setTheme(isDark ? "dark" : "light");
      setActiveOrg(api.getSelectedOrg());

      if (user) {
        api.getOrganizations()
          .then((data) => setOrgs(data))
          .catch(() => {});
      } else {
        setOrgs([]);
      }

      const handleWorkspaceChange = () => {
        setActiveOrg(api.getSelectedOrg());
      };
      window.addEventListener("tld:workspace-changed", handleWorkspaceChange);
      return () => window.removeEventListener("tld:workspace-changed", handleWorkspaceChange);
    }
  }, [user, pathname]);

  const toggleTheme = () => {
    const newTheme = theme === "dark" ? "light" : "dark";
    setTheme(newTheme);
    if (newTheme === "dark") {
      document.documentElement.classList.add("dark");
      localStorage.setItem("tld:theme", "dark");
    } else {
      document.documentElement.classList.remove("dark");
      localStorage.setItem("tld:theme", "light");
    }
  };

  const handleLogout = () => {
    logout();
    router.push("/");
  };

  const navLink = (href: string, label: string) => {
    const active = pathname === href || pathname.startsWith(href + "/");
    return (
      <Link
        href={href}
        className={`text-xs font-black uppercase tracking-wider px-4 py-2 rounded-xl transition-all duration-200 relative overflow-hidden group border ${
          active
            ? "text-[var(--accent-primary)] bg-[rgba(var(--accent-primary-rgb),0.06)] border-[rgba(var(--accent-primary-rgb),0.15)] shadow-[0_0_15px_rgba(var(--accent-primary-rgb),0.03)]"
            : "text-muted-foreground hover:text-foreground hover:bg-muted/40 border-transparent"
        }`}
      >
        {label}
        {active && (
          <span className="absolute bottom-0 left-1/2 -translate-x-1/2 w-4 h-[3px] bg-[var(--accent-primary)] rounded-full" />
        )}
      </Link>
    );
  };

  return (
    <nav className="border-b border-border/70 bg-background/80 backdrop-blur-md sticky top-0 z-50 transition-all duration-300 shadow-sm">
      <div className="max-w-6xl mx-auto px-4 h-16 flex items-center justify-between">
        {/* Logo — dashboard if logged in, landing if not */}
        <div className="flex items-center gap-3">
          <Link href={user ? "/dashboard" : "/"} className="flex items-center gap-2 group">
            <img
              src="/logo-light.png"
              alt="Logo"
              className="h-10 w-auto object-contain block dark:hidden group-hover:scale-105 transition-transform"
            />
            <img
              src="/logo-dark.png"
              alt="Logo"
              className="h-10 w-auto object-contain hidden dark:block group-hover:scale-105 transition-transform"
            />
            <span className="font-black text-lg tracking-tight text-foreground group-hover:text-[var(--accent-primary)] transition-colors">The Last Deploy</span>
          </Link>
          {user && orgs.length > 0 && (() => {
            const currentOrg = orgs.find((o) => o.slug === activeOrg) || orgs.find((o) => o.type === "platform" || o.is_platform) || orgs[0];
            const isPlatform = currentOrg?.type === "platform" || currentOrg?.is_platform || currentOrg?.slug === "tld";
            const isUniversity = currentOrg?.type === "university";
            const isAdmin = currentOrg?.roles?.includes("admin") || currentOrg?.roles?.includes("owner");

            return (
              <DropdownMenu>
                <DropdownMenuTrigger asChild>
                  <Button
                    variant="outline"
                    size="sm"
                    className="hidden sm:inline-flex items-center gap-2 px-3 py-1.5 h-8 rounded-xl text-xs font-mono font-bold bg-muted/40 hover:bg-muted border-border/80 transition-all cursor-pointer"
                  >
                    {isUniversity ? (
                      <GraduationCap className="h-3.5 w-3.5 text-[var(--accent-primary)]" />
                    ) : isPlatform ? (
                      <Globe className="h-3.5 w-3.5 text-[var(--accent-primary)]" />
                    ) : (
                      <Building2 className="h-3.5 w-3.5 text-[var(--accent-primary)]" />
                    )}
                    <span className="max-w-[130px] truncate text-foreground">
                      {currentOrg ? currentOrg.name : "TLD Platform"}
                    </span>
                    <ChevronDown className="h-3 w-3 text-muted-foreground" />
                  </Button>
                </DropdownMenuTrigger>
                <DropdownMenuContent align="start" className="w-64 p-2 rounded-2xl bg-card border-border shadow-xl">
                  <div className="px-2 py-1.5 text-[10px] font-mono uppercase tracking-wider text-muted-foreground">
                    Active Workspace
                  </div>
                  {orgs.map((org) => {
                    const isSelected = activeOrg === org.slug || (!activeOrg && (org.type === "platform" || org.is_platform));
                    const isOrgUniv = org.type === "university";
                    const isOrgPlatform = org.type === "platform" || org.is_platform;

                    return (
                      <DropdownMenuItem
                        key={org.slug}
                        onClick={() => {
                          api.setSelectedOrg(org.slug);
                          setActiveOrg(org.slug);
                        }}
                        className={`flex items-center justify-between p-2.5 rounded-xl cursor-pointer text-xs font-medium transition-colors ${
                          isSelected ? "bg-[var(--accent-primary)]/10 text-[var(--accent-primary)] font-bold" : "hover:bg-muted"
                        }`}
                      >
                        <div className="flex items-center gap-2.5 truncate">
                          {isOrgUniv ? (
                            <GraduationCap className="h-4 w-4 shrink-0 text-[var(--accent-primary)]" />
                          ) : isOrgPlatform ? (
                            <Globe className="h-4 w-4 shrink-0 text-[var(--accent-primary)]" />
                          ) : (
                            <Building2 className="h-4 w-4 shrink-0 text-[var(--accent-primary)]" />
                          )}
                          <div className="truncate">
                            <p className="truncate text-foreground font-semibold">{org.name}</p>
                            <p className="text-[10px] text-muted-foreground font-mono">
                              {org.roles && org.roles.length > 0 ? org.roles.join(", ") : "Member"} • {org.total_xp} XP
                            </p>
                          </div>
                        </div>
                        {isSelected && <Check className="h-3.5 w-3.5 shrink-0 text-[var(--accent-primary)]" />}
                      </DropdownMenuItem>
                    );
                  })}
                  {isAdmin && currentOrg && (
                    <>
                      <DropdownMenuSeparator className="my-1.5 border-border" />
                      <DropdownMenuItem asChild>
                        <Link
                          href={`/org/${currentOrg.slug}`}
                          className="flex items-center gap-2 p-2 rounded-xl text-xs font-semibold hover:bg-muted cursor-pointer text-foreground"
                        >
                          <Settings className="h-3.5 w-3.5 text-muted-foreground" />
                          <span>Manage {currentOrg.name}</span>
                        </Link>
                      </DropdownMenuItem>
                    </>
                  )}
                  <DropdownMenuSeparator className="my-1.5 border-border" />
                  <DropdownMenuItem asChild>
                    <Link
                      href="/select-org"
                      className="flex items-center justify-center p-2 rounded-xl text-xs font-mono text-muted-foreground hover:text-foreground hover:bg-muted text-center cursor-pointer"
                    >
                      Browse All Workspaces →
                    </Link>
                  </DropdownMenuItem>
                </DropdownMenuContent>
              </DropdownMenu>
            );
          })()}
        </div>

        {/* Nav links */}
        <div className="hidden md:flex items-center gap-2">
          {navLink("/modules", "Modules")}
          {user && navLink("/builder", "Builder")}
          {user && (user.is_maintainer || user.is_admin) && navLink("/maintainer", "Control")}
        </div>

        {/* Auth & Theme Toggler */}
        <div className="flex items-center gap-3">
          <Button
            variant="ghost"
            size="icon"
            onClick={toggleTheme}
            className="rounded-xl text-muted-foreground hover:text-foreground hover:bg-muted shrink-0 cursor-pointer"
            aria-label="Toggle theme"
          >
            {theme === "dark" ? (
              <Sun className="h-4 w-4" />
            ) : (
              <Moon className="h-4 w-4" />
            )}
          </Button>

          {loading ? (
            <div className="h-9 w-28 bg-muted/50 animate-pulse rounded-xl border border-border/50" />
          ) : user ? (
            <DropdownMenu>
              <DropdownMenuTrigger asChild>
                <button className="flex items-center gap-2.5 pl-2 pr-4 py-1.5 rounded-xl bg-card hover:bg-muted transition-all border border-border hover:border-[rgba(var(--accent-primary-rgb),0.25)] hover:shadow-[0_0_15px_rgba(var(--accent-primary-rgb),0.06)] text-foreground cursor-pointer outline-none">
                  <Avatar className="h-6 w-6 shrink-0">
                    <AvatarFallback className="text-[10px] font-bold text-black" style={{ backgroundColor: "var(--accent-primary)" }}>
                      {user.username.slice(0, 2).toUpperCase()}
                    </AvatarFallback>
                  </Avatar>
                  <div className="text-left hidden md:block">
                    <p className="text-xs font-black leading-none">{user.username}</p>
                    <p className="text-[10px] font-mono font-bold leading-none mt-1" style={{ color: "var(--accent-primary)" }}>
                      {user.xp} XP
                    </p>
                  </div>
                </button>
              </DropdownMenuTrigger>
              <DropdownMenuContent align="end" className="w-52 bg-card border-border rounded-xl p-1.5 shadow-xl">
                <DropdownMenuItem onClick={() => router.push("/builder")} className="cursor-pointer text-foreground hover:bg-muted flex items-center gap-2 font-bold rounded-lg py-2">
                  <Hammer className="h-4 w-4 text-[var(--accent-primary)]" />
                  Builder
                </DropdownMenuItem>
                {user && (user.is_maintainer || user.is_admin) && (
                  <DropdownMenuItem onClick={() => router.push("/maintainer")} className="cursor-pointer text-foreground hover:bg-muted flex items-center gap-2 font-bold rounded-lg py-2">
                    <Shield className="h-4 w-4 text-[var(--accent-primary)]" />
                    Control
                  </DropdownMenuItem>
                )}
                <DropdownMenuItem onClick={() => router.push("/select-org")} className="cursor-pointer text-foreground hover:bg-muted flex items-center gap-2 font-bold rounded-lg py-2">
                  <Building2 className="h-4 w-4 text-[var(--accent-primary)]" />
                  Switch Workspace
                </DropdownMenuItem>
                <DropdownMenuSeparator className="bg-border my-1" />
                <DropdownMenuItem onClick={() => router.push("/profile")} className="cursor-pointer text-foreground hover:bg-muted rounded-lg py-2">
                  Profile & Settings
                </DropdownMenuItem>
                <DropdownMenuSeparator className="bg-border my-1" />
                <DropdownMenuItem onClick={handleLogout} className="cursor-pointer text-red-500 hover:bg-red-500/5 hover:text-red-400 rounded-lg py-2">
                  Logout
                </DropdownMenuItem>
              </DropdownMenuContent>
            </DropdownMenu>
          ) : (
            <>
              <Button variant="ghost" size="sm" asChild className="text-muted-foreground hover:text-foreground hover:bg-muted cursor-pointer rounded-xl">
                <Link href="/login">Login</Link>
              </Button>
              <Button size="sm" asChild className="font-bold text-black rounded-xl cursor-pointer hover:opacity-90 transition-opacity" style={{ backgroundColor: "var(--accent-primary)" }}>
                <Link href="/register">Sign up</Link>
              </Button>
            </>
          )}
        </div>
      </div>
    </nav>
  );
}