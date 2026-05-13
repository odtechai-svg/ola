import { NextResponse } from "next/server";
import { cookies } from "next/headers";
import { requireUser } from "@/lib/server/auth";
import { markSessionDone } from "@/lib/push/store";

export async function POST() {
  try {
    const user = await requireUser();
    if (!user.isAdmin) {
      return NextResponse.json({ error: "Forbidden" }, { status: 403 });
    }

    const cookieStore = await cookies();
    const opts = { path: "/", maxAge: 60 * 60 * 24 * 365, sameSite: "lax" as const };

    cookieStore.set("ola_sessions_done",       "0", opts);
    cookieStore.set("ola_total_phrases",        "0", opts);
    cookieStore.set("ola_total_score_sum",      "0", opts);
    cookieStore.set("ola_current_block_order",  "1", opts);
    cookieStore.set("ola_words_repeated",       "0", opts);
    cookieStore.delete("ola_streak_days");
    cookieStore.delete("ola_last_session_date");

    return NextResponse.json({ ok: true });
  } catch (e: any) {
    return NextResponse.json({ error: e.message }, { status: 500 });
  }
}
