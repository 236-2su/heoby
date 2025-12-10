// import { Navigate, Outlet } from "react-router-dom";
import { useGetUser } from "@/features/auth/hooks/useUser";
import { useAuthStore } from "@/features/auth/store/authStore";
import { REFRESH_TOKEN_KEY } from "@/shared/constants/keys";
import { APP_ROUTES } from "@/shared/constants/routes";
import { Navigate, Outlet } from "react-router-dom";
// import { useAuthStore } from "../store/authStore";

/**
 * 인증이 필요한 라우트를 보호하는 컴포넌트
 * 인증되지 않은 사용자는 로그인 페이지로 리다이렉트
 */
export const ProtectedRoute = () => {
  const isAuthenticated = useAuthStore((state) => state.isAuthenticated);
  const accessToken = useAuthStore((state) => state.accessToken);
  const refreshToken =
    typeof window !== "undefined"
      ? localStorage.getItem(REFRESH_TOKEN_KEY)
      : null;

  // 사용자 정보 자동 로드 (로그인 시 invalidateQueries로 refetch됨)
  useGetUser();

  // 자동 로그인 진행 중일 때는 로딩 상태 유지
  if (!isAuthenticated && refreshToken && !accessToken) {
    return null;
  }

  if (!isAuthenticated && !accessToken) {
    // 로그인되지 않았으면 로그인 페이지로 리다이렉트
    return <Navigate to={APP_ROUTES.login} replace />;
  }

  // 로그인되어 있으면 자식 라우트 렌더링
  return <Outlet />;
};
