"use client";
import { ThemeProvider } from "next-themes";
import { ReactNode } from "react";
import { LanguageProvider } from "@/lib/i18n-context";

export function Providers({
  children,
  initialSourceLang = "",
}: {
  children: ReactNode;
  initialSourceLang?: string;
}) {
  return (
    <ThemeProvider attribute="class" defaultTheme="dark" enableSystem={false}>
      <LanguageProvider initialSourceLang={initialSourceLang}>
        {children}
      </LanguageProvider>
    </ThemeProvider>
  );
}
