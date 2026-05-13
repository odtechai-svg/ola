"use client";

import { useEffect } from "react";
import { usePush } from "@/hooks/use-push";

export function PushToggle() {
  // Register SW on mount
  useEffect(() => {
    if ("serviceWorker" in navigator) {
      navigator.serviceWorker.register("/sw.js").catch(console.error);
    }
  }, []);

  const { state, subscribe, unsubscribe, sendTest } = usePush();

  const isSubscribed = state === "subscribed";
  const isLoading   = state === "loading";
  const isDenied    = state === "denied";
  const unsupported = state === "unsupported";

  if (unsupported) return null;

  return (
    <div className="bg-surface-container-low p-8 rounded-lg ghost-border space-y-4">
      <div className="flex items-center gap-3">
        <span className="material-symbols-outlined text-primary">notifications</span>
        <h3 className="text-lg font-bold text-on-surface">Push Notifications</h3>
      </div>

      <p className="text-on-surface-variant text-sm">
        Receive daily training reminders and session streaks even when the app is closed.
      </p>

      {isDenied && (
        <div className="flex items-center gap-2 bg-error/10 text-error text-sm px-4 py-3 rounded-lg">
          <span className="material-symbols-outlined text-base">block</span>
          Notifications blocked by the browser. Enable them in your browser settings.
        </div>
      )}

      <div className="flex items-center gap-3 flex-wrap">
        <button
          onClick={isSubscribed ? unsubscribe : subscribe}
          disabled={isLoading || isDenied}
          className={`flex items-center gap-2 px-6 py-3 rounded-full font-bold text-sm transition-all active:scale-95 disabled:opacity-50 ${
            isSubscribed
              ? "bg-surface-container border border-outline-variant/30 text-on-surface-variant hover:bg-error/10 hover:text-error hover:border-error/30"
              : "bg-primary/10 text-primary hover:bg-primary/20"
          }`}
        >
          <span className="material-symbols-outlined text-lg">
            {isLoading ? "sync" : isSubscribed ? "notifications_off" : "notifications_active"}
          </span>
          {isLoading ? "Loading..." : isSubscribed ? "Disable notifications" : "Enable notifications"}
        </button>

        {isSubscribed && (
          <button
            onClick={sendTest}
            className="flex items-center gap-2 px-5 py-3 rounded-full font-bold text-sm border border-outline-variant/20 text-on-surface-variant hover:text-primary hover:border-primary/30 transition-all active:scale-95"
          >
            <span className="material-symbols-outlined text-base">send</span>
            Send test
          </button>
        )}
      </div>

      {isSubscribed && (
        <p className="text-xs text-secondary flex items-center gap-1">
          <span className="material-symbols-outlined text-sm">check_circle</span>
          Active — you will receive training reminders
        </p>
      )}
    </div>
  );
}
