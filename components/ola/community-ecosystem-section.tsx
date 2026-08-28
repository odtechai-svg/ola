"use client";

import { useState } from "react";
import Link from "next/link";
import { useLanguage } from "@/lib/i18n-context";

type FeedbackCategory = "bug" | "suggestion" | "opinion" | "feature";

export function CommunityEcosystemSection() {
  const { t } = useLanguage();
  const [category, setCategory] = useState<FeedbackCategory>("suggestion");
  const [message, setMessage] = useState("");
  const [email, setEmail] = useState("");
  const [name, setName] = useState("");
  const [status, setStatus] = useState<"idle" | "submitting" | "success" | "error">("idle");
  const [errorMessage, setErrorMessage] = useState("");

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!message.trim()) return;

    setStatus("submitting");
    setErrorMessage("");

    try {
      const res = await fetch("/api/feedback", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          category,
          message: message.trim(),
          email: email.trim() || undefined,
          name: name.trim() || undefined,
        }),
      });

      const data = await res.json();
      if (!res.ok) {
        throw new Error(data.error || "Erro ao enviar feedback.");
      }

      setStatus("success");
      setMessage("");
      setEmail("");
      setName("");
    } catch (err: any) {
      setStatus("error");
      setErrorMessage(err.message || "Não foi possível enviar agora. Tente novamente.");
    }
  };

  const categories: { id: FeedbackCategory; labelKey: string; icon: string }[] = [
    { id: "bug", labelKey: "feedback.cat.bug", icon: "bug_report" },
    { id: "suggestion", labelKey: "feedback.cat.suggestion", icon: "lightbulb" },
    { id: "opinion", labelKey: "feedback.cat.opinion", icon: "forum" },
    { id: "feature", labelKey: "feedback.cat.feature", icon: "add_task" },
  ];

  return (
    <footer className="w-full border-t border-outline-variant/15 mt-20 pt-16 pb-20 bg-surface-container-lowest/50 backdrop-blur-md">
      <div className="max-w-7xl mx-auto px-6 space-y-20">

        {/* ── 1. Feedback & Community Support Section ── */}
        <div className="relative bg-surface-container-low rounded-3xl p-8 md:p-12 ghost-border overflow-hidden shadow-2xl">
          <div className="absolute top-0 right-0 w-96 h-96 bg-primary/5 rounded-full blur-[120px] pointer-events-none" />
          <div className="absolute bottom-0 left-0 w-80 h-80 bg-secondary/5 rounded-full blur-[100px] pointer-events-none" />

          <div className="relative z-10 grid grid-cols-1 lg:grid-cols-12 gap-12 items-start">
            {/* Left Info Column */}
            <div className="lg:col-span-5 space-y-6">
              <div className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-primary/10 border border-primary/20 text-primary text-xs font-bold uppercase tracking-widest">
                <span className="material-symbols-outlined text-base">favorite</span>
                <span>{t("feedback.badge")}</span>
              </div>

              <h2 className="text-3xl md:text-4xl font-black text-on-surface tracking-tight leading-tight">
                {t("feedback.title")}
              </h2>

              <p className="text-on-surface-variant text-base leading-relaxed">
                {t("feedback.desc")}
              </p>

              <div className="p-4 rounded-2xl bg-surface-container/60 ghost-border space-y-2">
                <div className="flex items-center gap-2 text-primary font-bold text-sm">
                  <span className="material-symbols-outlined text-lg">mark_email_read</span>
                  <span>{t("feedback.direct_channel")}</span>
                </div>
                <p className="text-xs text-on-surface-variant leading-relaxed">
                  {t("feedback.direct_desc")}{" "}
                  <a
                    href="mailto:contato@odtechai.com"
                    className="text-primary hover:underline font-semibold"
                  >
                    contato@odtechai.com
                  </a>
                </p>
              </div>
            </div>

            {/* Right Form Column */}
            <div className="lg:col-span-7 bg-surface-container/80 p-6 md:p-8 rounded-2xl ghost-border shadow-inner">
              {status === "success" ? (
                <div className="py-10 text-center space-y-4">
                  <div className="w-16 h-16 rounded-full bg-primary/20 text-primary flex items-center justify-center mx-auto">
                    <span className="material-symbols-outlined text-4xl">check_circle</span>
                  </div>
                  <h3 className="text-2xl font-bold text-on-surface">{t("feedback.success.title")}</h3>
                  <p className="text-on-surface-variant text-sm max-w-md mx-auto">
                    {t("feedback.success.desc")}
                  </p>
                  <button
                    onClick={() => setStatus("idle")}
                    className="mt-4 px-6 py-2.5 rounded-full bg-surface-container-high text-on-surface font-semibold text-sm hover:bg-surface-container-highest transition-all"
                  >
                    {t("feedback.send_another")}
                  </button>
                </div>
              ) : (
                <form onSubmit={handleSubmit} className="space-y-6">
                  {/* Category Pills */}
                  <div className="space-y-2">
                    <label className="text-xs font-bold uppercase tracking-wider text-on-surface-variant">
                      {t("feedback.select_type")}
                    </label>
                    <div className="grid grid-cols-2 sm:grid-cols-4 gap-2">
                      {categories.map((cat) => {
                        const isSelected = category === cat.id;
                        return (
                          <button
                            key={cat.id}
                            type="button"
                            onClick={() => setCategory(cat.id)}
                            className={`flex items-center justify-center gap-2 px-3 py-2.5 rounded-xl text-xs font-bold transition-all ${
                              isSelected
                                ? "bg-primary text-on-primary shadow-md shadow-primary/20 scale-[1.02]"
                                : "bg-surface-container-high/60 text-on-surface-variant hover:bg-surface-container-highest hover:text-on-surface"
                            }`}
                          >
                            <span className="material-symbols-outlined text-sm">{cat.icon}</span>
                            <span>{t(cat.labelKey)}</span>
                          </button>
                        );
                      })}
                    </div>
                  </div>

                  {/* Textarea Message */}
                  <div className="space-y-2">
                    <label className="text-xs font-bold uppercase tracking-wider text-on-surface-variant">
                      {t("feedback.message_label")} <span className="text-primary">*</span>
                    </label>
                    <textarea
                      required
                      rows={4}
                      value={message}
                      onChange={(e) => setMessage(e.target.value)}
                      placeholder={t("feedback.placeholder")}
                      className="w-full bg-surface-container-lowest text-on-surface p-4 rounded-xl ghost-border focus:outline-none focus:ring-2 focus:ring-primary/50 text-sm leading-relaxed placeholder:text-on-surface-variant/40"
                    />
                  </div>

                  {/* Optional Email & Name Inputs */}
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <div className="space-y-1.5">
                      <label className="text-xs font-semibold text-on-surface-variant">
                        {t("feedback.name_label")} <span className="text-xs opacity-60">({t("feedback.optional")})</span>
                      </label>
                      <input
                        type="text"
                        value={name}
                        onChange={(e) => setName(e.target.value)}
                        placeholder="Ex: Maria Silva"
                        className="w-full bg-surface-container-lowest text-on-surface px-4 py-2.5 rounded-xl ghost-border focus:outline-none focus:ring-2 focus:ring-primary/50 text-sm"
                      />
                    </div>
                    <div className="space-y-1.5">
                      <label className="text-xs font-semibold text-on-surface-variant">
                        {t("feedback.email_label")} <span className="text-xs opacity-60">({t("feedback.optional")})</span>
                      </label>
                      <input
                        type="email"
                        value={email}
                        onChange={(e) => setEmail(e.target.value)}
                        placeholder="contato@exemplo.com"
                        className="w-full bg-surface-container-lowest text-on-surface px-4 py-2.5 rounded-xl ghost-border focus:outline-none focus:ring-2 focus:ring-primary/50 text-sm"
                      />
                    </div>
                  </div>

                  {/* Error Message Display */}
                  {status === "error" && (
                    <div className="p-3 rounded-xl bg-error/15 border border-error/30 text-error text-xs flex items-center gap-2">
                      <span className="material-symbols-outlined text-base">error</span>
                      <span>{errorMessage}</span>
                    </div>
                  )}

                  {/* Submit Button */}
                  <button
                    type="submit"
                    disabled={status === "submitting" || !message.trim()}
                    className="w-full py-4 rounded-xl bg-gradient-to-br from-primary to-primary-container text-on-primary font-bold text-sm tracking-wide uppercase inner-glow hover:opacity-90 transition-all active:scale-[0.99] disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2"
                  >
                    {status === "submitting" ? (
                      <>
                        <span className="material-symbols-outlined animate-spin text-lg">progress_activity</span>
                        <span>{t("feedback.sending")}</span>
                      </>
                    ) : (
                      <>
                        <span className="material-symbols-outlined text-lg">send</span>
                        <span>{t("feedback.submit_button")}</span>
                      </>
                    )}
                  </button>
                </form>
              )}
            </div>
          </div>
        </div>


        {/* ── 2. Free Charity Disclaimer & Ecosystem Cards ── */}
        <div className="space-y-10">
          <div className="text-center max-w-3xl mx-auto space-y-4">
            <div className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-tertiary/10 border border-tertiary/20 text-tertiary text-xs font-black tracking-widest uppercase">
              <span className="material-symbols-outlined text-sm">volunteer_activism</span>
              <span>{t("ecosystem.badge")}</span>
            </div>
            <h2 className="text-3xl md:text-5xl font-black text-on-surface tracking-tight">
              {t("ecosystem.title")}
            </h2>
            <p className="text-on-surface-variant text-base md:text-lg font-medium leading-relaxed">
              {t("ecosystem.subtitle")}
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            {/* Card 1: OLAlíngua */}
            <div className="relative bg-surface-container-low p-8 rounded-2xl ghost-border flex flex-col justify-between group hover:border-primary/40 transition-all duration-300">
              <div className="space-y-4">
                <div className="flex items-center gap-2">
                  <span className="px-2.5 py-1 rounded-md bg-primary/15 text-primary font-bold text-[10px] uppercase tracking-wider">
                    {t("ecosystem.free")}
                  </span>
                  <span className="px-2.5 py-1 rounded-md bg-surface-container-high text-on-surface-variant font-medium text-[10px] uppercase tracking-wider">
                    {t("ecosystem.education")}
                  </span>
                </div>
                <h3 className="text-2xl font-black text-on-surface flex items-center gap-2">
                  <span>OLAlíngua</span>
                  <span className="text-primary text-sm font-normal">★</span>
                </h3>
                <p className="text-on-surface-variant text-sm leading-relaxed">
                  {t("ecosystem.olalingua.desc")}
                </p>
              </div>
              <div className="mt-8 pt-4 border-t border-outline-variant/10">
                <span className="text-primary font-bold text-xs group-hover:translate-x-1 inline-flex items-center gap-1 transition-transform">
                  olalingua.com <span className="material-symbols-outlined text-sm">arrow_forward</span>
                </span>
              </div>
            </div>

            {/* Card 2: Fluxo Vital 369 */}
            <a
              href="https://www.fluxovital369.com.br/"
              target="_blank"
              rel="noopener noreferrer"
              className="relative bg-surface-container-low p-8 rounded-2xl ghost-border flex flex-col justify-between group hover:border-secondary/40 transition-all duration-300"
            >
              <div className="space-y-4">
                <div className="flex items-center gap-2">
                  <span className="px-2.5 py-1 rounded-md bg-secondary/15 text-secondary font-bold text-[10px] uppercase tracking-wider">
                    {t("ecosystem.free")}
                  </span>
                  <span className="px-2.5 py-1 rounded-md bg-surface-container-high text-on-surface-variant font-medium text-[10px] uppercase tracking-wider">
                    {t("ecosystem.health")}
                  </span>
                </div>
                <h3 className="text-2xl font-black text-on-surface">Fluxo Vital 369</h3>
                <p className="text-on-surface-variant text-sm leading-relaxed">
                  {t("ecosystem.fluxo.desc")}
                </p>
              </div>
              <div className="mt-8 pt-4 border-t border-outline-variant/10">
                <span className="text-secondary font-bold text-xs group-hover:translate-x-1 inline-flex items-center gap-1 transition-transform">
                  fluxovital369.com.br <span className="material-symbols-outlined text-sm">open_in_new</span>
                </span>
              </div>
            </a>

            {/* Card 3: Trilha da Consciência */}
            <a
              href="https://www.trilhadaconsciencia.com.br/"
              target="_blank"
              rel="noopener noreferrer"
              className="relative bg-surface-container-low p-8 rounded-2xl ghost-border flex flex-col justify-between group hover:border-tertiary/40 transition-all duration-300"
            >
              <div className="space-y-4">
                <div className="flex items-center gap-2">
                  <span className="px-2.5 py-1 rounded-md bg-tertiary/15 text-tertiary font-bold text-[10px] uppercase tracking-wider">
                    {t("ecosystem.free")}
                  </span>
                  <span className="px-2.5 py-1 rounded-md bg-surface-container-high text-on-surface-variant font-medium text-[10px] uppercase tracking-wider">
                    {t("ecosystem.human_dev")}
                  </span>
                </div>
                <h3 className="text-2xl font-black text-on-surface">Trilha da Consciência</h3>
                <p className="text-on-surface-variant text-sm leading-relaxed">
                  {t("ecosystem.trilha.desc")}
                </p>
              </div>
              <div className="mt-8 pt-4 border-t border-outline-variant/10">
                <span className="text-tertiary font-bold text-xs group-hover:translate-x-1 inline-flex items-center gap-1 transition-transform">
                  trilhadaconsciencia.com.br <span className="material-symbols-outlined text-sm">open_in_new</span>
                </span>
              </div>
            </a>
          </div>
        </div>


        {/* ── 3. ODTech AI B2B Spotlight Banner ── */}
        <div className="relative bg-gradient-to-br from-surface-container-high via-surface-container-low to-surface-container-lowest rounded-3xl p-8 md:p-12 ghost-border overflow-hidden shadow-2xl border border-primary/20">
          <div className="absolute -top-16 -right-16 w-80 h-80 bg-primary/10 rounded-full blur-[90px] pointer-events-none" />

          <div className="relative z-10 flex flex-col lg:flex-row items-center justify-between gap-8">
            <div className="space-y-4 max-w-2xl text-left">
              <div className="inline-flex items-center gap-2 px-3.5 py-1 rounded-full bg-primary/15 border border-primary/30 text-primary text-xs font-black tracking-widest uppercase">
                <span className="material-symbols-outlined text-sm">precision_manufacturing</span>
                <span>ODTech AI • Software & IA AI-First</span>
              </div>

              <h3 className="text-2xl md:text-4xl font-black text-on-surface tracking-tight">
                {t("odtech.title")}
              </h3>

              <p className="text-on-surface-variant text-sm md:text-base leading-relaxed font-medium">
                {t("odtech.desc")}
              </p>
            </div>

            <div className="flex flex-col sm:flex-row items-center gap-4 w-full lg:w-auto shrink-0">
              <a
                href="https://www.odtechai.com"
                target="_blank"
                rel="noopener noreferrer"
                className="w-full sm:w-auto px-8 py-4 rounded-full bg-gradient-to-br from-primary to-primary-container text-on-primary font-bold text-sm tracking-wide uppercase inner-glow hover:opacity-90 transition-all text-center flex items-center justify-center gap-2 shadow-lg shadow-primary/20"
              >
                <span>{t("odtech.cta_main")}</span>
                <span className="material-symbols-outlined text-base">arrow_forward</span>
              </a>
              <a
                href="mailto:contato@odtechai.com"
                className="w-full sm:w-auto px-6 py-4 rounded-full bg-surface-container-highest/80 text-on-surface font-semibold text-sm hover:bg-surface-container-highest transition-all text-center flex items-center justify-center gap-2"
              >
                <span>{t("odtech.cta_contact")}</span>
                <span className="material-symbols-outlined text-base">mail</span>
              </a>
            </div>
          </div>
        </div>

        {/* Footer copyright */}
        <div className="text-center text-xs text-on-surface-variant/40 font-medium tracking-wide">
          © {new Date().getFullYear()} OLA — Open Language Acquisition • Desenvolvido com IA por{" "}
          <a
            href="https://www.odtechai.com"
            target="_blank"
            rel="noopener noreferrer"
            className="hover:text-primary transition-colors underline"
          >
            odtechai.com
          </a>
        </div>

      </div>
    </footer>
  );
}
