"use client";

import { useState } from "react";
import Link from "next/link";
import { useSearchParams } from "next/navigation";
import { HeaderActions } from "@/components/ola/header-actions";

type Mode = "login" | "register" | "forgot";

export default function LoginPage() {
  const searchParams = useSearchParams();
  const resetDone = searchParams.get("reset") === "ok";

  const [mode, setMode]       = useState<Mode>("login");
  const [name, setName]       = useState("");
  const [email, setEmail]     = useState("");
  const [password, setPassword] = useState("");
  const [message, setMessage] = useState<string | null>(resetDone ? "Senha redefinida com sucesso! Faça login." : null);
  const [msgType, setMsgType] = useState<"error" | "success">(resetDone ? "success" : "error");
  const [loading, setLoading] = useState(false);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setLoading(true);
    setMessage(null);

    if (mode === "forgot") {
      await fetch("/api/auth/forgot-password", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email }),
      });
      setLoading(false);
      setMsgType("success");
      setMessage("Se esse e-mail estiver cadastrado, você receberá um link de recuperação. Verifique sua caixa de entrada.");
      return;
    }

    const endpoint = mode === "login" ? "/api/auth/login" : "/api/auth/register";
    const body     = mode === "login" ? { email, password } : { email, password, name };

    const res  = await fetch(endpoint, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(body),
    });
    const data = await res.json();
    setLoading(false);

    if (!res.ok) {
      setMsgType("error");
      setMessage(data.error || "Algo deu errado.");
      return;
    }

    // New users go through onboarding (choose target language + push opt-in)
    // Returning users go straight to home
    window.location.href = mode === "register" ? "/onboarding" : "/home";
  }

  function switchMode(newMode: Mode) {
    setMode(newMode);
    setMessage(null);
    setMsgType("error");
  }

  return (
    <div className="min-h-screen bg-surface text-on-surface font-sans relative overflow-hidden">
      <div className="absolute top-[-10%] left-[-5%] w-[500px] h-[500px] bg-primary/10 rounded-full blur-[120px] pointer-events-none" />
      <div className="absolute bottom-[-10%] right-[-5%] w-[400px] h-[400px] bg-secondary/10 rounded-full blur-[100px] pointer-events-none" />

      <header className="fixed top-0 left-0 w-full z-50 px-6 py-8">
        <div className="max-w-7xl mx-auto flex items-center justify-between">
          <Link href="/" className="flex items-center gap-2 text-on-surface-variant hover:text-on-surface transition-colors group">
            <span className="material-symbols-outlined text-2xl group-active:scale-90 transition-transform">arrow_back</span>
            <span className="text-sm font-medium tracking-wide">Voltar</span>
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
              {mode === "forgot"
                ? "Recuperar senha"
                : mode === "login"
                ? "Entrar na sua conta"
                : "Criar conta"}
            </h1>
            <p className="text-on-surface-variant text-base">
              {mode === "forgot"
                ? "Insira seu e-mail e enviaremos um link para redefinir."
                : mode === "login"
                ? "Bem-vindo de volta!"
                : "Comece a aprender hoje, é grátis."}
            </p>
          </div>

          {/* Tab switch — only login/register */}
          {mode !== "forgot" && (
            <div className="flex rounded-2xl bg-surface-container p-1 mb-8">
              <button
                onClick={() => switchMode("login")}
                className={`flex-1 py-3 rounded-xl text-sm font-bold transition-all ${mode === "login" ? "bg-primary text-on-primary shadow" : "text-on-surface-variant hover:text-on-surface"}`}
              >
                Entrar
              </button>
              <button
                onClick={() => switchMode("register")}
                className={`flex-1 py-3 rounded-xl text-sm font-bold transition-all ${mode === "register" ? "bg-primary text-on-primary shadow" : "text-on-surface-variant hover:text-on-surface"}`}
              >
                Criar conta
              </button>
            </div>
          )}

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

            {mode !== "forgot" && (
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
            )}

            {/* Forgot password link — only visible on login mode */}
            {mode === "login" && (
              <div className="flex justify-end -mt-2">
                <button
                  type="button"
                  onClick={() => switchMode("forgot")}
                  className="text-sm text-primary hover:text-primary/80 font-medium transition-colors"
                >
                  Esqueci minha senha
                </button>
              </div>
            )}

            {message && (
              <div className={`rounded-2xl p-4 text-sm ${
                msgType === "success"
                  ? "bg-secondary/10 text-secondary"
                  : "bg-error/10 text-error"
              }`}>
                {msgType === "success" && (
                  <span className="material-symbols-outlined text-base align-middle mr-1.5">check_circle</span>
                )}
                {message}
              </div>
            )}

            <button
              type="submit"
              disabled={loading}
              className="w-full bg-gradient-to-r from-primary to-primary-container text-on-primary py-5 rounded-full font-bold text-lg shadow-[0_8px_30px_-12px_rgba(163,166,255,0.4)] active:scale-95 transition-all flex items-center justify-center gap-2 group disabled:opacity-60"
            >
              <span>
                {loading
                  ? "Aguarde..."
                  : mode === "forgot"
                  ? "Enviar link de recuperação"
                  : mode === "login"
                  ? "Entrar"
                  : "Criar conta"}
              </span>
              {!loading && (
                <span className="material-symbols-outlined group-hover:translate-x-1 transition-transform">
                  {mode === "forgot" ? "mail" : "arrow_forward"}
                </span>
              )}
            </button>

            {/* Back to login from forgot mode */}
            {mode === "forgot" && (
              <button
                type="button"
                onClick={() => switchMode("login")}
                className="w-full flex items-center justify-center gap-2 text-sm text-on-surface-variant hover:text-on-surface font-medium py-3 transition-colors"
              >
                <span className="material-symbols-outlined text-lg">arrow_back</span>
                Voltar ao login
              </button>
            )}
          </form>
        </div>
      </main>
    </div>
  );
}
