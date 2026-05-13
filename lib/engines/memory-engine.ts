import { MemoryState } from "@/lib/contracts/domain";

export interface UpdateMemoryInput {
  current?: MemoryState;
  performance: number;
  speechScore: number;
}

function nextIntervalDays(strength: number): number {
  if (strength < 30) return 0.014; // ~20 minutes
  if (strength < 60) return 1;
  if (strength < 80) return 7;
  return 30;
}

export function createInitialMemoryState(): MemoryState {
  const next = new Date(Date.now() + 20 * 60 * 1000).toISOString();

  return {
    strength: 20,
    fluencyScore: 20,
    stability: 0.2,
    easeFactor: 2.5,
    reviewStage: 0,
    successStreak: 0,
    failureCount: 0,
    nextReviewAt: next
  };
}

export function updateMemoryState({ current = createInitialMemoryState(), performance, speechScore }: UpdateMemoryInput): MemoryState {
  const pass = performance >= 0.65;
  const nextStrength = Math.max(0, Math.min(100, current.strength + (pass ? 14 : -12) + performance * 10));
  const nextFluency = Math.max(0, Math.min(100, current.fluencyScore + (speechScore - 0.5) * 24));
  const nextStability = Math.max(0.1, current.stability + (pass ? 0.2 : -0.15));
  const nextEase = Math.max(1.3, current.easeFactor + (pass ? 0.08 : -0.2));
  const nextStage = Math.max(0, pass ? current.reviewStage + 1 : current.reviewStage - 1);
  const now = new Date();
  const intervalMs = nextIntervalDays(nextStrength) * 24 * 60 * 60 * 1000;

  return {
    strength: Number(nextStrength.toFixed(1)),
    fluencyScore: Number(nextFluency.toFixed(1)),
    stability: Number(nextStability.toFixed(2)),
    easeFactor: Number(nextEase.toFixed(2)),
    reviewStage: nextStage,
    successStreak: pass ? current.successStreak + 1 : 0,
    failureCount: pass ? current.failureCount : current.failureCount + 1,
    nextReviewAt: new Date(now.getTime() + intervalMs).toISOString()
  };
}
