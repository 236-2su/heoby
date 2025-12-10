/**
 * WebRTC 전역 인스턴스
 */

import { WebRTCClient } from "./client";
import type { WebRTCConfig } from "./types";

let globalClient: WebRTCClient | null = null;

/**
 * WebRTC 초기화
 */
export function initWebRTC(config: WebRTCConfig): WebRTCClient {
  if (globalClient) {
    console.warn(
      "WebRTC client already initialized. Closing previous instance."
    );
    globalClient.close();
  }

  globalClient = new WebRTCClient(config);
  return globalClient;
}

/**
 * 전역 WebRTC 클라이언트 가져오기
 */
export function getWebRTCClient(): WebRTCClient | null {
  return globalClient;
}

/**
 * WebRTC 연결 종료
 */
export function closeWebRTC(): void {
  if (globalClient) {
    globalClient.close();
    globalClient = null;
  }
}

/**
 * 전역 인스턴스 (직접 접근용)
 */
export { globalClient as webrtcClient };
