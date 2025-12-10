/**
 * WebRTC 에러 클래스
 */

export class WebRTCBaseError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "WebRTCBaseError";
  }
}

export class SignalingError extends WebRTCBaseError {
  constructor(message: string) {
    super(message);
    this.name = "SignalingError";
  }
}

export class ConnectionError extends WebRTCBaseError {
  constructor(message: string) {
    super(message);
    this.name = "ConnectionError";
  }
}

export class MediaError extends WebRTCBaseError {
  constructor(message: string) {
    super(message);
    this.name = "MediaError";
  }
}

export class PeerError extends WebRTCBaseError {
  constructor(message: string) {
    super(message);
    this.name = "PeerError";
  }
}
