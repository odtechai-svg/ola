import { redirect } from "next/navigation";
import { LiveSessionPlayer } from "@/components/ola/live-session-player";
import { requireUser } from "@/lib/server/auth";
import { buildLiveSession } from "@/lib/server/queries";

export default async function SessionPage({ params }: { params: Promise<{ sessionId: string }> }) {
  const user = await requireUser();
  const { sessionId } = await params;

  if (sessionId !== "live") {
    redirect("/session/live");
  }

  const payload = await buildLiveSession(user.id);

  return (
    <LiveSessionPlayer
      summary={payload.summary}
      sessionId={payload.sessionId}
      languagePairId={payload.languagePairId}
    />
  );
}
