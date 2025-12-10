export const APP_ROUTES = {
  home: "/",
  map: "/map",
  notifications: "/notifications",
  profile: "/profile",
  settings: "/settings",
  login: "/login",
  cctv: "/cctv",
} as const;

export type AppRoute = (typeof APP_ROUTES)[keyof typeof APP_ROUTES];

export const PAGE_TITLES: Partial<Record<AppRoute, string>> = {
  [APP_ROUTES.home]: "홈",
  [APP_ROUTES.map]: "지도",
  [APP_ROUTES.cctv]: "카메라",
  [APP_ROUTES.profile]: "프로필",
  [APP_ROUTES.notifications]: "알림",
};
