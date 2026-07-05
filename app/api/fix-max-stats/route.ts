import { NextResponse } from "next/server";
import { createAdminPbClient } from "@/lib/pocketbase/server";

export async function GET(request: Request) {
  const { searchParams } = new URL(request.url);
  const secret = searchParams.get("secret");

  if (secret !== process.env.CRON_SECRET) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  try {
    const pb = await createAdminPbClient();
    
    // Update the record with ID db249lwlcdg7qnm (Max's active Italian progress)
    await pb.collection("user_progress").update("db249lwlcdg7qnm", {
      sessions_done: 53,
      total_phrases: 689, // 53 * 13
    });

    return NextResponse.json({
      success: true,
      message: "Max's Italian stats adjusted successfully: sessions_done=53, total_phrases=689"
    });
  } catch (e: any) {
    return NextResponse.json({
      error: e.message,
      status: e.status,
      response: e.response,
    }, { status: 500 });
  }
}
