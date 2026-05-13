import "jsr:@supabase/functions-js/edge-runtime.d.ts";

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};

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

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    const { text, lang, gender } = await req.json();
    const apiKey = Deno.env.get("GOOGLE_TTS_KEY");

    if (!apiKey) throw new Error("GOOGLE_TTS_KEY is not set");
    if (!text)   throw new Error("No text provided");

    const resolvedLang: string = lang || "pt-BR";
    const resolvedGender: Gender = gender === "male" ? "male" : "female";

    const voice: VoiceConfig =
      VOICE_MAP[resolvedLang]?.[resolvedGender] ??
      VOICE_MAP["pt-BR"][resolvedGender];

    const response = await fetch(
      `https://texttospeech.googleapis.com/v1/text:synthesize?key=${apiKey}`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          input: { text },
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

    const data = await response.json();
    if (!response.ok) throw new Error(data.error?.message || "Google API Error");

    return new Response(JSON.stringify({ audioContent: data.audioContent }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });

  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
