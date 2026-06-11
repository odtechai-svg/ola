import { cookies } from "next/headers";
import { Shell } from "@/components/layout/shell";
import { requireUser } from "@/lib/server/auth";
import { getDashboardProfile } from "@/lib/server/queries";
import { createPbClient } from "@/lib/pocketbase/server";
import { SettingsClient } from "@/components/settings/SettingsClient";

export default async function SettingsPage() {
  const user = await requireUser();
  const [{ profile }, cookieStore] = await Promise.all([
    getDashboardProfile(user.id),
    cookies(),
  ]);

  const voiceGender = cookieStore.get("ola_voice_gender")?.value || "female";

  // Fetch live user record from PocketBase to get persisted whatsapp/name
  let whatsapp = "";
  try {
    const pb = createPbClient(user.token);
    const pbUser = await pb.collection("users").getOne(user.id);
    whatsapp = (pbUser as any).whatsapp || "";
  } catch {}

  return (
    <Shell>
      <SettingsClient
        displayName={profile?.displayName ?? "Learner"}
        userEmail={user.email ?? ""}
        whatsapp={whatsapp}
        sourceLanguage={profile?.sourceLanguage ?? ""}
        targetLanguage={profile?.targetLanguage ?? ""}
        defaultVoiceGender={voiceGender}
        isAdmin={user.email === (process.env.PB_ADMIN_EMAIL || "odtechai@gmail.com")}
      />
    </Shell>
  );
}
