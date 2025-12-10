import { useLogin } from "@/features/auth/hooks/useAuth";
import { showErrorToast, showSuccessToast } from "@/shared/lib/toast";
import { useState, type FormEvent } from "react";
import { Link, useNavigate } from "react-router-dom";
import { BaseBox } from "../../shared/components/Box/BaseBox";
import { BaseLayout } from "../../shared/components/Layout/BaseLayout";
import { buildAppPath } from "@/shared/utils/path";
import { APP_ROUTES } from "@/shared/constants/routes";
import { useAuthStore } from "@/features/auth/store/authStore";
import { useEffect } from "react";

export const LoginPage = () => {
  const navigate = useNavigate();
  const { mutate: login, isPending: isLoading } = useLogin();
  const isAuthenticated = useAuthStore((state) => state.isAuthenticated);

  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");

  useEffect(() => {
    if (isAuthenticated) {
      navigate(buildAppPath(APP_ROUTES.home), { replace: true });
    }
  }, [isAuthenticated, navigate]);

  const handleSubmit = (event: FormEvent) => {
    event.preventDefault();

    login(
      { email, password },
      {
        onSuccess: () => {
          showSuccessToast("로그인에 성공했어요!");
          navigate(buildAppPath(APP_ROUTES.home), { replace: true });
        },
        onError: (error) => {
          showErrorToast(error.message || "로그인에 실패했습니다.");
        },
      }
    );
  };

  return (
    <BaseLayout showHeader={false} showBottomNav={false}>
      <div className="flex items-center justify-center min-h-screen">
        <div className="w-full max-w-md flex-none">
          <BaseBox title="로그인">
            <form
              className="w-full px-6 py-6 space-y-6"
              onSubmit={handleSubmit}
            >
              <div className="space-y-4 w-full">
                <div>
                  <label
                    htmlFor="email"
                    className="block text-sm font-medium text-gray-700"
                  >
                    이메일
                  </label>
                  <input
                    id="email"
                    name="email"
                    type="email"
                    required
                    autoComplete="username"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    className="mt-1 block w-full rounded-md border border-gray-300 px-3 py-2 shadow-sm focus:border-blue-500 focus:outline-none focus:ring-blue-500 placeholder:text-gray-400"
                    placeholder="이메일을 입력해주세요"
                  />
                </div>

                <div>
                  <label
                    htmlFor="password"
                    className="block text-sm font-medium text-gray-700"
                  >
                    비밀번호
                  </label>
                  <input
                    id="password"
                    name="password"
                    type="password"
                    required
                    autoComplete="current-password"
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    className="mt-1 block w-full rounded-md border border-gray-300 px-3 py-2 shadow-sm focus:border-blue-500 focus:outline-none focus:ring-blue-500 placeholder:text-gray-400 placeholder:opacity-80"
                    placeholder="비밀번호를 입력해주세요"
                  />
                </div>
              </div>

              <div>
                <button
                  type="submit"
                  disabled={isLoading}
                  className="w-full flex justify-center rounded-md border border-transparent bg-blue-600 py-2 px-4 text-sm font-medium text-white shadow-sm transition hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 disabled:cursor-not-allowed disabled:bg-gray-400"
                >
                  {isLoading ? "로그인 중..." : "로그인"}
                </button>
              </div>

              <div className="text-center text-sm text-gray-600">
                아직 계정이 없으신가요?{" "}
                <Link
                  to="/signup"
                  className="font-medium text-blue-600 hover:text-blue-500"
                >
                  회원가입
                </Link>
              </div>
            </form>
          </BaseBox>
        </div>
      </div>
    </BaseLayout>
  );
};
