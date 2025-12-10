import type { AppRoute } from "../constants/routes";

export interface MenuItem {
  icon: React.ReactNode;
  to: AppRoute;
}
