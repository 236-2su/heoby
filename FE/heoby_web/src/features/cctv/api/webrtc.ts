/**
 * CCTV WebRTC API
 */

import type { WebRTCClient } from "@/shared/api/webrtc";
import { closeWebRTC, getWebRTCClient, initWebRTC } from "@/shared/api/webrtc";

const SIGNALING_SERVER_URL =
  import.meta.env.VITE_WS_URL ||
  (typeof window !== "undefined"
    ? `ws://${window.location.hostname}:8080`
    : "ws://localhost:8080");

/**
 * WebRTC 클라이언트 초기화
 */
export function initializeCctvWebRTC(): WebRTCClient {
  return initWebRTC({
    signalingServerUrl: SIGNALING_SERVER_URL,
    iceServers: [
      { urls: "stun:stun.l.google.com:19302" },
      { urls: "stun:stun1.l.google.com:19302" },
    ],
    autoReconnect: true,
    maxReconnectAttempts: 5,
  });
}

/**
 * 전역 WebRTC 클라이언트 가져오기
 */
export function getCctvWebRTCClient(): WebRTCClient | null {
  return getWebRTCClient();
}

/**
 * CCTV 스트림 연결
 */
export async function connectToCctv(cctvId: number): Promise<void> {
  console.log(`[connectToCctv] Connecting to CCTV ${cctvId}`);
  const client = getCctvWebRTCClient();
  if (!client) {
    throw new Error("WebRTC client not initialized");
  }

  // 기존 연결 모두 끊기
  console.log(`[connectToCctv] Removing all existing peers`);
  client.removeAllPeers();

  // 새 CCTV 연결
  console.log(`[connectToCctv] Sending offer to cctv-${cctvId}`);
  await client.sendOffer(`cctv-${cctvId}`);
  console.log(`[connectToCctv] Offer sent successfully`);
}

/**
 * CCTV 연결 해제
 */
export function disconnectCctv(): void {
  const client = getCctvWebRTCClient();
  if (!client) return;

  // 모든 Peer 연결 해제
  client.removeAllPeers();
}

/**
 * WebRTC 종료
 */
export function shutdownCctvWebRTC(): void {
  closeWebRTC();
}
