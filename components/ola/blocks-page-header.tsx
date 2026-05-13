"use client";
import { useLanguage } from "@/lib/i18n-context";

export function BlocksPageHeader() {
  const { t } = useLanguage();
  return (
    <div>
      <span className="text-primary font-bold uppercase tracking-[0.2em] text-sm">
        {t("blocks.section")}
      </span>
      <h1 className="mt-2 text-4xl md:text-5xl font-black tracking-tight text-on-surface">
        {t("blocks.title")}
      </h1>
      <p className="mt-3 max-w-3xl text-on-surface-variant">
        {t("blocks.desc")}
      </p>
    </div>
  );
}
