"use client";

import { useState } from "react";

export function AdminPasswordReset() {
  const [email, setEmail]       = useState("");
  const [newPwd, setNewPwd]     = useState("");
  const [cfmPwd, setCfmPwd]     = useState("");
  const [loading, setLoading]   = useState(false);
  const [msg, setMsg]           = useState<{ text: string; ok: boolean } | null>(null);

  async function handleReset() {
    if (newPwd !== cfmPwd) {
      setMsg({ text: "As senhas não coincidem.", ok: false });
      return;
    }
    if (newPwd.length < 8) {
      setMsg({ text: "A senha deve ter no mínimo 8 caracteres.", ok: false });
      return;
    }

    setLoading(true);
    setMsg(null);

    const res = await fetch("/api/admin/reset-user-password", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email: email.trim(), newPassword: newPwd, newPasswordConfirm: cfmPwd }),
    });
    const data = await res.json();
    setLoading(false);

    if (!res.ok) {
      setMsg({ text: data.error || "Erro ao resetar senha.", ok: false });
      return;
    }

    setMsg({ text: `Senha do usuário ${email} foi alterada com sucesso!`, ok: true });
    setEmail("");
    setNewPwd("");
    setCfmPwd("");
    setTimeout(() => setMsg(null), 5000);
  }

  return (
    <div className="bg-surface-container-low p-6 rounded-xl ghost-border space-y-5">
      <div className="flex items-center gap-3">
        <span className="material-symbols-outlined text-primary">admin_panel_settings</span>
        <div>
          <p className="font-bold text-on-surface">Resetar Senha de Usuário</p>
          <p className="text-xs text-on-surface-variant mt-0.5">
            Defina uma nova senha para qualquer usuário pelo e-mail cadastrado.
          </p>
        </div>
      </div>

      <div className="space-y-3">
        <div>
          <label className="text-xs font-bold text-on-surface-variant uppercase tracking-wider block mb-1">
            E-mail do usuário
          </label>
          <input
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            placeholder="usuario@email.com"
            className="w-full bg-surface-container rounded-lg px-4 py-3 text-on-surface font-medium ghost-border focus:outline-none focus:ring-2 focus:ring-primary/40"
          />
        </div>
        <div>
          <label className="text-xs font-bold text-on-surface-variant uppercase tracking-wider block mb-1">
            Nova senha
          </label>
          <input
            type="password"
            value={newPwd}
            onChange={(e) => setNewPwd(e.target.value)}
            placeholder="Mínimo 8 caracteres"
            className="w-full bg-surface-container rounded-lg px-4 py-3 text-on-surface font-medium ghost-border focus:outline-none focus:ring-2 focus:ring-primary/40"
          />
        </div>
        <div>
          <label className="text-xs font-bold text-on-surface-variant uppercase tracking-wider block mb-1">
            Confirmar nova senha
          </label>
          <input
            type="password"
            value={cfmPwd}
            onChange={(e) => setCfmPwd(e.target.value)}
            placeholder="Repita a nova senha"
            className="w-full bg-surface-container rounded-lg px-4 py-3 text-on-surface font-medium ghost-border focus:outline-none focus:ring-2 focus:ring-primary/40"
          />
        </div>
      </div>

      {msg && (
        <div className={`rounded-lg p-3 text-sm flex items-center gap-2 ${
          msg.ok ? "bg-secondary/10 text-secondary" : "bg-error/10 text-error"
        }`}>
          <span className="material-symbols-outlined text-base">
            {msg.ok ? "check_circle" : "error"}
          </span>
          {msg.text}
        </div>
      )}

      <button
        onClick={handleReset}
        disabled={loading || !email || !newPwd || !cfmPwd}
        className="flex items-center gap-2 bg-primary/10 text-primary font-bold px-6 py-3 rounded-full hover:bg-primary/20 active:scale-95 transition-all disabled:opacity-50"
      >
        <span className="material-symbols-outlined text-lg">
          {loading ? "sync" : "lock_reset"}
        </span>
        {loading ? "Resetando..." : "Resetar Senha"}
      </button>
    </div>
  );
}
