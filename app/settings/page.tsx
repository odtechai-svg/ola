import { cookies } from "next/headers";
import { Shell } from "@/components/layout/shell";
import { requireUser } from "@/lib/server/auth";
import { getDashboardProfile } from "@/lib/server/queries";
import { SettingsClient } from "@/components/settings/SettingsClient";

export default async function SettingsPage() {
  const user = await requireUser();
  const { profile } = await getDashboardProfile(user.id);

  const cookieStore = await cookies();
  const voiceGender = cookieStore.get("ola_voice_gender")?.value || "female";

  return (
    <Shell>
      <SettingsClient
        displayName={profile?.displayName ?? "Learner"}
        userEmail={user.email ?? ""}
        whatsapp={""}
        sourceLanguage={profile?.sourceLanguage ?? ""}
        targetLanguage={profile?.targetLanguage ?? ""}
        defaultVoiceGender={voiceGender}
        isAdmin={user.email === (process.env.PB_ADMIN_EMAIL || "odtechai@gmail.com")}
      />
    </Shell>
  );
}
