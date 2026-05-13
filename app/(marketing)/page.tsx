"use client";
import Link from "next/link";
import { HeaderActions } from "@/components/ola/header-actions";
import { useLanguage } from "@/lib/i18n-context";

export default function LandingPage() {
  const { t } = useLanguage();

  return (
    <div className="bg-surface text-on-surface font-sans overflow-x-hidden">
      {/* ── TopAppBar ── */}
      <nav className="bg-transparent fixed top-0 w-full z-50">
        <div className="flex justify-between items-center w-full px-6 py-4 max-w-7xl mx-auto">
          <div className="text-primary font-bold tracking-[0.3em] uppercase text-sm md:text-base">
            {t("nav.brand")}
          </div>
          <div className="flex items-center gap-4">
            <HeaderActions dropdown />
            <Link
              href="/auth/login"
              className="px-6 py-2.5 rounded-full bg-surface-container-high/70 backdrop-blur-md text-on-surface font-semibold text-sm hover:bg-surface-container-highest transition-all active:scale-95"
            >
              {t("nav.signin")}
            </Link>
          </div>
        </div>
      </nav>

      {/* ── Hero Section ── */}
      <main className="relative min-h-screen flex flex-col items-center justify-center px-6 pt-20 pb-32 hero-gradient">
        <div className="max-w-4xl w-full text-center flex flex-col items-center gap-8">
          {/* Decorative blurs */}
          <div className="absolute -top-10 -left-20 w-96 h-96 bg-primary/5 rounded-full blur-[100px] pointer-events-none" />
          <div className="absolute top-1/2 -right-20 w-80 h-80 bg-secondary/5 rounded-full blur-[80px] pointer-events-none" />



          {/* Main Display Heading */}
          <h1 className="font-headline font-black text-5xl md:text-7xl lg:text-8xl tracking-tighter leading-[0.9] text-on-surface max-w-3xl">
            OLA <br />
            <span className="text-primary italic">{t("hero.title")}</span> <br />
            {t("hero.title2")}
          </h1>

          {/* Subtitle */}
          <p className="text-on-surface-variant text-lg md:text-xl max-w-xl leading-relaxed font-medium">
            {t("hero.subtitle")}
          </p>

          {/* CTA Cluster */}
          <div className="flex flex-col sm:flex-row items-center gap-4 mt-4 w-full justify-center">
            <Link
              href="/auth/login"
              className="w-full sm:w-auto px-10 py-5 rounded-full bg-gradient-to-br from-primary to-primary-container text-on-primary font-bold text-lg inner-glow transition-all hover:opacity-90 active:scale-95"
            >
              {t("hero.cta_start")}
            </Link>
            <Link
              href="/auth/login"
              className="w-full sm:w-auto px-10 py-5 rounded-full bg-surface-container-high/70 backdrop-blur-md text-on-surface font-semibold text-lg hover:bg-surface-container-highest transition-all active:scale-95"
            >
              {t("hero.cta_account")}
            </Link>
          </div>

          {/* Features Bento */}
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mt-16 w-full max-w-5xl">
            <FeatureCard
              icon="menu_book"
              color="primary"
              title={t("feature1.title")}
              description={t("feature1.desc")}
            />
            <FeatureCard
              icon="timer"
              color="secondary"
              title={t("feature2.title")}
              description={t("feature2.desc")}
            />
            <FeatureCard
              icon="psychology"
              color="tertiary"
              title={t("feature3.title")}
              description={t("feature3.desc")}
            />
          </div>
        </div>
      </main>

      {/* ── Scientific Pillars Section ── */}
      <section className="w-full max-w-7xl mx-auto px-6 pt-16 pb-24 border-t border-outline-variant/10">
        <div className="text-center mb-20">
          <span className="text-primary font-bold uppercase tracking-[0.2em] text-sm">{t("method.subtitle")}</span>
          <h2 className="text-4xl md:text-6xl font-black text-on-surface mt-4 tracking-tight">
            {t("method.title")}
          </h2>
          <p className="text-on-surface-variant text-lg mt-6 max-w-3xl mx-auto font-medium">
            {t("method.desc")}
          </p>
        </div>
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          <PillarCard
            number="01"
            icon="auto_awesome"
            color="primary"
            title={t("pillar1.title")}
            description={t("pillar1.desc")}
          />
          <PillarCard
            number="02"
            icon="analytics"
            color="secondary"
            title={t("pillar2.title")}
            description={t("pillar2.desc")}
          />
          <PillarCard
            number="03"
            icon="fitness_center"
            color="tertiary"
            title={t("pillar3.title")}
            description={t("pillar3.desc")}
          />
        </div>
      </section>

      {/* ── Science / Philosophy Section ── */}
      <section className="w-full max-w-7xl mx-auto px-6 py-24 border-t border-outline-variant/10">
        <div className="text-center mb-20">
          <span className="text-secondary font-bold uppercase tracking-[0.2em] text-sm">{t("science.label")}</span>
          <h2 className="text-4xl md:text-6xl font-black text-on-surface mt-4 tracking-tight max-w-3xl mx-auto">
            {t("science.title")}
          </h2>
          <p className="text-on-surface-variant text-lg mt-6 max-w-2xl mx-auto font-medium">
            {t("science.desc")}
          </p>
        </div>

        {/* Philosopher Cards */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-16">
          <ThinkerCard
            color="primary"
            initial="K"
            name={t("science.krashen.name")}
            role={t("science.krashen.role")}
            principles={[
              { title: t("science.krashen.p1.title"), desc: t("science.krashen.p1.desc"), icon: "input" },
              { title: t("science.krashen.p2.title"), desc: t("science.krashen.p2.desc"), icon: "sentiment_calm" },
            ]}
          />
          <ThinkerCard
            color="secondary"
            initial="T"
            name={t("science.thomas.name")}
            role={t("science.thomas.role")}
            principles={[
              { title: t("science.thomas.p1.title"), desc: t("science.thomas.p1.desc"), icon: "construction" },
              { title: t("science.thomas.p2.title"), desc: t("science.thomas.p2.desc"), icon: "mic" },
            ]}
          />
        </div>

        {/* Ebbinghaus + Learning Pyramid row */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
          {/* Forgetting Curve */}
          <div className="bg-surface-container-low rounded-2xl p-10 ghost-border space-y-6">
            <div>
              <span className="text-xs font-bold uppercase tracking-[0.2em] text-tertiary">{t("science.forgetting.label")}</span>
              <h3 className="text-2xl font-black text-on-surface mt-3">{t("science.forgetting.title")}</h3>
            </div>
            <div className="grid grid-cols-3 gap-4">
              {[
                { value: t("science.forgetting.stat1.value"), label: t("science.forgetting.stat1.label") },
                { value: t("science.forgetting.stat2.value"), label: t("science.forgetting.stat2.label") },
                { value: t("science.forgetting.stat3.value"), label: t("science.forgetting.stat3.label") },
              ].map(({ value, label }) => (
                <div key={label} className="bg-surface-container rounded-xl p-4 text-center">
                  <p className="text-3xl font-black text-tertiary">{value}</p>
                  <p className="text-xs text-on-surface-variant mt-1 leading-tight">{label}</p>
                </div>
              ))}
            </div>
            <p className="text-on-surface-variant text-sm leading-relaxed border-l-2 border-tertiary/40 pl-4 italic">
              {t("science.forgetting.answer")}
            </p>
          </div>

          {/* Learning Pyramid */}
          <div className="bg-surface-container-low rounded-2xl p-10 ghost-border space-y-6 flex flex-col justify-between">
            <div>
              <span className="text-xs font-bold uppercase tracking-[0.2em] text-primary">Learning Pyramid · NTL Institute</span>
              <div className="flex items-end gap-4 mt-6">
                <p className="text-8xl font-black text-primary leading-none">{t("science.pyramid.stat")}</p>
                <div className="pb-2 space-y-1">
                  <p className="text-on-surface font-bold text-lg leading-tight">{t("science.pyramid.stat.label")}</p>
                  <p className="text-on-surface-variant text-sm">{t("science.pyramid.stat.vs")}</p>
                </div>
              </div>
            </div>
            <p className="text-on-surface-variant text-sm leading-relaxed border-l-2 border-primary/40 pl-4 italic">
              {t("science.pyramid.desc")}
            </p>
          </div>
        </div>
      </section>

      {/* ── Phonetic Precision Section ── */}
      <section className="w-full max-w-7xl mx-auto px-6 py-24">
        <div className="relative overflow-hidden rounded-xl bg-surface-container-low min-h-[400px] flex items-center">
          <div className="grid md:grid-cols-2 gap-12 p-12 items-center w-full">
            <div className="space-y-6">
              <span className="text-secondary font-bold uppercase tracking-widest text-xs">
                {t("precision.subtitle")}
              </span>
              <h2 className="text-4xl md:text-5xl font-black text-on-surface leading-tight">
                {t("precision.title1")} <br />
                <span className="text-outline">{t("precision.title2")}</span>
              </h2>
              <p className="text-on-surface-variant text-lg">
                {t("precision.desc")}
              </p>
            </div>
            <div className="relative group">
              <div className="absolute -inset-1 bg-gradient-to-r from-primary to-secondary rounded-lg blur opacity-25 group-hover:opacity-40 transition duration-1000" />
              <div className="relative aspect-video bg-surface-container-highest rounded-lg flex items-center justify-center overflow-hidden">
                <div className="flex gap-1 items-end h-12">
                  {[4, 8, 12, 6, 10, 3].map((h, i) => (
                    <div
                      key={i}
                      className="w-1.5 bg-secondary rounded-full"
                      style={{ height: `${h * 4}px`, opacity: 0.3 + (h / 12) * 0.7 }}
                    />
                  ))}
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* ── Footer CTA ── */}
      <section className="w-full max-w-7xl mx-auto px-6 py-24 text-center">
        <h2 className="text-4xl md:text-5xl font-black text-on-surface tracking-tight">
          {t("footer.title")}
        </h2>
        <p className="text-on-surface-variant text-lg mt-4 max-w-xl mx-auto">
          {t("footer.desc")}
        </p>
        <Link
          href="/auth/login"
          className="inline-flex mt-8 px-12 py-5 rounded-full bg-gradient-to-br from-primary to-primary-container text-on-primary font-bold text-lg inner-glow transition-all hover:opacity-90 active:scale-95"
        >
          {t("footer.cta")}
        </Link>
      </section>
    </div>
  );
}

function FeatureCard({
  icon,
  color,
  title,
  description,
}: {
  icon: string;
  color: "primary" | "secondary" | "tertiary";
  title: string;
  description: string;
}) {
  const bg = { primary: "bg-primary/10 text-primary", secondary: "bg-secondary/10 text-secondary", tertiary: "bg-tertiary/10 text-tertiary" };
  return (
    <div className="bg-surface-container-high/60 backdrop-blur-xl p-8 rounded-lg flex flex-col items-start gap-4 text-left ghost-border">
      <div className={`w-12 h-12 rounded-full ${bg[color]} flex items-center justify-center`}>
        <span className="material-symbols-outlined">{icon}</span>
      </div>
      <div>
        <h3 className="text-on-surface font-bold text-xl">{title}</h3>
        <p className="text-on-surface-variant text-sm mt-1">{description}</p>
      </div>
    </div>
  );
}

function ThinkerCard({
  color,
  initial,
  name,
  role,
  principles,
}: {
  color: "primary" | "secondary";
  initial: string;
  name: string;
  role: string;
  principles: { title: string; desc: string; icon: string }[];
}) {
  const accent = {
    primary: { badge: "bg-primary/15 text-primary border-primary/20", border: "hover:border-primary/30", line: "bg-primary", dot: "bg-primary/20 text-primary" },
    secondary: { badge: "bg-secondary/15 text-secondary border-secondary/20", border: "hover:border-secondary/30", line: "bg-secondary", dot: "bg-secondary/20 text-secondary" },
  }[color];

  return (
    <div className={`group relative bg-surface-container-low rounded-2xl p-10 ghost-border ${accent.border} transition-all duration-500 overflow-hidden`}>
      <div className="absolute -top-8 -right-8 w-40 h-40 rounded-full bg-surface-container opacity-60 group-hover:opacity-100 transition-opacity" />
      <div className="relative z-10 space-y-8">
        {/* Header */}
        <div className="flex items-center gap-4">
          <div className={`w-14 h-14 rounded-full ${accent.badge} border flex items-center justify-center text-2xl font-black flex-shrink-0`}>
            {initial}
          </div>
          <div>
            <p className="text-on-surface font-black text-xl leading-tight">{name}</p>
            <p className="text-on-surface-variant text-xs mt-0.5">{role}</p>
          </div>
        </div>
        {/* Principles */}
        <div className="space-y-5">
          {principles.map(({ title, desc, icon }) => (
            <div key={title} className="flex gap-4">
              <div className={`w-9 h-9 rounded-lg ${accent.dot} flex items-center justify-center flex-shrink-0 mt-0.5`}>
                <span className="material-symbols-outlined text-lg">{icon}</span>
              </div>
              <div>
                <p className="text-on-surface font-bold text-sm">{title}</p>
                <p className="text-on-surface-variant text-sm mt-1 leading-relaxed">{desc}</p>
              </div>
            </div>
          ))}
        </div>
        <div className={`h-0.5 w-12 ${accent.line} rounded-full group-hover:w-full transition-all duration-700`} />
      </div>
    </div>
  );
}

function PillarCard({
  number,
  icon,
  color,
  title,
  description,
}: {
  number: string;
  icon: string;
  color: "primary" | "secondary" | "tertiary";
  title: string;
  description: string;
}) {
  const bg = { primary: "bg-primary/20 text-primary", secondary: "bg-secondary/20 text-secondary", tertiary: "bg-tertiary/20 text-tertiary" };
  const line = { primary: "bg-primary", secondary: "bg-secondary", tertiary: "bg-tertiary" };
  const border = { primary: "hover:border-primary/30", secondary: "hover:border-secondary/30", tertiary: "hover:border-tertiary/30" };
  const numColor = { primary: "", secondary: "text-secondary", tertiary: "text-tertiary" };

  return (
    <div className={`group relative bg-surface-container-low p-10 rounded-2xl ghost-border ${border[color]} transition-all duration-500 overflow-hidden`}>
      <div className="absolute top-0 right-0 p-6 opacity-10 group-hover:opacity-20 transition-opacity">
        <span className={`text-8xl font-black leading-none ${numColor[color]}`}>{number}</span>
      </div>
      <div className="relative z-10 space-y-6">
        <div className={`w-14 h-14 rounded-xl ${bg[color]} flex items-center justify-center`}>
          <span className="material-symbols-outlined text-3xl">{icon}</span>
        </div>
        <h3 className="text-2xl font-black text-on-surface">{title}</h3>
        <p className="text-on-surface-variant leading-relaxed">{description}</p>
        <div className={`h-1 w-12 ${line[color]} rounded-full group-hover:w-full transition-all duration-500`} />
      </div>
    </div>
  );
}
