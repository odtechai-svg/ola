import { NextResponse } from "next/server";
import { cookies } from "next/headers";
import { createAdminPbClient, createPbClient } from "@/lib/pocketbase/server";

const COOKIE_OPTS = {
  httpOnly: true,
  sameSite: "lax" as const,
  path: "/",
  maxAge: 60 * 60 * 24 * 30,
};

export async function POST(request: Request) {
  const { email, password, name } = await request.json();

  try {
    const admin = await createAdminPbClient();
    await admin.collection("users").create({
      email,
      password,
      passwordConfirm: password,
      name: name || "",
      verified: true,
    });

    const pb = createPbClient();
    const auth = await pb.collection("users").authWithPassword(email, password);
    const cookieStore = await cookies();
    cookieStore.set("pb_auth", auth.token, COOKIE_OPTS);
    cookieStore.set("pb_user_id", auth.record.id, COOKIE_OPTS);
    cookieStore.set("pb_user_email", auth.record.email || "", COOKIE_OPTS);
    return NextResponse.json({ ok: true });
  } catch (e: any) {
    const msg = e?.response?.data?.email?.message || e?.message || "Erro ao criar conta.";
    return NextResponse.json({ error: msg }, { status: 400 });
  }
}
