import { Shell } from "@/components/layout/shell";
import { getCurrentUser } from "@/lib/server/auth";
import { getDashboardProfile } from "@/lib/server/queries";

export default async function ProgressPage() {
  const user = await getCurrentUser();
  const userId = user?.id || "anonymous";
  const { profile } = await getDashboardProfile(userId);

  const stats = [
    { icon: "menu_book",    value: profile?.sessionsDone ?? 0,  label: "Sessões completas", color: "primary"   as const },
    { icon: "trending_up",  value: profile?.avgScore ?? 0,      label: "Score médio",       color: "secondary" as const },
    { icon: "graphic_eq",   value: profile?.totalPhrases ?? 0,  label: "Frases praticadas", color: "tertiary"  as const },
  ];

  return (
    <Shell>
      <div className="space-y-8">
        <div>
          <span className="text-primary font-bold uppercase tracking-[0.2em] text-sm">Analytics</span>
          <h1 className="mt-2 text-4xl md:text-5xl font-black tracking-tight text-on-surface">
            Seu Progresso
          </h1>
          <p className="mt-3 max-w-3xl text-on-surface-variant">
            Acompanhe sua performance cognitiva: retenção de vocabulário, pronúncia e sequências de treino.
          </p>
        </div>

        <div className="grid gap-6 md:grid-cols-3">
          {stats.map((stat) => {
            const bg = {
              primary:   "bg-primary/5 text-primary",
              secondary: "bg-secondary/5 text-secondary",
              tertiary:  "bg-tertiary/5 text-tertiary",
            };
            return (
              <div key={stat.label} className="bg-surface-container-low p-8 rounded-lg ghost-border group hover:border-primary/20 transition-all">
                <div className={`w-14 h-14 rounded-full ${bg[stat.color]} flex items-center justify-center mb-6`}>
                  <span className="material-symbols-outlined text-2xl" style={{ fontVariationSettings: "'FILL' 1" }}>
                    {stat.icon}
                  </span>
                </div>
                <p className="text-5xl font-black text-on-surface">{stat.value}</p>
                <p className="text-sm text-on-surface-variant mt-2 uppercase tracking-wider font-bold">{stat.label}</p>
              </div>
            );
          })}
        </div>

        <div className="bg-surface-container-low p-8 rounded-lg ghost-border">
          <div className="flex items-center gap-6">
            <div className="w-16 h-16 rounded-full bg-secondary/10 flex items-center justify-center">
              <span className="material-symbols-outlined text-3xl text-secondary" style={{ fontVariationSettings: "'FILL' 1" }}>
                emoji_events
              </span>
            </div>
            <div>
              <p className="text-5xl font-black text-secondary">{profile?.wordsRepeated ?? 0}</p>
              <p className="text-sm text-on-surface-variant mt-1 uppercase tracking-wider font-bold">
                Palavras repetidas no total
              </p>
            </div>
          </div>
        </div>
      </div>
    </Shell>
  );
}
