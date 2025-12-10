/**
 * WebRTC 클라이언트
 */

import { ConnectionError, MediaError } from "./errors";
import { PeerConnection } from "./peer";
import { SignalingClient } from "./signaling";
import type {
  DataChannelMessage,
  ICECandidatePayload,
  MediaConstraints,
  RTCStatus,
  SDPPayload,
  SignalingMessage,
  Unsubscribe,
  WebRTCConfig,
} from "./types";

type WebRTCEventType =
  | "peer-connected"
  | "peer-disconnected"
  | "track"
  | "data";
type WebRTCEventHandler = (data: unknown) => void;

export class WebRTCClient {
  private signaling: SignalingClient;
  private peers = new Map<string, PeerConnection>();
  private status: RTCStatus = "DISCONNECTED";
  private config: WebRTCConfig;
  private eventHandlers = new Map<WebRTCEventType, Set<WebRTCEventHandler>>();
  private localStream?: MediaStream;

  constructor(config: WebRTCConfig) {
    this.config = {
      iceServers: [{ urls: "stun:stun.l.google.com:19302" }],
      autoReconnect: true,
      maxReconnectAttempts: 5,
      ...config,
    };

    this.signaling = new SignalingClient(this.config.signalingServerUrl, {
      maxReconnectAttempts: this.config.maxReconnectAttempts,
      getToken: this.config.getToken,
    });

    this.setupSignalingHandlers();
  }

  private setupSignalingHandlers(): void {
    // Offer 수신
    this.signaling.on("offer", async (message: SignalingMessage) => {
      if (!message.from) return;
      await this.handleOffer(message.from, message.payload as SDPPayload);
    });

    // Answer 수신
    this.signaling.on("answer", async (message: SignalingMessage) => {
      if (!message.from) return;
      await this.handleAnswer(message.from, message.payload as SDPPayload);
    });

    // ICE Candidate 수신
    this.signaling.on("ice-candidate", async (message: SignalingMessage) => {
      if (!message.from) return;
      await this.handleIceCandidate(
        message.from,
        message.payload as ICECandidatePayload
      );
    });

    // Peer 연결 해제
    this.signaling.on("leave", (message: SignalingMessage) => {
      if (!message.from) return;
      this.removePeer(message.from);
    });
  }

  /**
   * 연결 시작
   */
  async connect(roomId?: string): Promise<void> {
    try {
      this.setStatus("CONNECTING");
      await this.signaling.connect();

      if (roomId) {
        this.signaling.send({
          type: "join",
          payload: { roomId },
        });
      }

      this.setStatus("CONNECTED");
    } catch (error) {
      this.setStatus("FAILED");
      throw new ConnectionError(
        `Failed to connect: ${(error as Error).message}`
      );
    }
  }

  /**
   * 로컬 미디어 스트림 초기화
   */
  async initLocalStream(constraints?: MediaConstraints): Promise<MediaStream> {
    try {
      const mediaConstraints = constraints ||
        this.config.mediaConstraints || {
          video: true,
          audio: true,
        };

      this.localStream = await navigator.mediaDevices.getUserMedia(
        mediaConstraints
      );
      return this.localStream;
    } catch (error) {
      throw new MediaError(
        `Failed to get local media: ${(error as Error).message}`
      );
    }
  }

  /**
   * Peer와 연결 생성
   */
  async createPeerConnection(peerId: string): Promise<PeerConnection> {
    if (this.peers.has(peerId)) {
      return this.peers.get(peerId)!;
    }

    const peer = new PeerConnection(peerId, {
      iceServers: this.config.iceServers,
    });

    // ICE Candidate 전송
    peer.on("ice-candidate", (candidate) => {
      this.signaling.send({
        type: "ice-candidate",
        to: peerId,
        payload: candidate,
      });
    });

    // Track 수신
    peer.on("track", (stream) => {
      this.emit("track", { peerId, stream });
    });

    // 연결 상태 변경
    peer.on("connection-state-change", (state) => {
      if (state === "connected") {
        this.emit("peer-connected", { peerId });
      } else if (state === "disconnected" || state === "failed") {
        this.removePeer(peerId);
      }
    });

    // 데이터 채널 메시지
    peer.on("data-channel-message", (message) => {
      this.emit("data", { peerId, message });
    });

    // 로컬 스트림이 있으면 추가
    if (this.localStream) {
      await peer.addLocalStream(this.localStream);
    }

    this.peers.set(peerId, peer);
    return peer;
  }

  /**
   * Offer 생성 및 전송
   */
  async sendOffer(peerId: string): Promise<void> {
    console.log(`[WebRTCClient] Creating peer connection for ${peerId}`);
    const peer = await this.createPeerConnection(peerId);
    console.log(`[WebRTCClient] Peer created, creating offer...`);
    const offer = await peer.createOffer();
    console.log(`[WebRTCClient] Offer created:`, offer);

    console.log(`[WebRTCClient] Sending offer to ${peerId}`);
    this.signaling.send({
      type: "offer",
      to: peerId,
      payload: offer,
    });
    console.log(`[WebRTCClient] Offer sent`);
  }

  /**
   * Offer 처리
   */
  private async handleOffer(peerId: string, offer: SDPPayload): Promise<void> {
    const peer = await this.createPeerConnection(peerId);
    await peer.setRemoteDescription(offer);

    const answer = await peer.createAnswer();
    this.signaling.send({
      type: "answer",
      to: peerId,
      payload: answer,
    });
  }

  /**
   * Answer 처리
   */
  private async handleAnswer(
    peerId: string,
    answer: SDPPayload
  ): Promise<void> {
    const peer = this.peers.get(peerId);
    if (!peer) {
      console.error(`Peer ${peerId} not found`);
      return;
    }

    await peer.setRemoteDescription(answer);
  }

  /**
   * ICE Candidate 처리
   */
  private async handleIceCandidate(
    peerId: string,
    candidate: ICECandidatePayload
  ): Promise<void> {
    const peer = this.peers.get(peerId);
    if (!peer) {
      console.error(`Peer ${peerId} not found`);
      return;
    }

    await peer.addIceCandidate(candidate);
  }

  /**
   * 데이터 전송
   */
  sendData(peerId: string, message: DataChannelMessage): void {
    const peer = this.peers.get(peerId);
    if (!peer) {
      throw new ConnectionError(`Peer ${peerId} not found`);
    }
    peer.sendData(message);
  }

  /**
   * 모든 Peer에게 데이터 전송
   */
  broadcastData(message: DataChannelMessage): void {
    this.peers.forEach((peer) => {
      try {
        peer.sendData(message);
      } catch (error) {
        console.error(`Failed to send data to ${peer.getPeerId()}:`, error);
      }
    });
  }

  /**
   * Peer 제거 (public)
   */
  removePeer(peerId: string): void {
    const peer = this.peers.get(peerId);
    if (peer) {
      peer.close();
      this.peers.delete(peerId);
      this.emit("peer-disconnected", { peerId });
    }
  }

  /**
   * 모든 Peer 제거
   */
  removeAllPeers(): void {
    this.peers.forEach((peer) => peer.close());
    this.peers.clear();
  }

  /**
   * 상태 변경
   */
  private setStatus(status: RTCStatus): void {
    this.status = status;
  }

  /**
   * 현재 상태
   */
  getStatus(): RTCStatus {
    return this.status;
  }

  /**
   * 연결된 Peer 목록
   */
  getPeers(): string[] {
    return Array.from(this.peers.keys());
  }

  /**
   * 이벤트 핸들러 등록
   */
  on(event: WebRTCEventType, handler: WebRTCEventHandler): Unsubscribe {
    if (!this.eventHandlers.has(event)) {
      this.eventHandlers.set(event, new Set());
    }
    this.eventHandlers.get(event)!.add(handler);

    return () => {
      this.eventHandlers.get(event)?.delete(handler);
    };
  }

  private emit(event: WebRTCEventType, data: unknown): void {
    this.eventHandlers.get(event)?.forEach((handler) => {
      try {
        handler(data);
      } catch (error) {
        console.error(`Error in WebRTC event handler for ${event}:`, error);
      }
    });
  }

  /**
   * 연결 종료
   */
  close(): void {
    this.peers.forEach((peer) => peer.close());
    this.peers.clear();
    this.localStream?.getTracks().forEach((track) => track.stop());
    this.signaling.close();
    this.eventHandlers.clear();
    this.setStatus("DISCONNECTED");
  }
}
