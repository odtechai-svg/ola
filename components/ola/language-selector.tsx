"use client";
import { useState } from "react";
import Link from "next/link";
import { useLanguage } from "@/lib/i18n-context";

const LANGUAGES = [
  { code: "pt" as const, label: "Português", flag: "🇧🇷" },
  { code: "en" as const, label: "English",   flag: "🇺🇸" },
  { code: "es" as const, label: "Español",   flag: "🇪🇸" },
  { code: "it" as const, label: "Italiano",  flag: "🇮🇹" },
  { code: "fr" as const, label: "Français",  flag: "🇫🇷" },
  { code: "de" as const, label: "Deutsch",   flag: "🇩🇪" },
];

/**
 * dropdown=true  → seletor com menu suspenso (landing/login page)
 * dropdown=false → indicador read-only do idioma nativo, link para Settings (app autenticado)
 */
export function LanguageSelector({ dropdown = false }: { dropdown?: boolean }) {
  const { language, setLanguage } = useLanguage();
  const [isOpen, setIsOpen] = useState(false);

  const selected = LANGUAGES.find((l) => l.code === language) ?? LANGUAGES[1];

  if (!dropdown) {
    return (
      <Link
        href="/settings"
        className="flex items-center gap-2 h-10 px-3 md:px-4 rounded-full bg-surface-container-high/70 backdrop-blur-md text-on-surface text-sm font-medium hover:bg-surface-container-highest transition-colors ghost-border select-none"
        title="Idioma nativo — clique para alterar em Configurações"
      >
        <span className="text-base">{selected.flag}</span>
        <span className="hidden md:inline">{selected.label}</span>
      </Link>
    );
  }

  return (
    <div className="relative">
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center gap-2 h-10 px-3 md:px-4 rounded-full bg-surface-container-high/70 backdrop-blur-md text-on-surface text-sm font-medium hover:bg-surface-container-highest transition-colors active:scale-95 ghost-border select-none"
      >
        <span className="text-base">{selected.flag}</span>
        <span className="hidden md:inline">{selected.label}</span>
        <span
          className="material-symbols-outlined text-[18px] text-on-surface-variant transition-transform duration-200"
          style={{ transform: isOpen ? "rotate(180deg)" : "rotate(0deg)" }}
        >
          expand_more
        </span>
      </button>

      {isOpen && (
        <>
          <div className="fixed inset-0 z-40" onClick={() => setIsOpen(false)} />
          <div className="absolute top-12 right-0 bg-surface-container-highest/90 backdrop-blur-xl border border-outline-variant/30 rounded-xl shadow-[0_8px_32px_rgba(0,0,0,0.5)] flex flex-col overflow-hidden min-w-[150px] z-50 animate-in fade-in slide-in-from-top-2 duration-200">
            {LANGUAGES.map((lang) => (
              <button
                key={lang.code}
                onClick={() => {
                  setLanguage(lang.code);
                  setIsOpen(false);
                }}
                className={`flex items-center gap-3 px-4 py-3 text-sm text-left transition-colors ${
                  selected.code === lang.code
                    ? "bg-primary/10 text-primary font-bold"
                    : "text-on-surface hover:bg-surface-container-high"
                }`}
              >
                <span className="text-lg">{lang.flag}</span>
                <span>{lang.label}</span>
              </button>
            ))}
          </div>
        </>
      )}
    </div>
  );
}
