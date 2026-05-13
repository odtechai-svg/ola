import { ReactNode } from "react";
import clsx from "clsx";

export function OlaCard({ children, className }: { children: ReactNode; className?: string }) {
  return (
    <div className={clsx(
      "glass-card rounded-lg p-6 ghost-border",
      className
    )}>
      {children}
    </div>
  );
}
