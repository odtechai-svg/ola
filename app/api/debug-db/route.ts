import { NextResponse } from "next/server";
import { cookies } from "next/headers";
import { createPbClient } from "@/lib/pocketbase/server";

export async function GET(request: Request) {
  const { searchParams } = new URL(request.url);
  const secret = searchParams.get("secret");

  if (secret !== process.env.CRON_SECRET) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  try {
    const cookieStore = await cookies();
    const token = cookieStore.get("pb_auth")?.value;
    const userId = cookieStore.get("pb_user_id")?.value;

    if (!token || !userId) {
      return NextResponse.json({ error: "Not logged in (cookies missing)" }, { status: 400 });
    }

    const pb = createPbClient(token);
    
    // Get all user_progress records for this user
    const progressList = await pb.collection("user_progress").getFullList({
      filter: `user_id = "${userId}"`,
      sort: "-updated",
    });

    return NextResponse.json({
      userId,
      progressList
    });
  } catch (e: any) {
    return NextResponse.json({
      error: e.message,
      status: e.status,
      response: e.response,
    }, { status: 500 });
  }
}
