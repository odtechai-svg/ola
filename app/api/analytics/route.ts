import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

export async function POST(request: Request) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  const body = await request.json();
  const { sessionId = null, eventName, eventProperties = {} } = body ?? {};
  if (!eventName) return NextResponse.json({ error: "eventName is required" }, { status: 400 });

  const { error } = await supabase.from("analytics_events").insert({
    user_id: user?.id ?? null,
    session_id: sessionId,
    event_name: eventName,
    event_properties: eventProperties
  });
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });
  return NextResponse.json({ ok: true });
}
