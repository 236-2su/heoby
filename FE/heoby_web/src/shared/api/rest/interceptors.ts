import { AuthApi } from "@/features/auth/api/authApi";
import { useAuthStore } from "@/features/auth/store/authStore";
import type { RefreshResDto } from "@/features/auth/type/dto/refresh.dto";
import { REFRESH_TOKEN_KEY } from "@/shared/constants/keys";
import { showErrorToast } from "@/shared/lib/toast";
import { buildAppPath } from "@/shared/utils/path";
import type { AxiosResponse, InternalAxiosRequestConfig } from "axios";
import { AxiosError } from "axios";
import ApiClient from "./client";
import {
  convertAxiosError,
  isForbiddenError,
  isNetworkError,
  isTimeoutError,
  isUnauthorizedError,
} from "./errors";

// 토큰 갱신 중복 방지를 위한 변수
let refreshPromise: Promise<string> | null = null;

// Request Interceptor
ApiClient.interceptors.request.use(
  (config: InternalAxiosRequestConfig) => {
    config.withCredentials = true;

    // Zustand store에서 토큰 가져오기
    const token = useAuthStore.getState().accessToken;

    // 토큰이 있으면 Authorization 헤더에 추가
    if (token && config.headers) {
      config.headers.Authorization = `Bearer ${token}`;
    }

    // 요청 로깅 (개발 환경에서만)
    if (import.meta.env.DEV) {
      const fullUrl = config.baseURL
        ? `${config.baseURL}${config.url}`
        : config.url;
      console.log("🚀 API Request:", {
        method: config.method?.toUpperCase(),
        baseURL: config.baseURL,
        url: config.url,
        fullURL: fullUrl,
        data: config.data,
        headers: config.headers,
      });
    }

    return config;
  },
  (error: AxiosError) => {
    console.error("❌ Request Error:", error);
    return Promise.reject(error);
  }
);

// Response Interceptor
ApiClient.interceptors.response.use(
  (response: AxiosResponse) => {
    // 응답 로깅 (개발 환경에서만)
    if (import.meta.env.DEV) {
      const fullUrl = response.config.baseURL
        ? `${response.config.baseURL}${response.config.url}`
        : response.config.url;
      console.log("✅ API Response:", {
        status: response.status,
        statusText: response.statusText,
        fullURL: fullUrl,
        data: response.data,
        dataType: Array.isArray(response.data) ? "Array" : typeof response.data,
      });
    }

    return response;
  },
  async (error: AxiosError) => {
    const originalRequest = error.config as InternalAxiosRequestConfig & {
      _retry?: boolean;
    };

    // AxiosError를 커스텀 에러로 변환
    const customError: Error = convertAxiosError(error);

    // 에러 로깅 (개발 환경에서만)
    if (import.meta.env.DEV) {
      const fullUrl = originalRequest.baseURL
        ? `${originalRequest.baseURL}${originalRequest.url}`
        : originalRequest.url;
      console.error("❌ API Error:", {
        fullURL: fullUrl,
        status: error.response?.status,
        statusText: error.response?.statusText,
        name: customError.name,
        message: customError.message,
        responseData: error.response?.data,
        originalError: error,
      });
    }

    // 401 에러이고, 재시도하지 않은 경우, refresh 엔드포인트가 아닌 경우
    if (
      isUnauthorizedError(customError) &&
      !originalRequest._retry &&
      originalRequest.url !== "/auth/refresh" &&
      originalRequest.url !== "/auth/login"
    ) {
      originalRequest._retry = true;

      // 이미 토큰 갱신 중이면 해당 Promise를 재사용
      if (refreshPromise) {
        if (import.meta.env.DEV) {
          console.log("🔄 토큰 갱신 대기 중...");
        }
        try {
          const newAccessToken = await refreshPromise;

          // 원래 요청에 새 토큰 적용
          if (originalRequest.headers) {
            originalRequest.headers.Authorization = `Bearer ${newAccessToken}`;
          }

          // 원래 요청 재시도
          return ApiClient(originalRequest);
        } catch (error) {
          return Promise.reject(error);
        }
      }

      // 새로운 토큰 갱신 시작
      if (import.meta.env.DEV) {
        console.log("🔄 토큰 갱신 시작");
      }

      refreshPromise = (async () => {
        try {
          // localStorage에서 refreshToken 가져오기
          const refreshToken = localStorage.getItem(REFRESH_TOKEN_KEY);

          if (!refreshToken) {
            throw new Error("RefreshToken이 없습니다.");
          }

          // 토큰 갱신 시도
          const data: RefreshResDto = await AuthApi.refresh({ refreshToken });

          // Zustand store에 새 토큰 저장
          useAuthStore
            .getState()
            .setAuth(data.accessToken, data.refreshToken, data.userUuid);

          if (import.meta.env.DEV) {
            console.log("✅ 토큰 갱신 성공");
          }
          return data.accessToken;
        } catch (refreshError) {
          if (import.meta.env.DEV) {
            console.log("❌ 토큰 갱신 실패:", refreshError);
          }

          // 토큰 갱신 실패 - 로그아웃 처리
          useAuthStore.getState().clearAuth();
          showErrorToast("인증이 만료되었습니다. 다시 로그인해주세요.");

          // 로그인 페이지로 리다이렉트
          if (typeof window !== "undefined") {
            window.location.href = buildAppPath("/login", {
              includeBase: true,
            });
          }

          throw refreshError;
        } finally {
          refreshPromise = null;
        }
      })();

      try {
        const newAccessToken = await refreshPromise;

        // 원래 요청에 새 토큰 적용
        if (originalRequest.headers) {
          originalRequest.headers.Authorization = `Bearer ${newAccessToken}`;
        }

        // 원래 요청 재시도
        return ApiClient(originalRequest);
      } catch (refreshError) {
        return Promise.reject(refreshError);
      }
    }

    // 에러 타입별 처리 및 토스트 표시
    if (isUnauthorizedError(customError)) {
      // 인증 실패 (토큰 갱신도 실패한 경우)
      showErrorToast("인증이 만료되었습니다. 다시 로그인해주세요.");
    } else if (isNetworkError(customError)) {
      // 네트워크 에러
      showErrorToast("서버와 연결할 수 없습니다. 네트워크를 확인해주세요.");
    } else if (isTimeoutError(customError)) {
      // 타임아웃 에러
      showErrorToast("요청 시간이 초과되었습니다. 다시 시도해주세요.");
    } else if (
      isForbiddenError(customError) &&
      originalRequest.url?.startsWith("/dashboard/alarms/")
    ) {
      // 알림 읽기 권한 오류는 토스트를 띄우지 않음

      console.warn("알림 읽기 권한 오류: 토스트 생략", customError);
    } else {
      // 기타 API 에러
      const errorMessage =
        (customError as Error).message || "알 수 없는 오류가 발생했습니다.";
      showErrorToast(errorMessage);
    }

    // 커스텀 에러를 반환
    return Promise.reject(customError);
  }
);

export default ApiClient;
