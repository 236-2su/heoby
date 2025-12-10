import { BOTTOM_MENU_ITEMS } from "@/shared/constants/menus";
import { PAGE_TITLES } from "@/shared/constants/routes";
import { Link, useLocation } from "react-router-dom";

export function BottomNavBar() {
  const location = useLocation();
  const currentPath = location.pathname;
  return (
    <div className="lg:hidden fixed bottom-0 left-0 right-0 h-20 bg-fg flex items-center justify-around px-4 z-[1000]">
      {BOTTOM_MENU_ITEMS.map((item) => {
        const isActive = currentPath === item.to;

        return (
          <Link to={item.to} key={item.to}>
            <div
              className={`flex flex-col items-center justify-center p-4 rounded-2xl transition-all duration-200 ${
                isActive
                  ? "bg-white/15 text-[#FFD54F] scale-105 shadow-md"
                  : "text-white/70 hover:text-white hover:bg-white/5"
              }`}
            >
              <div
                className={`w-6 h-6 mb-1 ${
                  isActive ? "text-[#FFD54F]" : "text-white/80"
                }`}
              >
                {item.icon}
              </div>
              <div
                className={`text-sm ${
                  isActive ? "font-semibold text-[#FFD54F]" : "text-white/70"
                }`}
              >
                {PAGE_TITLES[item.to]}
              </div>
            </div>
          </Link>
        );
      })}
    </div>
  );
}
