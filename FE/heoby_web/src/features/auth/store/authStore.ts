import { REFRESH_TOKEN_KEY } from "@/shared/constants/keys";
import { create } from "zustand";
import { type AuthStore } from "../type/domain/auth.domain";

export const useAuthStore = create<AuthStore>((set) => ({
  // 초기 상태
  accessToken: null,
  userUuid: null,
  isAuthenticated: false,

  // 로그인 성공 시 호출
  setAuth: (accessToken, refreshToken, userUuid) => {
    // refreshToken을 localStorage에 저장
    localStorage.setItem(REFRESH_TOKEN_KEY, refreshToken);

    set({
      accessToken: accessToken,
      userUuid: userUuid,
      isAuthenticated: true,
    });
  },

  // 로그아웃 시 호출
  clearAuth: () => {
    // localStorage에서 refreshToken 삭제
    localStorage.removeItem(REFRESH_TOKEN_KEY);

    set({
      accessToken: null,
      userUuid: null,
      isAuthenticated: false,
    });
  },
}));

// 개발 환경에서 디버깅용
if (import.meta.env.DEV) {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  (window as any).useAuthStore = useAuthStore;
}
