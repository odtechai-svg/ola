import { cookies } from "next/headers";
import { Shell } from "@/components/layout/shell";
import { requireUser } from "@/lib/server/auth";
import { StatsClient } from "@/components/ola/stats-client";

async function getUserStats() {
  const cookieStore = await cookies();
  const sessionsDone  = parseInt(cookieStore.get("ola_sessions_done")?.value  || "0", 10);
  const totalPhrases  = parseInt(cookieStore.get("ola_total_phrases")?.value  || "0", 10);
  const totalScoreSum = parseFloat(cookieStore.get("ola_total_score_sum")?.value || "0");
  const blockOrder    = parseInt(cookieStore.get("ola_current_block_order")?.value || "1", 10);
  const sourceLang    = cookieStore.get("ola_source_lang")?.value  || "pt-BR";
  const targetLang    = cookieStore.get("ola_target_lang")?.value  || "en";

  const avgScore = sessionsDone > 0 ? Math.round((totalScoreSum / sessionsDone) * 100) : 0;
  const blocksCompleted = Math.max(0, blockOrder - 1);
  const wordsLearned = blocksCompleted * 8 + (sessionsDone * 3);
  const minutesTrained = sessionsDone * 15;

  return { sessionsDone, totalPhrases, avgScore, blocksCompleted, sourceLang, targetLang, wordsLearned, minutesTrained };
}

export default async function StatsPage() {
  await requireUser();
  const s = await getUserStats();

  return (
    <Shell>
      <StatsClient {...s} />
    </Shell>
  );
}
