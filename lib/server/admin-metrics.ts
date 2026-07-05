import { createAdminPbClient } from "@/lib/pocketbase/server";

export interface AdminMetrics {
  totalUsers: number;
  dau: number;
  mau: number;
  dauMauRatio: number;
  totalSessions: number;
  totalPhrases: number;
  avgAccuracy: number;
  avgSessionsPerWeek: number;
  retention: { d1: number; d7: number; d30: number };
  langPairs: { pair: string; users: number; pct: number }[];
  targetLangs: { lang: string; flag: string; pct: number }[];
  segments: { pct: number; color: string }[];
  isReal: boolean;
}

const LANG_LABELS: Record<string, { lang: string; flag: string }> = {
  "en":    { lang: "English",    flag: "🇺🇸" },
  "pt-BR": { lang: "Português",  flag: "🇧🇷" },
  "es":    { lang: "Español",    flag: "🇪🇸" },
  "fr":    { lang: "Français",   flag: "🇫🇷" },
  "de":    { lang: "Deutsch",    flag: "🇩🇪" },
  "it":    { lang: "Italiano",   flag: "🇮🇹" },
};

function langLabel(code: string) {
  return LANG_LABELS[code] ?? { lang: code, flag: "🌐" };
}

function pairLabel(source: string, target: string) {
  const s = LANG_LABELS[source]?.lang ?? source;
  const t = LANG_LABELS[target]?.lang ?? target;
  return `${s} → ${t}`;
}

function round1(n: number) {
  return Math.round(n * 10) / 10;
}

export async function getAdminMetrics(): Promise<AdminMetrics> {
  try {
    const pb = await createAdminPbClient();

    const today  = new Date().toISOString().slice(0, 10);
    const d30ago = new Date(Date.now() - 30 * 86_400_000).toISOString().slice(0, 10);

    // ── 1. Total users ──────────────────────────────────────────────────────
    const usersPage  = await pb.collection("users").getList(1, 1, { fields: "id" });
    const totalUsers = usersPage.totalItems;

    // ── 2. All user_progress records ────────────────────────────────────────
    const allProgress = await pb.collection("user_progress").getFullList({
      fields:
        "user_id,source_lang,target_lang,sessions_done,total_score_sum,total_phrases,last_session_date,created",
    });

    if (allProgress.length === 0) return zeroMetrics(totalUsers);

    // ── 3. DAU / MAU ────────────────────────────────────────────────────────
    const dauSet = new Set<string>();
    const mauSet = new Set<string>();
    for (const p of allProgress) {
      const d = p.last_session_date ? String(p.last_session_date).slice(0, 10) : null;
      if (!d) continue;
      if (d === today) dauSet.add(p.user_id);
      if (d >= d30ago) mauSet.add(p.user_id);
    }
    const dau         = dauSet.size;
    const mau         = mauSet.size;
    const dauMauRatio = mau > 0 ? round1((dau / mau) * 100) : 0;

    // ── 4. Aggregate totals ─────────────────────────────────────────────────
    let totalSessions = 0;
    let totalPhrases  = 0;
    let totalScoreSum = 0;
    for (const p of allProgress) {
      totalSessions += p.sessions_done   || 0;
      totalPhrases  += p.total_phrases   || 0;
      totalScoreSum += p.total_score_sum || 0;
    }
    // total_score_sum is stored as cumulative 0–1 per session → avg × 100 = %
    const avgAccuracy =
      totalSessions > 0 ? Math.round((totalScoreSum / totalSessions) * 100) : 0;

    // ── 5. Sessions per user per week ───────────────────────────────────────
    const userSessions  = new Map<string, number>();
    const userFirstDate = new Map<string, string>();
    for (const p of allProgress) {
      userSessions.set(p.user_id, (userSessions.get(p.user_id) ?? 0) + (p.sessions_done || 0));
      const cur = userFirstDate.get(p.user_id);
      if (!cur || String(p.created) < cur) userFirstDate.set(p.user_id, String(p.created));
    }
    let spwSum = 0, spwCount = 0;
    for (const [uid, sessions] of userSessions.entries()) {
      if (sessions === 0) continue;
      const firstDate   = userFirstDate.get(uid) ?? today;
      const weeksActive = Math.max(1, (Date.now() - new Date(firstDate).getTime()) / (7 * 86_400_000));
      spwSum += sessions / weeksActive;
      spwCount++;
    }
    const avgSessionsPerWeek = spwCount > 0 ? round1(spwSum / spwCount) : 0;

    // ── 6. Language pairs distribution ──────────────────────────────────────
    const pairCounts = new Map<string, number>();
    for (const p of allProgress) {
      const key = `${p.source_lang}||${p.target_lang}`;
      pairCounts.set(key, (pairCounts.get(key) ?? 0) + 1);
    }
    const totalEnrollments = allProgress.length;
    const sortedPairs      = [...pairCounts.entries()].sort((a, b) => b[1] - a[1]);
    const topPairs = sortedPairs.slice(0, 5).map(([key, count]) => {
      const [src, tgt] = key.split("||");
      return {
        pair:  pairLabel(src, tgt),
        users: count,
        pct:   Math.round((count / totalEnrollments) * 100),
      };
    });
    const otherCount = sortedPairs.slice(5).reduce((s, [, c]) => s + c, 0);
    if (otherCount > 0) {
      topPairs.push({
        pair:  "Outros pares",
        users: otherCount,
        pct:   Math.round((otherCount / totalEnrollments) * 100),
      });
    }
    // Clamp percentages to sum to 100
    const pctSum = topPairs.reduce((s, p) => s + p.pct, 0);
    if (pctSum !== 100 && topPairs.length > 0) topPairs[0].pct += 100 - pctSum;

    // ── 7. Target language distribution ─────────────────────────────────────
    const targetCounts = new Map<string, number>();
    for (const p of allProgress) {
      if (p.target_lang) targetCounts.set(p.target_lang, (targetCounts.get(p.target_lang) ?? 0) + 1);
    }
    const sortedTargets = [...targetCounts.entries()].sort((a, b) => b[1] - a[1]);
    const totalTargets  = sortedTargets.reduce((s, [, c]) => s + c, 0);
    const targetLangs   = sortedTargets.map(([code, count]) => ({
      ...langLabel(code),
      pct: Math.round((count / totalTargets) * 100),
    }));

    // ── 8. User segments ────────────────────────────────────────────────────
    let power = 0, regular = 0, casual = 0, risk = 0;
    for (const [uid, sessions] of userSessions.entries()) {
      const firstDate   = userFirstDate.get(uid) ?? today;
      const weeksActive = Math.max(1, (Date.now() - new Date(firstDate).getTime()) / (7 * 86_400_000));
      const spw         = sessions / weeksActive;
      if      (spw >= 7) power++;
      else if (spw >= 3) regular++;
      else if (spw >= 1) casual++;
      else               risk++;
    }
    const totalSeg = power + regular + casual + risk || 1;
    const segments = [
      { pct: Math.round((power   / totalSeg) * 100), color: "bg-primary"   },
      { pct: Math.round((regular / totalSeg) * 100), color: "bg-secondary" },
      { pct: Math.round((casual  / totalSeg) * 100), color: "bg-tertiary"  },
      { pct: Math.round((risk    / totalSeg) * 100), color: "bg-error"     },
    ];

    // ── 9. Retention (approximation from available aggregate data) ───────────
    // D1: % of users with sessions_done >= 2 (returned at least once)
    const usersWithSession = new Set(allProgress.filter(p => p.sessions_done >= 1).map(p => p.user_id));
    const usersWithReturn  = new Set(allProgress.filter(p => p.sessions_done >= 2).map(p => p.user_id));

    // D7/D30: % whose last_session_date span from first progress is >= N days
    const d7Set  = new Set<string>();
    const d30Set = new Set<string>();
    for (const [uid, firstDateStr] of userFirstDate.entries()) {
      if (!usersWithSession.has(uid)) continue;
      const lastDate = allProgress
        .filter(p => p.user_id === uid && p.last_session_date)
        .map(p => String(p.last_session_date).slice(0, 10))
        .sort()
        .at(-1);
      if (!lastDate) continue;
      const daysSpan =
        (new Date(lastDate).getTime() - new Date(String(firstDateStr).slice(0, 10)).getTime()) /
        86_400_000;
      if (daysSpan >= 7)  d7Set.add(uid);
      if (daysSpan >= 30) d30Set.add(uid);
    }

    const base    = usersWithSession.size || 1;
    const retention = {
      d1:  Math.min(99, Math.round((usersWithReturn.size / base) * 100)),
      d7:  Math.min(99, Math.round((d7Set.size          / base) * 100)),
      d30: Math.min(99, Math.round((d30Set.size         / base) * 100)),
    };

    return {
      totalUsers,
      dau,
      mau,
      dauMauRatio,
      totalSessions,
      totalPhrases,
      avgAccuracy,
      avgSessionsPerWeek,
      retention,
      langPairs: topPairs,
      targetLangs,
      segments,
      isReal: true,
    };
  } catch (err) {
    console.error("[AdminMetrics] Failed to fetch real metrics:", err);
    return zeroMetrics(0);
  }
}

function zeroMetrics(totalUsers: number): AdminMetrics {
  return {
    totalUsers,
    dau: 0, mau: 0, dauMauRatio: 0,
    totalSessions: 0, totalPhrases: 0, avgAccuracy: 0, avgSessionsPerWeek: 0,
    retention: { d1: 0, d7: 0, d30: 0 },
    langPairs: [], targetLangs: [], segments: [],
    isReal: true,
  };
}
