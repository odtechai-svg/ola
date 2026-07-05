import { NextResponse } from "next/server";
import { createPbClient } from "@/lib/pocketbase/server";

export async function POST(request: Request) {
  const { email } = await request.json();

  if (!email || typeof email !== "string") {
    // Always return success to avoid revealing whether the email exists
    return NextResponse.json({ ok: true });
  }

  try {
    const pb = createPbClient();
    await pb.collection("users").requestPasswordReset(email.trim());
  } catch {
    // Silently ignore — don't reveal whether the email exists
  }

  return NextResponse.json({ ok: true });
}
