import { redirect } from "next/navigation";
import { cookies } from "next/headers";
import { Shell } from "@/components/layout/shell";
import { requireUser } from "@/lib/server/auth";
import { getDashboardProfile } from "@/lib/server/queries";
import { HomeClient } from "@/components/ola/home-client";

export default async function HomePage() {
  const user = await requireUser();
  const { profile, enrollment, queueCount, blockTitle, blocksTodayDone } = await getDashboardProfile(user.id);

  if (!enrollment) {
    redirect("/onboarding");
  }

  const cookieStore = await cookies();
  const voiceGender = cookieStore.get("ola_voice_gender")?.value || "female";

  return (
    <Shell>
      <HomeClient
        displayName={profile?.displayName ?? "Learner"}
        streakDays={profile?.streakDays ?? 0}
        streakState={(profile as any)?.streakState ?? "new"}
        currentBlockOrder={enrollment.currentBlockOrder}
        sourceLanguageCode={enrollment.sourceLanguageCode}
        targetLanguageCode={enrollment.targetLanguageCode}
        queueCount={queueCount}
        blockTitle={blockTitle}
        sessionsDone={(profile as any)?.sessionsDone ?? 0}
        totalPhrases={(profile as any)?.totalPhrases ?? 0}
        uniqueWords={(profile as any)?.uniqueWords ?? 0}
        avgScore={(profile as any)?.avgScore ?? 0}
        wordsRepeated={(profile as any)?.wordsRepeated ?? 0}
        defaultVoiceGender={voiceGender}
        blocksTodayDone={blocksTodayDone}
      />
    </Shell>
  );
}
