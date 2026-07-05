import { redirect } from "next/navigation";
import { LiveSessionPlayer } from "@/components/ola/live-session-player";
import { requireUser } from "@/lib/server/auth";
import { buildLiveSession } from "@/lib/server/queries";

export default async function SessionPage({
  params,
  searchParams,
}: {
  params: Promise<{ sessionId: string }>;
  searchParams: Promise<{ block?: string }>;
}) {
  const user = await requireUser();
  const { sessionId } = await params;
  const { block } = await searchParams;

  if (sessionId !== "live") {
    redirect("/session/live");
  }

  const payload = await buildLiveSession(user.id, block ? Number(block) : undefined);

  return (
    <LiveSessionPlayer
      summary={payload.summary}
      sessionId={payload.sessionId}
      languagePairId={payload.languagePairId}
      startingBlockOrder={payload.startingBlockOrder}
      totalBlocks={payload.totalBlocks}
    />
  );
}
