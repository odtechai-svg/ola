import { serve } from "https://deno.land/std@0.224.0/http/server.ts";

serve(async (req) => {
  if (req.method !== "POST") {
    return new Response(JSON.stringify({ error: "Method not allowed" }), { status: 405 });
  }

  const body = await req.json();
  const expected = String(body.expected ?? "");
  const transcript = String(body.transcript ?? "");

  const score = expected && transcript
    ? transcript.toLowerCase() === expected.toLowerCase() ? 1 : 0.72
    : 0;

  return new Response(
    JSON.stringify({
      transcript,
      speechScore: score,
      pronunciationScore: score,
      speedScore: 0.9,
      finalScore: score,
      feedback: score > 0.8 ? "Strong production" : "Repeat once more",
      provider: "edge-function"
    }),
    { headers: { "Content-Type": "application/json" } }
  );
});
