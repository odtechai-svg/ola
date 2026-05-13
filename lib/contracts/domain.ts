export type LanguageCode = "en" | "pt-BR" | "es" | "it" | "fr" | "de" | string;

export type LearningPhase =
  | "survival"
  | "expansion"
  | "conversation"
  | "fluency";

export type ExerciseType =
  | "listen_repeat"
  | "recall"
  | "build_sentence"
  | "shadowing";

export type QueueReason = "urgent_review" | "review" | "fluency_training" | "new_content";

export interface LanguageOption {
  code: LanguageCode;
  name: string;
  nativeName: string;
}

export interface UserProfile {
  id: string;
  displayName: string;
  sourceLanguage: LanguageCode;
  targetLanguage: LanguageCode;
  currentBlockOrder: number;
  streakDays: number;
}

export interface BlockSummary {
  id: string;
  order: number;
  slug: string;
  title: string;
  phase: LearningPhase;
  status: "locked" | "active" | "completed";
  completionPercent: number;
}

export interface SessionItem {
  memoryId?: string;
  sentenceId: string;
  blockId: string;
  blockTitle: string;
  prompt: string;
  expectedText: string;
  sourceGloss: string;
  imageHint: string;
  imageUrl?: string;
  audioUrl?: string;
  strength?: number;
  fluencyScore?: number;
  queueReason: QueueReason;
  suggestedExercise: ExerciseType;
}

export interface SessionSummary {
  sessionId: string;
  totalItems: number;
  targetMinutes: number;
  items: SessionItem[];
}

export interface SpeechEvaluation {
  transcript: string;
  speechScore: number;
  pronunciationScore: number;
  speedScore: number;
  finalScore: number;
  feedback: string;
  provider: "browser" | "whisper" | "llm";
}

export interface MemoryState {
  strength: number;
  fluencyScore: number;
  stability: number;
  easeFactor: number;
  reviewStage: number;
  successStreak: number;
  failureCount: number;
  nextReviewAt: string;
}

export interface AnalyticsEvent {
  name:
    | "signup_completed"
    | "language_pair_selected"
    | "session_started"
    | "item_presented"
    | "speech_recorded"
    | "speech_scored"
    | "memory_item_updated"
    | "block_completed";
  payload: Record<string, string | number | boolean | null>;
  at: string;
}
