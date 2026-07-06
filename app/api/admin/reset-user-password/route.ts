import { NextResponse } from "next/server";
import { cookies } from "next/headers";
import { createAdminPbClient } from "@/lib/pocketbase/server";

export async function POST(request: Request) {
  // Verify the caller is the admin
  const cookieStore = await cookies();
  const callerEmail = cookieStore.get("pb_user_email")?.value;
  const adminEmail  = process.env.PB_ADMIN_EMAIL || "odtechai@gmail.com";

  if (callerEmail !== adminEmail) {
    return NextResponse.json({ error: "Unauthorized." }, { status: 403 });
  }

  const { email, newPassword, newPasswordConfirm } = await request.json();

  if (!email || !newPassword || !newPasswordConfirm) {
    return NextResponse.json(
      { error: "All fields are required." },
      { status: 400 }
    );
  }

  if (newPassword !== newPasswordConfirm) {
    return NextResponse.json(
      { error: "Passwords do not match." },
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
    const pb = await createAdminPbClient();

    // Find the user by email
    const users = await pb.collection("users").getList(1, 1, {
      filter: `email = "${email.trim()}"`,
    });

    if (users.items.length === 0) {
      return NextResponse.json(
        { error: `Nenhum usuário encontrado com o e-mail: ${email}` },
        { status: 404 }
      );
    }

    const userId = users.items[0].id;

    // Admin update — no oldPassword required when using superuser auth
    await pb.collection("users").update(userId, {
      password: newPassword,
      passwordConfirm: newPasswordConfirm,
    });

    return NextResponse.json({ ok: true });
  } catch (e: any) {
    console.error("[OLA] Admin password reset failed:", e);
    return NextResponse.json(
      { error: e?.message || "Failed to reset password." },
      { status: 500 }
    );
  }
}
