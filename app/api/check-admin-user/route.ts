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
    
    // Check if the user exists
    let userRecord;
    try {
      userRecord = await pb.collection("users").getFirstListItem(`email = "odtechai@gmail.com"`);
    } catch {
      userRecord = null;
    }

    if (userRecord) {
      const reset = searchParams.get("reset") === "true";
      if (reset) {
        // Reset password to "admin12345"
        await pb.collection("users").update(userRecord.id, {
          password: "admin12345",
          passwordConfirm: "admin12345",
          emailVisibility: true,
          verified: true
        });
        return NextResponse.json({
          exists: true,
          message: "Password reset successfully to: admin12345. Please log in and change it in your settings immediately.",
          user: {
            id: userRecord.id,
            email: userRecord.email,
            username: userRecord.username,
            verified: true
          }
        });
      }

      return NextResponse.json({
        exists: true,
        message: "User exists. To reset password to 'admin12345', call this endpoint with &reset=true",
        user: {
          id: userRecord.id,
          email: userRecord.email,
          username: userRecord.username,
          verified: userRecord.verified,
          created: userRecord.created
        }
      });
    } else {
      const create = searchParams.get("create") === "true";
      if (create) {
        const newUser = await pb.collection("users").create({
          email: "odtechai@gmail.com",
          emailVisibility: true,
          password: "admin12345",
          passwordConfirm: "admin12345",
          name: "Admin OLA",
          verified: true
        });
        return NextResponse.json({
          exists: false,
          created: true,
          message: "User created successfully with password: admin12345. Please log in and change it immediately.",
          user: newUser
        });
      }

      return NextResponse.json({
        exists: false,
        message: "User 'odtechai@gmail.com' does not exist in PocketBase users collection. To create it, call this endpoint with &create=true"
      });
    }
  } catch (e: any) {
    return NextResponse.json({
      error: e.message,
      status: e.status,
      response: e.response,
    }, { status: 500 });
  }
}
