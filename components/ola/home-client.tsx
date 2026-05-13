"use client";

import Link from "next/link";
import { useState } from "react";
import { useLanguage } from "@/lib/i18n-context";

interface HomeClientProps {
  displayName: string;
  streakDays: number;
  streakState: "new" | "today" | "alive" | "broken";
  currentBlockOrder: number;
  sourceLanguageCode: string;
  targetLanguageCode: string;
  queueCount: number;
  blockTitle: string;
  sessionsDone: number;
  totalPhrases: number;
  avgScore: number;
  wordsRepeated: number;
  defaultVoiceGender: string;
}

function getGreetingKey(): string {
  const hour = new Date().getHours();
  if (hour < 12) return "home.greeting.morning";
  if (hour < 18) return "home.greeting.afternoon";
  return "home.greeting.evening";
}

const LANG_META: Record<string, { flag: string; key: string }> = {
  en:      { flag: "🇺🇸", key: "lang.en" },
  "pt-BR": { flag: "🇧🇷", key: "lang.pt" },
  pt:      { flag: "🇧🇷", key: "lang.pt" },
  es:      { flag: "🇪🇸", key: "lang.es" },
  it:      { flag: "🇮🇹", key: "lang.it" },
  fr:      { flag: "🇫🇷", key: "lang.fr" },
  de:      { flag: "🇩🇪", key: "lang.de" },
};

export function HomeClient({
  displayName,
  streakDays,
  streakState,
  currentBlockOrder,
  sourceLanguageCode,
  targetLanguageCode,
  queueCount,
  blockTitle,
  sessionsDone,
  totalPhrases,
  avgScore,
  wordsRepeated,
  defaultVoiceGender,
}: HomeClientProps) {
  const { t } = useLanguage();
  const [voiceGender, setVoiceGender] = useState(defaultVoiceGender);
  const [savingVoice, setSavingVoice] = useState(false);

  async function handleVoiceSelect(value: string) {
    if (value === voiceGender || savingVoice) return;
    setSavingVoice(true);
    setVoiceGender(value);
    await fetch("/api/settings/voice", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ gender: value }),
    });
    setSavingVoice(false);
  }

  const greetingKey = getGreetingKey();
  const targetMeta = LANG_META[targetLanguageCode] ?? LANG_META["en"];

  return (
    <div className="flex flex-col gap-8">
      {/* ── Greeting & Streak ── */}
      <div className="flex flex-col md:flex-row md:items-end justify-between gap-4">
        <div className="space-y-2">
          <h2 className="text-4xl md:text-5xl font-bold tracking-tight text-on-surface">
            {t(greetingKey)}, {displayName} 👋
          </h2>
          <p className="text-on-surface-variant font-medium">
            {t("home.subtitle")}
          </p>
          {/* Training language badge */}
          <div className="inline-flex items-center gap-2 mt-1 px-3 py-1.5 rounded-full bg-secondary/10 border border-secondary/20">
            <span className="text-sm">{targetMeta.flag}</span>
            <span className="text-xs font-bold uppercase tracking-widest text-secondary">
              {t("home.training_label")} {t(targetMeta.key)}
            </span>
          </div>
        </div>
        {/* Streak Card */}
        {(() => {
          const streakMeta = {
            new:    { emoji: "⚡", valueColor: "text-on-surface-variant", subKey: "home.streak.new_sub" },
            today:  { emoji: "🔥", valueColor: "text-amber-400",          subKey: "home.streak.sub"     },
            alive:  { emoji: "🔥", valueColor: "text-amber-400",          subKey: "home.streak.alive_sub"},
            broken: { emoji: "💪", valueColor: "text-on-surface-variant", subKey: "home.streak.broken_sub"},
          }[streakState];
          return (
            <div className="glass-card p-4 px-6 rounded-lg inline-flex items-center gap-3 ghost-border self-start md:self-auto shadow-2xl shadow-surface-container-lowest">
              <span className="text-3xl">{streakMeta.emoji}</span>
              <div className="flex flex-col">
                {streakDays > 0 ? (
                  <span className={`text-xl font-black ${streakMeta.valueColor}`}>
                    {streakDays} {t("home.streak.label")}
                  </span>
                ) : (
                  <span className="text-xl font-black text-on-surface-variant">
                    {streakState === "broken" ? t("home.streak.broken") : t("home.streak.new")}
                  </span>
                )}
                <span className="text-[10px] uppercase tracking-widest text-on-surface-variant font-bold">
                  {t(streakMeta.subKey)}
                </span>
              </div>
            </div>
          );
        })()}
      </div>

      {/* ── Bento Grid ── */}
      <div className="grid grid-cols-1 md:grid-cols-12 gap-6">
        {/* Main Session Card */}
        <div className="md:col-span-8 glass-card rounded-lg overflow-hidden relative group p-8 flex flex-col justify-between min-h-[340px] ghost-border">
          <div className="absolute -top-12 -right-12 w-64 h-64 bg-primary/10 rounded-full blur-3xl pointer-events-none group-hover:bg-primary/20 transition-colors duration-700" />
          <div className="relative z-10">
            <span className="text-xs font-black tracking-[0.2em] text-primary uppercase bg-primary/10 px-3 py-1 rounded-full">
              {t("home.session.badge")}
            </span>
            <h3 className="text-5xl md:text-6xl font-black text-on-surface mt-6 leading-tight max-w-md">
              {t("home.session.title")}
            </h3>
          </div>
          {/* Voice selector + CTA */}
          <div className="relative z-10 flex items-end justify-between gap-6 mt-8">
            <div className="flex flex-col gap-2">
              <div className="flex items-center gap-2 mb-1">
                <span className="material-symbols-outlined text-sm text-on-surface-variant">record_voice_over</span>
                <span className="text-xs font-bold uppercase tracking-widest text-on-surface-variant">
                  {t("home.voice_label")}
                </span>
              </div>
              {[
                { value: "female", icon: "face_3", label: t("settings.voice_female") },
                { value: "male",   icon: "face",   label: t("settings.voice_male")   },
              ].map(({ value, icon, label }) => (
                <button
                  key={value}
                  onClick={() => handleVoiceSelect(value)}
                  disabled={savingVoice}
                  title={label}
                  className={`flex items-center gap-1.5 px-3 py-1.5 rounded-full border text-xs font-bold transition-all ${
                    voiceGender === value
                      ? "bg-primary/15 border-primary text-primary"
                      : "border-outline-variant/20 text-on-surface-variant hover:border-primary/40 hover:text-primary"
                  }`}
                >
                  <span className="material-symbols-outlined text-sm">{icon}</span>
                  {label}
                </button>
              ))}
            </div>
            <Link
              href="/session/live"
              className="bg-gradient-to-br from-primary to-primary-container text-on-primary font-black py-4 px-10 rounded-full inner-glow active:scale-95 duration-200 shadow-[0_0_40px_rgba(163,166,255,0.2)] flex items-center gap-3"
            >
              {t("home.session.cta")}
              <span
                className="material-symbols-outlined"
                style={{ fontVariationSettings: "'FILL' 1" }}
              >
                play_arrow
              </span>
            </Link>
          </div>
        </div>

        {/* Block Progress Card */}
        <div className="md:col-span-4 bg-surface-container-low rounded-lg p-8 flex flex-col justify-between ghost-border">
          <div>
            <span className="text-xs font-bold text-on-surface-variant uppercase tracking-widest">
              {t("home.block.label")}
            </span>
            <div className="flex items-center justify-between mt-2">
              <h4 className="text-2xl font-bold text-on-surface">
                {t("blocks.block")} {currentBlockOrder}
              </h4>
              <span
                className="material-symbols-outlined text-5xl text-tertiary/70"
                style={{ fontVariationSettings: "'FILL' 1" }}
              >
                auto_stories
              </span>
            </div>
            <p className="text-on-surface-variant text-sm mt-1">
              {sourceLanguageCode} → {targetLanguageCode}
            </p>
            {blockTitle && (
              <p className="text-tertiary text-xs font-semibold mt-2 leading-snug">{blockTitle}</p>
            )}
          </div>
          <div className="mt-8">
            <div className="flex justify-between items-end mb-3">
              <span className="text-4xl font-black text-secondary">
                {queueCount}
              </span>
              <span className="text-xs font-bold text-on-surface-variant uppercase">
                {t("home.block.phrases")}
              </span>
            </div>
            <div className="h-2 w-full bg-surface-container-highest rounded-full overflow-hidden">
              <div
                className="h-full bg-gradient-to-r from-secondary-dim to-secondary rounded-full transition-all"
                style={{ width: `${Math.min((queueCount / 5) * 100, 100)}%` }}
              />
            </div>
          </div>
          <Link
            href="/blocks"
            className="mt-6 flex items-center justify-center gap-2 text-on-surface-variant hover:text-secondary transition-colors text-sm font-bold uppercase tracking-wider group"
          >
            {t("home.block.view_progress")}
            <span className="material-symbols-outlined text-sm group-hover:translate-x-1 transition-transform">
              chevron_right
            </span>
          </Link>
        </div>

        {/* Quick Stats */}
        <div className="md:col-span-12 grid grid-cols-2 sm:grid-cols-4 gap-6">
          <StatCard
            icon="menu_book"
            value={`${totalPhrases * 5}`}
            label={t("home.stats.words")}
            color="primary"
          />
          <StatCard
            icon="replay"
            value={`${wordsRepeated}`}
            label={t("home.stats.repeated")}
            color="secondary"
          />
          <StatCard
            icon="history_edu"
            value={`${sessionsDone}`}
            label={t("home.stats.sessions")}
            color="tertiary"
          />
          <StatCard
            icon="target"
            value={`${avgScore}%`}
            label={t("home.stats.score")}
            color="primary"
          />
        </div>
      </div>
    </div>
  );
}

function StatCard({
  icon,
  value,
  label,
  color,
}: {
  icon: string;
  value: string;
  label: string;
  color: "primary" | "secondary" | "tertiary";
}) {
  const bg = {
    primary: "bg-primary/5 text-primary",
    secondary: "bg-secondary/5 text-secondary",
    tertiary: "bg-tertiary/5 text-tertiary",
  };
  return (
    <div className="bg-surface-container p-6 rounded-lg ghost-border flex items-center gap-6">
      <div className={`w-14 h-14 rounded-full ${bg[color]} flex items-center justify-center`}>
        <span
          className="material-symbols-outlined"
          style={{ fontVariationSettings: "'FILL' 1" }}
        >
          {icon}
        </span>
      </div>
      <div>
        <p className="text-3xl font-black text-on-surface">{value}</p>
        <p className="text-xs font-bold text-on-surface-variant uppercase tracking-widest">
          {label}
        </p>
      </div>
    </div>
  );
}
