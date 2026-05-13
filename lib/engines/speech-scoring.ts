import { SpeechEvaluation } from "@/lib/contracts/domain";

function normalize(text: string): string[] {
  return text
    .toLowerCase()
    .normalize("NFD")
    .replace(/[̀-ͯ]/g, "")
    .replace(/[^a-z0-9\s]/g, "")
    .split(/\s+/)
    .filter(Boolean);
}

// Longest common subsequence length (respects word order)
function lcsLength(a: string[], b: string[]): number {
  const m = a.length, n = b.length;
  const dp: number[][] = Array.from({ length: m + 1 }, () => new Array(n + 1).fill(0));
  for (let i = 1; i <= m; i++) {
    for (let j = 1; j <= n; j++) {
      dp[i][j] = a[i - 1] === b[j - 1] ? dp[i - 1][j - 1] + 1 : Math.max(dp[i - 1][j], dp[i][j - 1]);
    }
  }
  return dp[m][n];
}

export function scoreSpeech(expected: string, spoken: string): SpeechEvaluation {
  const expectedWords = normalize(expected);
  const spokenWords = normalize(spoken);

  if (expectedWords.length === 0) {
    return {
      transcript: spoken, speechScore: 1, pronunciationScore: 1,
      speedScore: 1, finalScore: 1,
      feedback: "Perfect.", provider: "browser",
    };
  }

  // Word coverage: how many expected words appear anywhere in spoken (unordered)
  const hits = expectedWords.filter((w) => spokenWords.includes(w)).length;
  const coverage = hits / expectedWords.length;

  // Order quality: LCS ratio — penalises words said in wrong order
  const lcs = lcsLength(expectedWords, spokenWords);
  const orderScore = lcs / expectedWords.length;

  // Length penalty: too short or way too long
  const lenRatio = spokenWords.length / expectedWords.length;
  const lenScore = lenRatio < 0.5 ? lenRatio * 2 : lenRatio > 2 ? 1 / lenRatio : 1;

  // Combined: coverage weighted most, then order, then length
  const finalScore = Number(((coverage * 0.55) + (orderScore * 0.30) + (lenScore * 0.15)).toFixed(2));
  const pct = Math.round(finalScore * 100);

  const feedback =
    pct >= 90 ? "Excellent! Perfect pronunciation." :
    pct >= 75 ? "Good job! Keep going." :
    pct >= 50 ? "Almost there — focus on the missing words." :
    "Try again, speak clearly and completely.";

  return {
    transcript: spoken,
    speechScore: Number(coverage.toFixed(2)),
    pronunciationScore: Number(orderScore.toFixed(2)),
    speedScore: Number(lenScore.toFixed(2)),
    finalScore,
    feedback,
    provider: "browser",
  };
}
