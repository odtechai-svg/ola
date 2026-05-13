import { NextResponse } from "next/server";
import { scoreSpeech } from "@/lib/engines/speech-scoring";

export async function POST(request: Request) {
  const body = await request.json();
  const {
    sessionId,
    languagePairId,
    sentenceId,
    expectedText,
    transcript
  } = body;

  if (!sessionId || !languagePairId || !sentenceId || !expectedText) {
    return NextResponse.json({ error: "Missing required fields." }, { status: 400 });
  }

  const evaluation = scoreSpeech(expectedText, transcript || "");
  const recall = evaluation.finalScore;

  // Local Mock Logic: Just return the evaluation without trying to connect to Superbase
  const mockMemoryItem = {
    id: "mock-memory-" + Date.now(),
    strength: recall,
    fluency_score: evaluation.speechScore
  };

  return NextResponse.json({
    evaluation,
    memory: mockMemoryItem
  });
}
