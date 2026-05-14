import { createAdminPbClient, createPbClient } from "@/lib/pocketbase/server";

export interface StoredSubscription {
  userId: string;
  subscription: PushSubscriptionJSON;
  sourceLang: string;
  createdAt: string;
  lastSessionDate?: string;
}

export async function saveSubscription(
  userId: string,
  subscription: PushSubscriptionJSON,
  sourceLang = "pt-BR",
  userToken: string
) {
  const pb = createPbClient(userToken);
  const sub = subscription as any;
  const data = {
    user_id: userId,
    endpoint: sub.endpoint,
    p256dh: sub.keys?.p256dh || "",
    auth: sub.keys?.auth || "",
    source_lang: sourceLang,
  };

  const existing = await pb
    .collection("push_subscriptions")
    .getList(1, 1, { filter: `user_id = "${userId}"` })
    .catch(() => ({ items: [] as any[] }));

  if (existing.items.length > 0) {
    await pb.collection("push_subscriptions").update(existing.items[0].id, data);
  } else {
    await pb.collection("push_subscriptions").create(data);
  }
}

export async function removeSubscription(userId: string, userToken: string) {
  const pb = createPbClient(userToken);
  const existing = await pb
    .collection("push_subscriptions")
    .getList(1, 50, { filter: `user_id = "${userId}"` })
    .catch(() => ({ items: [] as any[] }));

  for (const item of existing.items) {
    await pb.collection("push_subscriptions").delete(item.id);
  }
}

export async function getAllSubscriptions(): Promise<StoredSubscription[]> {
  const pb = await createAdminPbClient();
  const records = await pb.collection("push_subscriptions").getFullList();

  return records.map((r) => ({
    userId: r.user_id,
    subscription: {
      endpoint: r.endpoint,
      keys: { p256dh: r.p256dh, auth: r.auth },
    } as PushSubscriptionJSON,
    sourceLang: r.source_lang || "pt-BR",
    createdAt: r.created,
    lastSessionDate: r.last_notified ? r.last_notified.slice(0, 10) : undefined,
  }));
}

export async function getSubscription(
  userId: string,
  userToken: string
): Promise<StoredSubscription | undefined> {
  const pb = createPbClient(userToken);
  const existing = await pb
    .collection("push_subscriptions")
    .getList(1, 1, { filter: `user_id = "${userId}"` })
    .catch(() => ({ items: [] as any[] }));

  if (existing.items.length === 0) return undefined;
  const r = existing.items[0];
  return {
    userId: r.user_id,
    subscription: {
      endpoint: r.endpoint,
      keys: { p256dh: r.p256dh, auth: r.auth },
    } as PushSubscriptionJSON,
    sourceLang: r.source_lang || "pt-BR",
    createdAt: r.created,
    lastSessionDate: r.last_notified ? r.last_notified.slice(0, 10) : undefined,
  };
}

export async function markSessionDone(userId: string, userToken?: string) {
  const pb = userToken ? createPbClient(userToken) : await createAdminPbClient();
  const existing = await pb
    .collection("push_subscriptions")
    .getList(1, 1, { filter: `user_id = "${userId}"` })
    .catch(() => ({ items: [] as any[] }));

  if (existing.items.length === 0) return;
  await pb.collection("push_subscriptions").update(existing.items[0].id, {
    last_notified: todayUTC(),
  });
}

export function todayUTC(): string {
  return new Date().toISOString().slice(0, 10);
}
