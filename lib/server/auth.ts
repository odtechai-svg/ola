import { cookies } from "next/headers";

export interface OlaUser {
  id: string;
  token: string;
  email?: string;
  name?: string;
}

export async function getCurrentUser(): Promise<OlaUser | null> {
  const cookieStore = await cookies();
  const token = cookieStore.get("pb_auth")?.value;
  const userId = cookieStore.get("pb_user_id")?.value;
  if (token && userId) {
    return { id: userId, token };
  }
  return null;
}

export async function requireUser(): Promise<OlaUser> {
  const user = await getCurrentUser();
  if (!user) throw new Error("Unauthorized");
  return user;
}
