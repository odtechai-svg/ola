import { redirect } from "next/navigation";
import { OnboardingForm } from "@/components/ola/onboarding-form";
import { getLanguageOptions } from "@/lib/server/queries";
import { getCurrentUser } from "@/lib/server/auth";
import Link from "next/link";

export default async function OnboardingPage() {
  const user = await getCurrentUser();
  if (!user) redirect("/auth/login");
  const languageOptions = await getLanguageOptions();

  return (
    <div className="min-h-screen bg-surface text-on-surface font-sans">
      {/* TopAppBar */}
      <nav className="bg-transparent top-0 z-50">
        <div className="flex justify-between items-center w-full px-6 py-4 max-w-7xl mx-auto">
          <span className="text-xl font-black text-on-surface tracking-tight">OLA</span>
          <div className="flex gap-4">
            <button className="text-primary hover:opacity-80 transition-opacity active:scale-95 duration-150">
              <span className="material-symbols-outlined">leaderboard</span>
            </button>
            <Link href="/home" className="text-primary hover:opacity-80 transition-opacity active:scale-95 duration-150">
              <span className="material-symbols-outlined">close</span>
            </Link>
          </div>
        </div>
      </nav>

      <main className="relative px-6 pt-12 pb-32 max-w-xl mx-auto min-h-[calc(100vh-80px)] flex flex-col justify-center">
        <OnboardingForm languageOptions={languageOptions} />
      </main>
    </div>
  );
}
