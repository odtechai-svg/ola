import { cookies } from "next/headers";
import { Shell } from "@/components/layout/shell";
import { requireUser } from "@/lib/server/auth";

async function getUserStats() {
  const cookieStore = await cookies();
  const sessionsDone  = parseInt(cookieStore.get("ola_sessions_done")?.value  || "0", 10);
  const totalPhrases  = parseInt(cookieStore.get("ola_total_phrases")?.value  || "0", 10);
  const totalScoreSum = parseFloat(cookieStore.get("ola_total_score_sum")?.value || "0");
  const blockOrder    = parseInt(cookieStore.get("ola_current_block_order")?.value || "1", 10);
  const sourceLang    = cookieStore.get("ola_source_lang")?.value  || "pt-BR";
  const targetLang    = cookieStore.get("ola_target_lang")?.value  || "en";
  const displayName   = cookieStore.get("ola_display_name")?.value || "Learner";

  const avgScore = sessionsDone > 0 ? Math.round((totalScoreSum / sessionsDone) * 100) : 0;
  const blocksCompleted = Math.max(0, blockOrder - 1);
  const wordsLearned = blocksCompleted * 8 + (sessionsDone * 3);
  const minutesTrained = sessionsDone * 15;

  return { sessionsDone, totalPhrases, avgScore, blockOrder, blocksCompleted, sourceLang, targetLang, displayName, wordsLearned, minutesTrained };
}

export default async function StatsPage() {
  await requireUser();
  const s = await getUserStats();

  const accuracy = s.avgScore;
  const accuracyColor = accuracy >= 85 ? "text-secondary" : accuracy >= 65 ? "text-primary" : "text-tertiary";

  const topCards = [
    { icon: "event_available",   label: "Sessions Done",       value: s.sessionsDone,    unit: "",    color: "primary"   },
    { icon: "forum",             label: "Phrases Practiced",   value: s.totalPhrases,    unit: "",    color: "secondary" },
    { icon: "workspace_premium", label: "Accuracy Score",      value: `${s.avgScore}%`,  unit: "",    color: "tertiary"  },
    { icon: "dictionary",        label: "Words Learned",       value: s.wordsLearned,    unit: "",    color: "primary"   },
    { icon: "timer",             label: "Minutes Trained",     value: s.minutesTrained,  unit: "min", color: "secondary" },
    { icon: "check_circle",      label: "Blocks Completed",    value: s.blocksCompleted, unit: "",    color: "tertiary"  },
  ];

  const blockPct = Math.min(100, Math.round((s.blocksCompleted / 120) * 100));
  const accuracyPct = s.avgScore;

  return (
    <Shell>
      <div className="mx-auto max-w-3xl space-y-8">
        {/* Header */}
        <div>
          <span className="text-primary font-bold uppercase tracking-[0.2em] text-sm">Analytics</span>
          <h1 className="mt-2 text-4xl md:text-5xl font-black tracking-tight text-on-surface">
            My Journey
          </h1>
          <p className="mt-3 text-on-surface-variant text-sm">
            Your personal progress with{" "}
            <span className="font-bold text-on-surface">{s.sourceLang} → {s.targetLang}</span>
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
            <p className="text-sm font-bold text-on-surface-variant uppercase tracking-wider">Curriculum Progress</p>
            <p className="text-sm font-black text-primary">{s.blocksCompleted} / 120 blocks</p>
          </div>
          <div className="h-3 w-full bg-surface-container-highest rounded-full overflow-hidden">
            <div
              className="h-full bg-gradient-to-r from-primary-dim to-primary rounded-full transition-all"
              style={{ width: `${Math.max(blockPct, 1)}%` }}
            />
          </div>
          <p className="text-xs text-on-surface-variant">{blockPct}% of the full curriculum complete</p>
        </div>

        {/* Accuracy bar */}
        <div className="bg-surface-container-low p-6 rounded-xl ghost-border space-y-3">
          <div className="flex items-center justify-between">
            <p className="text-sm font-bold text-on-surface-variant uppercase tracking-wider">Speech Accuracy</p>
            <p className={`text-sm font-black ${accuracyColor}`}>{s.avgScore}%</p>
          </div>
          <div className="h-3 w-full bg-surface-container-highest rounded-full overflow-hidden">
            <div
              className={`h-full rounded-full transition-all ${
                accuracy >= 85 ? "bg-gradient-to-r from-secondary-dim to-secondary"
                : accuracy >= 65 ? "bg-gradient-to-r from-primary-dim to-primary"
                : "bg-gradient-to-r from-tertiary-dim to-tertiary"
              }`}
              style={{ width: `${Math.max(accuracyPct, 1)}%` }}
            />
          </div>
          <p className="text-xs text-on-surface-variant">
            {accuracy >= 85 ? "Excellent — native-level pronunciation precision" : accuracy >= 65 ? "Good — keep practicing for a stronger accent" : "Keep going — consistency builds fluency"}
          </p>
        </div>

        {/* Motivational footer */}
        <div className="bg-primary/5 border border-primary/20 p-6 rounded-xl flex gap-4 items-center">
          <span className="material-symbols-outlined text-3xl text-primary">bolt</span>
          <div>
            <p className="font-bold text-on-surface">
              {s.sessionsDone === 0
                ? "Start your first session to build your stats!"
                : s.sessionsDone < 5
                ? `${s.sessionsDone} sessions in — you're just getting started. Keep going!`
                : s.sessionsDone < 20
                ? `${s.sessionsDone} sessions strong. The habit is forming.`
                : `${s.sessionsDone} sessions completed. You're a cognitive athlete.`}
            </p>
            <p className="text-sm text-on-surface-variant mt-1">
              At this pace you'll complete the full curriculum in {s.sessionsDone > 0 ? `~${Math.ceil((120 - s.blocksCompleted) * 3)} sessions` : "120 sessions (15 min/day)"}.
            </p>
          </div>
        </div>
      </div>
    </Shell>
  );
}
