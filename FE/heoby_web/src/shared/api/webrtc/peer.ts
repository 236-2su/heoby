/**
 * RTCPeerConnection 관리
 */

import { PeerError } from "./errors";
import type {
  DataChannelMessage,
  ICECandidatePayload,
  SDPPayload,
} from "./types";

export type PeerEventType =
  | "ice-candidate"
  | "track"
  | "data-channel"
  | "connection-state-change"
  | "data-channel-message";

type PeerEventHandler = (data: unknown) => void;

export class PeerConnection {
  private pc: RTCPeerConnection;
  private peerId: string;
  private eventHandlers = new Map<PeerEventType, Set<PeerEventHandler>>();
  private dataChannel?: RTCDataChannel;
  public localStream?: MediaStream;
  public remoteStream?: MediaStream;

  constructor(peerId: string, config?: RTCConfiguration) {
    this.peerId = peerId;
    this.pc = new RTCPeerConnection(config);
    this.setupEventHandlers();
  }

  private setupEventHandlers(): void {
    // ICE candidate 이벤트
    this.pc.onicecandidate = (event) => {
      if (event.candidate) {
        console.log(
          `[Peer ${this.peerId}] ICE candidate:`,
          event.candidate.candidate
        );
        const payload: ICECandidatePayload = {
          candidate: event.candidate.candidate,
          sdpMid: event.candidate.sdpMid,
          sdpMLineIndex: event.candidate.sdpMLineIndex,
        };
        this.emit("ice-candidate", payload);
      }
    };

    // 원격 트랙 추가 이벤트
    this.pc.ontrack = (event) => {
      console.log(
        `[Peer ${this.peerId}] Received track:`,
        event.track.kind,
        event.streams
      );
      if (event.streams && event.streams[0]) {
        this.remoteStream = event.streams[0];
        console.log(
          `[Peer ${this.peerId}] Remote stream set:`,
          this.remoteStream.id
        );
        this.emit("track", event.streams[0]);
      }
    };

    // 데이터 채널 이벤트
    this.pc.ondatachannel = (event) => {
      console.log(
        `[Peer ${this.peerId}] Data channel received:`,
        event.channel.label
      );
      this.dataChannel = event.channel;
      this.setupDataChannel();
      this.emit("data-channel", event.channel);
    };

    // 연결 상태 변경
    this.pc.onconnectionstatechange = () => {
      console.log(
        `[Peer ${this.peerId}] Connection state:`,
        this.pc.connectionState
      );
      this.emit("connection-state-change", this.pc.connectionState);
    };

    // ICE 연결 상태 변경
    this.pc.oniceconnectionstatechange = () => {
      console.log(
        `[Peer ${this.peerId}] ICE connection state:`,
        this.pc.iceConnectionState
      );
    };

    // ICE gathering 상태 변경
    this.pc.onicegatheringstatechange = () => {
      console.log(
        `[Peer ${this.peerId}] ICE gathering state:`,
        this.pc.iceGatheringState
      );
    };
  }

  private setupDataChannel(): void {
    if (!this.dataChannel) return;

    this.dataChannel.onmessage = (event) => {
      try {
        const message: DataChannelMessage = JSON.parse(event.data);
        this.emit("data-channel-message", message);
      } catch {
        console.error("Failed to parse data channel message");
      }
    };
  }

  /**
   * 로컬 미디어 스트림 추가
   */
  async addLocalStream(stream: MediaStream): Promise<void> {
    this.localStream = stream;
    stream.getTracks().forEach((track) => {
      this.pc.addTrack(track, stream);
    });
  }

  /**
   * 데이터 채널 생성
   */
  createDataChannel(
    label: string,
    options?: RTCDataChannelInit
  ): RTCDataChannel {
    this.dataChannel = this.pc.createDataChannel(label, options);
    this.setupDataChannel();
    return this.dataChannel;
  }

  /**
   * 데이터 채널로 메시지 전송
   */
  sendData(message: DataChannelMessage): void {
    if (!this.dataChannel || this.dataChannel.readyState !== "open") {
      throw new PeerError("Data channel not open");
    }
    this.dataChannel.send(JSON.stringify(message));
  }

  /**
   * Offer 생성
   */
  async createOffer(): Promise<SDPPayload> {
    try {
      const offer = await this.pc.createOffer();
      await this.pc.setLocalDescription(offer);
      return {
        sdp: offer.sdp!,
        type: "offer",
      };
    } catch (error) {
      throw new PeerError(
        `Failed to create offer: ${(error as Error).message}`
      );
    }
  }

  /**
   * Answer 생성
   */
  async createAnswer(): Promise<SDPPayload> {
    try {
      const answer = await this.pc.createAnswer();
      await this.pc.setLocalDescription(answer);
      return {
        sdp: answer.sdp!,
        type: "answer",
      };
    } catch (error) {
      throw new PeerError(
        `Failed to create answer: ${(error as Error).message}`
      );
    }
  }

  /**
   * Remote Description 설정
   */
  async setRemoteDescription(sdp: SDPPayload): Promise<void> {
    try {
      await this.pc.setRemoteDescription(
        new RTCSessionDescription({ type: sdp.type, sdp: sdp.sdp })
      );
    } catch (error) {
      throw new PeerError(
        `Failed to set remote description: ${(error as Error).message}`
      );
    }
  }

  /**
   * ICE Candidate 추가
   */
  async addIceCandidate(candidate: ICECandidatePayload): Promise<void> {
    try {
      await this.pc.addIceCandidate(
        new RTCIceCandidate({
          candidate: candidate.candidate,
          sdpMid: candidate.sdpMid,
          sdpMLineIndex: candidate.sdpMLineIndex,
        })
      );
    } catch (error) {
      throw new PeerError(
        `Failed to add ICE candidate: ${(error as Error).message}`
      );
    }
  }

  /**
   * 이벤트 핸들러 등록
   */
  on(event: PeerEventType, handler: PeerEventHandler): () => void {
    if (!this.eventHandlers.has(event)) {
      this.eventHandlers.set(event, new Set());
    }
    this.eventHandlers.get(event)!.add(handler);

    return () => {
      this.eventHandlers.get(event)?.delete(handler);
    };
  }

  private emit(event: PeerEventType, data: unknown): void {
    this.eventHandlers.get(event)?.forEach((handler) => {
      try {
        handler(data);
      } catch (error) {
        console.error(`Error in peer event handler for ${event}:`, error);
      }
    });
  }

  /**
   * 연결 상태
   */
  getConnectionState(): RTCPeerConnectionState {
    return this.pc.connectionState;
  }

  /**
   * Peer ID
   */
  getPeerId(): string {
    return this.peerId;
  }

  /**
   * 연결 종료
   */
  close(): void {
    this.dataChannel?.close();
    this.localStream?.getTracks().forEach((track) => track.stop());
    this.pc.close();
    this.eventHandlers.clear();
  }
}
