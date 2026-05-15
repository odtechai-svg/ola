"use client";

import Link from "next/link";
import { ReactNode, useEffect, useState } from "react";
import { AuthButton } from "@/components/ola/auth-button";
import { HeaderActions } from "@/components/ola/header-actions";
import { useLanguage } from "@/lib/i18n-context";

export function Shell({ children, isAdmin = true }: { children: ReactNode; isAdmin?: boolean }) {
  const { t } = useLanguage();
  const [adminVisible, setAdminVisible] = useState(isAdmin);

  useEffect(() => {
    const isAdminCookie = document.cookie.match(/(?:^|;\s*)ola_is_admin=([^;]+)/);
    if (isAdminCookie) {
      setAdminVisible(isAdminCookie[1] !== "false");
    }
  }, []);

  const nav = [
    { href: "/home", labelKey: "nav.today", icon: "today" },
    { href: "/blocks", labelKey: "nav.blocks", icon: "widgets" },
    { href: "/stats", labelKey: "nav.progress", icon: "analytics" },
    { href: "/settings", labelKey: "nav.settings", icon: "settings" },
  ];

  return (
    <div className="min-h-screen bg-surface text-on-surface flex">
      {/* ── Desktop SideNavBar ── */}
      <aside className="hidden lg:flex flex-col py-8 gap-8 h-screen w-64 bg-surface-container-lowest sticky top-0 shrink-0">
        <div className="px-8">
          <h1 className="text-2xl font-black text-primary tracking-tighter">OLA</h1>
          <p className="text-xs text-on-surface-variant font-medium mt-1 uppercase tracking-widest">
            {t("nav.tagline")}
          </p>
        </div>
        <nav className="flex flex-col gap-2 mt-4 flex-1">
          {nav.map((item) => (
            <Link
              key={item.href}
              href={item.href as any}
              className="flex items-center gap-4 pl-8 py-3 text-on-surface-variant hover:bg-surface-container-low hover:text-primary transition-all group"
            >
              <span className="material-symbols-outlined text-xl">{item.icon}</span>
              <span className="font-medium">{t(item.labelKey)}</span>
            </Link>
          ))}
        </nav>
        <div className="px-6 space-y-4">
          <Link
            href="/session/live"
            className="block w-full text-center bg-gradient-to-br from-primary to-primary-container text-on-primary font-bold py-4 rounded-full inner-glow hover:opacity-90 transition-opacity active:scale-95 duration-150 shadow-lg shadow-primary-dim/10"
          >
            {t("nav.start_session")}
          </Link>
          <AuthButton />
        </div>
      </aside>

      {/* ── Main Content Canvas ── */}
      <main className="flex-1 flex flex-col min-h-screen pb-24 lg:pb-12">
        {/* TopAppBar */}
        <header className="flex justify-between items-center w-full px-6 py-4 max-w-7xl mx-auto bg-transparent">
          <div className="lg:hidden">
            <Link href="/home" className="text-xl font-black text-primary tracking-tighter">OLA</Link>
          </div>
          <div className="hidden lg:block" />
          <div className="flex items-center gap-4">
            <HeaderActions />
            <Link href="/stats" className="text-on-surface-variant hover:text-primary transition-colors active:scale-95 duration-150" title="My Stats">
              <span className="material-symbols-outlined">leaderboard</span>
            </Link>
            {adminVisible && (
              <Link href="/admin" className="text-primary hover:opacity-80 transition-opacity active:scale-95 duration-150" title="Admin Dashboard">
                <span className="material-symbols-outlined">admin_panel_settings</span>
              </Link>
            )}
            <Link href="/settings" className="w-10 h-10 rounded-full bg-surface-container-highest flex items-center justify-center overflow-hidden ghost-border hover:ring-2 hover:ring-primary/30 transition-all">
              <span className="material-symbols-outlined text-on-surface-variant">person</span>
            </Link>
          </div>
        </header>

        <div className="px-6 py-4 max-w-7xl mx-auto w-full flex-1">
          {children}
        </div>
      </main>

      {/* ── BottomNavBar (Mobile) ── */}
      <nav className="lg:hidden fixed bottom-0 left-0 w-full flex justify-around items-center px-2 pb-6 pt-3 bg-surface-container-lowest/80 backdrop-blur-xl z-50 rounded-t-[2rem] shadow-[0_-8px_40px_-12px_rgba(0,0,0,0.5)]">
        {nav.slice(0, 2).map((item) => (
          <Link
            key={item.href}
            href={item.href as any}
            className="flex flex-col items-center justify-center text-on-surface-variant px-3 py-2 hover:text-primary transition-colors active:scale-90 duration-200"
          >
            <span className="material-symbols-outlined">{item.icon}</span>
            <span className="text-[11px] font-semibold tracking-wide uppercase mt-1">{t(item.labelKey)}</span>
          </Link>
        ))}

        {/* Central Start Session FAB */}
        <Link
          href="/session/live"
          className="flex flex-col items-center justify-center -mt-5 active:scale-90 duration-200"
        >
          <div className="w-14 h-14 rounded-full bg-gradient-to-br from-primary to-primary-container flex items-center justify-center shadow-lg shadow-primary/30 inner-glow">
            <span className="material-symbols-outlined text-on-primary text-2xl" style={{ fontVariationSettings: "'FILL' 1" }}>play_arrow</span>
          </div>
          <span className="text-[10px] font-bold text-primary tracking-wide uppercase mt-1">{t("nav.start_session")}</span>
        </Link>

        {nav.slice(2).map((item) => (
          <Link
            key={item.href}
            href={item.href as any}
            className="flex flex-col items-center justify-center text-on-surface-variant px-3 py-2 hover:text-primary transition-colors active:scale-90 duration-200"
          >
            <span className="material-symbols-outlined">{item.icon}</span>
            <span className="text-[11px] font-semibold tracking-wide uppercase mt-1">{t(item.labelKey)}</span>
          </Link>
        ))}
      </nav>
    </div>
  );
}
