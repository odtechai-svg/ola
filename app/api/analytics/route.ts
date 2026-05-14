import { NextResponse } from "next/server";
import { getCurrentUser } from "@/lib/server/auth";

export async function POST(request: Request) {
  const user = await getCurrentUser();
  const body = await request.json();
  const { eventName } = body ?? {};
  if (!eventName) return NextResponse.json({ error: "eventName is required" }, { status: 400 });
  // Analytics logging — just console for now, migrate to PocketBase later if needed
  console.log("[OLA Analytics]", { userId: user?.id ?? null, eventName, ...body });
  return NextResponse.json({ ok: true });
}
