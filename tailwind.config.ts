import type { Config } from "tailwindcss";

export default {
  darkMode: "class",
  content: [
    "./app/**/*.{ts,tsx}",
    "./components/**/*.{ts,tsx}",
    "./lib/**/*.{ts,tsx}"
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ["Inter", "ui-sans-serif", "system-ui", "-apple-system", "sans-serif"],
        headline: ["Inter"],
        body: ["Inter"],
        label: ["Inter"],
      },
      colors: {
        surface:                   { DEFAULT: "rgb(var(--color-surface) / <alpha-value>)", dim: "rgb(var(--color-surface-dim) / <alpha-value>)", bright: "rgb(var(--color-surface-bright) / <alpha-value>)" },
        "surface-container":       { lowest: "rgb(var(--color-surface-lowest) / <alpha-value>)", low: "rgb(var(--color-surface-low) / <alpha-value>)", DEFAULT: "rgb(var(--color-surface-container) / <alpha-value>)", high: "rgb(var(--color-surface-high) / <alpha-value>)", highest: "rgb(var(--color-surface-highest) / <alpha-value>)" },
        "surface-variant":         "rgb(var(--color-surface-variant) / <alpha-value>)",

        primary:                   { DEFAULT: "rgb(var(--color-primary) / <alpha-value>)", dim: "rgb(var(--color-primary-dim) / <alpha-value>)", fixed: "rgb(var(--color-primary-fixed) / <alpha-value>)", "fixed-dim": "rgb(var(--color-primary-fixed-dim) / <alpha-value>)" },
        "primary-container":       "rgb(var(--color-primary-container) / <alpha-value>)",
        "on-primary":              "rgb(var(--color-on-primary) / <alpha-value>)",
        "on-primary-container":    "rgb(var(--color-on-primary-container) / <alpha-value>)",
        "inverse-primary":         "rgb(var(--color-inverse-primary) / <alpha-value>)",

        secondary:                 { DEFAULT: "rgb(var(--color-secondary) / <alpha-value>)", dim: "rgb(var(--color-secondary-dim) / <alpha-value>)", fixed: "rgb(var(--color-secondary-fixed) / <alpha-value>)", "fixed-dim": "rgb(var(--color-secondary-fixed-dim) / <alpha-value>)" },
        "secondary-container":     "rgb(var(--color-secondary-container) / <alpha-value>)",
        "on-secondary":            "rgb(var(--color-on-secondary) / <alpha-value>)",
        "on-secondary-container":  "rgb(var(--color-on-secondary-container) / <alpha-value>)",

        tertiary:                  { DEFAULT: "rgb(var(--color-tertiary) / <alpha-value>)", dim: "rgb(var(--color-tertiary-dim) / <alpha-value>)", fixed: "rgb(var(--color-tertiary-fixed) / <alpha-value>)", "fixed-dim": "rgb(var(--color-tertiary-fixed-dim) / <alpha-value>)" },
        "tertiary-container":      "rgb(var(--color-tertiary-container) / <alpha-value>)",
        "on-tertiary":             "rgb(var(--color-on-tertiary) / <alpha-value>)",
        "on-tertiary-container":   "rgb(var(--color-on-tertiary-container) / <alpha-value>)",

        error:                     { DEFAULT: "rgb(var(--color-error) / <alpha-value>)", dim: "rgb(var(--color-error-dim) / <alpha-value>)" },
        "error-container":         "rgb(var(--color-error-container) / <alpha-value>)",
        "on-error":                "rgb(var(--color-on-error) / <alpha-value>)",
        "on-error-container":      "rgb(var(--color-on-error-container) / <alpha-value>)",

        "on-surface":              "rgb(var(--color-on-surface) / <alpha-value>)",
        "on-surface-variant":      "rgb(var(--color-on-surface-variant) / <alpha-value>)",
        "on-background":           "rgb(var(--color-on-background) / <alpha-value>)",
        outline:                   { DEFAULT: "rgb(var(--color-outline) / <alpha-value>)", variant: "rgb(var(--color-outline-variant) / <alpha-value>)" },
        "inverse-surface":         "rgb(var(--color-inverse-surface) / <alpha-value>)",
        "inverse-on-surface":      "rgb(var(--color-inverse-on-surface) / <alpha-value>)",
        "surface-tint":            "rgb(var(--color-surface-tint) / <alpha-value>)",
      },
      borderRadius: {
        DEFAULT: "1rem",
        lg: "2rem",
        xl: "3rem",
        full: "9999px",
      },
      boxShadow: {
        card: "0 12px 40px rgba(var(--color-surface-highest), 0.08)",
        glow: "0 0 30px 0 rgba(var(--color-primary), 0.08)",
        "glow-active": "0 0 30px 0 rgba(var(--color-primary), 0.2)",
        "mic-glow": "0 12px 40px -12px rgba(var(--color-primary), 0.6)",
      },
      keyframes: {
        "pulse-ring": {
          "0%":   { boxShadow: "0 0 0 0 rgba(var(--color-primary), 0.4)" },
          "70%":  { boxShadow: "0 0 0 20px rgba(var(--color-primary), 0)" },
          "100%": { boxShadow: "0 0 0 0 rgba(var(--color-primary), 0)" },
        },
      },
      animation: {
        "pulse-ring": "pulse-ring 2s cubic-bezier(0.4, 0, 0.6, 1) infinite",
      },
    },
  },
  plugins: [],
} satisfies Config;
