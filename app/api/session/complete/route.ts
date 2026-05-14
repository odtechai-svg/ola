import { NextResponse } from "next/server";
import { cookies } from "next/headers";
import { markSessionDone } from "@/lib/push/store";
import { getCurrentUser } from "@/lib/server/auth";
import { createPbClient } from "@/lib/pocketbase/server";
import wordRepetitionsData from "@/lib/data/word-repetitions.json";

export async function POST(request: Request) {
  try {
    const user = await getCurrentUser();
    const { score = 0, phrasesCount = 0 } = await request.json().catch(() => ({}));
    const cookieStore = await cookies();

    const cookieOptions = { path: "/", maxAge: 60 * 60 * 24 * 365, sameSite: "lax" as const };

    // ── Block Order ────────────────────────────────────────────────────────
    const currentOrderStr = cookieStore.get("ola_current_block_order")?.value;
    const currentOrder = currentOrderStr ? parseInt(currentOrderStr, 10) : 1;
    const nextOrder = currentOrder + 1;

    // ── Stats ──────────────────────────────────────────────────────────────
    const sessionsDone = parseInt(cookieStore.get("ola_sessions_done")?.value || "0", 10) + 1;
    const totalPhrases = parseInt(cookieStore.get("ola_total_phrases")?.value || "0", 10) + phrasesCount;
    const totalScoreSum = parseFloat(cookieStore.get("ola_total_score_sum")?.value || "0") + score;

    const blockData = (wordRepetitionsData as { blockOrder: number; blockRepetitions: number }[])
      .find((b) => b.blockOrder === currentOrder);
    const blockRepetitionCount = blockData?.blockRepetitions ?? 13;
    const wordsRepeated = parseInt(cookieStore.get("ola_words_repeated")?.value || "0", 10) + blockRepetitionCount;

    // ── Streak ─────────────────────────────────────────────────────────────
    const today = new Date().toISOString().slice(0, 10);
    const yesterday = new Date();
    yesterday.setDate(yesterday.getDate() - 1);
    const yesterdayStr = yesterday.toISOString().slice(0, 10);

    const lastSessionDate = cookieStore.get("ola_last_session_date")?.value;
    const currentStreak = parseInt(cookieStore.get("ola_streak_days")?.value || "0", 10);

    let newStreak: number;
    if (!lastSessionDate) {
      newStreak = 1;
    } else if (lastSessionDate === today) {
      newStreak = currentStreak;
    } else if (lastSessionDate === yesterdayStr) {
      newStreak = currentStreak + 1;
    } else {
      newStreak = 1;
    }

    // ── Daily Blocks Counter (Desafio 15) ──────────────────────────────────
    const blocksTodayDate = cookieStore.get("ola_blocks_today_date")?.value;
    const blocksTodayRaw = parseInt(cookieStore.get("ola_blocks_today")?.value || "0", 10);
    const blocksTodayDone = blocksTodayDate === today ? Math.min(blocksTodayRaw + 1, 3) : 1;

    // ── Cookie writes (always, for demo mode + cache) ──────────────────────
    cookieStore.set("ola_current_block_order", nextOrder.toString(), cookieOptions);
    cookieStore.set("ola_sessions_done", sessionsDone.toString(), cookieOptions);
    cookieStore.set("ola_total_phrases", totalPhrases.toString(), cookieOptions);
    cookieStore.set("ola_total_score_sum", totalScoreSum.toString(), cookieOptions);
    cookieStore.set("ola_words_repeated", wordsRepeated.toString(), cookieOptions);
    cookieStore.set("ola_last_session_date", today, cookieOptions);
    cookieStore.set("ola_streak_days", newStreak.toString(), cookieOptions);
    cookieStore.set("ola_blocks_today", blocksTodayDone.toString(), cookieOptions);
    cookieStore.set("ola_blocks_today_date", today, cookieOptions);

    // ── PocketBase write (real users only) ─────────────────────────────────
    if (user) {
      try {
        const pb = createPbClient(user.token);
        const existing = await pb
          .collection("user_progress")
          .getList(1, 1, { filter: `user_id = "${user.id}"` })
          .catch(() => ({ items: [] as any[] }));

        const progressData = {
          user_id: user.id,
          block_order: nextOrder,
          sessions_done: sessionsDone,
          total_phrases: totalPhrases,
          total_score_sum: totalScoreSum,
          words_repeated: wordsRepeated,
          streak_days: newStreak,
          last_session_date: today,
          source_lang: cookieStore.get("ola_source_lang")?.value || "pt-BR",
          target_lang: cookieStore.get("ola_target_lang")?.value || "en",
          voice_gender: cookieStore.get("ola_voice_gender")?.value || "female",
        };

        if (existing.items.length > 0) {
          await pb.collection("user_progress").update(existing.items[0].id, progressData);
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
      stats: { sessionsDone, totalPhrases, avgScore: Math.round((totalScoreSum / sessionsDone) * 100) },
    });
  } catch (error: any) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }
}
