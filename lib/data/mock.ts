import { BlockSummary, LanguageOption, SessionSummary, UserProfile } from "@/lib/contracts/domain";

export const languageOptions: LanguageOption[] = [
  { code: "en", name: "English", nativeName: "English" },
  { code: "pt-BR", name: "Portuguese (Brazil)", nativeName: "Português (Brasil)" },
  { code: "es", name: "Spanish", nativeName: "Español" },
  { code: "it", name: "Italian", nativeName: "Italiano" },
  { code: "fr", name: "French", nativeName: "Français" },
  { code: "de", name: "German", nativeName: "Deutsch" },
];

export const mockUser: UserProfile = {
  id: "user_demo_1",
  displayName: "Max",
  sourceLanguage: "en",
  targetLanguage: "pt-BR",
  currentBlockOrder: 3,
  streakDays: 6
};

export const mockBlocks: BlockSummary[] = Array.from({ length: 12 }, (_, index) => ({
  id: `block_${index + 1}`,
  order: index + 1,
  slug: `block-${index + 1}`,
  title: [
    "Want & Need",
    "Go & Move",
    "Food & Water",
    "Time & Waiting",
    "Ask & Understand",
    "Home & Place",
    "Help & Work",
    "Speak & Listen",
    "Feel & Reason",
    "Pay & Buy",
    "Find & Way",
    "Today & Tomorrow"
  ][index] ?? `Block ${index + 1}`,
  phase: index < 3 ? "survival" : index < 6 ? "expansion" : index < 9 ? "conversation" : "fluency",
  status: index + 1 < 3 ? "completed" : index + 1 === 3 ? "active" : "locked",
  completionPercent: index + 1 < 3 ? 100 : index + 1 === 3 ? 42 : 0
}));

export const mockSession: SessionSummary = {
  sessionId: "session_demo_1",
  totalItems: 4,
  targetMinutes: 15,
  items: [
    {
      sentenceId: "sent_001",
      blockId: "block_3",
      blockTitle: "Food & Water",
      prompt: "Say this in Portuguese.",
      expectedText: "Eu quero água agora.",
      sourceGloss: "I want water now.",
      imageHint: "A traveler asking for water at a café.",
      queueReason: "urgent_review",
      suggestedExercise: "listen_repeat",
      strength: 62,
      fluencyScore: 49
    },
    {
      sentenceId: "sent_002",
      blockId: "block_3",
      blockTitle: "Food & Water",
      prompt: "How do you say this from memory?",
      expectedText: "Nós precisamos comprar comida.",
      sourceGloss: "We need to buy food.",
      imageHint: "A person looking at groceries and a wallet.",
      queueReason: "review",
      suggestedExercise: "recall",
      strength: 54,
      fluencyScore: 58
    },
    {
      sentenceId: "sent_003",
      blockId: "block_4",
      blockTitle: "Time & Waiting",
      prompt: "Shadow the audio.",
      expectedText: "Eu espero por você.",
      sourceGloss: "I wait for you.",
      imageHint: "A person waiting at a station.",
      queueReason: "fluency_training",
      suggestedExercise: "shadowing",
      strength: 70,
      fluencyScore: 38
    },
    {
      sentenceId: "sent_004",
      blockId: "block_4",
      blockTitle: "Time & Waiting",
      prompt: "Build the sentence.",
      expectedText: "É hora de falar.",
      sourceGloss: "It is time to speak.",
      imageHint: "A person with a microphone preparing to speak.",
      queueReason: "new_content",
      suggestedExercise: "build_sentence"
    }
  ]
};
