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

    // Restore language defaults for new device / cleared cookies
    const sourceLang = cookieStore.get("ola_source_lang")?.value || "pt-BR";
    const targetLang = cookieStore.get("ola_target_lang")?.value || "en";
    if (!cookieStore.get("ola_source_lang")?.value) {
      cookieStore.set("ola_source_lang", sourceLang, YEAR);
      cookieStore.set("ola_target_lang", targetLang, YEAR);
    }

    // Restore progress from PocketBase for cross-device sync
    try {
      const pbAuth = createPbClient(auth.token);
      const progressResult = await pbAuth.collection("user_progress").getList(1, 1, {
        filter: `user_id = "${auth.record.id}" && source_lang = "${sourceLang}" && target_lang = "${targetLang}"`,
        sort: "-updated",
      });
      const progress = progressResult.items[0];
      if (progress) {
        cookieStore.set("ola_current_block_order", String(progress.block_order || 1), YEAR);
        cookieStore.set("ola_sessions_done",   String(progress.sessions_done  || 0), YEAR);
        cookieStore.set("ola_total_phrases",   String(progress.total_phrases  || 0), YEAR);
        cookieStore.set("ola_total_score_sum", String(progress.total_score_sum || 0), YEAR);
        cookieStore.set("ola_words_repeated",  String(progress.words_repeated || 0), YEAR);
        cookieStore.set("ola_streak_days",     String(progress.streak_days    || 0), YEAR);
        if (progress.last_session_date) {
          cookieStore.set("ola_last_session_date", String(progress.last_session_date).slice(0, 10), YEAR);
        }
        cookieStore.set("ola_progress_lang_pair", `${sourceLang}→${targetLang}`, YEAR);
        cookieStore.set("ola_blocks_today_user", auth.record.id, YEAR);
      }
    } catch (e) {
      console.error("[OLA] Failed to restore progress from PocketBase on login:", e);
    }

    return NextResponse.json({ ok: true });
  } catch {
    return NextResponse.json({ error: "Email ou senha incorretos." }, { status: 401 });
  }
}
