"use client";

import Link from "next/link";
import { useState } from "react";
import { useLanguage } from "@/lib/i18n-context";
import { PushToggle } from "@/components/settings/PushToggle";
import { AuthButton } from "@/components/ola/auth-button";

interface SettingsClientProps {
  displayName: string;
  userEmail: string;
  whatsapp: string;
  sourceLanguage: string;
  targetLanguage: string;
  defaultVoiceGender: string;
  isAdmin?: boolean;
}

export function SettingsClient({
  displayName: initialName,
  userEmail: initialEmail,
  whatsapp: initialWhatsapp,
  sourceLanguage,
  targetLanguage,
  defaultVoiceGender,
  isAdmin = false,
}: SettingsClientProps) {
  const { t } = useLanguage();
  const [gender,      setGender]      = useState(defaultVoiceGender);
  const [name,        setName]        = useState(initialName);
  const [email,       setEmail]       = useState(initialEmail);
  const [whatsapp,    setWhatsapp]    = useState(initialWhatsapp);
  const [saving,      setSaving]      = useState(false);
  const [resetStatus, setResetStatus] = useState<"idle"|"confirming"|"resetting"|"done">("idle");

  async function handleReset() {
    if (resetStatus === "idle") { setResetStatus("confirming"); return; }
    setResetStatus("resetting");
    try {
      const res = await fetch("/api/admin/reset-stats", { method: "POST" });
      if (!res.ok) {
        throw new Error("Reset failed");
      }
      setResetStatus("done");
    } catch (e) {
      console.error("[SettingsClient] Reset stats failed:", e);
      setResetStatus("idle");
    } finally {
      setTimeout(() => setResetStatus("idle"), 3000);
    }
  }
  const [saved,    setSaved]    = useState(false);

  async function handleVoiceSelect(value: string) {
    if (value === gender || saving) return;
    setSaving(true);
    setGender(value);
    await fetch("/api/settings/voice", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ gender: value }),
    });
    setSaving(false);
  }

  async function handleSaveProfile() {
    setSaving(true);
    setSaved(false);
    await fetch("/api/settings/profile", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ displayName: name, email, whatsapp }),
    });
    setSaving(false);
    setSaved(true);
    setTimeout(() => setSaved(false), 2500);
  }

  const voiceOptions = [
    { value: "female", label: t("settings.voice_female"), icon: "face_3" },
    { value: "male",   label: t("settings.voice_male"),   icon: "face"   },
  ];

  return (
    <div className="mx-auto max-w-3xl space-y-8">
      <div>
        <span className="text-primary font-bold uppercase tracking-[0.2em] text-sm">
          {t("settings.section")}
        </span>
        <h1 className="mt-2 text-4xl md:text-5xl font-black tracking-tight text-on-surface">
          {t("settings.title")}
        </h1>
      </div>

      {/* Profile Card */}
      <div className="bg-surface-container-low p-8 rounded-lg ghost-border space-y-6">
        <div className="flex items-center gap-6">
          <div className="w-16 h-16 rounded-full bg-primary/10 flex items-center justify-center">
            <span className="material-symbols-outlined text-3xl text-primary">person</span>
          </div>
          <div>
            <h2 className="text-2xl font-bold text-on-surface">{name || t("settings.tagline")}</h2>
            <p className="text-on-surface-variant text-sm">{t("settings.tagline")}</p>
          </div>
        </div>

        {/* Editable fields */}
        <div className="space-y-4">
          <div>
            <label className="text-xs font-bold text-on-surface-variant uppercase tracking-wider block mb-1">
              {t("settings.display_name")}
            </label>
            <input
              type="text"
              value={name}
              onChange={(e) => setName(e.target.value)}
              className="w-full bg-surface-container rounded-lg px-4 py-3 text-on-surface font-medium ghost-border focus:outline-none focus:ring-2 focus:ring-primary/40"
            />
          </div>
          <div>
            <label className="text-xs font-bold text-on-surface-variant uppercase tracking-wider block mb-1">
              Email
            </label>
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="w-full bg-surface-container rounded-lg px-4 py-3 text-on-surface font-medium ghost-border focus:outline-none focus:ring-2 focus:ring-primary/40"
            />
          </div>
          <div>
            <label className="text-xs font-bold text-on-surface-variant uppercase tracking-wider block mb-1">
              WhatsApp
            </label>
            <input
              type="tel"
              value={whatsapp}
              onChange={(e) => setWhatsapp(e.target.value)}
              placeholder="+55 11 99999-9999"
              className="w-full bg-surface-container rounded-lg px-4 py-3 text-on-surface font-medium ghost-border focus:outline-none focus:ring-2 focus:ring-primary/40"
            />
            <p className="text-xs text-on-surface-variant mt-1">{t("settings.whatsapp_hint")}</p>
          </div>
        </div>

        <button
          onClick={handleSaveProfile}
          disabled={saving}
          className="flex items-center gap-2 bg-primary/10 text-primary font-bold px-6 py-3 rounded-full hover:bg-primary/20 active:scale-95 transition-all disabled:opacity-50"
        >
          <span className="material-symbols-outlined text-lg">
            {saved ? "check_circle" : "save"}
          </span>
          {saved ? t("settings.saved") : t("settings.save_profile")}
        </button>

        <div className="grid gap-4 md:grid-cols-2 pt-2 border-t border-outline-variant/10">
          <div className="bg-surface-container p-4 rounded-lg">
            <p className="text-xs font-bold text-on-surface-variant uppercase tracking-wider">
              {t("settings.source_lang")}
            </p>
            <p className="mt-2 text-xl font-bold text-on-surface">{sourceLanguage || "—"}</p>
          </div>
          <div className="bg-surface-container p-4 rounded-lg">
            <p className="text-xs font-bold text-on-surface-variant uppercase tracking-wider">
              {t("settings.target_lang")}
            </p>
            <p className="mt-2 text-xl font-bold text-on-surface">{targetLanguage || "—"}</p>
          </div>
        </div>

        <Link
          href="/onboarding"
          className="inline-flex items-center gap-2 rounded-full border border-outline-variant/20 px-6 py-3 text-sm font-bold text-on-surface-variant hover:text-primary hover:border-primary/30 transition-all"
        >
          <span className="material-symbols-outlined text-lg">swap_horiz</span>
          {t("settings.change_pair")}
        </Link>
      </div>

      {/* Voice Card */}
      <div className="bg-surface-container-low p-8 rounded-lg ghost-border space-y-4">
        <div className="flex items-center gap-3">
          <span className="material-symbols-outlined text-primary">record_voice_over</span>
          <h3 className="text-lg font-bold text-on-surface">{t("settings.voice_title")}</h3>
        </div>
        <p className="text-on-surface-variant text-sm">{t("settings.voice_desc")}</p>
        <div className="flex gap-3">
          {voiceOptions.map(({ value, label, icon }) => (
            <button
              key={value}
              onClick={() => handleVoiceSelect(value)}
              disabled={saving}
              className={`flex-1 flex items-center justify-center gap-2 p-4 rounded-lg border transition-all font-bold text-sm ${
                gender === value
                  ? "bg-primary/10 border-primary text-primary"
                  : "bg-surface-container border-outline-variant/20 text-on-surface-variant hover:border-primary/30 hover:text-primary"
              }`}
            >
              <span className="material-symbols-outlined">{icon}</span>
              {label}
            </button>
          ))}
        </div>
      </div>

      {/* Push Notifications Card */}
      <PushToggle />

      {/* Sign out — visible on mobile where sidebar is hidden */}
      <div className="lg:hidden">
        <AuthButton />
      </div>

      {/* Admin: Reset Stats */}
      {isAdmin && (
        <div className="bg-error/5 border border-error/20 p-6 rounded-lg space-y-3">
          <div className="flex items-center gap-3">
            <span className="material-symbols-outlined text-error">restart_alt</span>
            <h3 className="text-base font-bold text-on-surface">Resetar Estatísticas</h3>
          </div>
          <p className="text-sm text-on-surface-variant">
            Zera sessões, frases, pontuação e volta ao bloco 1. Use para reiniciar seus testes do zero.
          </p>
          <button
            onClick={handleReset}
            disabled={resetStatus === "resetting"}
            className={`flex items-center gap-2 px-5 py-2.5 rounded-full font-bold text-sm transition-all active:scale-95 disabled:opacity-50 ${
              resetStatus === "confirming"
                ? "bg-error text-white"
                : resetStatus === "done"
                ? "bg-secondary/10 text-secondary"
                : "bg-error/10 text-error hover:bg-error/20"
            }`}
          >
            <span className="material-symbols-outlined text-base">
              {resetStatus === "done" ? "check_circle" : resetStatus === "resetting" ? "sync" : "delete_forever"}
            </span>
            {resetStatus === "confirming"
              ? "Confirmar reset — tem certeza?"
              : resetStatus === "resetting"
              ? "Resetando..."
              : resetStatus === "done"
              ? "Estatísticas zeradas!"
              : "Zerar estatísticas"}
          </button>
          {resetStatus === "confirming" && (
            <button onClick={() => setResetStatus("idle")} className="text-xs text-on-surface-variant ml-2 underline">
              Cancelar
            </button>
          )}
        </div>
      )}
    </div>
  );
}
