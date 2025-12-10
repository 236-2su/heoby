/**
 * WebRTC 관련 타입 정의
 */

export type RTCStatus = "DISCONNECTED" | "CONNECTING" | "CONNECTED" | "FAILED";

export type SignalingStatus = "DISCONNECTED" | "CONNECTING" | "CONNECTED";

/**
 * 시그널링 메시지 타입
 */
export type SignalingMessageType =
  | "offer"
  | "answer"
  | "ice-candidate"
  | "join"
  | "leave"
  | "error";

/**
 * 시그널링 메시지
 */
export interface SignalingMessage<T = unknown> {
  type: SignalingMessageType;
  payload?: T;
  from?: string;
  to?: string;
  roomId?: string;
  timestamp?: number;
}

/**
 * SDP Offer/Answer Payload
 */
export interface SDPPayload {
  sdp: string;
  type: "offer" | "answer";
}

/**
 * ICE Candidate Payload
 */
export interface ICECandidatePayload {
  candidate: string;
  sdpMid: string | null;
  sdpMLineIndex: number | null;
}

/**
 * 미디어 스트림 설정
 */
export interface MediaConstraints {
  video?: boolean | MediaTrackConstraints;
  audio?: boolean | MediaTrackConstraints;
}

/**
 * WebRTC 클라이언트 설정
 */
export interface WebRTCConfig {
  signalingServerUrl: string;
  iceServers?: RTCIceServer[];
  mediaConstraints?: MediaConstraints;
  autoReconnect?: boolean;
  maxReconnectAttempts?: number;
  getToken?: () => string | null;
}

/**
 * Peer 정보
 */
export interface PeerInfo {
  id: string;
  connection: RTCPeerConnection;
  stream?: MediaStream;
  dataChannel?: RTCDataChannel;
}

/**
 * 데이터 채널 메시지
 */
export interface DataChannelMessage<T = unknown> {
  type: string;
  payload?: T;
  timestamp?: number;
}

/**
 * Unsubscribe 함수
 */
export type Unsubscribe = () => void;
