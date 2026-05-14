import PocketBase from "pocketbase";

const PB_URL = process.env.POCKETBASE_URL!;

export function createPbClient(token?: string): PocketBase {
  const pb = new PocketBase(PB_URL);
  if (token) pb.authStore.save(token, null);
  return pb;
}

export async function createAdminPbClient(): Promise<PocketBase> {
  const pb = new PocketBase(PB_URL);
  await pb.collection("_superusers").authWithPassword(
    process.env.PB_ADMIN_EMAIL!,
    process.env.PB_ADMIN_PASSWORD!
  );
  return pb;
}
