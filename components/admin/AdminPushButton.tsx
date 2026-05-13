"use client";

import { useState } from "react";

const TEMPLATES = [
  {
    label: "Daily reminder",
    title: "OLA 🎯",
    body: "Hora do seu treino diário! 15 minutos e você mantém a sequência.",
  },
  {
    label: "Streak warning",
    title: "OLA ⚡ Não perca sua sequência!",
    body: "Você ainda não treinou hoje. Sua sequência está em risco — 15 min agora resolve.",
  },
  {
    label: "New feature",
    title: "OLA ✨ Novidade no app!",
    body: "Melhoramos a experiência de aprendizado. Dê uma olhada e treine hoje!",
  },
  {
    label: "Weekly recap",
    title: "OLA 📊 Sua semana em números",
    body: "Confira seu progresso da semana e continue avançando no currículo!",
  },
  {
    label: "Motivational",
    title: "OLA 🧠 A língua é um músculo",
    body: "Músculos que não são usados enfraquecem. 15 minutos de treino mantém tudo funcionando.",
  },
];

type Status = "idle" | "sending" | "sent" | "error";

export function AdminPushButton() {
  const [title, setTitle]   = useState(TEMPLATES[0].title);
  const [body, setBody]     = useState(TEMPLATES[0].body);
  const [url, setUrl]       = useState("/home");
  const [status, setStatus] = useState<Status>("idle");
  const [result, setResult] = useState<{ sent: number; failed: number } | null>(null);

  function applyTemplate(t: typeof TEMPLATES[0]) {
    setTitle(t.title);
    setBody(t.body);
  }

  async function handleSend() {
    if (!body.trim()) return;
    setStatus("sending");
    try {
      const res = await fetch("/api/push/send", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ title, body, url }),
      });
      const data = await res.json();
      setResult(data);
      setStatus("sent");
      setTimeout(() => setStatus("idle"), 5000);
    } catch {
      setStatus("error");
      setTimeout(() => setStatus("idle"), 3000);
    }
  }

  return (
    <div className="space-y-4">
      {/* Quick templates */}
      <div>
        <p className="text-xs font-bold text-on-surface-variant uppercase tracking-wider mb-2">Quick templates</p>
        <div className="flex flex-wrap gap-2">
          {TEMPLATES.map((t) => (
            <button
              key={t.label}
              onClick={() => applyTemplate(t)}
              className={`px-3 py-1.5 rounded-full text-xs font-bold border transition-all ${
                title === t.title && body === t.body
                  ? "bg-primary/15 border-primary/40 text-primary"
                  : "border-outline-variant/20 text-on-surface-variant hover:border-primary/30 hover:text-primary"
              }`}
            >
              {t.label}
            </button>
          ))}
        </div>
      </div>

      {/* Message editor */}
      <div className="space-y-3">
        <div>
          <label className="text-xs font-bold text-on-surface-variant uppercase tracking-wider block mb-1">
            Title
          </label>
          <input
            type="text"
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            placeholder="OLA 🎯"
            className="w-full bg-surface-container rounded-lg px-4 py-2.5 text-on-surface font-medium ghost-border focus:outline-none focus:ring-2 focus:ring-primary/40 text-sm"
          />
        </div>
        <div>
          <label className="text-xs font-bold text-on-surface-variant uppercase tracking-wider block mb-1">
            Message body
          </label>
          <textarea
            value={body}
            onChange={(e) => setBody(e.target.value)}
            rows={3}
            placeholder="Write your message here..."
            className="w-full bg-surface-container rounded-lg px-4 py-2.5 text-on-surface font-medium ghost-border focus:outline-none focus:ring-2 focus:ring-primary/40 text-sm resize-none"
          />
          <p className="text-xs text-on-surface-variant mt-1 text-right">{body.length} chars</p>
        </div>
        <div>
          <label className="text-xs font-bold text-on-surface-variant uppercase tracking-wider block mb-1">
            Deep link (destination)
          </label>
          <input
            type="text"
            value={url}
            onChange={(e) => setUrl(e.target.value)}
            placeholder="/home"
            className="w-full bg-surface-container rounded-lg px-4 py-2.5 text-on-surface font-medium ghost-border focus:outline-none focus:ring-2 focus:ring-primary/40 text-sm"
          />
        </div>
      </div>

      {/* Send button */}
      <div className="flex items-center gap-4 pt-1 flex-wrap">
        <button
          onClick={handleSend}
          disabled={status === "sending" || !body.trim()}
          className="flex items-center gap-2 bg-primary text-on-primary font-bold px-6 py-3 rounded-full hover:opacity-90 active:scale-95 transition-all disabled:opacity-40 text-sm shadow-md shadow-primary/20"
        >
          <span className="material-symbols-outlined text-base">
            {status === "sending" ? "sync" : status === "sent" ? "check_circle" : "send"}
          </span>
          {status === "sending"
            ? "Sending..."
            : status === "sent"
            ? `Sent to ${result?.sent ?? 0} subscriber(s)`
            : "Broadcast to all users"}
        </button>
        {status === "error" && (
          <p className="text-error text-sm flex items-center gap-1">
            <span className="material-symbols-outlined text-sm">error</span>
            Failed. Check subscriptions file.
          </p>
        )}
        {status === "sent" && result && result.failed > 0 && (
          <p className="text-on-surface-variant text-xs">{result.failed} failed (expired subscriptions)</p>
        )}
      </div>
    </div>
  );
}
