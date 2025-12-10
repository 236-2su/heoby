import { LoginPage } from "@/pages/auth/LoginPage";
import { ProfilePage } from "@/pages/auth/ProfilePage";
import { CctvPage } from "@/pages/cctv/CctvPage";
import { DashboardPage } from "@/pages/dashboard/DashboardPage";
import { MapPage } from "@/pages/map/MapPage";
import { NotificationPage } from "@/pages/noti/NotificationPage";
import { APP_ROUTES } from "@/shared/constants/routes";
import { ProtectedRoute } from "./ProtectedRoute";

export interface RouteConfig {
  path: string;
  element: React.ReactNode;
  children?: RouteConfig[];
}

export const routes: RouteConfig[] = [
  // 공개 라우트
  { path: APP_ROUTES.login, element: <LoginPage /> },

  // 보호된 라우트 (인증 필요)
  {
    path: "/",
    element: <ProtectedRoute />,
    children: [
      { path: APP_ROUTES.home, element: <DashboardPage /> },
      { path: APP_ROUTES.map, element: <MapPage /> },
      { path: APP_ROUTES.notifications, element: <NotificationPage /> },
      { path: APP_ROUTES.cctv, element: <CctvPage /> },
      { path: APP_ROUTES.profile, element: <ProfilePage /> },
    ],
  },
];
