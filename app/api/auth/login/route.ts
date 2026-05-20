import { NextResponse } from "next/server";
import { cookies } from "next/headers";
import { createPbClient } from "@/lib/pocketbase/server";

const COOKIE_OPTS = {
  httpOnly: true,
  sameSite: "lax" as const,
  path: "/",
  maxAge: 60 * 60 * 24 * 30, // 30 days
};

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
    // Restore language defaults for users without cookies (new device / cleared cookies)
    if (!cookieStore.get("ola_source_lang")?.value) {
      cookieStore.set("ola_source_lang", "pt-BR", { ...COOKIE_OPTS, maxAge: 60 * 60 * 24 * 365 });
      cookieStore.set("ola_target_lang", "en",    { ...COOKIE_OPTS, maxAge: 60 * 60 * 24 * 365 });
    }
    return NextResponse.json({ ok: true });
  } catch {
    return NextResponse.json({ error: "Email ou senha incorretos." }, { status: 401 });
  }
}
