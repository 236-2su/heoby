import { APP_ROUTES } from "@/shared/constants/routes";
import { Bell, Cctv, House, MapPin, User } from "lucide-react";
import type { MenuItem } from "../types/menuItem";

export const BOTTOM_MENU_ITEMS: MenuItem[] = [
  {
    icon: <House />,
    to: APP_ROUTES.home,
  },
  {
    icon: <MapPin />,
    to: APP_ROUTES.map,
  },
  {
    icon: <Cctv />,
    to: APP_ROUTES.cctv,
  },
  {
    icon: <User />,
    to: APP_ROUTES.profile,
  },
];

export const HEADER_MENU_ITEMS: MenuItem[] = [
  {
    icon: <MapPin />,
    to: APP_ROUTES.map,
  },
  {
    icon: <Cctv />,
    to: APP_ROUTES.cctv,
  },
  {
    icon: <Bell />,
    to: APP_ROUTES.notifications,
  },
  {
    icon: <User />,
    to: APP_ROUTES.profile,
  },
];
