"use client";

import { useState } from "react";
import Link from "next/link";
import { HeaderActions } from "@/components/ola/header-actions";
import { applyLanguagePair } from "@/lib/i18n-context";

const TEST_PROFILES = [
  { label: "BR 🇧🇷 → EN 🇺🇸", sub: "Brazilian learning English",    source: "pt-BR", target: "en"   },
  { label: "US 🇺🇸 → PT 🇧🇷", sub: "American learning Portuguese",  source: "en",    target: "pt-BR" },
  { label: "ES 🇪🇸 → PT 🇧🇷", sub: "Spanish learning Portuguese",   source: "es",    target: "pt-BR" },
  { label: "BR 🇧🇷 → ES 🇪🇸", sub: "Brazilian learning Spanish",    source: "pt-BR", target: "es"   },
  { label: "BR 🇧🇷 → IT 🇮🇹", sub: "Brazilian learning Italian",    source: "pt-BR", target: "it"   },
  { label: "BR 🇧🇷 → FR 🇫🇷", sub: "Brazilian learning French",     source: "pt-BR", target: "fr"   },
  { label: "BR 🇧🇷 → DE 🇩🇪", sub: "Brazilian learning German",     source: "pt-BR", target: "de"   },
];

type Mode = "login" | "register";

export default function LoginPage() {
  const [mode, setMode] = useState<Mode>("login");
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [message, setMessage] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setLoading(true);
    setMessage(null);

    const endpoint = mode === "login" ? "/api/auth/login" : "/api/auth/register";
    const body = mode === "login" ? { email, password } : { email, password, name };

    const res = await fetch(endpoint, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(body),
    });
    const data = await res.json();
    setLoading(false);

    if (!res.ok) {
      setMessage(data.error || "Algo deu errado.");
    } else {
      window.location.href = "/home";
    }
  }

  function handleSimulate(source: string, target: string) {
    applyLanguagePair(source, target);
    window.location.href = "/home";
  }

  return (
    <div className="min-h-screen bg-surface text-on-surface font-sans relative overflow-hidden">
      <div className="absolute top-[-10%] left-[-5%] w-[500px] h-[500px] bg-primary/10 rounded-full blur-[120px] pointer-events-none" />
      <div className="absolute bottom-[-10%] right-[-5%] w-[400px] h-[400px] bg-secondary/10 rounded-full blur-[100px] pointer-events-none" />

      <header className="fixed top-0 left-0 w-full z-50 px-6 py-8">
        <div className="max-w-7xl mx-auto flex items-center justify-between">
          <Link href="/" className="flex items-center gap-2 text-on-surface-variant hover:text-on-surface transition-colors group">
            <span className="material-symbols-outlined text-2xl group-active:scale-90 transition-transform">arrow_back</span>
            <span className="text-sm font-medium tracking-wide">Back</span>
          </Link>
          <HeaderActions dropdown />
        </div>
      </header>

      <main className="relative min-h-screen flex items-center justify-center px-6">
        <div className="w-full max-w-md relative z-10">
          <div className="mb-10">
            <div className="inline-block mb-6">
              <span className="text-4xl font-black tracking-tighter text-primary">OLA</span>
              <div className="h-1 w-8 bg-secondary mt-1 rounded-full" />
            </div>
            <h1 className="text-4xl font-extrabold tracking-tight mb-2 leading-tight">
              {mode === "login" ? "Entrar na sua conta" : "Criar conta"}
            </h1>
            <p className="text-on-surface-variant text-base">
              {mode === "login" ? "Bem-vindo de volta!" : "Comece a aprender hoje, é grátis."}
            </p>
          </div>

          {/* Tab switch */}
          <div className="flex rounded-2xl bg-surface-container p-1 mb-8">
            <button
              onClick={() => { setMode("login"); setMessage(null); }}
              className={`flex-1 py-3 rounded-xl text-sm font-bold transition-all ${mode === "login" ? "bg-primary text-on-primary shadow" : "text-on-surface-variant hover:text-on-surface"}`}
            >
              Entrar
            </button>
            <button
              onClick={() => { setMode("register"); setMessage(null); }}
              className={`flex-1 py-3 rounded-xl text-sm font-bold transition-all ${mode === "register" ? "bg-primary text-on-primary shadow" : "text-on-surface-variant hover:text-on-surface"}`}
            >
              Criar conta
            </button>
          </div>

          <form onSubmit={handleSubmit} className="space-y-5">
            {mode === "register" && (
              <div>
                <label className="block text-xs font-bold uppercase tracking-widest text-on-surface-variant mb-2 ml-1">Nome</label>
                <input
                  type="text"
                  value={name}
                  onChange={(e) => setName(e.target.value)}
                  placeholder="Seu nome"
                  className="w-full bg-surface-container-low border-2 border-surface-container-high rounded-2xl px-6 py-4 text-on-surface focus:border-primary outline-none transition-all placeholder:text-outline-variant"
                />
              </div>
            )}

            <div>
              <label className="block text-xs font-bold uppercase tracking-widest text-on-surface-variant mb-2 ml-1">Email</label>
              <input
                type="email"
                required
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="seu@email.com"
                className="w-full bg-surface-container-low border-2 border-surface-container-high rounded-2xl px-6 py-4 text-on-surface focus:border-primary outline-none transition-all placeholder:text-outline-variant"
              />
            </div>

            <div>
              <label className="block text-xs font-bold uppercase tracking-widest text-on-surface-variant mb-2 ml-1">Senha</label>
              <input
                type="password"
                required
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder="••••••••"
                className="w-full bg-surface-container-low border-2 border-surface-container-high rounded-2xl px-6 py-4 text-on-surface focus:border-primary outline-none transition-all placeholder:text-outline-variant"
              />
            </div>

            {message && (
              <div className="rounded-2xl p-4 text-sm bg-error/10 text-error">{message}</div>
            )}

            <button
              type="submit"
              disabled={loading}
              className="w-full bg-gradient-to-r from-primary to-primary-container text-on-primary py-5 rounded-full font-bold text-lg shadow-[0_8px_30px_-12px_rgba(163,166,255,0.4)] active:scale-95 transition-all flex items-center justify-center gap-2 group disabled:opacity-60"
            >
              <span>{loading ? "Aguarde..." : mode === "login" ? "Entrar" : "Criar conta"}</span>
              {!loading && (
                <span className="material-symbols-outlined group-hover:translate-x-1 transition-transform">arrow_forward</span>
              )}
            </button>
          </form>

          {/* Dev Quick Access */}
          <div className="pt-10 border-t border-surface-container-high mt-10">
            <h3 className="text-xs font-black uppercase tracking-widest text-outline-variant mb-6 text-center">
              Dev Quick Access — Simulate Language Pair
            </h3>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
              {TEST_PROFILES.map((profile) => (
                <button
                  key={profile.label}
                  type="button"
                  onClick={() => handleSimulate(profile.source, profile.target)}
                  className="flex items-center justify-between bg-surface-container px-6 py-4 rounded-2xl hover:bg-surface-container-high transition-colors group"
                >
                  <div className="flex flex-col items-start">
                    <span className="text-sm font-bold">{profile.label}</span>
                    <span className="text-[10px] text-on-surface-variant uppercase tracking-tighter">{profile.sub}</span>
                  </div>
                  <span className="material-symbols-outlined text-primary group-hover:translate-x-1 transition-transform">login</span>
                </button>
              ))}
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}
