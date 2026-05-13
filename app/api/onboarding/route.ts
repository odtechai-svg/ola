import { NextResponse } from "next/server";
import { cookies } from "next/headers";

export async function POST(request: Request) {
  const body = await request.json();
  const sourceLanguageCode = body.sourceLanguageCode as string;
  const targetLanguageCode = body.targetLanguageCode as string;

  if (!sourceLanguageCode || !targetLanguageCode || sourceLanguageCode === targetLanguageCode) {
    return NextResponse.json({ error: "Choose different source and target languages." }, { status: 400 });
  }

  // Validate the pair is supported
  const validPairs = [
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
  const pairKey = `${sourceLanguageCode}→${targetLanguageCode}`;
  if (!validPairs.includes(pairKey)) {
    return NextResponse.json({ error: `Language pair "${pairKey}" is not yet supported.` }, { status: 400 });
  }

  // Persist the language choice in cookies (local-only, no Supabase)
  const cookieStore = await cookies();
  cookieStore.set("ola_source_lang", sourceLanguageCode, {
    path: "/",
    maxAge: 60 * 60 * 24 * 365, // 1 year
    sameSite: "lax",
  });
  cookieStore.set("ola_target_lang", targetLanguageCode, {
    path: "/",
    maxAge: 60 * 60 * 24 * 365,
    sameSite: "lax",
  });

  return NextResponse.json({ ok: true, languagePairId: pairKey });
}
