import { Shell } from "@/components/layout/shell";
import { BlockGrid } from "@/components/ola/block-grid";
import { BlocksPageHeader } from "@/components/ola/blocks-page-header";
import { requireUser } from "@/lib/server/auth";
import { getBlocksForActiveEnrollment } from "@/lib/server/queries";

export default async function BlocksPage() {
  const user = await requireUser();
  const blocks = await getBlocksForActiveEnrollment(user.id);

  return (
    <Shell>
      <div className="space-y-8">
        <BlocksPageHeader />
        <BlockGrid blocks={blocks} />
      </div>
    </Shell>
  );
}
