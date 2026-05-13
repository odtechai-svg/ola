"use client";

import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { LanguageOption } from "@/lib/contracts/domain";
import { useLanguage, sourceLangToI18n } from "@/lib/i18n-context";

const VAPID_PUBLIC_KEY = process.env.NEXT_PUBLIC_VAPID_PUBLIC_KEY!;

function urlBase64ToUint8Array(base64String: string) {
  const padding = "=".repeat((4 - (base64String.length % 4)) % 4);
  const base64 = (base64String + padding).replace(/-/g, "+").replace(/_/g, "/");
  const rawData = window.atob(base64);
  return Uint8Array.from([...rawData].map((c) => c.charCodeAt(0)));
}

const flags: Record<string, string> = {
  en: "🇬🇧",
  "pt-BR": "🇧🇷",
  es: "🇪🇸",
  fr: "🇫🇷",
  de: "🇩🇪",
  it: "🇮🇹",
  ja: "🇯🇵",
  ko: "🇰🇷",
  zh: "🇨🇳",
};

export function OnboardingForm({
  languageOptions,
  defaultSource = "en",
  defaultTarget = "pt-BR",
  step = 1,
  totalSteps = 3,
}: {
  languageOptions: LanguageOption[];
  defaultSource?: string;
  defaultTarget?: string;
  step?: number;
  totalSteps?: number;
}) {
  const router = useRouter();
  const { t, setLanguage } = useLanguage();
  const [source, setSource] = useState(defaultSource);
  const [target, setTarget] = useState(defaultTarget);
  const [submitting, setSubmitting] = useState(false);
  const [message, setMessage] = useState<string | null>(null);
  const [currentStep, setCurrentStep] = useState<"source" | "target" | "notify">("source");
  const [notifyState, setNotifyState] = useState<"idle" | "loading" | "granted">("idle");
  const [pushSupported, setPushSupported] = useState(false);

  useEffect(() => {
    setPushSupported("serviceWorker" in navigator && "PushManager" in window && Notification.permission !== "denied");
  }, []);

  function handleSourceSelect(code: string) {
    setSource(code);
    // Immediately switch UI language to the selected native language
    setLanguage(sourceLangToI18n(code));
  }

  async function handleSubmit() {
    setSubmitting(true);
    setMessage(null);

    const response = await fetch("/api/onboarding", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ sourceLanguageCode: source, targetLanguageCode: target }),
    });
    const data = await response.json();
    setSubmitting(false);

    if (!response.ok) {
      setMessage(data.error ?? "Unable to save onboarding.");
      return;
    }

    router.push("/home");
    router.refresh();
  }

  async function handleEnableNotifications() {
    setNotifyState("loading");
    try {
      if ("serviceWorker" in navigator) {
        await navigator.serviceWorker.register("/sw.js");
      }
      const reg = await navigator.serviceWorker.ready;
      const sub = await reg.pushManager.subscribe({
        userVisibleOnly: true,
        applicationServerKey: urlBase64ToUint8Array(VAPID_PUBLIC_KEY),
      });
      await fetch("/api/push/subscribe", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ subscription: sub.toJSON() }),
      });
      setNotifyState("granted");
    } catch (err) {
      console.warn("Push subscribe failed:", err);
    }
    // proceed regardless of outcome
    await handleSubmit();
  }

  function handleContinue() {
    if (currentStep === "source") {
      setCurrentStep("target");
    } else if (currentStep === "target") {
      // Show notification step only if browser supports it and permission not yet granted
      if (pushSupported && Notification.permission === "default") {
        setCurrentStep("notify");
      } else {
        handleSubmit();
      }
    }
  }

  const currentOptions =
    currentStep === "source"
      ? languageOptions
      : languageOptions.filter((opt) => opt.code !== source);
  const selectedCode = currentStep === "source" ? source : target;
  const setSelected = currentStep === "source" ? handleSourceSelect : setTarget;

  const stepNumber = currentStep === "source" ? step : currentStep === "target" ? step + 1 : step + 2;

  return (
    <div className="space-y-8 relative">
      {/* Decorative blurs */}
      <div className="absolute -top-12 -left-20 w-64 h-64 bg-primary/5 rounded-full blur-[100px] pointer-events-none" />
      <div className="absolute top-1/2 -right-32 w-80 h-80 bg-secondary/5 rounded-full blur-[120px] pointer-events-none" />

      {/* Header */}
      <header className="mb-8 relative">
        <p className="text-[11px] font-bold tracking-[0.2em] text-on-surface-variant uppercase mb-4">
          {t("onboarding.step")} {stepNumber} {t("onboarding.of")} {totalSteps}
        </p>
        {currentStep !== "notify" && (
          <h1 className="text-4xl md:text-5xl font-extrabold tracking-tight text-on-surface leading-[1.1]">
            {currentStep === "source" ? (
              <>
                {t("onboarding.source.question")} <br />
                <span className="text-primary">{t("onboarding.source.highlight")}</span>
              </>
            ) : (
              <>
                {t("onboarding.target.question")} <br />
                <span className="text-primary">{t("onboarding.target.highlight")}</span>
              </>
            )}
          </h1>
        )}
      </header>

      {/* ── Notification Permission Step ── */}
      {currentStep === "notify" && (
        <div className="space-y-8 relative">
          <div className="text-center space-y-4">
            <div className="w-20 h-20 rounded-full bg-primary/10 flex items-center justify-center mx-auto">
              <span className="material-symbols-outlined text-4xl text-primary">notifications_active</span>
            </div>
            <h1 className="text-4xl font-extrabold tracking-tight text-on-surface">
              {t("onboarding.notify.title")}
            </h1>
            <p className="text-on-surface-variant">{t("onboarding.notify.subtitle")}</p>
          </div>

          <div className="space-y-3">
            {[
              { icon: "schedule",        key: "onboarding.notify.b1" },
              { icon: "local_fire_department", key: "onboarding.notify.b2" },
              { icon: "new_releases",    key: "onboarding.notify.b3" },
            ].map(({ icon, key }) => (
              <div key={key} className="flex items-center gap-4 bg-surface-container-low p-4 rounded-xl ghost-border">
                <span className="material-symbols-outlined text-primary text-xl shrink-0">{icon}</span>
                <p className="text-sm font-medium text-on-surface">{t(key)}</p>
              </div>
            ))}
          </div>

          <div className="flex flex-col gap-3">
            <button
              onClick={handleEnableNotifications}
              disabled={notifyState === "loading" || notifyState === "granted"}
              className="w-full bg-gradient-to-br from-primary to-primary-container text-on-primary font-bold text-lg py-5 rounded-full inner-glow hover:opacity-90 transition-all active:scale-[0.97] shadow-lg shadow-primary-dim/10 disabled:opacity-70 flex items-center justify-center gap-2"
            >
              <span className="material-symbols-outlined">
                {notifyState === "loading" ? "sync" : notifyState === "granted" ? "check_circle" : "notifications_active"}
              </span>
              {notifyState === "granted"
                ? t("onboarding.notify.granted")
                : notifyState === "loading"
                ? t("onboarding.saving")
                : t("onboarding.notify.enable")}
            </button>
            <button
              onClick={() => handleSubmit()}
              disabled={submitting}
              className="text-sm text-on-surface-variant hover:text-primary transition-colors py-2"
            >
              {t("onboarding.notify.skip")}
            </button>
          </div>
        </div>
      )}

      {/* Language Cards — only shown for source/target steps */}
      {currentStep !== "notify" && <section className="space-y-4 relative">
        {currentOptions.map((option) => {
          const isSelected = option.code === selectedCode;
          return (
            <button
              key={option.code}
              onClick={() => setSelected(option.code)}
              className="w-full text-left group transition-all duration-200 active:scale-[0.98]"
            >
              <div
                className={`rounded-lg p-6 flex items-center justify-between border-2 transition-colors ${
                  isSelected
                    ? "glass-card border-primary bg-primary/10 shadow-glow"
                    : "bg-surface-container-low hover:bg-surface-container-high border-transparent"
                }`}
              >
                <div className="flex items-center gap-5">
                  <div
                    className={`w-12 h-12 rounded-full bg-surface-container-highest flex items-center justify-center text-2xl ${
                      !isSelected ? "grayscale group-hover:grayscale-0 transition-all" : ""
                    }`}
                  >
                    {flags[option.code] ?? "🌐"}
                  </div>
                  <div>
                    <p
                      className={`text-xl font-bold ${
                        isSelected
                          ? "text-on-surface"
                          : "text-on-surface-variant group-hover:text-on-surface transition-colors"
                      }`}
                    >
                      {option.name}
                    </p>
                    <p
                      className={`text-sm ${
                        isSelected
                          ? "text-primary font-medium"
                          : "text-outline group-hover:text-on-surface-variant"
                      }`}
                    >
                      {isSelected && currentStep === "source"
                        ? t("onboarding.primary_lang")
                        : isSelected && currentStep === "target"
                        ? t("onboarding.target_lang")
                        : option.nativeName}
                    </p>
                  </div>
                </div>
                <div
                  className={`w-6 h-6 rounded-full flex items-center justify-center ${
                    isSelected
                      ? "bg-primary"
                      : "border-2 border-outline-variant group-hover:border-primary/50 transition-colors"
                  }`}
                >
                  {isSelected && (
                    <span
                      className="material-symbols-outlined text-[16px] text-on-primary font-bold"
                      style={{ fontVariationSettings: "'FILL' 1" }}
                    >
                      check
                    </span>
                  )}
                </div>
              </div>
            </button>
          );
        })}
      </section>}

      {/* Error */}
      {message && (
        <p className="rounded-2xl bg-error/10 p-4 text-sm text-error">{message}</p>
      )}

      {/* Footer Action — hidden on notify step (it has its own buttons) */}
      {currentStep !== "notify" && (
        <footer className="flex flex-col items-center gap-6 pt-4">
          <button
            onClick={handleContinue}
            disabled={submitting}
            className="w-full bg-gradient-to-br from-primary to-primary-container text-on-primary font-bold text-lg py-5 rounded-full inner-glow hover:opacity-90 transition-all active:scale-[0.97] shadow-lg shadow-primary-dim/10 disabled:opacity-60"
          >
            {submitting
              ? t("onboarding.saving")
              : currentStep === "source"
              ? t("onboarding.continue")
              : t("onboarding.start")}
          </button>
          {currentStep === "target" && (
            <button
              onClick={() => setCurrentStep("source")}
              className="text-sm text-on-surface-variant hover:text-primary transition-colors"
            >
              {t("onboarding.back")}
            </button>
          )}
          <p className="text-sm text-on-surface-variant/60 font-medium">
            {t("onboarding.change_hint")}{" "}
            <span className="text-on-surface-variant">{t("onboarding.settings")}</span>
          </p>
        </footer>
      )}
    </div>
  );
}
