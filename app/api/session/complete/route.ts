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

    // ── Read current state ────────────────────────────────────────────────────
    // For authenticated users, PocketBase is the source of truth.
    // Cookies are only used as the source for anonymous (demo) users.
    const pbProgress = user ? await getPbProgress(user.id, user.token) : null;

    const sourceLang = pbProgress?.source_lang
      ?? cookieStore.get("ola_source_lang")?.value ?? "pt-BR";
    const targetLang = pbProgress?.target_lang
      ?? cookieStore.get("ola_target_lang")?.value ?? "en";

    const currentOrder = pbProgress?.block_order
      ?? parseInt(cookieStore.get("ola_current_block_order")?.value || "1", 10);
    const nextOrder = currentOrder + 1;

    const prevSessionsDone = pbProgress?.sessions_done
      ?? parseInt(cookieStore.get("ola_sessions_done")?.value || "0", 10);
    const prevTotalPhrases = pbProgress?.total_phrases
      ?? parseInt(cookieStore.get("ola_total_phrases")?.value || "0", 10);
    const prevTotalScoreSum = pbProgress?.total_score_sum
      ?? parseFloat(cookieStore.get("ola_total_score_sum")?.value || "0");
    const prevWordsRepeated = pbProgress?.words_repeated
      ?? parseInt(cookieStore.get("ola_words_repeated")?.value || "0", 10);

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
      : cookieStore.get("ola_last_session_date")?.value;
    const currentStreak = pbProgress?.streak_days
      ?? parseInt(cookieStore.get("ola_streak_days")?.value || "0", 10);

    let newStreak: number;
    if (!lastSessionDate)               newStreak = 1;
    else if (lastSessionDate === today)  newStreak = currentStreak;
    else if (lastSessionDate === yesterdayStr) newStreak = currentStreak + 1;
    else                                 newStreak = 1;

    // ── Daily blocks counter (Desafio 15) ─────────────────────────────────────
    const blocksTodayDate   = cookieStore.get("ola_blocks_today_date")?.value;
    const blocksTodayUserId = cookieStore.get("ola_blocks_today_user")?.value;
    const blocksOwnedByUser = user ? blocksTodayUserId === user.id : true;
    const blocksTodayRaw    = (blocksTodayDate === today && blocksOwnedByUser)
      ? parseInt(cookieStore.get("ola_blocks_today")?.value || "0", 10)
      : 0;
    const blocksTodayDone   = Math.min(blocksTodayRaw + 1, 3);

    // ── Cookie writes (always — keeps anonymous mode working + immediate UI) ──
    cookieStore.set("ola_source_lang",           sourceLang,                cookieOptions);
    cookieStore.set("ola_target_lang",           targetLang,                cookieOptions);
    cookieStore.set("ola_current_block_order",   nextOrder.toString(),      cookieOptions);
    cookieStore.set("ola_sessions_done",         sessionsDone.toString(),   cookieOptions);
    cookieStore.set("ola_total_phrases",         totalPhrases.toString(),   cookieOptions);
    cookieStore.set("ola_total_score_sum",       totalScoreSum.toString(),  cookieOptions);
    cookieStore.set("ola_words_repeated",        wordsRepeated.toString(),  cookieOptions);
    cookieStore.set("ola_last_session_date",     today,                     cookieOptions);
    cookieStore.set("ola_streak_days",           newStreak.toString(),      cookieOptions);
    cookieStore.set("ola_blocks_today",          blocksTodayDone.toString(), cookieOptions);
    cookieStore.set("ola_blocks_today_date",     today,                     cookieOptions);
    cookieStore.set("ola_progress_lang_pair",    `${sourceLang}→${targetLang}`, cookieOptions);
    if (user) cookieStore.set("ola_blocks_today_user", user.id,             cookieOptions);

    // ── PocketBase write (authenticated users only) ───────────────────────────
    if (user) {
      try {
        const pb = createPbClient(user.token);
        const progressData = {
          user_id:         user.id,
          source_lang:     sourceLang,
          target_lang:     targetLang,
          block_order:     nextOrder,
          sessions_done:   sessionsDone,
          total_phrases:   totalPhrases,
          total_score_sum: totalScoreSum,
          words_repeated:  wordsRepeated,
          streak_days:     newStreak,
          last_session_date: today,
          voice_gender:    cookieStore.get("ola_voice_gender")?.value || "female",
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
