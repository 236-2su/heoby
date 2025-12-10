// import { Menu } from "lucide-react";
import LogoIcon from "@/assets/icons/logo.svg";
import { HEADER_MENU_ITEMS } from "@/shared/constants/menus";
import {
  APP_ROUTES,
  PAGE_TITLES,
  type AppRoute,
} from "@/shared/constants/routes";
import { Link, useLocation } from "react-router-dom";
import { Container } from "../Container/Container";

export function Header() {
  const location = useLocation().pathname as AppRoute;
  const pageTitle = PAGE_TITLES[location as keyof typeof PAGE_TITLES];

  return (
    <header className="w-full shadow-sm">
      <Container>
        <div className="flex justify-between items-center h-16">
          <Link to={APP_ROUTES.home}>
            <div className="flex items-center gap-2">
              {location != APP_ROUTES.home ? (
                <span className="text-2xl font-bold">{pageTitle}</span>
              ) : (
                <img src={LogoIcon} alt="Heoby" className="h-24 w-24" />
              )}
            </div>
          </Link>
          <div className="flex items-center">
            {/* 데스크탑 */}
            <div className="hidden lg:block">
              {HEADER_MENU_ITEMS.map((item, index) => {
                return (
                  <Link
                    to={item.to}
                    key={index}
                    className="text-xl font-semibold px-4 py-2"
                  >
                    {PAGE_TITLES[item.to]}
                  </Link>
                );
              })}
            </div>

            {/* 모바일 */}
            <div className="block lg:hidden">
              {HEADER_MENU_ITEMS.map((item, index) => {
                if (item.to !== APP_ROUTES.notifications) return null;

                return (
                  <Link
                    to={item.to}
                    key={index}
                    aria-label="알림"
                    title="알림"
                    className="
                      relative inline-flex items-center justify-center
                      w-11 h-11 rounded-full
                      bg-white/5 hover:bg-white/10 active:bg-white/15
              
                      transition-transform duration-150 active:scale-95
                      focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2 focus-visible:ring-yellow-400
                      select-none touch-manipulation
                    "
                  >
                    <div className="w-6 h-6">{item.icon}</div>
                  </Link>
                );
              })}
            </div>
          </div>
        </div>
      </Container>
    </header>
  );
}
