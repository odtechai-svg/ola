import { NextResponse } from "next/server";
import { cookies } from "next/headers";
import { createPbClient, createAdminPbClient } from "@/lib/pocketbase/server";

export async function GET(request: Request) {
  const { searchParams } = new URL(request.url);
  const secret = searchParams.get("secret");

  if (secret !== process.env.CRON_SECRET) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  let adminError: any = null;
  let adminCollections: any = null;
  let adminProgressList: any = null;

  try {
    const pbAdmin = await createAdminPbClient();
    adminCollections = (await pbAdmin.collections.getFullList()).map(c => ({ name: c.name, fields: (c as any).fields || (c as any).schema }));
    adminProgressList = await pbAdmin.collection("user_progress").getFullList();
  } catch (e: any) {
    adminError = {
      message: e.message,
      status: e.status,
      response: e.response,
    };
  }

  let userError: any = null;
  let userProgressList: any = null;
  let userId: string | undefined;

  try {
    const cookieStore = await cookies();
    const token = cookieStore.get("pb_auth")?.value;
    userId = cookieStore.get("pb_user_id")?.value;

    if (token && userId) {
      const pbUser = createPbClient(token);
      userProgressList = await pbUser.collection("user_progress").getFullList({
        filter: `user_id = "${userId}"`,
      });
    } else {
      userError = "Not logged in (cookies missing)";
    }
  } catch (e: any) {
    userError = {
      message: e.message,
      status: e.status,
      response: e.response,
    };
  }

  return NextResponse.json({
    adminSuccess: !!adminProgressList,
    adminCollections,
    adminProgressList,
    adminError,
    userSuccess: !!userProgressList,
    userId,
    userProgressList,
    userError,
  });
}
