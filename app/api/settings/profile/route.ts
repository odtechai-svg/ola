import { NextResponse } from "next/server";
import { cookies } from "next/headers";
import { getCurrentUser } from "@/lib/server/auth";
import { createPbClient } from "@/lib/pocketbase/server";

export async function POST(request: Request) {
  try {
    const { displayName, whatsapp } = await request.json();
    const cookieStore = await cookies();
    const opts = { path: "/", maxAge: 60 * 60 * 24 * 365, sameSite: "lax" as const };

    // Update PocketBase users record (source of truth)
    const user = await getCurrentUser();
    if (user) {
      try {
        const pb = createPbClient(user.token);
        const pbData: Record<string, string> = {};
        if (displayName !== undefined) pbData.name     = displayName;
        if (whatsapp    !== undefined) pbData.whatsapp = whatsapp;
        if (Object.keys(pbData).length > 0) {
          await pb.collection("users").update(user.id, pbData);
        }
      } catch (e) {
        console.error("[OLA] Failed to save profile to PocketBase:", e);
      }
    }

    // Keep display name cookie in sync for layout
    if (displayName !== undefined) cookieStore.set("ola_display_name", displayName, opts);

    return NextResponse.json({ ok: true });
  } catch (e: any) {
    return NextResponse.json({ error: e.message }, { status: 500 });
  }
}
