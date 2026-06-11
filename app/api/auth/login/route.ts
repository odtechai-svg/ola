import { NextResponse } from "next/server";
import { cookies } from "next/headers";
import { createPbClient } from "@/lib/pocketbase/server";

const COOKIE_OPTS = {
  httpOnly: true,
  sameSite: "lax" as const,
  path: "/",
  maxAge: 60 * 60 * 24 * 30, // 30 days
};

const YEAR = { httpOnly: true, sameSite: "lax" as const, path: "/", maxAge: 60 * 60 * 24 * 365 };

export async function POST(request: Request) {
  const { email, password } = await request.json();
  const pb = createPbClient();

  try {
    const auth = await pb.collection("users").authWithPassword(email, password);
    const cookieStore = await cookies();
    cookieStore.set("pb_auth", auth.token, COOKIE_OPTS);
    cookieStore.set("pb_user_id", auth.record.id, COOKIE_OPTS);
    cookieStore.set("pb_user_email", auth.record.email || "", COOKIE_OPTS);
    cookieStore.set("ola_display_name", (auth.record as any).name || "", COOKIE_OPTS);

    // Restore all progress from PocketBase — no lang-pair filter so a new
    // device always recovers the correct language pair from the most recent record.
    try {
      const pbAuth = createPbClient(auth.token);
      const progressResult = await pbAuth.collection("user_progress").getList(1, 1, {
        filter: `user_id = "${auth.record.id}"`,
        sort: "-updated",
      });
      const progress = progressResult.items[0];
      if (progress) {
        const restoredSource = progress.source_lang || "pt-BR";
        const restoredTarget = progress.target_lang || "en";
        cookieStore.set("ola_source_lang",         restoredSource, YEAR);
        cookieStore.set("ola_target_lang",         restoredTarget, YEAR);
        cookieStore.set("ola_current_block_order", String(progress.block_order    || 1), YEAR);
        cookieStore.set("ola_sessions_done",       String(progress.sessions_done  || 0), YEAR);
        cookieStore.set("ola_total_phrases",       String(progress.total_phrases  || 0), YEAR);
        cookieStore.set("ola_total_score_sum",     String(progress.total_score_sum || 0), YEAR);
        cookieStore.set("ola_words_repeated",      String(progress.words_repeated || 0), YEAR);
        cookieStore.set("ola_streak_days",         String(progress.streak_days    || 0), YEAR);
        if (progress.last_session_date) {
          cookieStore.set("ola_last_session_date", String(progress.last_session_date).slice(0, 10), YEAR);
        }
        cookieStore.set("ola_progress_lang_pair", `${restoredSource}→${restoredTarget}`, YEAR);
        cookieStore.set("ola_blocks_today_user",  auth.record.id, YEAR);
      } else {
        // Brand new user — set language defaults only if cookies don't exist yet
        if (!cookieStore.get("ola_source_lang")?.value) {
          cookieStore.set("ola_source_lang", "pt-BR", YEAR);
          cookieStore.set("ola_target_lang", "en",    YEAR);
        }
      }
    } catch (e) {
      console.error("[OLA] Failed to restore progress from PocketBase on login:", e);
      if (!cookieStore.get("ola_source_lang")?.value) {
        cookieStore.set("ola_source_lang", "pt-BR", YEAR);
        cookieStore.set("ola_target_lang", "en",    YEAR);
      }
    }

    return NextResponse.json({ ok: true });
  } catch {
    return NextResponse.json({ error: "Email ou senha incorretos." }, { status: 401 });
  }
}
