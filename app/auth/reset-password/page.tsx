"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import { useSearchParams } from "next/navigation";
import { HeaderActions } from "@/components/ola/header-actions";

export default function ResetPasswordPage() {
  const searchParams = useSearchParams();
  const token = searchParams.get("token") || "";

  const [password, setPassword]               = useState("");
  const [passwordConfirm, setPasswordConfirm] = useState("");
  const [loading, setLoading]                 = useState(false);
  const [message, setMessage]                 = useState<string | null>(null);
  const [success, setSuccess]                 = useState(false);

  useEffect(() => {
    if (!token) {
      setMessage("Link de redefinição inválido. Solicite um novo.");
    }
  }, [token]);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!token) return;
    setLoading(true);
    setMessage(null);

    const res = await fetch("/api/auth/reset-password", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ token, password, passwordConfirm }),
    });
    const data = await res.json();
    setLoading(false);

    if (!res.ok) {
      setMessage(data.error || "Algo deu errado.");
      return;
    }

    setSuccess(true);
    setMessage("Senha redefinida com sucesso!");
  }

  return (
    <div className="min-h-screen bg-surface text-on-surface font-sans relative overflow-hidden">
      <div className="absolute top-[-10%] left-[-5%] w-[500px] h-[500px] bg-primary/10 rounded-full blur-[120px] pointer-events-none" />
      <div className="absolute bottom-[-10%] right-[-5%] w-[400px] h-[400px] bg-secondary/10 rounded-full blur-[100px] pointer-events-none" />

      <header className="fixed top-0 left-0 w-full z-50 px-6 py-8">
        <div className="max-w-7xl mx-auto flex items-center justify-between">
          <Link href="/auth/login" className="flex items-center gap-2 text-on-surface-variant hover:text-on-surface transition-colors group">
            <span className="material-symbols-outlined text-2xl group-active:scale-90 transition-transform">arrow_back</span>
            <span className="text-sm font-medium tracking-wide">Voltar ao login</span>
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
              Redefinir senha
            </h1>
            <p className="text-on-surface-variant text-base">
              Escolha uma nova senha para sua conta.
            </p>
          </div>

          {success ? (
            <div className="space-y-6">
              <div className="rounded-2xl p-6 bg-secondary/10 text-secondary text-center space-y-3">
                <span className="material-symbols-outlined text-4xl">check_circle</span>
                <p className="font-bold text-lg">{message}</p>
                <p className="text-sm text-on-surface-variant">Agora você pode entrar com sua nova senha.</p>
              </div>
              <Link
                href="/auth/login"
                className="w-full bg-gradient-to-r from-primary to-primary-container text-on-primary py-5 rounded-full font-bold text-lg shadow-[0_8px_30px_-12px_rgba(163,166,255,0.4)] active:scale-95 transition-all flex items-center justify-center gap-2 group"
              >
                <span className="material-symbols-outlined group-hover:translate-x-1 transition-transform">login</span>
                <span>Ir para o login</span>
              </Link>
            </div>
          ) : (
            <form onSubmit={handleSubmit} className="space-y-5">
              <div>
                <label className="block text-xs font-bold uppercase tracking-widest text-on-surface-variant mb-2 ml-1">Nova senha</label>
                <input
                  type="password"
                  required
                  minLength={8}
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  placeholder="Mínimo 8 caracteres"
                  className="w-full bg-surface-container-low border-2 border-surface-container-high rounded-2xl px-6 py-4 text-on-surface focus:border-primary outline-none transition-all placeholder:text-outline-variant"
                />
              </div>

              <div>
                <label className="block text-xs font-bold uppercase tracking-widest text-on-surface-variant mb-2 ml-1">Confirmar nova senha</label>
                <input
                  type="password"
                  required
                  minLength={8}
                  value={passwordConfirm}
                  onChange={(e) => setPasswordConfirm(e.target.value)}
                  placeholder="Repita a nova senha"
                  className="w-full bg-surface-container-low border-2 border-surface-container-high rounded-2xl px-6 py-4 text-on-surface focus:border-primary outline-none transition-all placeholder:text-outline-variant"
                />
              </div>

              {message && (
                <div className="rounded-2xl p-4 text-sm bg-error/10 text-error">{message}</div>
              )}

              <button
                type="submit"
                disabled={loading || !token}
                className="w-full bg-gradient-to-r from-primary to-primary-container text-on-primary py-5 rounded-full font-bold text-lg shadow-[0_8px_30px_-12px_rgba(163,166,255,0.4)] active:scale-95 transition-all flex items-center justify-center gap-2 group disabled:opacity-60"
              >
                <span>{loading ? "Aguarde..." : "Redefinir senha"}</span>
                {!loading && (
                  <span className="material-symbols-outlined group-hover:translate-x-1 transition-transform">lock_reset</span>
                )}
              </button>
            </form>
          )}
        </div>
      </main>
    </div>
  );
}
