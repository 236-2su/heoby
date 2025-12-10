/**
 * CCTV 도메인 타입 (내부 사용)
 * 외부 데이터는 DTO에서 Zod로 검증 후 이 타입으로 변환
 */

// CCTV 상태 상수
export const CCTV_STATUS = {
  ONLINE: "온라인",
  OFFLINE: "오프라인",
  MAINTENANCE: "점검 중",
} as const;

// CCTV 상태 타입
export type CctvStatus = (typeof CCTV_STATUS)[keyof typeof CCTV_STATUS];

// CCTV 도메인 타입
export interface Cctv {
  id: number;
  name: string;
  location: string;
  status: CctvStatus;
  lastUpdate: string;
}

// WebRTC 연결 상태 상수
export const CONNECTION_STATUS = {
  DISCONNECTED: "disconnected",
  CONNECTING: "connecting",
  CONNECTED: "connected",
  FAILED: "failed",
} as const;

// WebRTC 연결 상태 타입
export type ConnectionStatus =
  (typeof CONNECTION_STATUS)[keyof typeof CONNECTION_STATUS];
