"use client";

let currentAudio: HTMLAudioElement | null = null;
let currentUrl: string | null = null;

export const AudioManager = {
  stop() {
    if (currentAudio) {
      currentAudio.pause();
      currentAudio.onended = null;
      currentAudio.onerror = null;
      currentAudio = null;
    }
    if (currentUrl) {
      URL.revokeObjectURL(currentUrl);
      currentUrl = null;
    }
  },

  play(blob: Blob, onEnded?: () => void): HTMLAudioElement {
    this.stop();
    const url = URL.createObjectURL(blob);
    const audio = new Audio(url);
    currentAudio = audio;
    currentUrl = url;

    audio.onended = () => {
      currentAudio = null;
      if (currentUrl) {
        URL.revokeObjectURL(currentUrl);
        currentUrl = null;
      }
      if (onEnded) onEnded();
    };

    audio.onerror = () => {
      this.stop();
    };

    audio.play();
    return audio;
  },

  pause() {
    if (currentAudio) currentAudio.pause();
  },

  resume() {
    if (currentAudio) currentAudio.play();
  },

  isActive() {
    return currentAudio !== null;
  },

  isCurrentlyPlaying() {
    return currentAudio !== null && !currentAudio.paused;
  },
};
