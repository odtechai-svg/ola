import { NextResponse } from "next/server";
import webpush from "web-push";
import { requireUser } from "@/lib/server/auth";
import { getAllSubscriptions, getSubscription } from "@/lib/push/store";

webpush.setVapidDetails(
  process.env.VAPID_CONTACT!,
  process.env.NEXT_PUBLIC_VAPID_PUBLIC_KEY!,
  process.env.VAPID_PRIVATE_KEY!
);

export async function POST(request: Request) {
  try {
    const user = await requireUser();
    const { title, body, url, targetUserId } = await request.json();

    const payload = JSON.stringify({
      title: title || "OLA",
      body: body || "Hora do seu treino diário!",
      data: { url: url || "/home" },
    });

    // Admin can send to all; regular users can only trigger for themselves
    const targets = user.isAdmin && !targetUserId
      ? getAllSubscriptions()
      : [getSubscription(targetUserId || user.id)].filter(Boolean) as any[];

    const results = await Promise.allSettled(
      targets.map((s: any) =>
        webpush.sendNotification(s.subscription as any, payload)
      )
    );

    const sent = results.filter((r) => r.status === "fulfilled").length;
    const failed = results.filter((r) => r.status === "rejected").length;

    return NextResponse.json({ ok: true, sent, failed });
  } catch (e: any) {
    return NextResponse.json({ error: e.message }, { status: 500 });
  }
}
