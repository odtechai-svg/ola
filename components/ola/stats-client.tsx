"use client";

import { useLanguage } from "@/lib/i18n-context";

interface StatsClientProps {
  sessionsDone: number;
  totalPhrases: number;
  avgScore: number;
  blocksCompleted: number;
  wordsLearned: number;
  minutesTrained: number;
  sourceLang: string;
  targetLang: string;
}

export function StatsClient({
  sessionsDone,
  totalPhrases,
  avgScore,
  blocksCompleted,
  wordsLearned,
  minutesTrained,
  sourceLang,
  targetLang,
}: StatsClientProps) {
  const { t } = useLanguage();

  const accuracy = avgScore;
  const accuracyColor = accuracy >= 85 ? "text-secondary" : accuracy >= 65 ? "text-primary" : "text-tertiary";
  const blockPct = Math.min(100, Math.round((blocksCompleted / 120) * 100));

  const topCards = [
    { icon: "event_available",   label: t("stats.sessions"),       value: sessionsDone,          color: "primary"   },
    { icon: "forum",             label: t("stats.phrases"),        value: totalPhrases,          color: "secondary" },
    { icon: "workspace_premium", label: t("stats.accuracy_score"), value: `${avgScore}%`,        color: "tertiary"  },
    { icon: "dictionary",        label: t("stats.words"),          value: wordsLearned,          color: "primary"   },
    { icon: "timer",             label: t("stats.minutes"),        value: minutesTrained,        color: "secondary" },
    { icon: "check_circle",      label: t("stats.blocks_done"),    value: blocksCompleted,       color: "tertiary"  },
  ];

  const motivationText =
    sessionsDone === 0
      ? t("stats.motivation.zero")
      : sessionsDone < 5
      ? `${sessionsDone} ${t("stats.motivation.few")}`
      : sessionsDone < 20
      ? `${sessionsDone} ${t("stats.motivation.mid")}`
      : `${sessionsDone} ${t("stats.motivation.pro")}`;

  const accuracyText =
    accuracy >= 85
      ? t("stats.excellent")
      : accuracy >= 65
      ? t("stats.good")
      : t("stats.keep_going");

  return (
    <div className="mx-auto max-w-3xl space-y-8">
      {/* Header */}
      <div>
        <span className="text-primary font-bold uppercase tracking-[0.2em] text-sm">{t("stats.section")}</span>
        <h1 className="mt-2 text-4xl md:text-5xl font-black tracking-tight text-on-surface">
          {t("stats.title")}
        </h1>
        <p className="mt-3 text-on-surface-variant text-sm">
          {t("stats.subtitle")}{" "}
          <span className="font-bold text-on-surface">{sourceLang} → {targetLang}</span>
        </p>
      </div>

      {/* Stat grid */}
      <div className="grid grid-cols-2 md:grid-cols-3 gap-4">
        {topCards.map(({ icon, label, value, color }) => (
          <div key={label} className="bg-surface-container-low p-5 rounded-xl ghost-border flex flex-col gap-2">
            <span className={`material-symbols-outlined text-xl text-${color}`}>{icon}</span>
            <p className="text-3xl font-black text-on-surface">{value}</p>
            <p className="text-xs font-bold text-on-surface-variant uppercase tracking-wider leading-tight">{label}</p>
          </div>
        ))}
      </div>

      {/* Curriculum progress bar */}
      <div className="bg-surface-container-low p-6 rounded-xl ghost-border space-y-3">
        <div className="flex items-center justify-between">
          <p className="text-sm font-bold text-on-surface-variant uppercase tracking-wider">{t("stats.curriculum")}</p>
          <p className="text-sm font-black text-primary">{blocksCompleted} / 120 {t("stats.blocks_of")}</p>
        </div>
        <div className="h-3 w-full bg-surface-container-highest rounded-full overflow-hidden">
          <div
            className="h-full bg-gradient-to-r from-primary-dim to-primary rounded-full transition-all"
            style={{ width: `${Math.max(blockPct, 1)}%` }}
          />
        </div>
        <p className="text-xs text-on-surface-variant">{blockPct}{t("stats.curriculum_pct")}</p>
      </div>

      {/* Accuracy bar */}
      <div className="bg-surface-container-low p-6 rounded-xl ghost-border space-y-3">
        <div className="flex items-center justify-between">
          <p className="text-sm font-bold text-on-surface-variant uppercase tracking-wider">{t("stats.speech")}</p>
          <p className={`text-sm font-black ${accuracyColor}`}>{avgScore}%</p>
        </div>
        <div className="h-3 w-full bg-surface-container-highest rounded-full overflow-hidden">
          <div
            className={`h-full rounded-full transition-all ${
              accuracy >= 85 ? "bg-gradient-to-r from-secondary-dim to-secondary"
              : accuracy >= 65 ? "bg-gradient-to-r from-primary-dim to-primary"
              : "bg-gradient-to-r from-tertiary-dim to-tertiary"
            }`}
            style={{ width: `${Math.max(accuracy, 1)}%` }}
          />
        </div>
        <p className="text-xs text-on-surface-variant">{accuracyText}</p>
      </div>

      {/* Motivational footer */}
      <div className="bg-primary/5 border border-primary/20 p-6 rounded-xl flex gap-4 items-center">
        <span className="material-symbols-outlined text-3xl text-primary">bolt</span>
        <div>
          <p className="font-bold text-on-surface">{motivationText}</p>
          <p className="text-sm text-on-surface-variant mt-1">
            {sessionsDone > 0
              ? `${t("stats.pace")} ~${Math.ceil((120 - blocksCompleted) * 3)} ${t("stats.pace_sessions")}.`
              : `${t("stats.pace")} 120 ${t("stats.pace_sessions")}.`}
          </p>
        </div>
      </div>
    </div>
  );
}
