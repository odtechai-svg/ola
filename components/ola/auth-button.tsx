"use client";

import { createClient } from "@/lib/supabase/client";
import { useLanguage } from "@/lib/i18n-context";

export function AuthButton() {
  const { t } = useLanguage();

  async function signOut() {
    const supabase = createClient();
    await supabase.auth.signOut();
    window.location.href = "/";
  }

  if (typeof window !== "undefined" && !process.env.NEXT_PUBLIC_SUPABASE_URL) {
    return <span className="text-xs text-error">Missing Supabase env</span>;
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
