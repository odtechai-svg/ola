"use client";

import { useMemo, useState, useEffect, useRef } from "react";
import Link from "next/link";
import { SessionSummary } from "@/lib/contracts/domain";
import { chooseExercise } from "@/lib/engines/session-orchestrator";
import { AudioManager } from "@/lib/api/AudioManager";
import { useLanguage } from "@/lib/i18n-context";
import { ClassroomTutorial, hasSeenClassroomTutorial } from "@/components/ola/classroom-tutorial";

export function LiveSessionPlayer({
  summary,
  sessionId,
  languagePairId,
  startingBlockOrder,
  totalBlocks,
}: {
  summary: SessionSummary;
  sessionId: string;
  languagePairId: string;
  startingBlockOrder: number;
  totalBlocks: number;
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
  const [blocksTodayDone, setBlocksTodayDone] = useState(0);
  const [nextBlockOrder, setNextBlockOrder] = useState(startingBlockOrder + 1);
  const [showTutorial, setShowTutorial] = useState(false);
  const recognitionRef = useRef<any>(null);
  const autoPlayedIndexRef = useRef(-1);
  const isRetryRef = useRef(false);
  const isMountedRef = useRef(true);

  useEffect(() => {
    return () => { isMountedRef.current = false; };
  }, []);

  // Show tutorial only on first visit
  useEffect(() => {
    if (!hasSeenClassroomTutorial()) {
      setShowTutorial(true);
    }
  }, []);

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
    return () => { AudioManager.stop(); };
  }, []);

  // ── Auto-play TTS when navigating to a new item (paused during tutorial) ──
  useEffect(() => {
    if (showTutorial) return;
    if (autoPlayedIndexRef.current === index) return;
    autoPlayedIndexRef.current = index;

    const currentItem = summary.items[index];
    if (!currentItem) return;

    const timer = setTimeout(async () => {
      if (!isMountedRef.current) return;
      try {
        AudioManager.stop();
        if (isMountedRef.current) { setIsBufferingTTS(true); setIsPlayingTTS(false); }

        const targetLang = languagePairId.split('→')[1] || "pt-BR";
        const voiceGender = document.cookie
          .split("; ")
          .find((row) => row.startsWith("ola_voice_gender="))
          ?.split("=")[1] || "female";

        const response = await fetch("/api/tts", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            text: currentItem.expectedText.substring(0, 5000),
            lang: targetLang,
            gender: voiceGender,
          }),
        });

        if (!isMountedRef.current) return;
        const data = await response.json();
        if (!response.ok || !data?.audioContent) throw new Error("TTS error");

        const binaryString = atob(data.audioContent);
        const bytes = new Uint8Array(binaryString.length);
        for (let i = 0; i < binaryString.length; i++) {
          bytes[i] = binaryString.charCodeAt(i);
        }
        const audioBlob = new Blob([bytes], { type: "audio/mpeg" });

        if (!isMountedRef.current) return;
        AudioManager.play(audioBlob, () => { if (isMountedRef.current) setIsPlayingTTS(false); });
        setIsPlayingTTS(true);
        setIsBufferingTTS(false);
      } catch {
        if (isMountedRef.current) { setIsPlayingTTS(false); setIsBufferingTTS(false); }
      }
    }, 400);

    return () => clearTimeout(timer);
  }, [index, showTutorial, summary, languagePairId]);

  // ── Session Complete ──
  const avgScorePct = sessionScores.length > 0
    ? Math.round(sessionScores.reduce((a, b) => a + b, 0) / sessionScores.length * 100)
    : 0;

  if (!item) {
    const remaining = 3 - blocksTodayDone;
    return (
      <div className="min-h-[80vh] flex flex-col items-center justify-center text-center px-8 relative overflow-hidden">
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
        <div className="grid grid-cols-2 gap-4 w-full max-w-sm mb-8 relative z-10">
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

        {/* Desafio 15 Progress */}
        {blocksTodayDone > 0 && (
          <div className="w-full max-w-sm mb-8 relative z-10">
            <div className="flex items-center justify-between mb-3">
              <p className="text-[10px] uppercase tracking-[0.2em] font-black text-on-surface-variant">
                {t("session.challenge_label")}
              </p>
              <p className="text-[10px] font-bold text-on-surface-variant">
                {nextBlockOrder - 1} / {totalBlocks}
              </p>
            </div>
            <div className="flex gap-3">
              {[0, 1, 2].map((offset) => {
                const blockNum = nextBlockOrder - blocksTodayDone + offset;
                const done = offset < blocksTodayDone;
                return (
                  <div
                    key={offset}
                    className={`flex-1 flex flex-col items-center gap-2 py-4 rounded-2xl transition-all ${
                      done ? "bg-secondary/15 border border-secondary/30" : "bg-surface-container-low border border-outline-variant/20"
                    }`}
                  >
                    <span
                      className={`material-symbols-outlined text-2xl ${done ? "text-secondary" : "text-outline-variant"}`}
                      style={{ fontVariationSettings: done ? "'FILL' 1" : "'FILL' 0" }}
                    >
                      {done ? "check_circle" : "radio_button_unchecked"}
                    </span>
                    <span className={`text-[11px] font-black tracking-wide ${done ? "text-secondary" : "text-outline-variant"}`}>
                      Bl. {blockNum}
                    </span>
                  </div>
                );
              })}
            </div>
            <p className={`text-center text-sm font-bold mt-3 ${blocksTodayDone >= 3 ? "text-secondary" : "text-on-surface-variant"}`}>
              {blocksTodayDone >= 3
                ? t("session.challenge_all_done")
                : remaining === 1
                ? `${remaining} ${t("session.challenge_remaining_one")}`
                : `${remaining} ${t("session.challenge_remaining_many")}`}
            </p>
          </div>
        )}

        <div className="flex items-center gap-4 relative z-10">
          <button
            onClick={() => { setIndex(0); setSessionScores([]); setSpoken(""); setResult(null); autoPlayedIndexRef.current = -1; }}
            className="flex items-center gap-2 border border-outline-variant/30 text-on-surface-variant font-bold py-4 px-8 rounded-full hover:bg-surface-container-high active:scale-95 transition-all text-lg"
          >
            <span className="material-symbols-outlined text-[22px]">replay</span>
            {t("blocks.repeat")}
          </button>

          {/* Next block or back to home depending on daily challenge progress */}
          {blocksTodayDone > 0 && blocksTodayDone < 3 ? (
            <button
              onClick={() => { window.location.href = "/session/live"; }}
              className="flex items-center gap-2 bg-gradient-to-br from-secondary to-secondary-dim text-on-secondary font-bold py-4 px-10 rounded-full shadow-[0_0_40px_rgba(0,220,180,0.25)] hover:shadow-[0_0_60px_rgba(0,220,180,0.35)] hover:-translate-y-1 active:translate-y-0 active:scale-95 transition-all text-lg"
            >
              {t("session.next_block")}
              <span className="material-symbols-outlined text-[22px]" style={{ fontVariationSettings: "'FILL' 1" }}>arrow_forward</span>
            </button>
          ) : (
            <button
              onClick={() => { window.location.href = "/home"; }}
              className="flex items-center gap-2 bg-gradient-to-br from-primary to-primary-container text-on-primary font-bold py-4 px-10 rounded-full inner-glow shadow-[0_0_40px_rgba(163,166,255,0.2)] hover:shadow-[0_0_60px_rgba(163,166,255,0.3)] hover:-translate-y-1 active:translate-y-0 active:scale-95 transition-all text-lg"
            >
              {blocksTodayDone >= 3
                ? <span className="material-symbols-outlined text-[22px]" style={{ fontVariationSettings: "'FILL' 1" }}>emoji_events</span>
                : <span className="material-symbols-outlined text-[22px]">home</span>
              }
              {t("session.continue")}
            </button>
          )}
        </div>
      </div>
    );
  }

  async function handleEvaluate(finalTranscript?: string) {
    setSaving(true);
    setResult(null);

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
      const score = data.evaluation.finalScore;
      setSessionScores(prev => {
        if (isRetryRef.current) {
          isRetryRef.current = false;
          return prev.length > 0 ? [...prev.slice(0, -1), score] : [score];
        }
        return [...prev, score];
      });

      const tier = score >= 0.85 ? "excellent" : score >= 0.65 ? "good" : score >= 0.40 ? "ok" : "retry";
      const phrases = t(`session.feedback.${tier}`).split(";");
      const phrase = phrases[Math.floor(Math.random() * phrases.length)];
      setResult(phrase);
    } else {
      setResult(t("session.feedback.retry").split(";")[0]);
    }
  }

  function handlePointerDown() {
    AudioManager.stop();
    setIsRecording(true);
    setSpoken("");
    // If user already spoke and is retrying, mark as retry to replace score
    if (result !== null) {
      isRetryRef.current = true;
      setResult(null);
    }
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
      try { recognitionRef.current.stop(); } catch {}
    }
    handleEvaluate(spoken);
  }

  async function handleNext() {
    AudioManager.stop();
    const nextIndex = index + 1;

    // On the last item: wait for session/complete before transitioning.
    // This ensures PocketBase is updated before the completion screen
    // renders so "Nova Sessão" always starts the correct next block.
    if (nextIndex === summary.items.length) {
      setSaving(true);
      const avgScore = sessionScores.length > 0
        ? sessionScores.reduce((a, b) => a + b, 0) / sessionScores.length
        : 0;
      try {
        const res = await fetch("/api/session/complete", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ score: avgScore, phrasesCount: summary.items.length }),
        });
        const data = await res.json();
        if (!isMountedRef.current) return;
        if (data.blocksTodayDone) setBlocksTodayDone(data.blocksTodayDone);
        if (data.currentBlockOrder) setNextBlockOrder(data.currentBlockOrder);
      } catch (e) {
        console.error(e);
      }
      setSaving(false);
    }

    setIndex(nextIndex);
    setSpoken("");
    setResult(null);
    isRetryRef.current = false;
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
    }
  }

  const canProceed = result !== null;

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
        {/* Result feedback */}
        {result && (
          <div className="pointer-events-auto rounded-2xl bg-secondary/10 border border-secondary/25 px-6 py-3 text-center max-w-md w-full mb-2 animate-[scale-in_0.25s_ease-out]">
            <span className="text-secondary font-black text-xl tracking-tight">{result}</span>
          </div>
        )}

        {/* Live Transcript Display */}
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

          {/* Central mic button — always stays as mic, allows re-speaking */}
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

            {/* Mic aura when recording */}
            {isRecording && (
              <>
                <div className="absolute inset-0 rounded-full border-4 border-primary opacity-50 animate-ping pointer-events-none" />
                <div className="absolute -inset-4 rounded-full bg-primary/20 blur-xl pointer-events-none animate-pulse-ring" />
              </>
            )}
          </button>

          {/* Skip/Next button — turns green when user has spoken */}
          <button
            onClick={handleNext}
            className={`relative w-14 h-14 rounded-full flex items-center justify-center transition-all shadow-lg ${
              canProceed
                ? "bg-secondary text-on-secondary scale-110 shadow-[0_0_24px_rgba(0,220,180,0.3)] animate-[scale-in_0.3s_ease-out]"
                : "bg-surface-container-high text-on-surface-variant ghost-border hover:bg-surface-container-highest active:scale-90"
            }`}
          >
            <span className="material-symbols-outlined text-[28px]"
              style={{ fontVariationSettings: canProceed ? "'FILL' 1" : "'FILL' 0" }}
            >
              skip_next
            </span>
            {canProceed && (
              <div className="absolute inset-0 rounded-full border-2 border-secondary/60 animate-pulse pointer-events-none" />
            )}
          </button>
        </div>

        {/* Instruction label */}
        <div className="pointer-events-auto px-6 py-2 rounded-full bg-surface-container-low/80 backdrop-blur-md ghost-border">
          <span className="text-xs font-bold tracking-[0.15em] text-on-surface-variant uppercase">
            {canProceed ? t("session.retry_or_continue") : t("session.hold_speak")}
          </span>
        </div>
      </footer>

      {/* Background blurs */}
      <div className="absolute top-[-10%] left-[-10%] w-[40%] h-[40%] bg-primary/5 blur-[120px] rounded-full pointer-events-none" />
      <div className="absolute bottom-[-10%] right-[-10%] w-[50%] h-[50%] bg-secondary/5 blur-[150px] rounded-full pointer-events-none" />

      {/* First-time tutorial overlay */}
      {showTutorial && (
        <ClassroomTutorial
          onComplete={() => {
            setShowTutorial(false);
            // Reset auto-play ref so audio triggers after tutorial
            autoPlayedIndexRef.current = -1;
          }}
        />
      )}
    </div>
  );
}
