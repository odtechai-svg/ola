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
    
    // Get collections schemas to inspect fields
    const collections = await pb.collections.getFullList();
    
    // Get user_progress list
    const progressList = await pb.collection("user_progress").getFullList({
      sort: "-updated",
    });

    return NextResponse.json({
      collections: collections.map(c => ({ name: c.name, fields: c.fields })),
      progressList
    });
  } catch (e: any) {
    return NextResponse.json({
      error: e.message,
      status: e.status,
      response: e.response,
      pbUrl: process.env.POCKETBASE_URL ? `${process.env.POCKETBASE_URL.substring(0, 15)}...` : "undefined",
      adminEmail: process.env.PB_ADMIN_EMAIL || "undefined",
      hasAdminPassword: !!process.env.PB_ADMIN_PASSWORD
    }, { status: 500 });
  }
}
