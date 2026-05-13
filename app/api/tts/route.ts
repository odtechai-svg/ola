import { NextResponse } from "next/server";

type Gender = "female" | "male";

interface VoiceConfig {
  languageCode: string;
  name: string;
  ssmlGender: string;
}

const VOICE_MAP: Record<string, Record<Gender, VoiceConfig>> = {
  "en": {
    female: { languageCode: "en-US", name: "en-US-Neural2-F", ssmlGender: "FEMALE" },
    male:   { languageCode: "en-GB", name: "en-GB-Neural2-B", ssmlGender: "MALE" },
  },
  "es": {
    female: { languageCode: "es-ES", name: "es-ES-Neural2-E", ssmlGender: "FEMALE" },
    male:   { languageCode: "es-ES", name: "es-ES-Wavenet-B", ssmlGender: "MALE" },
  },
  "pt-BR": {
    female: { languageCode: "pt-BR", name: "pt-BR-Neural2-A", ssmlGender: "FEMALE" },
    male:   { languageCode: "pt-BR", name: "pt-BR-Neural2-B", ssmlGender: "MALE" },
  },
  "it": {
    female: { languageCode: "it-IT", name: "it-IT-Neural2-A", ssmlGender: "FEMALE" },
    male:   { languageCode: "it-IT", name: "it-IT-Neural2-C", ssmlGender: "MALE" },
  },
  "fr": {
    female: { languageCode: "fr-FR", name: "fr-FR-Neural2-C", ssmlGender: "FEMALE" },
    male:   { languageCode: "fr-FR", name: "fr-FR-Neural2-B", ssmlGender: "MALE" },
  },
  "de": {
    female: { languageCode: "de-DE", name: "de-DE-Neural2-C", ssmlGender: "FEMALE" },
    male:   { languageCode: "de-DE", name: "de-DE-Neural2-B", ssmlGender: "MALE" },
  },
};

export async function POST(request: Request) {
  const apiKey = process.env.GOOGLE_TTS_KEY;
  if (!apiKey) {
    return NextResponse.json({ error: "GOOGLE_TTS_KEY não configurada no .env.local" }, { status: 500 });
  }

  const body = await request.json();
  const text: string = body.text;
  const lang: string = body.lang || "pt-BR";
  const gender: Gender = body.gender === "male" ? "male" : "female";

  if (!text) {
    return NextResponse.json({ error: "Texto não fornecido" }, { status: 400 });
  }

  const voice: VoiceConfig =
    VOICE_MAP[lang]?.[gender] ?? VOICE_MAP["pt-BR"][gender];

  const googleRes = await fetch(
    `https://texttospeech.googleapis.com/v1/text:synthesize?key=${apiKey}`,
    {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        input: { text: text.substring(0, 5000) },
        voice: {
          languageCode: voice.languageCode,
          name: voice.name,
          ssmlGender: voice.ssmlGender,
        },
        audioConfig: {
          audioEncoding: "MP3",
          speakingRate: 1.0,
          pitch: 0.0,
        },
      }),
    }
  );

  const data = await googleRes.json();
  if (!googleRes.ok) {
    return NextResponse.json(
      { error: data.error?.message || "Erro na API do Google TTS" },
      { status: googleRes.status }
    );
  }

  return NextResponse.json({ audioContent: data.audioContent });
}
