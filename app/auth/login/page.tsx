"use client";

import { useState } from "react";
import Link from "next/link";
import { createClient } from "@/lib/supabase/client";
import { HeaderActions } from "@/components/ola/header-actions";
import { applyLanguagePair } from "@/lib/i18n-context";

const TEST_PROFILES = [
  // ── Portuguese ──
  { label: "BR 🇧🇷 → EN 🇺🇸", sub: "Brazilian learning English",    source: "pt-BR", target: "en"   },
  { label: "US 🇺🇸 → PT 🇧🇷", sub: "American learning Portuguese",  source: "en",    target: "pt-BR" },
  // ── Spanish ──
  { label: "ES 🇪🇸 → PT 🇧🇷", sub: "Spanish learning Portuguese",   source: "es",    target: "pt-BR" },
  { label: "BR 🇧🇷 → ES 🇪🇸", sub: "Brazilian learning Spanish",    source: "pt-BR", target: "es"   },
  // ── Italian ──
  { label: "BR 🇧🇷 → IT 🇮🇹", sub: "Brazilian learning Italian",    source: "pt-BR", target: "it"   },
  { label: "IT 🇮🇹 → EN 🇬🇧", sub: "Italian learning English",      source: "it",    target: "en"   },
  // ── French ──
  { label: "BR 🇧🇷 → FR 🇫🇷", sub: "Brazilian learning French",     source: "pt-BR", target: "fr"   },
  { label: "FR 🇫🇷 → EN 🇬🇧", sub: "French learning English",       source: "fr",    target: "en"   },
  // ── German ──
  { label: "BR 🇧🇷 → DE 🇩🇪", sub: "Brazilian learning German",     source: "pt-BR", target: "de"   },
  { label: "DE 🇩🇪 → EN 🇬🇧", sub: "German learning English",       source: "de",    target: "en"   },
  // ── Cross-language ──
  { label: "IT 🇮🇹 → FR 🇫🇷", sub: "Italian learning French",       source: "it",    target: "fr"   },
  { label: "FR 🇫🇷 → DE 🇩🇪", sub: "French learning German",        source: "fr",    target: "de"   },
];

export default function LoginPage() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [isPasswordMode, setIsPasswordMode] = useState(false);
  const [message, setMessage] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [sent, setSent] = useState(false);

  async function handleMagicLink(event: React.FormEvent) {
    event.preventDefault();
    setLoading(true);
    setMessage(null);
    const supabase = createClient();
    const origin = window.location.origin;
    const { error } = await supabase.auth.signInWithOtp({
      email,
      options: {
        emailRedirectTo: `${origin}/auth/callback`,
      },
    });
    setLoading(false);
    if (error) {
      setMessage(error.message);
    } else {
      setSent(true);
      setMessage("Check your email for the magic link.");
    }
  }

  async function handlePasswordLogin(event: React.FormEvent) {
    event.preventDefault();
    setLoading(true);
    setMessage(null);
    const supabase = createClient();
    const { error } = await supabase.auth.signInWithPassword({
      email,
      password,
    });
    setLoading(false);
    if (error) {
      setMessage(error.message);
    } else {
      window.location.href = "/home";
    }
  }

  /**
   * Sets the language-pair cookies and redirects to home.
   * Auth is mocked server-side so no Supabase login is needed for the test profiles.
   */
  function handleSimulate(source: string, target: string) {
    applyLanguagePair(source, target);
    window.location.href = "/home";
  }

  return (
    <div className="min-h-screen bg-surface text-on-surface font-sans relative overflow-hidden">
      {/* Background Elements */}
      <div className="absolute top-[-10%] left-[-5%] w-[500px] h-[500px] bg-primary/10 rounded-full blur-[120px] pointer-events-none" />
      <div className="absolute bottom-[-10%] right-[-5%] w-[400px] h-[400px] bg-secondary/10 rounded-full blur-[100px] pointer-events-none" />

      {/* Back button */}
      <header className="fixed top-0 left-0 w-full z-50 px-6 py-8">
        <div className="max-w-7xl mx-auto flex items-center justify-between">
          <Link
            href="/"
            className="flex items-center gap-2 text-on-surface-variant hover:text-on-surface transition-colors group"
          >
            <span className="material-symbols-outlined text-2xl group-active:scale-90 transition-transform">
              arrow_back
            </span>
            <span className="text-sm font-medium tracking-wide">Back</span>
          </Link>
          <div className="flex items-center">
            <HeaderActions dropdown />
          </div>
        </div>
      </header>

      <main className="relative min-h-screen flex items-center justify-center px-6">
        <div className="w-full max-w-md relative z-10">
          {/* Brand Anchor */}
          <div className="mb-12">
            <div className="inline-block mb-8">
              <span className="text-4xl font-black tracking-tighter text-primary">OLA</span>
              <div className="h-1 w-8 bg-secondary mt-1 rounded-full" />
            </div>
            <h1 className="text-4xl md:text-5xl font-extrabold tracking-tight mb-4 leading-tight">
              {sent ? "Check your email" : "Create your account"}
            </h1>
            <p className="text-on-surface-variant text-lg max-w-[280px]">
              {sent
                ? "We sent a magic link to your email. Click it to access OLA."
                : "You'll receive a magic link to access OLA instantly."}
            </p>
          </div>

          {/* Form */}
          {!sent && (
            <form onSubmit={isPasswordMode ? handlePasswordLogin : handleMagicLink} className="space-y-6">
              <div className="relative group">
                <label
                  htmlFor="email"
                  className="block text-xs font-bold uppercase tracking-widest text-on-surface-variant mb-3 ml-1"
                >
                  Email
                </label>
                <input
                  id="email"
                  type="email"
                  required
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  placeholder="athlete@cognitive.com"
                  className="w-full bg-surface-container-low border-2 border-surface-container-high rounded-2xl px-6 py-4 text-on-surface focus:border-primary focus:ring-0 transition-all placeholder:text-outline-variant outline-none"
                />
              </div>

              {isPasswordMode && (
                <div className="relative group animate-in fade-in slide-in-from-top-2 duration-300">
                  <label
                    htmlFor="password"
                    className="block text-xs font-bold uppercase tracking-widest text-on-surface-variant mb-3 ml-1"
                  >
                    Password
                  </label>
                  <input
                    id="password"
                    type="password"
                    required
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    placeholder="••••••••"
                    className="w-full bg-surface-container-low border-2 border-surface-container-high rounded-2xl px-6 py-4 text-on-surface focus:border-primary focus:ring-0 transition-all placeholder:text-outline-variant outline-none"
                  />
                </div>
              )}

              <div className="pt-2">
                <button
                  type="submit"
                  disabled={loading}
                  className="w-full bg-gradient-to-r from-primary to-primary-container text-on-primary py-5 rounded-full font-bold text-lg shadow-[0_8px_30px_-12px_rgba(163,166,255,0.4)] active:scale-95 transition-all flex items-center justify-center gap-2 group disabled:opacity-60"
                >
                  <span>{loading ? "Processing..." : isPasswordMode ? "Sign in" : "Send magic link"}</span>
                  {!loading && (
                    <span className="material-symbols-outlined group-hover:translate-x-1 transition-transform">
                      arrow_forward
                    </span>
                  )}
                </button>
              </div>

              <div className="flex flex-col gap-4 text-center">
                <button
                  type="button"
                  onClick={() => setIsPasswordMode(!isPasswordMode)}
                  className="text-primary text-sm font-bold hover:underline"
                >
                  {isPasswordMode ? "Use Magic Link instead" : "Use Password instead"}
                </button>
              </div>

              {/* Dev Quick Access */}
              <div className="pt-8 border-t border-surface-container-high">
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
                        <span className="text-[10px] text-on-surface-variant uppercase tracking-tighter">
                          {profile.sub}
                        </span>
                      </div>
                      <span className="material-symbols-outlined text-primary group-hover:translate-x-1 transition-transform">
                        login
                      </span>
                    </button>
                  ))}
                </div>
              </div>
            </form>
          )}

          {/* Message */}
          {message && (
            <div className={`mt-6 rounded-2xl p-4 text-sm ${sent ? "bg-secondary/10 text-secondary" : "bg-error/10 text-error"}`}>
              {message}
            </div>
          )}

          {sent && (
            <button
              onClick={() => { setSent(false); setMessage(null); }}
              className="mt-6 w-full rounded-full border border-outline-variant/20 px-5 py-3 font-medium text-on-surface-variant hover:text-on-surface hover:bg-surface-container-high transition-all"
            >
              Try a different email
            </button>
          )}

          {/* Progress stepper */}
          <div className="mt-24 grid grid-cols-3 gap-4 opacity-40">
            <div className="h-[2px] bg-surface-container-highest relative overflow-hidden">
              <div className="absolute inset-0 bg-secondary w-1/3" />
            </div>
            <div className="h-[2px] bg-surface-container-highest" />
            <div className="h-[2px] bg-surface-container-highest" />
          </div>
          <div className="mt-4 flex justify-between items-center text-[10px] uppercase tracking-widest font-black text-outline-variant">
            <span>Phase 01</span>
            <span>Identity Verification</span>
            <span>Active</span>
          </div>
        </div>

        {/* Decorative Layering */}
        <div className="hidden lg:block absolute right-24 top-1/2 -translate-y-1/2 w-64 h-96 opacity-20 pointer-events-none">
          <div className="glass-panel w-full h-full rounded-3xl ghost-border rotate-6 translate-x-12" />
          <div className="glass-panel w-full h-full rounded-3xl ghost-border -rotate-3 absolute inset-0" />
          <div className="absolute inset-0 flex items-center justify-center">
            <span className="text-8xl font-black text-on-surface-variant/20 tracking-tighter rotate-90">
              ATHLETE
            </span>
          </div>
        </div>
      </main>
    </div>
  );
}
