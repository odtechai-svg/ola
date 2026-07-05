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
    const records = await pb.collection("user_progress").getFullList();
    let updatedCount = 0;

    for (const record of records) {
      const sessions = record.sessions_done || 0;
      const targetPhrases = sessions * 3;
      const targetScoreSum = sessions * 0.95; // Reset average score to a realistic 95%

      // Update the record if values are different
      if (record.total_phrases !== targetPhrases || record.total_score_sum !== targetScoreSum) {
        await pb.collection("user_progress").update(record.id, {
          total_phrases: targetPhrases,
          total_score_sum: targetScoreSum,
        });
        updatedCount++;
      }
    }

    return NextResponse.json({
      success: true,
      message: `Database correction complete. Updated ${updatedCount} user progress records.`,
      updatedCount
    });
  } catch (e: any) {
    return NextResponse.json({
      error: e.message,
      status: e.status,
      response: e.response,
    }, { status: 500 });
  }
}
