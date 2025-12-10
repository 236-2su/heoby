import type { UserStore } from "@/features/auth/type/domain/user.domain";
import { create } from "zustand";

export const useUserStore = create<UserStore>((set) => ({
  userUuid: null,
  villageId: null,
  username: null,
  email: null,
  role: null,

  setUser: (user) =>
    set({
      userUuid: user.userUuid,
      villageId: user.villageId,
      username: user.username,
      email: user.email,
      role: user.role,
    }),

  clearUser: () =>
    set({
      userUuid: null,
      villageId: null,
      username: null,
      email: null,
      role: null,
    }),
}));

// 개발 환경에서 디버깅용
if (import.meta.env.DEV) {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  (window as any).useUserStore = useUserStore;
}
