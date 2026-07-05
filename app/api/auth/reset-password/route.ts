import { NextResponse } from "next/server";
import { createPbClient } from "@/lib/pocketbase/server";

export async function POST(request: Request) {
  const { token, password, passwordConfirm } = await request.json();

  if (!token || !password || !passwordConfirm) {
    return NextResponse.json(
      { error: "Missing required fields." },
      { status: 400 }
    );
  }

  if (password !== passwordConfirm) {
    return NextResponse.json(
      { error: "Passwords do not match." },
      { status: 400 }
    );
  }

  if (password.length < 8) {
    return NextResponse.json(
      { error: "Password must be at least 8 characters." },
      { status: 400 }
    );
  }

  try {
    const pb = createPbClient();
    await pb.collection("users").confirmPasswordReset(token, password, passwordConfirm);
    return NextResponse.json({ ok: true });
  } catch (e: any) {
    console.error("[OLA] Password reset confirmation failed:", e);
    return NextResponse.json(
      { error: "Invalid or expired reset token. Please request a new link." },
      { status: 400 }
    );
  }
}
