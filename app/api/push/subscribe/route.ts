import { NextResponse } from "next/server";
import { cookies } from "next/headers";
import { requireUser } from "@/lib/server/auth";
import { saveSubscription, removeSubscription } from "@/lib/push/store";

export async function POST(request: Request) {
  try {
    const user = await requireUser();
    const cookieStore = await cookies();
    const sourceLang = cookieStore.get("ola_source_lang")?.value || "pt-BR";
    const { subscription } = await request.json();
    if (!subscription) return NextResponse.json({ error: "Missing subscription" }, { status: 400 });
    await saveSubscription(user.id, subscription, sourceLang, user.token);
    return NextResponse.json({ ok: true });
  } catch (e: any) {
    return NextResponse.json({ error: e.message }, { status: 500 });
  }
}

export async function DELETE() {
  try {
    const user = await requireUser();
    await removeSubscription(user.id, user.token);
    return NextResponse.json({ ok: true });
  } catch (e: any) {
    return NextResponse.json({ error: e.message }, { status: 500 });
  }
}
