"use client";

import { useState } from "react";

export function VoiceGenderSelector({ defaultGender }: { defaultGender: string }) {
  const [gender, setGender] = useState(defaultGender);
  const [saving, setSaving] = useState(false);

  async function handleSelect(value: string) {
    if (value === gender || saving) return;
    setSaving(true);
    setGender(value);
    await fetch("/api/settings/voice", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ gender: value }),
    });
    setSaving(false);
  }

  const options = [
    { value: "female", label: "Feminina", icon: "face_3" },
    { value: "male",   label: "Masculina", icon: "face" },
  ];

  return (
    <div className="flex gap-3">
      {options.map(({ value, label, icon }) => (
        <button
          key={value}
          onClick={() => handleSelect(value)}
          disabled={saving}
          className={`flex-1 flex items-center justify-center gap-2 p-4 rounded-lg border transition-all font-bold text-sm ${
            gender === value
              ? "bg-primary/10 border-primary text-primary"
              : "bg-surface-container border-outline-variant/20 text-on-surface-variant hover:border-primary/30 hover:text-primary"
          }`}
        >
          <span className="material-symbols-outlined">{icon}</span>
          {label}
        </button>
      ))}
    </div>
  );
}
