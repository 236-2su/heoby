/// WebRTC 관련 모델 정의
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'webrtc_models.freezed.dart';
part 'webrtc_models.g.dart';

/// WebRTC 연결 상태
enum RTCStatus {
  disconnected,
  connecting,
  connected,
  failed,
}

/// 시그널링 상태
enum SignalingStatus {
  disconnected,
  connecting,
  connected,
}

/// 시그널링 메시지 타입
enum SignalingMessageType {
  offer,
  answer,
  @JsonValue('ice-candidate')
  iceCandidate,
  join,
  leave,
  error,
}

/// 시그널링 메시지
@freezed
class SignalingMessage with _$SignalingMessage {
  const factory SignalingMessage({
    required SignalingMessageType type,
    Map<String, dynamic>? payload,
    String? from,
    String? to,
    String? roomId,
    int? timestamp,
  }) = _SignalingMessage;

  factory SignalingMessage.fromJson(Map<String, dynamic> json) =>
      _$SignalingMessageFromJson(json);
}

/// SDP Offer/Answer Payload
@freezed
class SDPPayload with _$SDPPayload {
  const factory SDPPayload({
    required String sdp,
    required String type, // "offer" or "answer"
  }) = _SDPPayload;

  factory SDPPayload.fromJson(Map<String, dynamic> json) =>
      _$SDPPayloadFromJson(json);
}

/// ICE Candidate Payload
@freezed
class ICECandidatePayload with _$ICECandidatePayload {
  const factory ICECandidatePayload({
    required String candidate,
    String? sdpMid,
    int? sdpMLineIndex,
  }) = _ICECandidatePayload;

  factory ICECandidatePayload.fromJson(Map<String, dynamic> json) =>
      _$ICECandidatePayloadFromJson(json);
}

/// WebRTC 설정
class WebRTCConfig {
  final String signalingServerUrl;
  final List<Map<String, dynamic>> iceServers;
  final bool autoReconnect;
  final int maxReconnectAttempts;
  final String? Function()? getToken;

  WebRTCConfig({
    required this.signalingServerUrl,
    List<Map<String, dynamic>>? iceServers,
    this.autoReconnect = true,
    this.maxReconnectAttempts = 5,
    this.getToken,
  }) : iceServers = iceServers ??
            [
              {'urls': 'stun:stun.l.google.com:19302'},
              {'urls': 'stun:stun1.l.google.com:19302'},
            ];
}
