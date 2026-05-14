"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import { HeaderActions } from "@/components/ola/header-actions";
import { useLanguage } from "@/lib/i18n-context";

const VAPID_PUBLIC_KEY = process.env.NEXT_PUBLIC_VAPID_PUBLIC_KEY!;

function urlBase64ToUint8Array(base64String: string) {
  const padding = "=".repeat((4 - (base64String.length % 4)) % 4);
  const base64 = (base64String + padding).replace(/-/g, "+").replace(/_/g, "/");
  const rawData = window.atob(base64);
  return Uint8Array.from([...rawData].map((c) => c.charCodeAt(0)));
}

type Mode = "login" | "register";
type Step = "form" | "notify";

export default function LoginPage() {
  const { t } = useLanguage();
  const [mode, setMode] = useState<Mode>("login");
  const [step, setStep] = useState<Step>("form");
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [message, setMessage] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [notifyState, setNotifyState] = useState<"idle" | "loading" | "granted">("idle");
  const [pushSupported, setPushSupported] = useState(false);

  useEffect(() => {
    setPushSupported(
      "serviceWorker" in navigator &&
      "PushManager" in window &&
      Notification.permission !== "denied"
    );
  }, []);

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
      return;
    }

    // After register: show notification opt-in if supported
    if (mode === "register" && pushSupported && Notification.permission === "default") {
      setStep("notify");
    } else {
      window.location.href = "/home";
    }
  }

  async function handleEnableNotifications() {
    setNotifyState("loading");
    try {
      if ("serviceWorker" in navigator) {
        await navigator.serviceWorker.register("/sw.js");
      }
      const reg = await navigator.serviceWorker.ready;
      const sub = await reg.pushManager.subscribe({
        userVisibleOnly: true,
        applicationServerKey: urlBase64ToUint8Array(VAPID_PUBLIC_KEY),
      });
      await fetch("/api/push/subscribe", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ subscription: sub.toJSON() }),
      });
      setNotifyState("granted");
      setTimeout(() => { window.location.href = "/home"; }, 1200);
    } catch {
      window.location.href = "/home";
    }
  }

  // ── Notification opt-in screen ──────────────────────────────────────────
  if (step === "notify") {
    return (
      <div className="min-h-screen bg-surface text-on-surface font-sans relative overflow-hidden flex items-center justify-center px-6">
        <div className="absolute top-[-10%] left-[-5%] w-[500px] h-[500px] bg-primary/10 rounded-full blur-[120px] pointer-events-none" />
        <div className="absolute bottom-[-10%] right-[-5%] w-[400px] h-[400px] bg-secondary/10 rounded-full blur-[100px] pointer-events-none" />

        <div className="w-full max-w-md relative z-10 space-y-8">
          <div className="text-center space-y-4">
            <div className="w-20 h-20 rounded-full bg-primary/10 flex items-center justify-center mx-auto">
              <span className="material-symbols-outlined text-4xl text-primary">notifications_active</span>
            </div>
            <h1 className="text-4xl font-extrabold tracking-tight text-on-surface">
              {t("onboarding.notify.title")}
            </h1>
            <p className="text-on-surface-variant">{t("onboarding.notify.subtitle")}</p>
          </div>

          <div className="space-y-3">
            {[
              { icon: "schedule",              key: "onboarding.notify.b1" },
              { icon: "local_fire_department", key: "onboarding.notify.b2" },
              { icon: "new_releases",          key: "onboarding.notify.b3" },
            ].map(({ icon, key }) => (
              <div key={key} className="flex items-center gap-4 bg-surface-container-low p-4 rounded-xl ghost-border">
                <span className="material-symbols-outlined text-primary text-xl shrink-0">{icon}</span>
                <p className="text-sm font-medium text-on-surface">{t(key)}</p>
              </div>
            ))}
          </div>

          <div className="flex flex-col gap-3">
            <button
              onClick={handleEnableNotifications}
              disabled={notifyState === "loading" || notifyState === "granted"}
              className="w-full bg-gradient-to-br from-primary to-primary-container text-on-primary font-bold text-lg py-5 rounded-full inner-glow hover:opacity-90 transition-all active:scale-[0.97] shadow-lg disabled:opacity-70 flex items-center justify-center gap-2"
            >
              <span className="material-symbols-outlined">
                {notifyState === "loading" ? "sync" : notifyState === "granted" ? "check_circle" : "notifications_active"}
              </span>
              {notifyState === "granted"
                ? t("onboarding.notify.granted")
                : notifyState === "loading"
                ? t("onboarding.saving")
                : t("onboarding.notify.enable")}
            </button>
            <button
              onClick={() => { window.location.href = "/home"; }}
              className="w-full py-4 rounded-full text-on-surface-variant font-semibold text-sm hover:text-on-surface transition-colors"
            >
              {t("onboarding.notify.skip")}
            </button>
          </div>
        </div>
      </div>
    );
  }

  // ── Login / Register form ────────────────────────────────────────────────
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
        </div>
      </main>
    </div>
  );
}
