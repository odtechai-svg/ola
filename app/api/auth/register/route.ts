import { NextResponse } from "next/server";
import { cookies } from "next/headers";
import { createAdminPbClient, createPbClient } from "@/lib/pocketbase/server";

const COOKIE_OPTS = {
  httpOnly: true,
  sameSite: "lax" as const,
  path: "/",
  maxAge: 60 * 60 * 24 * 30,
};

export async function POST(request: Request) {
  const { email, password, name } = await request.json();

  try {
    const admin = await createAdminPbClient();
    await admin.collection("users").create({
      email,
      password,
      passwordConfirm: password,
      name: name || "",
      verified: true,
    });

    const pb = createPbClient();
    const auth = await pb.collection("users").authWithPassword(email, password);
    const cookieStore = await cookies();
    cookieStore.set("pb_auth", auth.token, COOKIE_OPTS);
    cookieStore.set("pb_user_id", auth.record.id, COOKIE_OPTS);
    cookieStore.set("pb_user_email", auth.record.email || "", COOKIE_OPTS);
    cookieStore.set("ola_display_name", auth.record.name || name || "", COOKIE_OPTS);
    const YEAR = { ...COOKIE_OPTS, maxAge: 60 * 60 * 24 * 365 };
    // Set default language for new users (Brazilian app — pt-BR learning en)
    cookieStore.set("ola_source_lang", "pt-BR", YEAR);
    cookieStore.set("ola_target_lang", "en",    YEAR);
    // Reset all progress cookies so a new account starts clean on this browser
    cookieStore.set("ola_current_block_order", "1",  YEAR);
    cookieStore.set("ola_sessions_done",        "0",  YEAR);
    cookieStore.set("ola_total_phrases",        "0",  YEAR);
    cookieStore.set("ola_total_score_sum",      "0",  YEAR);
    cookieStore.set("ola_words_repeated",       "0",  YEAR);
    cookieStore.set("ola_streak_days",          "0",  YEAR);
    cookieStore.set("ola_blocks_today",         "0",  YEAR);
    cookieStore.set("ola_blocks_today_date",    "",   YEAR);
    cookieStore.set("ola_blocks_today_user",    auth.record.id, YEAR);
    cookieStore.set("ola_progress_lang_pair",   "",   YEAR);
    return NextResponse.json({ ok: true });
  } catch (e: any) {
    const msg = e?.response?.data?.email?.message || e?.message || "Erro ao criar conta.";
    return NextResponse.json({ error: msg }, { status: 400 });
  }
}
