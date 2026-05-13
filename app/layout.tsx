import "./globals.css";
import { ReactNode } from "react";
import { cookies } from "next/headers";
import { Providers } from "@/components/providers";

export const metadata = {
  title: "OLA — Open Language Acquisition",
  description: "Speech-first language acquisition. Train your brain and mouth at the same time.",
};

export default async function RootLayout({ children }: { children: ReactNode }) {
  const cookieStore = await cookies();
  const sourceLang = cookieStore.get("ola_source_lang")?.value ?? "";

  return (
    <html lang="en" suppressHydrationWarning>
      <head>
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200&display=swap" />
      </head>
      <body className="bg-surface text-on-surface font-sans min-h-screen antialiased" suppressHydrationWarning>
        <Providers initialSourceLang={sourceLang}>
          {children}
        </Providers>
      </body>
    </html>
  );
}
