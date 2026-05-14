"use client";

import { useLanguage } from "@/lib/i18n-context";

export function AuthButton() {
  const { t } = useLanguage();

  async function signOut() {
    await fetch("/api/auth/logout", { method: "POST" });
    window.location.href = "/";
  }

  return (
    <button
      onClick={signOut}
      className="w-full rounded-full border border-outline-variant/20 px-4 py-2 text-sm font-medium text-on-surface-variant hover:bg-surface-container-high hover:text-on-surface transition-all"
    >
      {t("nav.sign_out")}
    </button>
  );
}
