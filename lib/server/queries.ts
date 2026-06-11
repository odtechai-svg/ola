import fs from "fs";
import path from "path";
import { cookies } from "next/headers";
import { BlockSummary, LanguageOption, SessionSummary, UserProfile } from "@/lib/contracts/domain";
import { createPbClient } from "@/lib/pocketbase/server";

export interface EnrollmentSummary {
  id: string;
  languagePairId: string;
  sourceLanguageCode: string;
  targetLanguageCode: string;
  currentBlockOrder: number;
  currentBlockId?: string | null;
}

const CURRICULUM_FILE_MAP: Record<string, string> = {
  "pt-BR→en": "curriculum_blocks_en.json",
  "en→pt-BR": "curriculum_blocks_ptbr.json",
  "pt-BR→es": "curriculum_blocks_es.json",
  "es→pt-BR": "curriculum_blocks_es_ptbr.json",
  "en→es": "curriculum_blocks_en_es.json",
  "es→en": "curriculum_blocks_es_en.json",
  "pt-BR→it": "curriculum_blocks_it.json",
  "it→pt-BR": "curriculum_blocks_it_ptbr.json",
  "en→it":    "curriculum_blocks_en_it.json",
  "it→en":    "curriculum_blocks_it_en.json",
  "es→it":    "curriculum_blocks_es_it.json",
  "it→es":    "curriculum_blocks_it_es.json",
  "pt-BR→fr": "curriculum_blocks_fr.json",
  "fr→pt-BR": "curriculum_blocks_fr_ptbr.json",
  "en→fr":    "curriculum_blocks_en_fr.json",
  "fr→en":    "curriculum_blocks_fr_en.json",
  "es→fr":    "curriculum_blocks_es_fr.json",
  "fr→es":    "curriculum_blocks_fr_es.json",
  "it→fr":    "curriculum_blocks_it_fr.json",
  "fr→it":    "curriculum_blocks_fr_it.json",
  "pt-BR→de": "curriculum_blocks_de.json",
  "de→pt-BR": "curriculum_blocks_de_ptbr.json",
  "en→de":    "curriculum_blocks_en_de.json",
  "de→en":    "curriculum_blocks_de_en.json",
  "es→de":    "curriculum_blocks_es_de.json",
  "de→es":    "curriculum_blocks_de_es.json",
  "it→de":    "curriculum_blocks_it_de.json",
  "de→it":    "curriculum_blocks_de_it.json",
  "fr→de":    "curriculum_blocks_fr_de.json",
  "de→fr":    "curriculum_blocks_de_fr.json",
};

export async function getLanguageOptions(): Promise<LanguageOption[]> {
  return [
    { code: "pt-BR", name: "Português (Brasil)", nativeName: "Português (Brasil)" },
    { code: "en",    name: "English",            nativeName: "English" },
    { code: "es",    name: "Español",            nativeName: "Español" },
    { code: "it",    name: "Italiano",           nativeName: "Italiano" },
    { code: "fr",    name: "Français",           nativeName: "Français" },
    { code: "de",    name: "Deutsch",            nativeName: "Deutsch" },
  ];
}

// ── PocketBase helper ─────────────────────────────────────────────────────────
// Always fetches the most recently updated progress record for this user,
// with NO language-pair filter — the record itself tells us the correct pair.
export async function getPbProgress(userId: string, token: string): Promise<any | null> {
  try {
    const pb = createPbClient(token);
    const result = await pb.collection("user_progress").getList(1, 1, {
      filter: `user_id = "${userId}"`,
      sort: "-updated",
    });
    return result.items[0] || null;
  } catch {
    return null;
  }
}

// Resolves language pair: PB record first, cookie fallback for anonymous users.
async function resolveLanguagePair(pbProgress: any | null): Promise<{ source: string; target: string }> {
  if (pbProgress?.source_lang) {
    return { source: pbProgress.source_lang, target: pbProgress.target_lang || "en" };
  }
  try {
    const cookieStore = await cookies();
    return {
      source: cookieStore.get("ola_source_lang")?.value || "pt-BR",
      target: cookieStore.get("ola_target_lang")?.value || "en",
    };
  } catch {
    return { source: "pt-BR", target: "en" };
  }
}

function getLocalBlocksData(source: string, target: string) {
  const key = `${source}→${target}`;
  const fileName = CURRICULUM_FILE_MAP[key] || "curriculum_blocks_en.json";
  const filePath = path.join(process.cwd(), "supabase/seeds", fileName);

  if (!fs.existsSync(filePath)) {
    console.warn(`[OLA] Curriculum file not found: ${filePath}, falling back to en.json`);
    const fallback = path.join(process.cwd(), "supabase/seeds/curriculum_blocks_en.json");
    if (!fs.existsSync(fallback)) return [];
    return JSON.parse(fs.readFileSync(fallback, "utf-8"));
  }
  return JSON.parse(fs.readFileSync(filePath, "utf-8"));
}

// ── Dashboard ─────────────────────────────────────────────────────────────────

type StreakState = "new" | "today" | "alive" | "broken";

export async function getDashboardProfile(userId: string): Promise<{
  profile: (UserProfile & { sessionsDone: number; avgScore: number; totalPhrases: number; wordsRepeated: number; streakState: StreakState }) | null;
  enrollment: EnrollmentSummary | null;
  queueCount: number;
  blockTitle: string;
  blocksTodayDone: number;
}> {
  const cookieStore = await cookies();
  const token = cookieStore.get("pb_auth")?.value;
  const isAuth = !!(token && userId && userId !== "anonymous");

  const pbProgress = isAuth ? await getPbProgress(userId, token!) : null;
  const { source, target } = await resolveLanguagePair(pbProgress);

  const currentBlockOrder = pbProgress?.block_order
    ?? parseInt(cookieStore.get("ola_current_block_order")?.value || "1", 10);
  const sessionsDone = pbProgress?.sessions_done
    ?? parseInt(cookieStore.get("ola_sessions_done")?.value || "0", 10);
  const totalPhrases = pbProgress?.total_phrases
    ?? parseInt(cookieStore.get("ola_total_phrases")?.value || "0", 10);
  const totalScoreSum = pbProgress?.total_score_sum
    ?? parseFloat(cookieStore.get("ola_total_score_sum")?.value || "0");
  const avgScore = sessionsDone > 0 ? Math.round((totalScoreSum / sessionsDone) * 100) : 0;
  const wordsRepeated = pbProgress?.words_repeated
    ?? parseInt(cookieStore.get("ola_words_repeated")?.value || "0", 10);
  const streakDays = pbProgress?.streak_days
    ?? parseInt(cookieStore.get("ola_streak_days")?.value || "0", 10);
  const lastSessionDate = pbProgress?.last_session_date
    ? String(pbProgress.last_session_date).slice(0, 10)
    : cookieStore.get("ola_last_session_date")?.value;
  const displayName = cookieStore.get("ola_display_name")?.value || "Atleta";

  const todayStr = new Date().toISOString().slice(0, 10);
  const yesterdayDate = new Date();
  yesterdayDate.setDate(yesterdayDate.getDate() - 1);
  const yesterdayStr = yesterdayDate.toISOString().slice(0, 10);

  // blocks_today is a per-device daily counter — cookie is fine here
  const blocksTodayDate   = cookieStore.get("ola_blocks_today_date")?.value;
  const blocksTodayUserId = cookieStore.get("ola_blocks_today_user")?.value;
  const blocksOwnedByUser = !userId || userId === "anonymous" || blocksTodayUserId === userId;
  const blocksTodayDone   = (blocksTodayDate === todayStr && blocksOwnedByUser)
    ? Math.min(parseInt(cookieStore.get("ola_blocks_today")?.value || "0", 10), 3)
    : 0;

  let streakState: StreakState;
  let finalStreakDays: number;
  if (!lastSessionDate) {
    streakState = "new";    finalStreakDays = 0;
  } else if (lastSessionDate === todayStr) {
    streakState = "today";  finalStreakDays = streakDays;
  } else if (lastSessionDate === yesterdayStr) {
    streakState = "alive";  finalStreakDays = streakDays;
  } else {
    streakState = "broken"; finalStreakDays = 0;
  }

  const blocksData = getLocalBlocksData(source, target);
  const currentBlock = blocksData.find((b: any) => b.order === currentBlockOrder) || blocksData[0] || {};
  const blockTitle: string  = currentBlock.title || "";
  const phraseCount: number = currentBlock.levels?.length ?? 3;

  return {
    profile: {
      id: userId || "anonymous",
      displayName,
      sourceLanguage: source,
      targetLanguage: target,
      currentBlockOrder,
      streakDays: finalStreakDays,
      streakState,
      sessionsDone,
      avgScore,
      totalPhrases,
      wordsRepeated,
    },
    enrollment: {
      id: "enrollment-id",
      languagePairId: `${source}→${target}`,
      sourceLanguageCode: source,
      targetLanguageCode: target,
      currentBlockOrder,
      currentBlockId: `block-${currentBlockOrder}`,
    },
    queueCount: phraseCount,
    blockTitle,
    blocksTodayDone,
  };
}

export async function getBlocksForActiveEnrollment(userId: string): Promise<BlockSummary[]> {
  const cookieStore = await cookies();
  const token = cookieStore.get("pb_auth")?.value;
  const isAuth = !!(token && userId && userId !== "anonymous");

  const pbProgress = isAuth ? await getPbProgress(userId, token!) : null;
  const { source, target } = await resolveLanguagePair(pbProgress);
  const currentBlockOrder = pbProgress?.block_order
    ?? parseInt(cookieStore.get("ola_current_block_order")?.value || "1", 10);

  const blocksData = getLocalBlocksData(source, target);
  return (blocksData ?? []).map((block: any) => {
    const status = block.order < currentBlockOrder ? "completed"
      : block.order === currentBlockOrder        ? "active"
      : "locked";
    return {
      id:                block.slug || `block-${block.order}`,
      order:             block.order,
      slug:              block.slug || `block-${block.order}`,
      title:             block.title,
      phase:             block.phase || "survival",
      status,
      completionPercent: status === "completed" ? 100 : status === "active" ? 25 : 0,
    };
  });
}

export async function getSessionBreakdown(userId?: string): Promise<{ novo: number; fala: number; revisao: number }> {
  const cookieStore = await cookies();
  const token = cookieStore.get("pb_auth")?.value;
  const isAuth = !!(token && userId && userId !== "anonymous");

  const pbProgress = isAuth ? await getPbProgress(userId!, token!) : null;
  const { source, target } = await resolveLanguagePair(pbProgress);
  const blockOrder = pbProgress?.block_order
    ?? parseInt(cookieStore.get("ola_current_block_order")?.value || "1", 10);
  const sessionsDone = pbProgress?.sessions_done
    ?? parseInt(cookieStore.get("ola_sessions_done")?.value || "0", 10);

  const blocksData = getLocalBlocksData(source, target);
  const currentBlock = blocksData.find((b: any) => b.order === blockOrder) || blocksData[0] || { levels: [] };
  const totalInBlock = currentBlock.levels?.length ?? 3;

  const revisao = Math.min((blockOrder - 1) * 2, 10);
  const sessionsOnBlock = sessionsDone % Math.max(blockOrder, 1);
  const novo = Math.max(totalInBlock - Math.min(sessionsOnBlock, totalInBlock), 0);
  const fala = totalInBlock - novo;

  return { novo, fala, revisao };
}

export async function buildLiveSession(userId: string): Promise<{
  sessionId: string;
  languagePairId: string;
  startingBlockOrder: number;
  totalBlocks: number;
  summary: SessionSummary;
}> {
  const cookieStore = await cookies();
  const token = cookieStore.get("pb_auth")?.value;
  const isAuth = !!(token && userId && userId !== "anonymous");

  const pbProgress = isAuth ? await getPbProgress(userId, token!) : null;
  const { source, target } = await resolveLanguagePair(pbProgress);
  const currentBlockOrder = pbProgress?.block_order
    ?? parseInt(cookieStore.get("ola_current_block_order")?.value || "1", 10);

  const blocksData = getLocalBlocksData(source, target);
  const currentBlock = blocksData.find((b: any) => b.order === currentBlockOrder) || blocksData[0] || { levels: [] };

  const items = currentBlock.levels.map((level: any, index: number) => ({
    memoryId:          `mem-${index}`,
    sentenceId:        `sent-${index}`,
    blockId:           currentBlock.slug || "mocked-block",
    blockTitle:        currentBlock.title || "Current block",
    prompt:            level.translation || level.text,
    expectedText:      level.text,
    sourceGloss:       level.translation || level.text,
    imageHint:         level.image_hint || "Use a simple contextual visual here.",
    imageUrl:          `/blocks/bl${String(currentBlockOrder).padStart(3, "0")}-l${index + 1}.webp`,
    audioUrl:          undefined,
    strength:          Math.random() > 0.5 ? 0.8 : undefined,
    fluencyScore:      Math.random() > 0.5 ? 0.9 : undefined,
    queueReason:       "new_content",
    suggestedExercise: "speak",
  }));

  const sessionId = "mock-session-id-" + Date.now();

  return {
    sessionId,
    languagePairId: `${source}→${target}`,
    startingBlockOrder: currentBlockOrder,
    totalBlocks: blocksData.length,
    summary: {
      sessionId,
      totalItems: items.length,
      targetMinutes: 15,
      items,
    },
  };
}
