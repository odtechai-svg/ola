import { NextResponse } from "next/server";
import { buildLiveSession } from "@/lib/server/queries";

export async function POST() {
  const userId = "fa7ef70f-e61a-40c7-a9e4-15429f7a0f5a"; // Mock user

  try {
    const payload = await buildLiveSession(userId);
    // Removed Supabase analytics insert
    return NextResponse.json(payload);
  } catch (error: any) {
    return NextResponse.json({ error: error.message ?? "Failed to start session." }, { status: 400 });
  }
}
