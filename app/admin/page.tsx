import { redirect } from "next/navigation";
import { cookies } from "next/headers";
import { Shell } from "@/components/layout/shell";
import { requireUser } from "@/lib/server/auth";
import { AdminPushButton } from "@/components/admin/AdminPushButton";
import { makeAdminT } from "@/lib/i18n/admin-dict";
import { getAdminMetrics } from "@/lib/server/admin-metrics";

function StatCard({ icon, label, value, sub, highlight = false }: {
  icon: string; label: string; value: string | number; sub?: string; highlight?: boolean;
}) {
  return (
    <div className={`p-5 rounded-xl ghost-border flex flex-col gap-1 ${highlight ? "bg-primary/8 border-primary/30" : "bg-surface-container-low"}`}>
      <span className="material-symbols-outlined text-xl text-primary">{icon}</span>
      <p className="text-3xl font-black text-on-surface mt-1">{value}</p>
      <p className="text-xs font-bold text-on-surface-variant uppercase tracking-wider leading-tight">{label}</p>
      {sub && <p className="text-xs text-on-surface-variant/70 mt-0.5">{sub}</p>}
    </div>
  );
}

function Bar({ pct, color = "bg-primary" }: { pct: number; color?: string }) {
  return (
    <div className="h-2 w-full bg-surface-container-highest rounded-full overflow-hidden">
      <div className={`h-full ${color} rounded-full`} style={{ width: `${pct}%` }} />
    </div>
  );
}

export default async function AdminPage() {
  let user;
  try {
    user = await requireUser();
  } catch (e) {
    redirect("/auth/login");
  }

  const adminEmail = process.env.PB_ADMIN_EMAIL || "odtechai@gmail.com";
  if (!user.email || user.email !== adminEmail) redirect("/home");

  const cookieStore = await cookies();
  const sourceLang = cookieStore.get("ola_source_lang")?.value || "pt-BR";
  const t = makeAdminT(sourceLang);

  const month = new Date().toLocaleDateString("pt-BR", { month: "long", year: "numeric" });

  // ── Fetch real metrics from PocketBase ──────────────────────────────────
  const metrics = await getAdminMetrics();

  const segments = [
    { label: t("seg_power"),   desc: t("seg_power_d"),   pct: metrics.segments[0]?.pct ?? 0, color: "bg-primary"   },
    { label: t("seg_regular"), desc: t("seg_regular_d"), pct: metrics.segments[1]?.pct ?? 0, color: "bg-secondary" },
    { label: t("seg_casual"),  desc: t("seg_casual_d"),  pct: metrics.segments[2]?.pct ?? 0, color: "bg-tertiary"  },
    { label: t("seg_risk"),    desc: t("seg_risk_d"),    pct: metrics.segments[3]?.pct ?? 0, color: "bg-error"     },
  ];

  return (
    <Shell isAdmin={true}>
      <div className="mx-auto max-w-4xl space-y-10">

        {/* Header */}
        <div className="flex items-start justify-between gap-4 flex-wrap">
          <div>
            <span className="text-primary font-bold uppercase tracking-[0.2em] text-sm">{t("label")}</span>
            <h1 className="mt-2 text-4xl md:text-5xl font-black tracking-tight text-on-surface">{t("title")}</h1>
            <p className="mt-2 text-on-surface-variant text-sm">{t("subtitle")} · {month}</p>
          </div>
          <div className="bg-secondary/10 border border-secondary/30 px-4 py-2 rounded-full flex items-center gap-2 shrink-0">
            <span className="w-2 h-2 rounded-full bg-secondary animate-pulse" />
            <span className="text-secondary font-bold text-sm">{t("live")}</span>
          </div>
        </div>

        {/* Core KPIs */}
        <div>
          <p className="text-xs font-bold text-on-surface-variant uppercase tracking-widest mb-3">{t("core_metrics")}</p>
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            <StatCard icon="group"          label={t("total_users")} value={metrics.totalUsers.toLocaleString("pt-BR")} highlight />
            <StatCard icon="today"          label={t("dau")}         value={metrics.dau}      sub={t("dau_sub")} />
            <StatCard icon="calendar_month" label={t("mau")}         value={metrics.mau}      sub={t("mau_sub")} />
            <StatCard icon="speed"          label={t("dau_mau")}     value={`${metrics.dauMauRatio}%`} sub={t("dau_mau_sub")} />
          </div>
        </div>

        {/* Usage & Engagement */}
        <div>
          <p className="text-xs font-bold text-on-surface-variant uppercase tracking-widest mb-3">{t("usage")}</p>
          <div className="grid grid-cols-2 md:grid-cols-3 gap-4">
            <StatCard icon="event_available"   label={t("sessions")}      value={metrics.totalSessions.toLocaleString("pt-BR")} />
            <StatCard icon="forum"             label={t("phrases")}       value={metrics.totalPhrases.toLocaleString("pt-BR")} />
            <StatCard icon="timer"             label={t("avg_session")}   value="~15 min" sub={t("session_target")} />
            <StatCard icon="repeat"            label={t("sessions_week")} value={metrics.avgSessionsPerWeek} sub={t("habit_zone")} />
            <StatCard icon="workspace_premium" label={t("avg_accuracy")}  value={`${metrics.avgAccuracy}%`}  sub={t("speech_rec")} />
            <StatCard icon="recommend"         label="Engajamento"        value={`${metrics.dauMauRatio}%`}  sub="DAU/MAU" highlight />
          </div>
        </div>

        {/* Retention */}
        <div className="bg-surface-container-low p-6 rounded-xl ghost-border space-y-5">
          <div>
            <p className="text-xs font-bold text-on-surface-variant uppercase tracking-widest">{t("retention")}</p>
            <p className="text-sm text-on-surface-variant mt-1">{t("retention_desc")}</p>
          </div>
          {[
            { label: t("d1"),  pct: metrics.retention.d1,  benchmark: 60 },
            { label: t("d7"),  pct: metrics.retention.d7,  benchmark: 30 },
            { label: t("d30"), pct: metrics.retention.d30, benchmark: 15 },
          ].map(({ label, pct, benchmark }) => (
            <div key={label} className="space-y-1.5">
              <div className="flex items-center justify-between text-sm">
                <span className="font-bold text-on-surface">{label}</span>
                <span className={`font-black ${pct >= benchmark ? "text-secondary" : "text-tertiary"}`}>{pct}%</span>
              </div>
              <div className="relative h-2.5 w-full bg-surface-container-highest rounded-full overflow-hidden">
                <div className="h-full bg-primary/20 rounded-full" style={{ width: `${benchmark}%` }} />
                <div className={`absolute top-0 left-0 h-full rounded-full ${pct >= benchmark ? "bg-secondary" : "bg-primary"}`}
                  style={{ width: `${Math.min(pct, 100)}%` }} />
              </div>
              <p className="text-xs text-on-surface-variant">
                {t("benchmark")}: {benchmark}% — OLA está {pct >= benchmark ? t("above") : t("below")} benchmark
              </p>
            </div>
          ))}
        </div>

        {/* Language pairs */}
        {metrics.langPairs.length > 0 && (
          <div className="bg-surface-container-low p-6 rounded-xl ghost-border space-y-4">
            <div>
              <p className="text-xs font-bold text-on-surface-variant uppercase tracking-widest">{t("lang_pairs")}</p>
              <p className="text-sm text-on-surface-variant mt-1">{t("lang_pairs_desc")}</p>
            </div>
            <div className="space-y-3">
              {metrics.langPairs.map(({ pair, pct, users }) => (
                <div key={pair} className="space-y-1">
                  <div className="flex items-center justify-between text-sm">
                    <span className="font-bold text-on-surface">{pair}</span>
                    <span className="text-on-surface-variant font-medium">
                      {users.toLocaleString("pt-BR")} {t("users")} · <span className="text-primary font-black">{pct}%</span>
                    </span>
                  </div>
                  <Bar pct={Math.min(pct * 2, 100)} />
                </div>
              ))}
            </div>
          </div>
        )}

        {/* Most studied target languages */}
        {metrics.targetLangs.length > 0 && (
          <div className="bg-surface-container-low p-6 rounded-xl ghost-border space-y-4">
            <p className="text-xs font-bold text-on-surface-variant uppercase tracking-widest">{t("target_langs")}</p>
            <div className="flex flex-wrap gap-3">
              {metrics.targetLangs.map(({ lang, pct, flag }) => (
                <div key={lang} className="flex-1 min-w-[100px] bg-surface-container p-4 rounded-xl text-center">
                  <p className="text-3xl">{flag}</p>
                  <p className="font-black text-on-surface mt-2">{pct}%</p>
                  <p className="text-xs text-on-surface-variant mt-0.5">{lang}</p>
                </div>
              ))}
            </div>
          </div>
        )}

        {/* User segments */}
        <div className="bg-surface-container-low p-6 rounded-xl ghost-border space-y-4">
          <div>
            <p className="text-xs font-bold text-on-surface-variant uppercase tracking-widest">{t("segments")}</p>
            <p className="text-sm text-on-surface-variant mt-1">{t("segments_desc")}</p>
          </div>
          <div className="space-y-3">
            {segments.map(({ label, desc, pct, color }) => (
              <div key={label} className="space-y-1">
                <div className="flex items-center justify-between text-sm">
                  <div>
                    <span className="font-bold text-on-surface">{label}</span>
                    <span className="text-on-surface-variant ml-2 text-xs">({desc})</span>
                  </div>
                  <span className="font-black text-on-surface">{pct}%</span>
                </div>
                <div className="h-2.5 w-full bg-surface-container-highest rounded-full overflow-hidden">
                  <div className={`h-full ${color} rounded-full opacity-80`} style={{ width: `${Math.min(pct * 2.2, 100)}%` }} />
                </div>
              </div>
            ))}
          </div>
          <p className="text-xs text-on-surface-variant pt-2 border-t border-outline-variant/10">{t("seg_footer")}</p>
        </div>

        {/* Investment Case */}
        <div className="bg-gradient-to-br from-primary/8 to-secondary/8 border border-primary/20 p-8 rounded-xl space-y-4">
          <div className="flex items-center gap-3">
            <span className="material-symbols-outlined text-primary text-2xl">trending_up</span>
            <p className="font-black text-on-surface text-lg">{t("investment")}</p>
          </div>
          <div className="grid md:grid-cols-3 gap-4">
            {[
              { stat: metrics.totalUsers.toLocaleString("pt-BR"), label: t("inv1_label"), sub: t("inv1_sub") },
              { stat: `${metrics.avgSessionsPerWeek}×`,           label: t("inv2_label"), sub: t("inv2_sub") },
              { stat: `${metrics.avgAccuracy}%`,                  label: "Precisão Média", sub: "Reconhecimento de fala" },
            ].map(({ stat, label, sub }) => (
              <div key={label} className="text-center">
                <p className="text-4xl font-black text-primary">{stat}</p>
                <p className="font-bold text-on-surface mt-1 text-sm">{label}</p>
                <p className="text-xs text-on-surface-variant mt-0.5">{sub}</p>
              </div>
            ))}
          </div>
          <p className="text-sm text-on-surface-variant border-t border-outline-variant/10 pt-4">{t("inv_body")}</p>
        </div>

        {/* Push broadcast */}
        <div className="bg-surface-container-low p-6 rounded-xl ghost-border space-y-5">
          <div className="flex items-start justify-between gap-4 flex-wrap">
            <div className="flex items-center gap-3">
              <span className="material-symbols-outlined text-primary">campaign</span>
              <div>
                <p className="font-bold text-on-surface">{t("push_title")}</p>
                <p className="text-xs text-on-surface-variant mt-0.5">{t("push_desc")}</p>
              </div>
            </div>
            <div className="flex items-center gap-2 bg-secondary/10 border border-secondary/20 px-3 py-1.5 rounded-full shrink-0">
              <span className="material-symbols-outlined text-secondary text-sm">schedule</span>
              <span className="text-secondary text-xs font-bold">{t("push_auto_time")}</span>
            </div>
          </div>
          <div className="grid md:grid-cols-2 gap-3 p-4 bg-surface-container rounded-xl">
            <div>
              <p className="text-xs font-bold text-on-surface-variant uppercase tracking-wider">{t("push_auto")}</p>
              <p className="text-sm text-on-surface mt-1">{t("push_auto_time")}</p>
              <p className="text-xs text-on-surface-variant mt-1">{t("push_auto_sub")}</p>
            </div>
            <div>
              <p className="text-xs font-bold text-on-surface-variant uppercase tracking-wider">{t("push_manual")}</p>
              <code className="text-xs text-primary mt-1 block break-all">/api/push/daily-reminder?secret=ola-cron-2026</code>
            </div>
          </div>
          <AdminPushButton />
        </div>

        <div className="flex items-center gap-2 text-xs text-on-surface-variant pb-4">
          <span className="material-symbols-outlined text-sm">database</span>
          <span>Métricas em tempo real do banco de dados PocketBase · Duração de sessão e NPS são estimativas.</span>
        </div>
      </div>
    </Shell>
  );
}

