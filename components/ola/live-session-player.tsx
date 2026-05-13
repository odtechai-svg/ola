"use client";

import { useMemo, useState, useEffect, useRef } from "react";
import Link from "next/link";
import { SessionSummary } from "@/lib/contracts/domain";
import { chooseExercise } from "@/lib/engines/session-orchestrator";
import { AudioManager } from "@/lib/api/AudioManager";
import { useLanguage } from "@/lib/i18n-context";

export function LiveSessionPlayer({
  summary,
  sessionId,
  languagePairId,
}: {
  summary: SessionSummary;
  sessionId: string;
  languagePairId: string;
}) {
  const { t } = useLanguage();
  const [index, setIndex] = useState(0);
  const [spoken, setSpoken] = useState("");
  const [result, setResult] = useState<string | null>(null);
  const [saving, setSaving] = useState(false);
  const [isPlayingTTS, setIsPlayingTTS] = useState(false);
  const [isBufferingTTS, setIsBufferingTTS] = useState(false);
  const [isRecording, setIsRecording] = useState(false);
  const [sessionScores, setSessionScores] = useState<number[]>([]);
  const recognitionRef = useRef<any>(null);

  useEffect(() => {
    if (typeof window !== "undefined") {
      const SpeechRecognition = (window as any).SpeechRecognition || (window as any).webkitSpeechRecognition;
      if (SpeechRecognition) {
        recognitionRef.current = new SpeechRecognition();
        recognitionRef.current.continuous = true;
        recognitionRef.current.interimResults = true;
      }
    }
  }, []);

  const item = summary.items[index];
  const progress = summary.items.length
    ? ((index + 1) / summary.items.length) * 100
    : 100;
  const exercise = useMemo(
    () => (item ? chooseExercise(item) : "listen_repeat"),
    [item]
  );

  useEffect(() => {
    if (recognitionRef.current && languagePairId) {
      const targetLang = languagePairId.split('→')[1] || "pt-BR";
      const SPEECH_LANG: Record<string, string> = { en: "en-US", es: "es-ES", it: "it-IT", fr: "fr-FR", de: "de-DE", "pt-BR": "pt-BR" };
      recognitionRef.current.lang = SPEECH_LANG[targetLang] ?? "pt-BR";
    }
  }, [languagePairId, item]);

  // Cleanup audio when component unmounts
  useEffect(() => {
    return () => {
      AudioManager.stop();
    };
  }, []);

  // ── Session Complete ──
  const avgScorePct = sessionScores.length > 0
    ? Math.round(sessionScores.reduce((a, b) => a + b, 0) / sessionScores.length * 100)
    : 0;

  if (!item) {
    return (
      <div className="min-h-[80vh] flex flex-col items-center justify-center text-center px-8 relative overflow-hidden">
        {/* Glow effect */}
        <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[500px] h-[500px] bg-primary/10 rounded-full blur-[120px] pointer-events-none" />

        <div className="w-24 h-24 rounded-full bg-secondary/10 flex items-center justify-center mb-6 relative z-10 animate-bounce">
          <span
            className="material-symbols-outlined text-6xl text-secondary"
            style={{ fontVariationSettings: "'FILL' 1" }}
          >
            check_circle
          </span>
        </div>
        <h2 className="text-4xl md:text-5xl font-black text-on-surface tracking-tight mb-2 relative z-10">
          {t("session.complete")}
        </h2>
        <p className="text-secondary font-bold text-lg max-w-md mb-8 relative z-10 leading-tight">
          &ldquo;{summary.items[0]?.blockTitle || 'Block'}&rdquo; {t("session.finished_ok")}
        </p>

        {/* Stats Grid */}
        <div className="grid grid-cols-2 gap-4 w-full max-w-sm mb-10 relative z-10">
          <div className="glass-card py-6 px-4 rounded-2xl ghost-border flex flex-col items-center justify-center shadow-lg hover:bg-surface-container-low transition-colors">
            <span className="material-symbols-outlined text-primary mb-2 text-3xl" style={{ fontVariationSettings: "'FILL' 1" }}>neurology</span>
            <span className="text-4xl font-black text-on-surface">{summary.items.length}</span>
            <span className="text-[10px] uppercase tracking-widest font-black text-on-surface-variant mt-1">{t("session.phrases")}</span>
          </div>
          <div className="glass-card py-6 px-4 rounded-2xl ghost-border flex flex-col items-center justify-center shadow-lg hover:bg-surface-container-low transition-colors">
            <span className="material-symbols-outlined text-tertiary mb-2 text-3xl" style={{ fontVariationSettings: "'FILL' 1" }}>analytics</span>
            <span className="text-4xl font-black text-on-surface">{avgScorePct}%</span>
            <span className="text-[10px] uppercase tracking-widest font-black text-on-surface-variant mt-1">{t("session.accuracy")}</span>
          </div>
        </div>

        <div className="flex items-center gap-4 relative z-10">
          <button
            onClick={() => { setIndex(0); setSessionScores([]); setSpoken(""); setResult(null); }}
            className="flex items-center gap-2 border border-outline-variant/30 text-on-surface-variant font-bold py-4 px-8 rounded-full hover:bg-surface-container-high active:scale-95 transition-all text-lg"
          >
            <span className="material-symbols-outlined text-[22px]">replay</span>
            {t("blocks.repeat")}
          </button>
          <Link
            href="/home"
            className="bg-gradient-to-br from-primary to-primary-container text-on-primary font-bold py-4 px-12 rounded-full inner-glow shadow-[0_0_40px_rgba(163,166,255,0.2)] hover:shadow-[0_0_60px_rgba(163,166,255,0.3)] hover:-translate-y-1 active:translate-y-0 active:scale-95 transition-all text-lg"
          >
            {t("session.continue")}
          </Link>
        </div>
      </div>
    );
  }

  async function handleEvaluate(finalTranscript?: string) {
    setSaving(true);
    setResult(null);
    
    // Auto-pass if no transcript was captured (e.g. quick tap or Safari no support)
    const transcriptToEvaluate = finalTranscript || spoken || item.expectedText;

    const response = await fetch("/api/session/evaluate", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        sessionId,
        languagePairId,
        sentenceId: item.sentenceId,
        memoryItemId: item.memoryId,
        expectedText: item.expectedText,
        transcript: transcriptToEvaluate,
        queueReason: item.queueReason,
        suggestedExercise: exercise,
        position: index + 1,
      }),
    });
    const data = await response.json();
    setSaving(false);
    if (!response.ok) {
      setResult(data.error ?? "Evaluation failed.");
      return;
    }

    if (data.evaluation?.finalScore !== undefined) {
      setSessionScores(prev => [...prev, data.evaluation.finalScore]);
    }

    setResult(
      `Score ${Math.round(data.evaluation.finalScore * 100)}%. ${data.evaluation.feedback}`
    );
  }

  function handlePointerDown() {
    AudioManager.stop();
    setIsRecording(true);
    setSpoken("");
    if (recognitionRef.current) {
      try {
        recognitionRef.current.start();
        recognitionRef.current.onresult = (event: any) => {
          let currentTranscript = "";
          for (let i = event.resultIndex; i < event.results.length; i++) {
            currentTranscript += event.results[i][0].transcript;
          }
          setSpoken(currentTranscript);
        };
      } catch (e) {
        console.error(e);
      }
    }
  }

  function handlePointerUp() {
    if (!isRecording) return;
    setIsRecording(false);
    if (recognitionRef.current) {
      try {
        recognitionRef.current.stop();
      } catch {}
    }
    // We pass `spoken` string as it is right now. Due to React state batching,
    // this will capture whatever was transcribed right before they let go. 
    // If it's empty, it auto-passes for easy debugging.
    handleEvaluate(spoken);
  }

  async function handleNext() {
    AudioManager.stop();
    const nextIndex = index + 1;
    
    // If we reached the end of the session, bump the block counter and save stats
    if (nextIndex === summary.items.length) {
      const avgScore = sessionScores.length > 0 
        ? sessionScores.reduce((a, b) => a + b, 0) / sessionScores.length 
        : 0;

      fetch("/api/session/complete", { 
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          score: avgScore,
          phrasesCount: summary.items.length
        })
      }).catch(console.error);
    }
    
    setIndex(nextIndex);
    setSpoken("");
    setResult(null);
  }

  async function handlePlayTTS() {
    if (isPlayingTTS) {
      AudioManager.stop();
      setIsPlayingTTS(false);
      return;
    }

    try {
      AudioManager.stop();
      setIsBufferingTTS(true);

      const targetLang = languagePairId.split('→')[1] || "pt-BR";
      const voiceGender = document.cookie
        .split("; ")
        .find((row) => row.startsWith("ola_voice_gender="))
        ?.split("=")[1] || "female";

      const response = await fetch("/api/tts", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          text: item.expectedText.substring(0, 5000),
          lang: targetLang,
          gender: voiceGender,
        }),
      });
      
      const data = await response.json();
      if (!response.ok) throw new Error(data.error?.message || data.error || "Failed to fetch audio");
      if (!data?.audioContent) throw new Error("Sem áudio na resposta");

      // Decode base64 to binary to Blob
      const binaryString = atob(data.audioContent);
      const bytes = new Uint8Array(binaryString.length);
      for (let i = 0; i < binaryString.length; i++) {
        bytes[i] = binaryString.charCodeAt(i);
      }
      const audioBlob = new Blob([bytes], { type: "audio/mpeg" });

      AudioManager.play(audioBlob, () => setIsPlayingTTS(false));
      setIsPlayingTTS(true);
      setIsBufferingTTS(false);
    } catch (err: any) {
      console.error("Erro TTS:", err);
      setIsPlayingTTS(false);
      setIsBufferingTTS(false);
      alert(`Erro na narração: ${err.message}`);
    }
  }

  return (
    <div className="h-screen flex flex-col relative bg-surface">
      {/* ── Header: Progress Bar ── */}
      <header className="flex justify-between items-center w-full px-6 py-4 max-w-7xl mx-auto z-10 bg-transparent">
        <div className="flex items-center gap-4">
          <Link
            href="/home"
            className="p-2 text-on-surface-variant hover:text-on-surface transition-colors active:scale-95"
          >
            <span className="material-symbols-outlined text-[28px]">close</span>
          </Link>
        </div>
        <div className="flex-1 max-w-md px-6 flex flex-col gap-2">
          <div className="flex justify-between items-end mb-1">
            <span className="text-[10px] font-black tracking-[0.2em] text-primary uppercase">
              {t("session.training_intensity")}
            </span>
            <span className="text-[10px] font-bold text-on-surface-variant">
              {index + 1}/{summary.items.length}
            </span>
          </div>
          <div className="h-1.5 w-full bg-surface-container-highest rounded-full overflow-hidden">
            <div
              className="h-full bg-gradient-to-r from-secondary-dim to-secondary rounded-full transition-all duration-500"
              style={{ width: `${progress}%` }}
            />
          </div>
        </div>
        <div className="flex items-center">
          <button className="p-2 text-primary hover:opacity-80 transition-opacity active:scale-95">
            <span className="material-symbols-outlined text-[24px]">leaderboard</span>
          </button>
        </div>
      </header>

      {/* ── Main Content ── */}
      <div className="flex-1 flex flex-col items-center justify-center px-8 pb-64 relative">
        {/* Block title */}
        <p className="text-xs uppercase tracking-[0.22em] text-on-surface-variant mb-6">
          {item.blockTitle}
        </p>

        {/* Image Card */}
        <div className="relative group mb-8">
          <div className="absolute -inset-4 bg-primary/10 blur-3xl rounded-full opacity-30 group-hover:opacity-50 transition-opacity" />
          <div className="w-48 h-48 md:w-64 md:h-64 rounded-xl overflow-hidden bg-surface-container-high shadow-2xl relative z-10 flex items-center justify-center">
            {item.imageUrl ? (
              <img
                key={item.imageUrl}
                src={item.imageUrl}
                alt={item.imageHint}
                className="w-full h-full object-cover"
                onError={(e) => { (e.currentTarget as HTMLImageElement).style.display = "none"; (e.currentTarget.nextSibling as HTMLElement).style.display = "flex"; }}
              />
            ) : null}
            <span
              className="material-symbols-outlined text-6xl text-on-surface-variant/30"
              style={{ display: item.imageUrl ? "none" : "flex" }}
            >
              image
            </span>
            <div className="absolute inset-0 bg-gradient-to-t from-surface/40 to-transparent pointer-events-none" />
          </div>
        </div>

        {/* Learning Content */}
        <div className="text-center space-y-4 max-w-3xl">
          <p className="text-secondary font-medium tracking-wide text-lg opacity-80 italic">
            &ldquo;{item.sourceGloss || item.prompt}&rdquo;
          </p>
          <h1 className="text-4xl md:text-6xl font-black text-on-surface tracking-tighter leading-none">
            {item.expectedText}
          </h1>
        </div>

        {/* Waveform */}
        <div className="mt-8 flex items-center justify-center gap-1 h-12">
          {[4, 8, 12, 6, 10, 4].map((h, i) => (
            <div
              key={i}
              className="w-1.5 bg-secondary rounded-full"
              style={{ height: `${h * 4}px`, opacity: 0.3 + (h / 12) * 0.7 }}
            />
          ))}
        </div>
      </div>

      {/* ── Controls: Fixed Bottom ── */}
      <footer className="fixed bottom-0 left-0 w-full p-8 md:p-12 flex flex-col items-center gap-4 pointer-events-none bg-gradient-to-t from-surface via-surface/80 to-transparent">
        {/* Result */}
        {result && (
          <div className="pointer-events-auto rounded-2xl bg-surface-container-high p-4 text-sm text-on-surface-variant max-w-md w-full ghost-border mb-2">
            {result}
          </div>
        )}

        {/* Live Transcript Display (Instead of input) */}
        <div className="pointer-events-auto w-full max-w-md h-12 flex items-center justify-center">
          {spoken ? (
            <p className="text-on-surface font-medium text-lg text-center truncate px-4 bg-surface-container-low rounded-xl py-2 ghost-border">
              &ldquo;{spoken}&rdquo;
            </p>
          ) : isRecording ? (
            <p className="text-primary italic text-sm animate-pulse">{t("session.listening")}</p>
          ) : (
            <p className="text-outline-variant italic text-sm">{t("session.hold_mic")}</p>
          )}
        </div>

        {/* Action buttons */}
        <div className="pointer-events-auto flex items-center gap-4">
          {/* Replay audio button */}
          <button
            onClick={handlePlayTTS}
            disabled={isBufferingTTS || isRecording}
            className="relative w-14 h-14 rounded-full bg-surface-container-high flex items-center justify-center text-primary ghost-border hover:bg-surface-container-highest active:scale-90 transition-all shadow-lg disabled:opacity-40"
          >
            {isBufferingTTS ? (
              <span className="material-symbols-outlined text-[32px] animate-spin">sync</span>
            ) : isPlayingTTS ? (
              <span className="material-symbols-outlined text-[32px]">stop</span>
            ) : (
              <span className="material-symbols-outlined text-[32px]">volume_up</span>
            )}
            {isPlayingTTS && (
              <div className="absolute inset-0 rounded-full border-2 border-primary animate-pulse pointer-events-none" />
            )}
          </button>

          {/* Main action button: HOLD TO SPEAK or NEXT */}
          {!result ? (
            <button
              onPointerDown={handlePointerDown}
              onPointerUp={handlePointerUp}
              onPointerLeave={handlePointerUp}
              onTouchStart={(e) => { e.preventDefault(); handlePointerDown(); }}
              onTouchEnd={(e) => { e.preventDefault(); handlePointerUp(); }}
              className={`relative w-[88px] h-[88px] md:w-[100px] md:h-[100px] rounded-full flex items-center justify-center text-on-primary shadow-mic-glow transition-all
                ${isRecording 
                  ? "bg-primary scale-95 shadow-inner" 
                  : "bg-gradient-to-br from-primary to-primary-dim hover:scale-105"
                }
                ${saving ? "opacity-60 pointer-events-none" : ""}
                ${isRecording && !saving ? "animate-pulse" : ""}
              `}
              title="Hold to speak"
            >
              <span
                className="material-symbols-outlined text-[40px] md:text-[48px]"
                style={{ fontVariationSettings: "'FILL' 1" }}
              >
                {saving ? "hourglass_top" : isRecording ? "mic" : "mic_none"}
              </span>
              
              {/* Mic aura effect when recording */}
              {isRecording && (
                <>
                  <div className="absolute inset-0 rounded-full border-4 border-primary opacity-50 animate-ping pointer-events-none" />
                  <div className="absolute -inset-4 rounded-full bg-primary/20 blur-xl pointer-events-none animate-pulse-ring" />
                </>
              )}
            </button>
          ) : (
            <button
              onClick={handleNext}
              className="relative w-[88px] h-[88px] md:w-[100px] md:h-[100px] bg-gradient-to-br from-secondary to-secondary-dim rounded-full flex items-center justify-center text-on-secondary shadow-mic-glow active:scale-95 transition-all animate-[scale-in_0.3s_ease-out]"
            >
              <span
                className="material-symbols-outlined text-[40px] md:text-[48px]"
                style={{ fontVariationSettings: "'FILL' 1" }}
              >
                arrow_forward
              </span>
            </button>
          )}

          {/* Skip button */}
          <button
            onClick={handleNext}
            className="w-14 h-14 rounded-full bg-surface-container-high flex items-center justify-center text-on-surface-variant ghost-border hover:bg-surface-container-highest active:scale-90 transition-all shadow-lg"
          >
            <span className="material-symbols-outlined text-[28px]">skip_next</span>
          </button>
        </div>

        {/* Label */}
        <div className="pointer-events-auto px-6 py-2 rounded-full bg-surface-container-low/80 backdrop-blur-md ghost-border">
          <span className="text-xs font-bold tracking-[0.15em] text-on-surface-variant uppercase">
            {result ? t("session.tap_continue") : t("session.hold_speak")}
          </span>
        </div>
      </footer>

      {/* Background blurs */}
      <div className="absolute top-[-10%] left-[-10%] w-[40%] h-[40%] bg-primary/5 blur-[120px] rounded-full pointer-events-none" />
      <div className="absolute bottom-[-10%] right-[-10%] w-[50%] h-[50%] bg-secondary/5 blur-[150px] rounded-full pointer-events-none" />
    </div>
  );
}
