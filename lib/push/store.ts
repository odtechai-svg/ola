import fs from "fs";
import path from "path";

const STORE_PATH = path.join(process.cwd(), "data/push-subscriptions.json");

export interface StoredSubscription {
  userId: string;
  subscription: PushSubscriptionJSON;
  sourceLang: string;
  createdAt: string;
  lastSessionDate?: string; // ISO date "YYYY-MM-DD" — updated after each session
}

function readStore(): StoredSubscription[] {
  try {
    return JSON.parse(fs.readFileSync(STORE_PATH, "utf-8"));
  } catch {
    return [];
  }
}

function writeStore(data: StoredSubscription[]) {
  fs.writeFileSync(STORE_PATH, JSON.stringify(data, null, 2));
}

export function saveSubscription(userId: string, subscription: PushSubscriptionJSON, sourceLang = "pt-BR") {
  const store = readStore().filter((s) => s.userId !== userId);
  store.push({ userId, subscription, sourceLang, createdAt: new Date().toISOString() });
  writeStore(store);
}

export function removeSubscription(userId: string) {
  writeStore(readStore().filter((s) => s.userId !== userId));
}

export function getAllSubscriptions(): StoredSubscription[] {
  return readStore();
}

export function getSubscription(userId: string): StoredSubscription | undefined {
  return readStore().find((s) => s.userId === userId);
}

export function markSessionDone(userId: string) {
  const store = readStore();
  const idx = store.findIndex((s) => s.userId === userId);
  if (idx === -1) return; // user has no push subscription — nothing to update
  store[idx].lastSessionDate = todayUTC();
  writeStore(store);
}

export function todayUTC(): string {
  return new Date().toISOString().slice(0, 10); // "YYYY-MM-DD"
}
