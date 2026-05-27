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

// Map of source→target to JSON file
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

async function getLanguagePairFromCookies(): Promise<{ source: string; target: string }> {
  try {
    const cookieStore = await cookies();
    const source = cookieStore.get("ola_source_lang")?.value || "pt-BR";
    const target = cookieStore.get("ola_target_lang")?.value || "en";
    return { source, target };
  } catch {
    return { source: "pt-BR", target: "en" };
  }
}

export async function getLanguageOptions(): Promise<LanguageOption[]> {
  return [
    { code: "pt-BR", name: "Português (Brasil)", nativeName: "Português (Brasil)" },
    { code: "en", name: "English", nativeName: "English" },
    { code: "es", name: "Español", nativeName: "Español" },
    { code: "it", name: "Italiano", nativeName: "Italiano" },
    { code: "fr", name: "Français", nativeName: "Français" },
    { code: "de", name: "Deutsch", nativeName: "Deutsch" },
  ];
}

async function getBlockOrderFromCookies(): Promise<number> {
  try {
    const cookieStore = await cookies();
    const order = cookieStore.get("ola_current_block_order")?.value;
    return order ? parseInt(order, 10) : 1;
  } catch {
    return 1;
  }
}

async function getStatsFromCookies() {
  try {
    const cookieStore = await cookies();
    const sessionsDone = parseInt(cookieStore.get("ola_sessions_done")?.value || "0", 10);
    const totalPhrases = parseInt(cookieStore.get("ola_total_phrases")?.value || "0", 10);
    const totalScoreSum = parseFloat(cookieStore.get("ola_total_score_sum")?.value || "0");
    const avgScore = sessionsDone > 0 ? Math.round((totalScoreSum / sessionsDone) * 100) : 0;
    const wordsRepeated = parseInt(cookieStore.get("ola_words_repeated")?.value || "0", 10);

    return { sessionsDone, totalPhrases, avgScore, wordsRepeated };
  } catch {
    return { sessionsDone: 0, totalPhrases: 0, avgScore: 0, wordsRepeated: 0 };
  }
}

type StreakState = "new" | "today" | "alive" | "broken";

export async function getDashboardProfile(userId: string): Promise<{
  profile: (UserProfile & { sessionsDone: number; avgScore: number; totalPhrases: number; wordsRepeated: number; streakState: StreakState }) | null;
  enrollment: EnrollmentSummary | null;
  queueCount: number;
  blockTitle: string;
  blocksTodayDone: number;
}> {
  const { source, target } = await getLanguagePairFromCookies();
  const cookieStore = await cookies();

  // Try to load progress from PocketBase filtered by language pair
  let pbProgress: any = null;
  const token = cookieStore.get("pb_auth")?.value;
  if (token && userId && userId !== "anonymous") {
    try {
      const pb = createPbClient(token);
      const result = await pb.collection("user_progress").getList(1, 1, {
        filter: `user_id = "${userId}" && source_lang = "${source}" && target_lang = "${target}"`,
      });
      pbProgress = result.items[0] || null;
    } catch {}
  }

  // Validate whether cookies belong to the current language pair
  const currentPair = `${source}→${target}`;
  const cookieProgressPair = cookieStore.get("ola_progress_lang_pair")?.value;
  const cookiesMatchPair = !cookieProgressPair || cookieProgressPair === currentPair;

  const currentBlockOrder = pbProgress?.block_order
    ?? (cookiesMatchPair ? parseInt(cookieStore.get("ola_current_block_order")?.value || "1", 10) : 1);
  const sessionsDone = pbProgress?.sessions_done
    ?? (cookiesMatchPair ? parseInt(cookieStore.get("ola_sessions_done")?.value || "0", 10) : 0);
  const totalPhrases = pbProgress?.total_phrases
    ?? (cookiesMatchPair ? parseInt(cookieStore.get("ola_total_phrases")?.value || "0", 10) : 0);
  const totalScoreSum = pbProgress?.total_score_sum
    ?? (cookiesMatchPair ? parseFloat(cookieStore.get("ola_total_score_sum")?.value || "0") : 0);
  const avgScore = sessionsDone > 0 ? Math.round((totalScoreSum / sessionsDone) * 100) : 0;
  const wordsRepeated = pbProgress?.words_repeated
    ?? (cookiesMatchPair ? parseInt(cookieStore.get("ola_words_repeated")?.value || "0", 10) : 0);
  const streakDaysPb = pbProgress?.streak_days
    ?? (cookiesMatchPair ? parseInt(cookieStore.get("ola_streak_days")?.value || "0", 10) : 0);
  const lastSessionDate = pbProgress?.last_session_date
    ? String(pbProgress.last_session_date).slice(0, 10)
    : (cookiesMatchPair ? cookieStore.get("ola_last_session_date")?.value : undefined);
  const displayName = cookieStore.get("ola_display_name")?.value || "Atleta";

  const blocksData = await getLocalBlocksData(source, target);
  const currentBlock = blocksData.find((b: any) => b.order === currentBlockOrder) || blocksData[0] || {};
  const blockTitle: string = currentBlock.title || "";
  const phraseCount: number = currentBlock.levels?.length ?? 3;

  const todayStr = new Date().toISOString().slice(0, 10);
  const yesterdayDate = new Date();
  yesterdayDate.setDate(yesterdayDate.getDate() - 1);
  const yesterdayStr = yesterdayDate.toISOString().slice(0, 10);

  const blocksTodayDate   = cookieStore.get("ola_blocks_today_date")?.value;
  const blocksTodayUserId = cookieStore.get("ola_blocks_today_user")?.value;
  const blocksOwnedByUser = !userId || userId === "anonymous" || blocksTodayUserId === userId;
  const blocksTodayDone   = (blocksTodayDate === todayStr && blocksOwnedByUser)
    ? Math.min(parseInt(cookieStore.get("ola_blocks_today")?.value || "0", 10), 3)
    : 0;

  let streakState: StreakState;
  let streakDays: number;

  if (!lastSessionDate) {
    streakState = "new";
    streakDays = 0;
  } else if (lastSessionDate === todayStr) {
    streakState = "today";
    streakDays = streakDaysPb;
  } else if (lastSessionDate === yesterdayStr) {
    streakState = "alive";
    streakDays = streakDaysPb;
  } else {
    streakState = "broken";
    streakDays = 0;
  }

  return {
    profile: {
      id: userId || "anonymous",
      displayName,
      sourceLanguage: source,
      targetLanguage: target,
      currentBlockOrder,
      streakDays,
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

// Parses the correct local JSON seed data based on language pair
async function getLocalBlocksData(source?: string, target?: string) {
  if (!source || !target) {
    const pair = await getLanguagePairFromCookies();
    source = pair.source;
    target = pair.target;
  }

  const key = `${source}→${target}`;
  const fileName = CURRICULUM_FILE_MAP[key] || "curriculum_blocks_en.json";
  const filePath = path.join(process.cwd(), "supabase/seeds", fileName);

  if (!fs.existsSync(filePath)) {
    console.warn(`[OLA] Curriculum file not found: ${filePath}, falling back to en.json`);
    const fallback = path.join(process.cwd(), "supabase/seeds/curriculum_blocks_en.json");
    if (!fs.existsSync(fallback)) return [];
    return JSON.parse(fs.readFileSync(fallback, "utf-8"));
  }

  const data = fs.readFileSync(filePath, "utf-8");
  return JSON.parse(data);
}

export async function getBlocksForActiveEnrollment(userId: string): Promise<BlockSummary[]> {
  const blocksData = await getLocalBlocksData();
  const cookieStore = await cookies();
  const token = cookieStore.get("pb_auth")?.value;
  let currentBlockOrder = await getBlockOrderFromCookies();
  if (token && userId && userId !== "anonymous") {
    try {
      const { source: s, target: t } = await getLanguagePairFromCookies();
      const pb = createPbClient(token);
      const result = await pb.collection("user_progress").getList(1, 1, {
        filter: `user_id = "${userId}" && source_lang = "${s}" && target_lang = "${t}"`,
      });
      if (result.items[0]?.block_order) currentBlockOrder = result.items[0].block_order;
    } catch {}
  }

  return (blocksData ?? []).map((block: any) => {
    const status = block.order < currentBlockOrder
      ? "completed"
      : block.order === currentBlockOrder
        ? "active"
        : "locked";

    return {
      id: block.slug || `block-${block.order}`,
      order: block.order,
      slug: block.slug || `block-${block.order}`,
      title: block.title,
      phase: block.phase || "survival",
      status,
      completionPercent: status === "completed" ? 100 : status === "active" ? 25 : 0
    };
  });
}

export async function getSessionBreakdown(): Promise<{ novo: number; fala: number; revisao: number }> {
  const blocksData   = await getLocalBlocksData();
  const blockOrder   = await getBlockOrderFromCookies();
  const cookieStore  = await cookies();
  const sessionsDone = parseInt(cookieStore.get("ola_sessions_done")?.value || "0", 10);

  const currentBlock  = blocksData.find((b: any) => b.order === blockOrder) || blocksData[0] || { levels: [] };
  const totalInBlock  = currentBlock.levels?.length ?? 3;

  // Items from previous blocks queued for spaced-repetition review (grows with progress)
  const revisao = Math.min((blockOrder - 1) * 2, 10);

  // New items shrink as the user repeats the block; after 3+ sessions on same block, all are familiar
  const sessionsOnBlock = sessionsDone % Math.max(blockOrder, 1);
  const novo  = Math.max(totalInBlock - Math.min(sessionsOnBlock, totalInBlock), 0);

  // Speaking items = block total minus what's still new
  const fala  = totalInBlock - novo;

  return { novo, fala, revisao };
}

export async function buildLiveSession(userId: string): Promise<{ sessionId: string; languagePairId: string; startingBlockOrder: number; totalBlocks: number; summary: SessionSummary; }> {
  const { source, target } = await getLanguagePairFromCookies();
  const blocksData = await getLocalBlocksData(source, target);
  const currentBlockOrder = await getBlockOrderFromCookies();
  
  // Find the queue items from the current block
  const currentBlock = blocksData.find((b: any) => b.order === currentBlockOrder) || blocksData[0] || { levels: [] };
  const items = currentBlock.levels.map((level: any, index: number) => ({
    memoryId: `mem-${index}`,
    sentenceId: `sent-${index}`,
    blockId: currentBlock.slug || "mocked-block",
    blockTitle: currentBlock.title || "Current block",
    prompt: level.translation || level.text,  // Show translation as prompt (native language hint)
    expectedText: level.text,                 // The sentence they need to speak/learn
    sourceGloss: level.translation || level.text,
    imageHint: level.image_hint || "Use a simple contextual visual here.",
    imageUrl: `/blocks/bl${String(currentBlockOrder).padStart(3, "0")}-l${index + 1}.webp`,
    audioUrl: undefined,
    strength: Math.random() > 0.5 ? 0.8 : undefined,
    fluencyScore: Math.random() > 0.5 ? 0.9 : undefined,
    queueReason: "new_content",
    suggestedExercise: "speak"
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
      items
    }
  };
}
