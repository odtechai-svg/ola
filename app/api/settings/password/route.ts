import { NextResponse } from "next/server";
import { cookies } from "next/headers";
import { createPbClient } from "@/lib/pocketbase/server";

export async function POST(request: Request) {
  const cookieStore = await cookies();
  const token  = cookieStore.get("pb_auth")?.value;
  const userId = cookieStore.get("pb_user_id")?.value;

  if (!token || !userId) {
    return NextResponse.json({ error: "Not authenticated." }, { status: 401 });
  }

  const { oldPassword, newPassword, newPasswordConfirm } = await request.json();

  if (!oldPassword || !newPassword || !newPasswordConfirm) {
    return NextResponse.json(
      { error: "All fields are required." },
      { status: 400 }
    );
  }

  if (newPassword !== newPasswordConfirm) {
    return NextResponse.json(
      { error: "New passwords do not match." },
      { status: 400 }
    );
  }

  if (newPassword.length < 8) {
    return NextResponse.json(
      { error: "Password must be at least 8 characters." },
      { status: 400 }
    );
  }

  try {
    const pb = createPbClient(token);
    await pb.collection("users").update(userId, {
      oldPassword,
      password: newPassword,
      passwordConfirm: newPasswordConfirm,
    });
    return NextResponse.json({ ok: true });
  } catch (e: any) {
    console.error("[OLA] Password change failed:", e);
    const message =
      e?.response?.data?.oldPassword?.message ||
      "Current password is incorrect or the update failed.";
    return NextResponse.json({ error: message }, { status: 400 });
  }
}
