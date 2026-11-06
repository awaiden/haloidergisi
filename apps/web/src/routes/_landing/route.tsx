import { createFileRoute, Outlet } from "@tanstack/react-router";

import HalloweenDecor from "@/components/halloween-decor";
import BottomTabs from "@/components/landing/bottom-tabs";
import LandingFooter from "@/components/landing/footer";
import LandingNavbar from "@/components/landing/navbar";

export const Route = createFileRoute("/_landing")({
  component: RouteComponent,
});

function RouteComponent() {
  return (
    <>
      <div className='flex min-h-screen flex-col'>
        <LandingNavbar />
        <main className='flex-1 pb-16 md:pb-0'>
          <Outlet />
        </main>
        <LandingFooter />
        <BottomTabs />
      </div>

      <HalloweenDecor />

      {/* Decorative Background Elements */}
      <div className='pointer-events-none fixed inset-0 -z-10 overflow-hidden'>
        <div className='halloween:bg-purple-700/30 absolute top-[-10%] left-[-10%] h-52 w-52 rounded-full bg-blue-600/20 blur-[100px] md:h-125 md:w-125'></div>
        <div className='halloween:bg-orange-500/25 absolute right-[-10%] bottom-[-10%] h-52 w-52 rounded-full bg-yellow-500/10 blur-[100px] md:h-150 md:w-150'></div>
      </div>
    </>
  );
}
