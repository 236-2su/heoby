/**
 * 시그널링 서버 클라이언트
 * WebSocket을 사용하여 시그널링 서버와 통신
 */

import { SignalingError } from "./errors";
import type { SignalingMessage, SignalingStatus } from "./types";

type SignalingEventHandler = (message: SignalingMessage) => void;

export class SignalingClient {
  private ws?: WebSocket;
  private status: SignalingStatus = "DISCONNECTED";
  private url: string;
  private handlers = new Map<string, Set<SignalingEventHandler>>();
  private reconnectAttempt = 0;
  private maxReconnectAttempts: number;
  private closedByUser = false;
  private getToken?: () => string | null;

  constructor(
    url: string,
    options?: {
      maxReconnectAttempts?: number;
      getToken?: () => string | null;
    }
  ) {
    this.url = url;
    this.maxReconnectAttempts = options?.maxReconnectAttempts ?? 5;
    this.getToken = options?.getToken;
  }

  getStatus(): SignalingStatus {
    return this.status;
  }

  connect(): Promise<void> {
    if (
      this.ws &&
      (this.status === "CONNECTED" || this.status === "CONNECTING")
    ) {
      return Promise.resolve();
    }

    this.closedByUser = false;
    this.setStatus("CONNECTING");

    return new Promise((resolve, reject) => {
      console.log(`[Signaling] Connecting to ${this.url}...`);

      try {
        this.ws = new WebSocket(this.url);
        console.log(`[Signaling] WebSocket created, readyState: ${this.ws.readyState}`);
      } catch (error) {
        console.error("[Signaling] Failed to create WebSocket:", error);
        this.setStatus("DISCONNECTED");
        reject(
          new SignalingError(
            `Failed to create WebSocket: ${(error as Error).message}`
          )
        );
        return;
      }

      // 연결 타임아웃 설정 (10초)
      const connectionTimeout = setTimeout(() => {
        if (this.ws && this.ws.readyState !== WebSocket.OPEN) {
          console.error("[Signaling] Connection timeout");
          this.ws.close();
          reject(new SignalingError("Connection timeout"));
        }
      }, 10000);

      this.ws.onopen = () => {
        console.log("[Signaling] WebSocket connected!");
        clearTimeout(connectionTimeout);
        this.setStatus("CONNECTED");
        this.reconnectAttempt = 0;

        // 인증 토큰이 있으면 전송
        if (this.getToken) {
          const token = this.getToken();
          if (token) {
            this.send({ type: "join", payload: { token } });
          }
        }

        resolve();
      };

      this.ws.onmessage = (event) => {
        this.handleMessage(event.data);
      };

      this.ws.onerror = (error) => {
        console.error("[Signaling] WebSocket error:", error);
        clearTimeout(connectionTimeout);
      };

      this.ws.onclose = (event) => {
        console.log(`[Signaling] WebSocket closed: code=${event.code}, reason=${event.reason || 'none'}, wasClean=${event.wasClean}`);
        clearTimeout(connectionTimeout);
        this.setStatus("DISCONNECTED");

        if (!this.closedByUser) {
          this.scheduleReconnect();
        }

        // 연결 중에 닫힌 경우 reject
        if (this.ws?.readyState === WebSocket.CONNECTING || !event.wasClean) {
          reject(new SignalingError(`WebSocket closed: code=${event.code}, reason=${event.reason || 'Connection failed'}`));
        }
      };
    });
  }

  private setStatus(status: SignalingStatus): void {
    this.status = status;
    this.emit("status", { type: "error", payload: { status } });
  }

  private scheduleReconnect(): void {
    if (this.reconnectAttempt >= this.maxReconnectAttempts) {
      console.error("Max reconnect attempts reached");
      return;
    }

    const delay = Math.min(1000 * Math.pow(2, this.reconnectAttempt), 30000);
    this.reconnectAttempt++;

    setTimeout(() => {
      console.log(`Reconnecting... Attempt ${this.reconnectAttempt}`);
      this.connect();
    }, delay);
  }

  private handleMessage(data: string | ArrayBuffer): void {
    try {
      const text =
        typeof data === "string" ? data : new TextDecoder().decode(data);
      const message: SignalingMessage = JSON.parse(text);

      console.log(`[Signaling] Received message type: ${message.type}`, message);
      this.emit(message.type, message);
    } catch (error) {
      console.error("Failed to parse signaling message:", error);
    }
  }

  send(message: SignalingMessage): void {
    if (this.status !== "CONNECTED" || !this.ws) {
      throw new SignalingError("Signaling server not connected");
    }

    try {
      this.ws.send(JSON.stringify(message));
    } catch (error) {
      throw new SignalingError(
        `Failed to send message: ${(error as Error).message}`
      );
    }
  }

  on(type: string, handler: SignalingEventHandler): () => void {
    if (!this.handlers.has(type)) {
      this.handlers.set(type, new Set());
    }
    this.handlers.get(type)!.add(handler);

    return () => {
      this.handlers.get(type)?.delete(handler);
    };
  }

  private emit(type: string, message: SignalingMessage): void {
    this.handlers.get(type)?.forEach((handler) => {
      try {
        handler(message);
      } catch (error) {
        console.error(`Error in signaling handler for ${type}:`, error);
      }
    });
  }

  close(): void {
    this.closedByUser = true;
    this.handlers.clear();
    this.ws?.close();
    this.setStatus("DISCONNECTED");
  }
}
