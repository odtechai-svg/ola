import { NextResponse } from "next/server";
import { cookies } from "next/headers";
import { markSessionDone } from "@/lib/push/store";
import { getCurrentUser } from "@/lib/server/auth";
import { createPbClient } from "@/lib/pocketbase/server";
import { getPbProgress } from "@/lib/server/queries";
import wordRepetitionsData from "@/lib/data/word-repetitions.json";

export async function POST(request: Request) {
  try {
    const user = await getCurrentUser();
    const { score = 0, phrasesCount = 0 } = await request.json().catch(() => ({}));
    const cookieStore = await cookies();
    const cookieOptions = { path: "/", maxAge: 60 * 60 * 24 * 365, sameSite: "lax" as const };

    // ── Read current state from PocketBase ────────────────────────────────────
    const pbProgress = user ? await getPbProgress(user.id, user.token) : null;

    // Language pair: PB record first, then onboarding cookies (first session only)
    const sourceLang = pbProgress?.source_lang
      ?? cookieStore.get("ola_source_lang")?.value ?? "pt-BR";
    const targetLang = pbProgress?.target_lang
      ?? cookieStore.get("ola_target_lang")?.value ?? "en";

    // Progress counters default to 0 when there is no PB record yet (first session)
    const currentOrder      = pbProgress?.block_order     ?? 1;
    const prevSessionsDone  = pbProgress?.sessions_done   ?? 0;
    const prevTotalPhrases  = pbProgress?.total_phrases   ?? 0;
    const prevTotalScoreSum = pbProgress?.total_score_sum ?? 0;
    const prevWordsRepeated = pbProgress?.words_repeated  ?? 0;

    const nextOrder      = currentOrder + 1;
    const sessionsDone   = prevSessionsDone + 1;
    const totalPhrases   = prevTotalPhrases + phrasesCount;
    const totalScoreSum  = prevTotalScoreSum + score;

    const blockData = (wordRepetitionsData as { blockOrder: number; blockRepetitions: number }[])
      .find((b) => b.blockOrder === currentOrder);
    const wordsRepeated = prevWordsRepeated + (blockData?.blockRepetitions ?? 13);

    // ── Streak ────────────────────────────────────────────────────────────────
    const today = new Date().toISOString().slice(0, 10);
    const yesterday = new Date();
    yesterday.setDate(yesterday.getDate() - 1);
    const yesterdayStr = yesterday.toISOString().slice(0, 10);

    const lastSessionDate = pbProgress?.last_session_date
      ? String(pbProgress.last_session_date).slice(0, 10)
      : undefined;
    const currentStreak = pbProgress?.streak_days ?? 0;

    let newStreak: number;
    if (!lastSessionDate)                    newStreak = 1;
    else if (lastSessionDate === today)       newStreak = currentStreak;
    else if (lastSessionDate === yesterdayStr) newStreak = currentStreak + 1;
    else                                      newStreak = 1;

    // ── Daily blocks counter (Desafio 15) — read from PB so it's cross-device ─
    const pbBlocksTodayDate  = pbProgress?.blocks_today_date
      ? String(pbProgress.blocks_today_date).slice(0, 10)
      : undefined;
    const pbBlocksTodayCount = pbProgress?.blocks_today_count ?? 0;
    const prevBlocksToday    = pbBlocksTodayDate === today ? pbBlocksTodayCount : 0;
    const blocksTodayDone    = Math.min(prevBlocksToday + 1, 3);

    // ── PocketBase write ──────────────────────────────────────────────────────
    if (user) {
      try {
        const pb = createPbClient(user.token);
        const progressData = {
          user_id:             user.id,
          source_lang:         sourceLang,
          target_lang:         targetLang,
          block_order:         nextOrder,
          sessions_done:       sessionsDone,
          total_phrases:       totalPhrases,
          total_score_sum:     totalScoreSum,
          words_repeated:      wordsRepeated,
          streak_days:         newStreak,
          last_session_date:   today,
          blocks_today_count:  blocksTodayDone,
          blocks_today_date:   today,
          voice_gender:        cookieStore.get("ola_voice_gender")?.value || "female",
        };

        if (pbProgress) {
          await pb.collection("user_progress").update(pbProgress.id, progressData);
        } else {
          await pb.collection("user_progress").create(progressData);
        }

        await markSessionDone(user.id, user.token);
      } catch (e) {
        console.error("[OLA] PocketBase write failed:", e);
      }
    }

    // ── Cookie writes (lang sync only — blocks_today now lives in PB) ──────────
    cookieStore.set("ola_source_lang", sourceLang, cookieOptions);
    cookieStore.set("ola_target_lang", targetLang, cookieOptions);

    return NextResponse.json({
      ok: true,
      currentBlockOrder: nextOrder,
      blocksTodayDone,
      stats: {
        sessionsDone,
        totalPhrases,
        avgScore: Math.round((totalScoreSum / sessionsDone) * 100),
      },
    });
  } catch (error: any) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }
}
