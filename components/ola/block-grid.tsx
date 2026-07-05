"use client";

import { useRouter } from "next/navigation";
import { BlockSummary } from "@/lib/contracts/domain";
import { useLanguage } from "@/lib/i18n-context";

const phaseColors: Record<string, string> = {
  survival: "bg-error",
  expansion: "bg-tertiary",
  conversation: "bg-secondary",
  fluency: "bg-primary",
};

export function BlockGrid({ blocks }: { blocks: BlockSummary[] }) {
  const { t } = useLanguage();
  const router = useRouter();

  function handleRepeat(order: number) {
    router.push(`/session/live?block=${order}`);
  }

  const statusConfig: Record<BlockSummary["status"], { bg: string; text: string; labelKey: string }> = {
    locked: { bg: "bg-surface-container-highest/50", text: "text-on-surface-variant", labelKey: "blocks.status.locked" },
    active: { bg: "bg-primary/20", text: "text-primary", labelKey: "blocks.status.active" },
    completed: { bg: "bg-secondary/20", text: "text-secondary", labelKey: "blocks.status.done" },
  };

  return (
    <div className="grid gap-4 md:grid-cols-2 xl:grid-cols-3">
      {blocks.map((block) => {
        const status = statusConfig[block.status];
        return (
          <div
            key={block.id}
            className={`group relative bg-surface-container-low p-6 rounded-lg ghost-border hover:border-primary/20 transition-all duration-300 overflow-hidden ${
              block.status === "locked" ? "opacity-50" : ""
            }`}
          >
            {/* Background number */}
            <div className="absolute top-0 right-0 p-4 opacity-5 group-hover:opacity-10 transition-opacity">
              <span className="text-6xl font-black leading-none">{String(block.order).padStart(2, "0")}</span>
            </div>

            <div className="relative z-10 space-y-4">
              <div className="flex items-center justify-between">
                <p className="text-xs uppercase tracking-[0.22em] text-on-surface-variant font-bold">
                  {t("blocks.block")} {block.order}
                </p>
                <span className={`rounded-full px-3 py-1 text-xs font-bold ${status.bg} ${status.text}`}>
                  {t(status.labelKey)}
                </span>
              </div>

              <div>
                <h2 className="text-xl font-bold text-on-surface">{block.title}</h2>
                <div className="flex items-center gap-2 mt-2">
                  <div className={`w-2 h-2 rounded-full ${phaseColors[block.phase] ?? "bg-primary"}`} />
                  <p className="text-sm capitalize text-on-surface-variant">{block.phase}</p>
                </div>
              </div>

              <div>
                <div className="mb-2 flex items-center justify-between text-xs text-on-surface-variant">
                  <span className="font-bold uppercase tracking-wider">{t("blocks.completion")}</span>
                  <span className="font-black text-secondary">{block.completionPercent}%</span>
                </div>
                <div className="h-1.5 overflow-hidden rounded-full bg-surface-container-highest">
                  <div
                    className="h-full rounded-full bg-gradient-to-r from-secondary-dim to-secondary transition-all duration-500"
                    style={{ width: `${block.completionPercent}%` }}
                  />
                </div>
              </div>

              {block.status !== "locked" && (
                <button
                  onClick={() => handleRepeat(block.order)}
                  className="w-full flex items-center justify-center gap-2 mt-1 py-2.5 rounded-xl border border-outline-variant/20 text-on-surface-variant text-xs font-bold uppercase tracking-widest hover:bg-surface-container-high hover:text-on-surface active:scale-95 transition-all"
                >
                  <span className="material-symbols-outlined text-[16px]">replay</span>
                  {t("blocks.repeat")}
                </button>
              )}
            </div>
          </div>
        );
      })}
    </div>
  );
}
