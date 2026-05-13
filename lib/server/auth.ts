import { cookies } from "next/headers";

export async function getCurrentUser() {
  const cookieStore = await cookies();
  const displayName = cookieStore.get("ola_display_name")?.value || "Max Carvalho";
  const email       = cookieStore.get("ola_email")?.value       || "odtechai@gmail.com";
  const whatsapp    = cookieStore.get("ola_whatsapp")?.value    || "";
  const isAdmin     = cookieStore.get("ola_is_admin")?.value !== "false"; // default true
  return {
    id: "fa7ef70f-e61a-40c7-a9e4-15429f7a0f5a",
    email,
    displayName,
    whatsapp,
    isAdmin,
    user_metadata: { full_name: displayName },
  } as any;
}

export async function requireUser() {
  return getCurrentUser();
}
