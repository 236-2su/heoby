import {
  QueryClient,
  QueryClientProvider,
  useQueryClient,
} from "@tanstack/react-query";
import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import { Toaster } from "react-hot-toast";
import { BrowserRouter, Route, Routes } from "react-router-dom";
import { routes } from "./app/routes/routes";
import { useAutoLogin } from "./features/auth/hooks/useAuth";
import { useAuthStore } from "./features/auth/store/authStore";
import { useFcmRegister } from "./features/notification/hooks/useNotifications";
import { NOTIFICATION_KEYS } from "./features/notification/hooks/useNotifications";
import { initializeFCM, type FCMNotification } from "./shared/lib/firebase/fcm";
import { showErrorToast, showSuccessToast } from "./shared/lib/toast";

// React Query 클라이언트 생성
const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 1000 * 60 * 5, // 5분
      retry: 1,
    },
  },
});

// 재귀적으로 라우트 렌더링 (중첩 라우트 지원)
const renderRoutes = (routes: typeof import("./app/routes/routes").routes) => {
  return routes.map((route) => (
    <Route key={route.path} path={route.path} element={route.element}>
      {route.children && renderRoutes(route.children)}
    </Route>
  ));
};

// QueryClientProvider 안에서 실행될 컴포넌트
function AppContent() {
  // 앱 시작 시 자동 로그인 (refreshToken 있으면)
  const { isLoading } = useAutoLogin();
  const accessToken = useAuthStore((state) => state.accessToken);
  const userUuid = useAuthStore((state) => state.userUuid);
  const isAuthenticated = useAuthStore((state) => state.isAuthenticated);
  const { mutate: registerFcm } = useFcmRegister();
  const [fcmToken, setFcmToken] = useState<string | null>(null);
  const [fcmStatus, setFcmStatus] = useState<
    "idle" | "requesting" | "ready" | "denied" | "error" | "unsupported"
  >("idle");
  const [fcmError, setFcmError] = useState<string | null>(null);
  const lastRegisteredToken = useRef<string | null>(null);
  const queryClient = useQueryClient();
  const platform = useMemo(() => {
    if (typeof navigator === "undefined") {
      return "WEB";
    }
    const ua = navigator.userAgent.toLowerCase();
    const isMobile =
      ua.includes("iphone") ||
      ua.includes("ipad") ||
      ua.includes("android") ||
      ua.includes("mobile");
    return isMobile ? "MOBILE_WEB" : "WEB";
  }, []);

  const handleForegroundNotification = useCallback(
    (notification: FCMNotification) => {
      const message = notification.body
        ? `${notification.title} - ${notification.body}`
        : notification.title;
      showSuccessToast(message);
      queryClient.invalidateQueries({ queryKey: NOTIFICATION_KEYS.base() });
    },
    [queryClient]
  );

  const requestFcmToken = useCallback(async () => {
    if (!isAuthenticated) {
      setFcmStatus("idle");
      setFcmToken(null);
      setFcmError(null);
      lastRegisteredToken.current = null;
      return;
    }

    setFcmStatus("requesting");
    setFcmError(null);

    const result = await initializeFCM(handleForegroundNotification);

    if (!result || result.status === "permission-denied") {
      setFcmStatus("denied");
      setFcmError("알림 권한이 거부되었습니다. 브라우저 설정에서 권한을 허용해 주세요.");
      return;
    }

    if (result.status === "unsupported") {
      setFcmStatus("unsupported");
      setFcmError("브라우저에서 알림을 지원하지 않아 FCM을 사용할 수 없습니다.");
      return;
    }

    if (result.status === "error") {
      setFcmStatus("error");
      setFcmError(result.error.message);
      return;
    }

    setFcmStatus("ready");
    setFcmToken(result.token);
  }, [handleForegroundNotification, isAuthenticated]);

  // FCM 초기화
  useEffect(() => {
    void requestFcmToken();
  }, [requestFcmToken]);

  useEffect(() => {
    if (!accessToken || !userUuid || fcmStatus !== "ready") {
      lastRegisteredToken.current = null;
      return;
    }

    if (!fcmToken) {
      return;
    }

    if (lastRegisteredToken.current === fcmToken) {
      return;
    }

    registerFcm(
      { userUuid, platform, token: fcmToken },
      {
        onSuccess: () => {
          lastRegisteredToken.current = fcmToken;
        },
        onError: (error) => {
          console.error("FCM 등록 실패:", error);
          showErrorToast("알림 등록에 실패했습니다. 잠시 후 다시 시도해 주세요.");
        },
      }
    );
  }, [
    accessToken,
    fcmStatus,
    fcmToken,
    platform,
    registerFcm,
    userUuid,
  ]);

  // 자동 로그인 진행 중이면 로딩 표시
  if (isLoading) {
    return (
      <div
        style={{
          display: "flex",
          justifyContent: "center",
          alignItems: "center",
          height: "100vh",
        }}
      >
        <div>로그인 중...</div>
      </div>
    );
  }

  return (
    <>
      <FcmStatusBanner
        status={fcmStatus}
        error={fcmError}
        onRetry={requestFcmToken}
      />
      <BrowserRouter basename={import.meta.env.VITE_BASE_PATH ?? "/"}>
        <Routes>{renderRoutes(routes)}</Routes>
      </BrowserRouter>
    </>
  );
}

function FcmStatusBanner({
  status,
  error,
  onRetry,
}: {
  status: "idle" | "requesting" | "ready" | "denied" | "error" | "unsupported";
  error: string | null;
  onRetry: () => void;
}) {
  if (status === "idle" || status === "ready" || status === "requesting") {
    return null;
  }

  const tone =
    status === "denied"
      ? { bg: "bg-amber-50", text: "text-amber-800", border: "border-amber-200" }
      : { bg: "bg-red-50", text: "text-red-800", border: "border-red-200" };

  return (
    <div
      className={`m-3 rounded-xl border ${tone.border} ${tone.bg} px-4 py-3 text-sm ${tone.text}`}
      role="alert"
    >
      <div className="flex items-start justify-between gap-3">
        <div>
          <p className="font-semibold">
            {status === "unsupported"
              ? "브라우저가 알림을 지원하지 않습니다."
              : "알림을 받을 수 없습니다."}
          </p>
          {error && <p className="mt-1 text-xs opacity-80">{error}</p>}
        </div>
        {status !== "unsupported" && (
          <button
            type="button"
            onClick={onRetry}
            className="rounded-lg bg-white px-3 py-1.5 text-xs font-semibold text-blue-600 shadow-sm hover:bg-blue-50 focus-visible:outline focus-visible:outline-2 focus-visible:outline-blue-400"
          >
            다시 시도
          </button>
        )}
      </div>
    </div>
  );
}

function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <AppContent />
      <Toaster
        position="top-center"
        toastOptions={{
          duration: 3000,
          style: {
            background: "#363636",
            color: "#fff",
          },
          success: {
            duration: 3000,
            iconTheme: {
              primary: "#4ade80",
              secondary: "#fff",
            },
          },
          error: {
            duration: 4000,
            iconTheme: {
              primary: "#ef4444",
              secondary: "#fff",
            },
          },
        }}
      />
    </QueryClientProvider>
  );
}

export default App;
