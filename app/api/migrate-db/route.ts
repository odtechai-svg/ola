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
    
    // 1. Get and update the collection schema
    const collection = await pb.collections.getOne("user_progress");
    let schemaUpdated = false;

    if (collection.fields) {
      if (!collection.fields.some((f: any) => f.name === "total_phrases")) {
        collection.fields.push({ 
          id: "total_phras",
          name: "total_phrases", 
          type: "number", 
          required: false, 
          presentable: false, 
          system: false,
          hidden: false
        } as any);
        schemaUpdated = true;
      }
      if (!collection.fields.some((f: any) => f.name === "total_score_sum")) {
        collection.fields.push({ 
          id: "total_score",
          name: "total_score_sum", 
          type: "number", 
          required: false, 
          presentable: false, 
          system: false,
          hidden: false
        } as any);
        schemaUpdated = true;
      }
    } else if ((collection as any).schema) {
      if (!(collection as any).schema.some((f: any) => f.name === "total_phrases")) {
        (collection as any).schema.push({ 
          id: "total_phras",
          name: "total_phrases", 
          type: "number", 
          required: false, 
          presentable: false, 
          system: false,
          hidden: false
        } as any);
        schemaUpdated = true;
      }
      if (!(collection as any).schema.some((f: any) => f.name === "total_score_sum")) {
        (collection as any).schema.push({ 
          id: "total_score",
          name: "total_score_sum", 
          type: "number", 
          required: false, 
          presentable: false, 
          system: false,
          hidden: false
        } as any);
        schemaUpdated = true;
      }
    }

    if (schemaUpdated) {
      await pb.collections.update("user_progress", collection);
    }

    // 2. Fetch all progress records and initialize missing values
    const records = await pb.collection("user_progress").getFullList();
    let updatedRecordsCount = 0;

    for (const record of records) {
      const needsUpdate = !record.total_phrases || !record.total_score_sum;
      if (needsUpdate) {
        const sessions = record.sessions_done || 0;
        const totalPhrases = record.total_phrases || (sessions * 13);
        const totalScoreSum = record.total_score_sum || (sessions * 0.95); // default 95% avg score
        
        await pb.collection("user_progress").update(record.id, {
          total_phrases: totalPhrases,
          total_score_sum: totalScoreSum,
        });
        updatedRecordsCount++;
      }
    }

    return NextResponse.json({
      success: true,
      schemaUpdated,
      updatedRecordsCount,
    });
  } catch (e: any) {
    return NextResponse.json({
      error: e.message,
      status: e.status,
      response: e.response,
    }, { status: 500 });
  }
}
