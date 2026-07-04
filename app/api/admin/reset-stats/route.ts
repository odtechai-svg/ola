import { NextResponse } from "next/server";
import { cookies } from "next/headers";
import { getCurrentUser } from "@/lib/server/auth";
import { createPbClient } from "@/lib/pocketbase/server";

export async function POST() {
  try {
    const user = await getCurrentUser();
    const adminEmail = process.env.PB_ADMIN_EMAIL || "odtechai@gmail.com";

    if (!user || user.email !== adminEmail) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const cookieStore = await cookies();
    const persistOpts = { path: "/", maxAge: 60 * 60 * 24 * 365, sameSite: "lax" as const };

    cookieStore.set("ola_sessions_done", "0", persistOpts);
    cookieStore.set("ola_total_phrases", "0", persistOpts);
    cookieStore.set("ola_total_score_sum", "0", persistOpts);
    cookieStore.set("ola_current_block_order", "1", persistOpts);
    cookieStore.set("ola_words_repeated", "0", persistOpts);
    cookieStore.delete("ola_streak_days");
    cookieStore.delete("ola_last_session_date");

    if (user) {
      try {
        const pb = createPbClient(user.token);
        const existing = await pb
          .collection("user_progress")
          .getList(1, 1, { filter: `user_id = "${user.id}"` })
          .catch(() => ({ items: [] as any[] }));
        if (existing.items.length > 0) {
          await pb.collection("user_progress").delete(existing.items[0].id);
        }
      } catch (e) {
        console.error("[OLA] reset-stats PocketBase error:", e);
      }
    }

    return NextResponse.json({ ok: true });
  } catch (e: any) {
    return NextResponse.json({ error: e.message }, { status: 500 });
  }
}
