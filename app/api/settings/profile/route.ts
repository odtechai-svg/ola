import { NextResponse } from "next/server";
import { cookies } from "next/headers";

export async function POST(request: Request) {
  try {
    const { displayName, email, whatsapp } = await request.json();
    const cookieStore = await cookies();
    const opts = { path: "/", maxAge: 60 * 60 * 24 * 365, sameSite: "lax" as const };

    if (displayName !== undefined) cookieStore.set("ola_display_name", displayName, opts);
    if (email      !== undefined) cookieStore.set("ola_email",        email,       opts);
    if (whatsapp   !== undefined) cookieStore.set("ola_whatsapp",     whatsapp,    opts);

    return NextResponse.json({ ok: true });
  } catch (e: any) {
    return NextResponse.json({ error: e.message }, { status: 500 });
  }
}
