"use client";

import { useState } from "react";

const SEEN_KEY = "ola_classroom_seen_v1";

export function hasSeenClassroomTutorial(): boolean {
  if (typeof window === "undefined") return true;
  return !!localStorage.getItem(SEEN_KEY);
}

export function markClassroomTutorialSeen() {
  if (typeof window !== "undefined") {
    localStorage.setItem(SEEN_KEY, "1");
  }
}

interface Step {
  title: string;
  body: string;
  icon: string;
  highlight: "left" | "center" | "right" | null;
  iconBg: string;
  iconColor: string;
}

const steps: Step[] = [
  {
    title: "Sua sala de aula 🎓",
    body: "Veja rapidamente como funciona antes de começar. Vai levar 30 segundos!",
    icon: "school",
    highlight: null,
    iconBg: "bg-primary/15",
    iconColor: "text-primary",
  },
  {
    title: "Ouça a pronúncia",
    body: "O áudio toca automaticamente em cada frase. Toque no botão para repetir quantas vezes quiser.",
    icon: "volume_up",
    highlight: "left",
    iconBg: "bg-primary/15",
    iconColor: "text-primary",
  },
  {
    title: "Segure e fale",
    body: "Pressione e SEGURE o microfone enquanto você fala. Solte ao terminar. Repita para melhorar!",
    icon: "mic",
    highlight: "center",
    iconBg: "bg-primary/15",
    iconColor: "text-primary",
  },
  {
    title: "Avance quando pronto",
    body: "Depois de falar, a seta fica VERDE. Toque nela para ir à próxima frase.",
    icon: "skip_next",
    highlight: "right",
    iconBg: "bg-secondary/15",
    iconColor: "text-secondary",
  },
];

function MiniUIPreview() {
  return (
    <div className="bg-surface-container rounded-2xl p-5 mb-2 flex flex-col items-center gap-4">
      {/* Image placeholder */}
      <div className="w-24 h-24 bg-primary/10 rounded-xl flex items-center justify-center">
        <span className="material-symbols-outlined text-4xl text-primary/30">image</span>
      </div>
      {/* Text placeholders */}
      <div className="space-y-2 w-full text-center">
        <div className="h-2 bg-on-surface/10 rounded-full w-1/2 mx-auto" />
        <div className="h-5 bg-on-surface/20 rounded-full w-4/5 mx-auto" />
      </div>
      {/* Buttons mini-layout */}
      <div className="flex items-center gap-3 pt-1">
        <div className="w-9 h-9 bg-surface-container-highest rounded-full flex items-center justify-center">
          <span className="material-symbols-outlined text-sm text-primary">volume_up</span>
        </div>
        <div className="w-14 h-14 bg-gradient-to-br from-primary to-primary-dim rounded-full flex items-center justify-center shadow-lg">
          <span className="material-symbols-outlined text-xl text-on-primary" style={{ fontVariationSettings: "'FILL' 1" }}>mic_none</span>
        </div>
        <div className="w-9 h-9 bg-surface-container-highest rounded-full flex items-center justify-center">
          <span className="material-symbols-outlined text-sm text-on-surface-variant">skip_next</span>
        </div>
      </div>
    </div>
  );
}

function ButtonBar({ highlight }: { highlight: "left" | "center" | "right" }) {
  const isLeft   = highlight === "left";
  const isCenter = highlight === "center";
  const isRight  = highlight === "right";

  return (
    <div className="flex items-center justify-center gap-4 mb-2 py-4">
      {/* Sound button */}
      <div className="flex flex-col items-center gap-1.5">
        <div className={`w-12 h-12 rounded-full flex items-center justify-center transition-all duration-300 ${
          isLeft
            ? "bg-primary text-on-primary shadow-[0_0_20px_rgba(163,166,255,0.5)] scale-125"
            : "bg-surface-container text-on-surface-variant opacity-30"
        }`}>
          <span className="material-symbols-outlined text-xl" style={{ fontVariationSettings: "'FILL' 1" }}>volume_up</span>
        </div>
        {isLeft && (
          <span className="text-[10px] font-black text-primary uppercase tracking-wider animate-pulse">← aqui</span>
        )}
      </div>

      {/* Mic button */}
      <div className="flex flex-col items-center gap-1.5">
        <div className={`w-[72px] h-[72px] rounded-full flex items-center justify-center transition-all duration-300 ${
          isCenter
            ? "bg-gradient-to-br from-primary to-primary-dim text-on-primary shadow-[0_0_25px_rgba(163,166,255,0.6)] scale-110"
            : "bg-surface-container text-on-surface-variant opacity-30"
        }`}>
          <span className="material-symbols-outlined text-2xl" style={{ fontVariationSettings: "'FILL' 1" }}>mic_none</span>
        </div>
        {isCenter && (
          <span className="text-[10px] font-black text-primary uppercase tracking-wider animate-pulse">segure aqui</span>
        )}
      </div>

      {/* Skip button */}
      <div className="flex flex-col items-center gap-1.5">
        <div className={`w-12 h-12 rounded-full flex items-center justify-center transition-all duration-300 ${
          isRight
            ? "bg-secondary text-on-secondary shadow-[0_0_20px_rgba(0,220,180,0.4)] scale-125"
            : "bg-surface-container text-on-surface-variant opacity-30"
        }`}>
          <span className="material-symbols-outlined text-xl" style={{ fontVariationSettings: isRight ? "'FILL' 1" : "'FILL' 0" }}>skip_next</span>
        </div>
        {isRight && (
          <span className="text-[10px] font-black text-secondary uppercase tracking-wider animate-pulse">aqui →</span>
        )}
      </div>
    </div>
  );
}

export function ClassroomTutorial({ onComplete }: { onComplete: () => void }) {
  const [step, setStep] = useState(0);
  const [fading, setFading] = useState(false);

  const current = steps[step];
  const isLast  = step === steps.length - 1;

  function advance() {
    if (fading) return;
    if (isLast) {
      markClassroomTutorialSeen();
      onComplete();
      return;
    }
    setFading(true);
    setTimeout(() => {
      setStep(s => s + 1);
      setFading(false);
    }, 180);
  }

  function skip() {
    markClassroomTutorialSeen();
    onComplete();
  }

  return (
    <div
      className="fixed inset-0 z-[60] flex flex-col items-center justify-end pb-8 px-5"
      style={{ background: "rgba(0,0,0,0.88)", backdropFilter: "blur(6px)" }}
      onClick={advance}
    >
      {/* Step dots */}
      <div className="flex gap-2 mb-5">
        {steps.map((_, i) => (
          <div
            key={i}
            className={`h-1.5 rounded-full transition-all duration-300 ${
              i === step
                ? "w-8 bg-primary"
                : i < step
                ? "w-3 bg-primary/40"
                : "w-3 bg-surface-container-high"
            }`}
          />
        ))}
      </div>

      {/* Card */}
      <div
        className={`w-full max-w-md bg-surface-container-low rounded-[2rem] p-7 shadow-2xl border border-outline-variant/10 transition-all duration-180 ${
          fading ? "opacity-0 scale-[0.98]" : "opacity-100 scale-100"
        }`}
        onClick={(e) => e.stopPropagation()}
        style={{ transition: "opacity 0.18s, transform 0.18s" }}
      >
        {/* Welcome preview or button highlight */}
        {current.highlight === null ? (
          <MiniUIPreview />
        ) : (
          <ButtonBar highlight={current.highlight} />
        )}

        {/* Icon + Title */}
        <div className="flex items-center gap-4 mb-4">
          <div className={`w-14 h-14 rounded-2xl ${current.iconBg} flex items-center justify-center shrink-0`}>
            <span
              className={`material-symbols-outlined text-3xl ${current.iconColor}`}
              style={{ fontVariationSettings: "'FILL' 1" }}
            >
              {current.icon}
            </span>
          </div>
          <h2 className="text-xl font-black text-on-surface leading-tight">{current.title}</h2>
        </div>

        <p className="text-on-surface-variant text-sm leading-relaxed mb-7">{current.body}</p>

        {/* Actions */}
        <div className="flex items-center gap-3">
          <button
            onClick={skip}
            className="text-sm text-on-surface-variant hover:text-on-surface transition-colors py-3 px-3"
          >
            Pular
          </button>
          <button
            onClick={advance}
            className={`flex-1 font-bold py-4 rounded-full transition-all active:scale-95 flex items-center justify-center gap-2 text-sm ${
              isLast
                ? "bg-secondary text-on-secondary shadow-[0_0_30px_rgba(0,220,180,0.25)]"
                : "bg-gradient-to-br from-primary to-primary-container text-on-primary"
            }`}
          >
            {isLast ? (
              <>
                <span className="material-symbols-outlined text-[20px]" style={{ fontVariationSettings: "'FILL' 1" }}>play_arrow</span>
                Começar sessão!
              </>
            ) : (
              <>
                Próximo
                <span className="material-symbols-outlined text-[18px]">arrow_forward</span>
              </>
            )}
          </button>
        </div>

        {step === 0 && (
          <p className="text-center text-xs text-on-surface-variant/50 mt-3">
            toque em qualquer lugar para avançar
          </p>
        )}
      </div>
    </div>
  );
}
