import { ExerciseType, QueueReason, SessionItem } from "@/lib/contracts/domain";

export function chooseExercise(item: Pick<SessionItem, "fluencyScore" | "strength" | "suggestedExercise">): ExerciseType {
  if ((item.fluencyScore ?? 100) < 50) return "shadowing";
  if ((item.strength ?? 100) < 50) return "recall";
  return item.suggestedExercise;
}

export function prioritizeQueue(items: SessionItem[]): SessionItem[] {
  const priority: Record<QueueReason, number> = {
    urgent_review: 0,
    review: 1,
    fluency_training: 2,
    new_content: 3
  };

  return [...items].sort((a, b) => {
    const reasonGap = priority[a.queueReason] - priority[b.queueReason];
    if (reasonGap !== 0) return reasonGap;
    return (a.fluencyScore ?? 100) - (b.fluencyScore ?? 100);
  });
}
