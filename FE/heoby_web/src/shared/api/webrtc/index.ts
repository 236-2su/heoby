/**
 * WebRTC API 모듈 Export
 */

export { WebRTCClient } from "./client";
export { PeerConnection } from "./peer";
export { SignalingClient } from "./signaling";

export {
  ConnectionError,
  MediaError,
  PeerError,
  SignalingError,
  WebRTCBaseError,
} from "./errors";

export type {
  DataChannelMessage,
  ICECandidatePayload,
  MediaConstraints,
  PeerInfo,
  RTCStatus,
  SDPPayload,
  SignalingMessage,
  SignalingMessageType,
  SignalingStatus,
  Unsubscribe,
  WebRTCConfig,
} from "./types";

// 전역 인스턴스와 헬퍼 함수
export {
  closeWebRTC,
  getWebRTCClient,
  initWebRTC,
  webrtcClient,
} from "./instance";
