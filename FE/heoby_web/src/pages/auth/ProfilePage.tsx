import { useLogout } from "@/features/auth/hooks/useAuth";
import { useGetUser } from "@/features/auth/hooks/useUser";
import { useUserStore } from "@/features/auth/store/userStore";
import { BaseLayout } from "@/shared/components/Layout/BaseLayout";
import React from "react";
import { useNavigate } from "react-router-dom";
import { REFRESH_TOKEN_KEY } from "@/shared/constants/keys";
import { buildAppPath } from "@/shared/utils/path";
import { APP_ROUTES } from "@/shared/constants/routes";

export const ProfilePage: React.FC = () => {
  const { username, email, role } = useUserStore();
  const { mutate: logout } = useLogout();
  const navigate = useNavigate();

  useGetUser();

  const handleLogout = () => {
    const confirmLogout = window.confirm("정말 로그아웃 하시겠습니까?");
    if (!confirmLogout) return;

    const refreshToken = localStorage.getItem(REFRESH_TOKEN_KEY);
    const loginPath = buildAppPath(APP_ROUTES.login);

    if (!refreshToken) {
      console.warn("리프레시 토큰이 없습니다.");
      localStorage.removeItem(REFRESH_TOKEN_KEY);
      navigate(loginPath, { replace: true });
      return;
    }

    logout(
      { refreshToken },
      {
        onSettled: () => {
          // 성공/실패 상관없이 로그인 페이지로 이동
          navigate(loginPath, { replace: true });
        },
      }
    );
  };

  return (
    <BaseLayout>
      <div className="min-h-[calc(100vh-200px)] bg-gradient-to-br from-[#eeedec] to-[#f0e6c6] flex flex-col gap-4 md:gap-6 my-4 md:my-8 rounded-3xl p-4 md:p-8">
        {/* 프로필 카드 */}
        <div className="flex justify-center items-center py-8">
          <div
            className="w-[90%] sm:w-[380px] rounded-2xl p-6 text-center shadow-lg
    bg-gradient-to-br from-[#667eea] to-[#764ba2] space-y-4"
          >
            {/* 아바타 */}
            <div className="flex justify-center">
              <div className="border-4 border-white rounded-full p-1">
                <div className="bg-white rounded-full w-20 h-20 flex items-center justify-center">
                  <i className="text-[#667eea] text-4xl bi bi-person-fill"></i>
                </div>
              </div>
            </div>

            {/* 사용자 이름 */}
            <div className="text-xl font-bold text-white">
              {username ?? "이름 없음"}
            </div>

            {/* 역할 뱃지 */}
            {role && (
              <div className="inline-block px-4 py-1.5 rounded-full bg-white text-[#667eea] font-semibold text-sm">
                {role}
              </div>
            )}

            {/* 이메일 */}
            <div className="px-4 py-1.5 rounded-full bg-white/20 text-white text-sm">
              {email ?? "이메일 없음"}
            </div>
          </div>
        </div>

        {/* Spacer */}
        <div className="flex-1" />

        {/* 로그아웃 버튼 */}
        <div className="flex justify-center">
          <button
            onClick={handleLogout}
            className="w-full max-w-md flex items-center justify-center gap-2 py-3 md:py-4 rounded-lg border border-red-500 text-red-500 bg-white hover:bg-red-50 font-semibold transition"
          >
            <i className="bi bi-box-arrow-right"></i>
            로그아웃
          </button>
        </div>
      </div>
    </BaseLayout>
  );
};
