import { Shell } from "@/components/layout/shell";
import { requireUser } from "@/lib/server/auth";
import { createClient } from "@/lib/supabase/server";

export default async function ProgressPage() {
  const user = await requireUser();
  const supabase = await createClient();

  const { data: memoryRows } = await supabase
    .from("memory_items")
    .select("strength, fluency_score, review_stage")
    .eq("user_id", user.id);

  const total = memoryRows?.length ?? 0;
  const avgStrength = total
    ? Math.round(
        (memoryRows ?? []).reduce((sum, row) => sum + Number(row.strength), 0) /
          total
      )
    : 0;
  const avgFluency = total
    ? Math.round(
        (memoryRows ?? []).reduce(
          (sum, row) => sum + Number(row.fluency_score),
          0
        ) / total
      )
    : 0;
  const mastered = (memoryRows ?? []).filter(
    (row) => row.review_stage >= 5
  ).length;

  const stats = [
    { icon: "menu_book", value: total, label: "Tracked items", color: "primary" as const },
    { icon: "trending_up", value: avgStrength, label: "Average strength", color: "secondary" as const },
    { icon: "graphic_eq", value: avgFluency, label: "Average fluency", color: "tertiary" as const },
  ];

  return (
    <Shell>
      <div className="space-y-8">
        <div>
          <span className="text-primary font-bold uppercase tracking-[0.2em] text-sm">
            Analytics
          </span>
          <h1 className="mt-2 text-4xl md:text-5xl font-black tracking-tight text-on-surface">
            Your Progress
          </h1>
          <p className="mt-3 max-w-3xl text-on-surface-variant">
            Track your cognitive performance across vocabulary retention, pronunciation accuracy, and session streaks.
          </p>
        </div>

        <div className="grid gap-6 md:grid-cols-3">
          {stats.map((stat) => {
            const bg = {
              primary: "bg-primary/5 text-primary",
              secondary: "bg-secondary/5 text-secondary",
              tertiary: "bg-tertiary/5 text-tertiary",
            };
            return (
              <div
                key={stat.label}
                className="bg-surface-container-low p-8 rounded-lg ghost-border group hover:border-primary/20 transition-all"
              >
                <div className={`w-14 h-14 rounded-full ${bg[stat.color]} flex items-center justify-center mb-6`}>
                  <span
                    className="material-symbols-outlined text-2xl"
                    style={{ fontVariationSettings: "'FILL' 1" }}
                  >
                    {stat.icon}
                  </span>
                </div>
                <p className="text-5xl font-black text-on-surface">{stat.value}</p>
                <p className="text-sm text-on-surface-variant mt-2 uppercase tracking-wider font-bold">
                  {stat.label}
                </p>
              </div>
            );
          })}
        </div>

        {/* Mastered Section */}
        <div className="bg-surface-container-low p-8 rounded-lg ghost-border">
          <div className="flex items-center gap-6">
            <div className="w-16 h-16 rounded-full bg-secondary/10 flex items-center justify-center">
              <span
                className="material-symbols-outlined text-3xl text-secondary"
                style={{ fontVariationSettings: "'FILL' 1" }}
              >
                emoji_events
              </span>
            </div>
            <div>
              <p className="text-5xl font-black text-secondary">{mastered}</p>
              <p className="text-sm text-on-surface-variant mt-1 uppercase tracking-wider font-bold">
                Mastered items (review stage ≥ 5)
              </p>
            </div>
          </div>
          <div className="mt-6 h-2 w-full bg-surface-container-highest rounded-full overflow-hidden">
            <div
              className="h-full bg-gradient-to-r from-secondary-dim to-secondary rounded-full transition-all"
              style={{ width: total > 0 ? `${(mastered / total) * 100}%` : "0%" }}
            />
          </div>
        </div>
      </div>
    </Shell>
  );
}
