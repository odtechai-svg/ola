import { NextResponse } from "next/server";
import { cookies } from "next/headers";
import { markSessionDone } from "@/lib/push/store";
import { getCurrentUser } from "@/lib/server/auth";
import { createPbClient } from "@/lib/pocketbase/server";
import { getPbProgressForPair } from "@/lib/server/queries";
import wordRepetitionsData from "@/lib/data/word-repetitions.json";

export async function POST(request: Request) {
  try {
    const user = await getCurrentUser();
    const { score = 0, phrasesCount = 0, blockOrder } = await request.json().catch(() => ({}));
    const cookieStore = await cookies();
    const cookieOptions = { path: "/", maxAge: 60 * 60 * 24 * 365, sameSite: "lax" as const };

    // Language pair comes from cookies — these are always set at login (synced
    // from PB) and at onboarding. Using them here ensures we read and write the
    // correct PB record even when the user has progress in multiple languages.
    const sourceLang = cookieStore.get("ola_source_lang")?.value ?? "pt-BR";
    const targetLang = cookieStore.get("ola_target_lang")?.value ?? "en";

    // Fetch the exact record for this language pair
    const pbProgress = user
      ? await getPbProgressForPair(user.id, user.token, sourceLang, targetLang)
      : null;

    // Progress counters — default to 0 for a brand new language pair
    const currentOrder      = pbProgress?.block_order     ?? 1;
    const prevSessionsDone  = pbProgress?.sessions_done   ?? 0;
    const prevTotalPhrases  = pbProgress?.total_phrases   ?? 0;
    const prevTotalScoreSum = pbProgress?.total_score_sum ?? 0;
    const prevWordsRepeated = pbProgress?.words_repeated  ?? 0;

    // Advance block order only if they completed their current or a newer block.
    // Repeating older blocks should increment sessions/phrases but NOT advance curriculum progress.
    let nextOrder = currentOrder;
    if (blockOrder === undefined || blockOrder === null || blockOrder >= currentOrder) {
      nextOrder = currentOrder + 1;
    }

    const sessionsDone  = prevSessionsDone + 1;
    const totalPhrases  = prevTotalPhrases + phrasesCount;
    const totalScoreSum = prevTotalScoreSum + score;

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
    if (!lastSessionDate)                     newStreak = 1;
    else if (lastSessionDate === today)        newStreak = currentStreak;
    else if (lastSessionDate === yesterdayStr) newStreak = currentStreak + 1;
    else                                       newStreak = 1;

    // ── Daily blocks counter (Desafio 15) ─────────────────────────────────────
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
          last_session_date:   new Date().toISOString(),
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
