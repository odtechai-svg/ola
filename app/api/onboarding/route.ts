import { NextResponse } from "next/server";
import { cookies } from "next/headers";
import { getCurrentUser } from "@/lib/server/auth";
import { createPbClient } from "@/lib/pocketbase/server";

const VALID_PAIRS = [
  "pt-BR→en", "en→pt-BR",
  "pt-BR→es", "es→pt-BR",
  "en→es",    "es→en",
  "pt-BR→it", "it→pt-BR",
  "en→it",    "it→en",
  "es→it",    "it→es",
  "pt-BR→fr", "fr→pt-BR",
  "en→fr",    "fr→en",
  "es→fr",    "fr→es",
  "it→fr",    "fr→it",
  "pt-BR→de", "de→pt-BR",
  "en→de",    "de→en",
  "es→de",    "de→es",
  "it→de",    "de→it",
  "fr→de",    "de→fr",
];

export async function POST(request: Request) {
  const body = await request.json();
  const sourceLanguageCode = body.sourceLanguageCode as string;
  const targetLanguageCode = body.targetLanguageCode as string;

  if (!sourceLanguageCode || !targetLanguageCode || sourceLanguageCode === targetLanguageCode) {
    return NextResponse.json({ error: "Choose different source and target languages." }, { status: 400 });
  }

  const pairKey = `${sourceLanguageCode}→${targetLanguageCode}`;
  if (!VALID_PAIRS.includes(pairKey)) {
    return NextResponse.json({ error: `Language pair "${pairKey}" is not yet supported.` }, { status: 400 });
  }

  const cookieOpts = { path: "/", maxAge: 60 * 60 * 24 * 365, sameSite: "lax" as const };
  const cookieStore = await cookies();
  cookieStore.set("ola_source_lang", sourceLanguageCode, cookieOpts);
  cookieStore.set("ola_target_lang", targetLanguageCode, cookieOpts);

  // For authenticated users: upsert the PB record for this language pair.
  // This "activates" the pair so that any device login (which reads the most
  // recently updated record) correctly restores the chosen language.
  const user = await getCurrentUser();
  if (user) {
    try {
      const pb = createPbClient(user.token);
      const existing = await pb.collection("user_progress").getList(1, 1, {
        filter: `user_id = "${user.id}" && source_lang = "${sourceLanguageCode}" && target_lang = "${targetLanguageCode}"`,
      });

      if (existing.items.length > 0) {
        // Touch the record — bumps `last_session_date` timestamp so login finds it first
        await pb.collection("user_progress").update(existing.items[0].id, {
          source_lang:       sourceLanguageCode,
          target_lang:       targetLanguageCode,
          last_session_date: new Date().toISOString(),
        });
      } else {
        // New language pair — create a fresh record
        await pb.collection("user_progress").create({
          user_id:            user.id,
          source_lang:        sourceLanguageCode,
          target_lang:        targetLanguageCode,
          block_order:        1,
          sessions_done:      0,
          total_phrases:      0,
          total_score_sum:    0,
          words_repeated:     0,
          streak_days:        0,
          blocks_today_count: 0,
          blocks_today_date:  "",
          last_session_date:  new Date().toISOString(),
        });
      }
    } catch (e) {
      console.error("[OLA] Failed to persist language pair to PB:", e);
    }
  }

  return NextResponse.json({ ok: true, languagePairId: pairKey });
}
