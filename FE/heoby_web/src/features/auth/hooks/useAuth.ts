import { useAuthStore } from "@/features/auth/store/authStore";
import { useUserStore } from "@/features/auth/store/userStore";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { useEffect } from "react";
import { useHeobyStore } from "@/features/heoby/store/heobyStore";
import { useCctvStore } from "@/features/cctv/store/cctvStore";
import { HEOBY_KEYS } from "@/features/heoby/hooks/useHeoby";
import { CCTV_KEYS } from "@/features/cctv/hooks/useCctv";
import { REFRESH_TOKEN_KEY } from "@/shared/constants/keys";
import { AuthApi } from "../api/authApi";
import type { UserState } from "../type/domain/user.domain";
import { type LoginReqDto, type LoginResDto } from "../type/dto/login.dto";
import type { LogoutReqDto } from "../type/dto/logout.dto";
import {
  type RefreshReqDto,
  type RefreshResDto,
} from "../type/dto/refresh.dto";
import { UserMapper } from "../type/dto/user.dto";
import { USER_KEY } from "./useUser";

export const AUTH_KEYS = {
  type: ["auth"] as const,
  login: () => [...AUTH_KEYS.type, "login"] as const,
  logout: () => [...AUTH_KEYS.type, "logout"] as const,
  refresh: () => [...AUTH_KEYS.type, "refresh"] as const,
  autoLogin: () => [...AUTH_KEYS.refresh(), "auto"] as const,
};

const clearSessionState = (queryClient: ReturnType<typeof useQueryClient>) => {
  useAuthStore.getState().clearAuth();
  useUserStore.getState().clearUser();
  useHeobyStore.getState().reset();
  useCctvStore.getState().reset();

  queryClient.removeQueries({ queryKey: USER_KEY.get() });
  queryClient.removeQueries({ queryKey: HEOBY_KEYS.type });
  queryClient.removeQueries({ queryKey: CCTV_KEYS.type });
  queryClient.removeQueries({ queryKey: ["notifications"] });
  queryClient.removeQueries({ queryKey: ["weather"] });
};

export const useLogin = () => {
  const queryClient = useQueryClient();

  return useMutation<LoginResDto, Error, LoginReqDto>({
    mutationKey: AUTH_KEYS.login(),
    mutationFn: AuthApi.login,
    onSuccess: async (data) => {
      console.log("🔐 Login response:", data);

      // DTO -> Domain 변환
      const user: UserState = UserMapper.fromDto(data.user);
      console.log("👤 Mapped user:", user);

      useAuthStore
        .getState()
        .setAuth(data.accessToken, data.refreshToken, data.user.userUuid);
      console.log("✅ Auth store updated");

      useUserStore.getState().setUser(user);
      console.log("✅ User store updated");

      await queryClient.invalidateQueries({ queryKey: USER_KEY.get() });
      console.log("✅ Queries invalidated");
    },
  });
};

export const useRefresh = () => {
  const queryClient = useQueryClient();

  return useMutation<RefreshResDto, Error, RefreshReqDto>({
    mutationKey: AUTH_KEYS.refresh(),
    mutationFn: AuthApi.refresh,
    onSuccess: async (data) => {
      useAuthStore
        .getState()
        .setAuth(data.accessToken, data.refreshToken, data.userUuid);

      await queryClient.invalidateQueries({ queryKey: USER_KEY.get() });
    },
  });
};

export const useLogout = () => {
  const queryClient = useQueryClient();

  return useMutation<void, Error, LogoutReqDto>({
    mutationKey: AUTH_KEYS.logout(),
    mutationFn: AuthApi.logout,
    onSuccess: () => {
      console.log("로그아웃 성공");
    },
    onError: (error) => {
      console.error("로그아웃 실패:", error);
    },
    onSettled: () => {
      // 성공/실패 상관없이 상태 초기화
      clearSessionState(queryClient);
    },
  });
};
export const useAutoLogin = () => {
  const refreshToken = localStorage.getItem(REFRESH_TOKEN_KEY);
  const queryClient = useQueryClient();

  const query = useQuery<RefreshResDto, Error>({
    queryKey: AUTH_KEYS.autoLogin(),
    queryFn: () => AuthApi.refresh({ refreshToken: refreshToken! }),
    enabled: !!refreshToken, // refreshToken이 있을 때만 실행
    staleTime: Infinity, // 한 번만 실행
    retry: false, // 실패 시 재시도 안 함
  });

  // 성공 시 처리 - useEffect로 side effect 처리
  useEffect(() => {
    if (query.isSuccess && query.data) {
      useAuthStore
        .getState()
        .setAuth(
          query.data.accessToken,
          query.data.refreshToken,
          query.data.userUuid
        );
      queryClient.invalidateQueries({ queryKey: USER_KEY.get() });
    }
  }, [query.isSuccess, query.data, queryClient]);

  // 실패 시 처리 - useEffect로 side effect 처리
  useEffect(() => {
    if (query.isError) {
      console.error("자동 로그인 실패:", query.error);
      localStorage.removeItem(REFRESH_TOKEN_KEY);
      clearSessionState(queryClient);
    }
  }, [query.isError, query.error, queryClient]);

  return query;
};
