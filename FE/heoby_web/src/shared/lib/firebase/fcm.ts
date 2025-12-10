import type { Messaging } from "firebase/messaging";
import { getToken, onMessage } from "firebase/messaging";
import { initializeMessaging } from "./firebase";
import { buildAppPath } from "@/shared/utils/path";

const VAPID_KEY = import.meta.env.VITE_FIREBASE_VAPID_KEY;

export interface FCMNotification {
  title: string;
  body: string;
  image?: string;
  data?: Record<string, string>;
}

/**
 * FCM 토큰 요청
 */
export const requestFCMToken = async (): Promise<{
  token: string | null;
  permission: NotificationPermission;
}> => {
  try {
    // 알림 권한 요청
    const permission = await Notification.requestPermission();
    if (permission !== "granted") {
      console.log("알림 권한이 거부되었습니다.");
      return { token: null, permission };
    }

    // Messaging 인스턴스 초기화
    const messaging = await initializeMessaging();
    if (!messaging) {
      console.error("Messaging을 초기화할 수 없습니다.");
      return { token: null, permission };
    }

    // Service Worker 등록
    const registration = await navigator.serviceWorker.register(
      buildAppPath("/firebase-messaging-sw.js", { includeBase: true })
    );
    await navigator.serviceWorker.ready;

    // FCM 토큰 가져오기
    const token = await getToken(messaging, {
      vapidKey: VAPID_KEY,
      serviceWorkerRegistration: registration,
    });

    console.log("FCM Token:", token);
    return { token, permission };
  } catch (error) {
    console.error("FCM 토큰 가져오기 실패:", error);
    return { token: null, permission: "default" };
  }
};

/**
 * 포그라운드 메시지 리스너 설정
 */
export const onForegroundMessage = (
  messaging: Messaging,
  callback: (notification: FCMNotification) => void
) => {
  return onMessage(messaging, (payload) => {
    console.log("포그라운드 메시지 수신:", payload);

    if (payload.notification) {
      const notification: FCMNotification = {
        title: payload.notification.title || "알림",
        body: payload.notification.body || "",
        image: payload.notification.image,
        data: payload.data as Record<string, string>,
      };

      callback(notification);

      // 브라우저 알림 표시
      if (Notification.permission === "granted") {
        new Notification(notification.title, {
          body: notification.body,
          icon: notification.image || "/favicon.svg",
          data: notification.data,
        });
      }
    }
  });
};

/**
 * FCM 초기화 및 리스너 설정
 */
export const initializeFCM = async (
  onNotification?: (notification: FCMNotification) => void
) => {
  try {
    // Messaging 인스턴스 초기화
    const messaging = await initializeMessaging();
    if (!messaging) {
      console.error("FCM을 초기화할 수 없습니다.");
      return { status: "unsupported" } as const;
    }

    // 토큰 요청
    const { token, permission } = await requestFCMToken();
    if (!token || permission !== "granted") {
      console.error("FCM 토큰을 가져올 수 없습니다.");
      return { status: "permission-denied" } as const;
    }

    // 포그라운드 메시지 리스너 설정
    if (onNotification) {
      onForegroundMessage(messaging, onNotification);
    }

    return { status: "ready", messaging, token } as const;
  } catch (error) {
    console.error("FCM 초기화 실패:", error);
    return {
      status: "error",
      error: error instanceof Error ? error : new Error("FCM 초기화 실패"),
    } as const;
  }
};
