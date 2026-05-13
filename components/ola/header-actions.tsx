"use client";
import { ThemeToggle } from "./theme-toggle";
import { LanguageSelector } from "./language-selector";

export function HeaderActions({ dropdown = false }: { dropdown?: boolean }) {
  return (
    <div className="flex items-center gap-2 md:gap-3">
      <LanguageSelector dropdown={dropdown} />
      <ThemeToggle />
    </div>
  );
}
