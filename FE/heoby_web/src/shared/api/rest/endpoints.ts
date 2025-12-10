import type { USERROLE } from "@/features/auth/type/domain/user.domain";

export const ENDPOINTS = {
  AUTH: {
    LOGIN: "/auth/login", // POST
    LOGOUT: "/auth/logout", // POST
    REFRESH: "/auth/refresh", // POST
    SIGNUP: "/auth/signup", // POST
  },

  USER: {
    ME: "/users/me", // GET, DELETE, PATCH
  },

  HEOBY: {
    USER: "/dashboard/scarecrows", // GET
    LEADER: "/dashboard/leader/scarecrows", // GET
  } as Record<USERROLE, string>,

  WEATHER: {
    USER: (crowId: string) => `/dashboard/weather/${crowId}`, // GET
    LEADER: (crowId: string) => `/dashboard/leader/weather/${crowId}`, // GET
  } as Record<USERROLE, (crowId: string) => string>,

  NOTIFICATION: {
    USER: "/dashboard/alarms", // GET
    LEADER: "/dashboard/leader/alarms", // GET
    READ: (alertUuid: string) => `/dashboard/alarms/${alertUuid}`, // PUT
  },

  MAP: {
    USER: (crowId: string) => `/dashboard/map/${crowId}`, // GET
    USER_DETAIL: (crowId: string) => `/dashboard/map/detail/${crowId}`, // GET
    LEADER: (crowId: string) => `/dashboard/leader/map/${crowId}`, // GET
    LEADER_DETAIL: (crowId: string) => `/dashboard/leader/map/detail/${crowId}`, // GET
  },

  CCTV: {
    USER: "/dashboard/workers", // GET
    LEADER: "/dashboard/leader/workers", // GET
  } as Record<USERROLE, string>,

  FCM: {
    REGISTER: "/fcm/register", // POST
    UNREGISTER: "/fcm/unregister", // POST
  },
} as const;
