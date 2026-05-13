import { NextResponse } from "next/server";
import { cookies } from "next/headers";
import { markSessionDone } from "@/lib/push/store";
import { requireUser } from "@/lib/server/auth";
import wordRepetitionsData from "@/lib/data/word-repetitions.json";

export async function POST(request: Request) {
  try {
    const user = await requireUser();
    const { score = 0, phrasesCount = 0 } = await request.json().catch(() => ({}));
    const cookieStore = await cookies();
    
    // 1. Update Block Order
    const currentOrderStr = cookieStore.get("ola_current_block_order")?.value;
    const currentOrder = currentOrderStr ? parseInt(currentOrderStr, 10) : 1;
    const nextOrder = currentOrder + 1;
    
    // 2. Update Stats
    const sessionsDone = parseInt(cookieStore.get("ola_sessions_done")?.value || "0", 10) + 1;
    const totalPhrases = parseInt(cookieStore.get("ola_total_phrases")?.value || "0", 10) + phrasesCount;
    const totalScoreSum = parseFloat(cookieStore.get("ola_total_score_sum")?.value || "0") + score;

    // Words repeated = real count from linguistic analysis of the curriculum
    const blockData = (wordRepetitionsData as { blockOrder: number; blockRepetitions: number }[])
      .find(b => b.blockOrder === currentOrder);
    const blockRepetitionCount = blockData?.blockRepetitions ?? 13;
    const wordsRepeated = parseInt(cookieStore.get("ola_words_repeated")?.value || "0", 10) + blockRepetitionCount;

    const cookieOptions = {
      path: "/",
      maxAge: 60 * 60 * 24 * 365, // 1 year
      sameSite: "lax" as const,
    };

    cookieStore.set("ola_current_block_order", nextOrder.toString(), cookieOptions);
    cookieStore.set("ola_sessions_done", sessionsDone.toString(), cookieOptions);
    cookieStore.set("ola_total_phrases", totalPhrases.toString(), cookieOptions);
    cookieStore.set("ola_total_score_sum", totalScoreSum.toString(), cookieOptions);
    cookieStore.set("ola_words_repeated", wordsRepeated.toString(), cookieOptions);

    // ── Streak calculation ──────────────────────────────────────────────────
    const today = new Date().toISOString().slice(0, 10);
    const yesterday = new Date();
    yesterday.setDate(yesterday.getDate() - 1);
    const yesterdayStr = yesterday.toISOString().slice(0, 10);

    const lastSessionDate = cookieStore.get("ola_last_session_date")?.value;
    const currentStreak   = parseInt(cookieStore.get("ola_streak_days")?.value || "0", 10);

    let newStreak: number;
    if (!lastSessionDate) {
      newStreak = 1;                                    // first session ever
    } else if (lastSessionDate === today) {
      newStreak = currentStreak;                        // already trained today — no change
    } else if (lastSessionDate === yesterdayStr) {
      newStreak = currentStreak + 1;                    // consecutive day!
    } else {
      newStreak = 1;                                    // gap > 1 day — streak broken, restart
    }

    cookieStore.set("ola_last_session_date", today, cookieOptions);
    cookieStore.set("ola_streak_days", newStreak.toString(), cookieOptions);

    // Mark today as a training day so the push cron skips this user
    markSessionDone(user.id);

    return NextResponse.json({ 
      ok: true, 
      currentBlockOrder: nextOrder,
      stats: { sessionsDone, totalPhrases, avgScore: Math.round(totalScoreSum / sessionsDone) }
    });
  } catch (error: any) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }
}
