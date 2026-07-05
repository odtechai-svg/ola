import { redirect } from "next/navigation";
import { Shell } from "@/components/layout/shell";
import { requireUser } from "@/lib/server/auth";
import { getDashboardProfile } from "@/lib/server/queries";
import { StatsClient } from "@/components/ola/stats-client";

export default async function StatsPage() {
  const user = await requireUser();
  const { profile, enrollment } = await getDashboardProfile(user.id);

  if (!enrollment) {
    redirect("/onboarding");
  }

  const sessionsDone = profile?.sessionsDone ?? 0;
  const totalPhrases = profile?.totalPhrases ?? 0;
  const avgScore = profile?.avgScore ?? 0;
  const blocksCompleted = Math.max(0, enrollment.currentBlockOrder - 1);
  const wordsLearned = profile?.uniqueWords ?? 0;
  const minutesTrained = sessionsDone * 15;

  return (
    <Shell>
      <StatsClient
        sessionsDone={sessionsDone}
        totalPhrases={totalPhrases}
        avgScore={avgScore}
        blocksCompleted={blocksCompleted}
        wordsLearned={wordsLearned}
        minutesTrained={minutesTrained}
        sourceLang={enrollment.sourceLanguageCode}
        targetLang={enrollment.targetLanguageCode}
      />
    </Shell>
  );
}
