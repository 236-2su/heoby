import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:heoby_mobile/shared/widgets/log/debug_log.dart';
import 'package:http/http.dart' as http;

import '../../features/cctv/data/models/webrtc_models.dart';

/// WHEP 기반 WebRTC 서비스
class WebRTCService {
  RTCPeerConnection? _peerConnection;
  MediaStream? _remoteStream;
  final StreamController<MediaStream> _streamController = StreamController<MediaStream>.broadcast();
  final StreamController<RTCStatus> _statusController = StreamController<RTCStatus>.broadcast();

  final String whepBaseUrl;
  RTCStatus _currentStatus = RTCStatus.disconnected;

  WebRTCService({required this.whepBaseUrl});

  /// 현재 상태
  RTCStatus get status => _currentStatus;

  /// 상태 스트림
  Stream<RTCStatus> get statusStream => _statusController.stream;

  /// WHEP 엔드포인트 URL 생성
  String _buildWhepUrl(String serialNumber) {
    // ${whepBaseUrl}/${serialNumber}/whep 형식
    return '$whepBaseUrl/$serialNumber/whep';
  }

  /// RTCPeerConnection 생성
  Future<RTCPeerConnection> _createPeerConnection() async {
    final configuration = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ],
    };

    final pc = await createPeerConnection(configuration);

    // Transceivers 추가 (recvonly)
    await pc.addTransceiver(
      kind: RTCRtpMediaType.RTCRtpMediaTypeVideo,
      init: RTCRtpTransceiverInit(direction: TransceiverDirection.RecvOnly),
    );
    await pc.addTransceiver(
      kind: RTCRtpMediaType.RTCRtpMediaTypeAudio,
      init: RTCRtpTransceiverInit(direction: TransceiverDirection.RecvOnly),
    );

    // onTrack 이벤트
    pc.onTrack = (RTCTrackEvent event) {
      if (event.streams.isNotEmpty) {
        _remoteStream = event.streams[0];
        _streamController.add(_remoteStream!);
      }
    };

    // 연결 상태 변경
    pc.onConnectionState = (RTCPeerConnectionState state) {
      debugPrint('PeerConnection state: $state');
      switch (state) {
        case RTCPeerConnectionState.RTCPeerConnectionStateConnected:
          _updateStatus(RTCStatus.connected);
          break;
        case RTCPeerConnectionState.RTCPeerConnectionStateConnecting:
          _updateStatus(RTCStatus.connecting);
          break;
        case RTCPeerConnectionState.RTCPeerConnectionStateFailed:
          _updateStatus(RTCStatus.failed);
          break;
        case RTCPeerConnectionState.RTCPeerConnectionStateDisconnected:
        case RTCPeerConnectionState.RTCPeerConnectionStateClosed:
          _updateStatus(RTCStatus.disconnected);
          break;
        default:
          break;
      }
    };

    // ICE 연결 상태
    pc.onIceConnectionState = (RTCIceConnectionState state) {
      debugPrint('ICE connection state: $state');
      if (state == RTCIceConnectionState.RTCIceConnectionStateFailed) {
        _updateStatus(RTCStatus.failed);
      }
    };

    return pc;
  }

  /// 상태 업데이트
  void _updateStatus(RTCStatus status) {
    _currentStatus = status;
    _statusController.add(status);
  }

  /// PeerConnection 정리
  Future<void> _cleanupPeerConnection() async {
    if (_peerConnection != null) {
      await _peerConnection!.close();
      _peerConnection = null;
    }
    _remoteStream = null;
  }

  /// CCTV 연결 (WHEP 프로토콜)
  Future<void> connectToCctv(String serialNumber) async {
    try {
      _updateStatus(RTCStatus.connecting);
      await _cleanupPeerConnection();

      // PeerConnection 생성
      _peerConnection = await _createPeerConnection();

      // Offer 생성
      final offer = await _peerConnection!.createOffer();
      await _peerConnection!.setLocalDescription(offer);

      // WHEP 엔드포인트로 POST 요청
      final endpoint = _buildWhepUrl(serialNumber);
      debugPrintLog('WHEP endpoint: $endpoint');

      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/sdp',
          'Accept': 'application/sdp',
        },
        body: offer.sdp,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('WHEP 요청 실패 (status: ${response.statusCode})');
      }

      // Answer SDP 설정
      final answerSdp = response.body;
      await _peerConnection!.setRemoteDescription(
        RTCSessionDescription(answerSdp, 'answer'),
      );

      debugPrint('WHEP 연결 성공: $serialNumber');
    } catch (e) {
      debugPrint('CCTV 연결 실패: $e');
      await _cleanupPeerConnection();
      _updateStatus(RTCStatus.failed);
      rethrow;
    }
  }

  /// CCTV 연결 해제
  Future<void> disconnectCctv() async {
    await _cleanupPeerConnection();
    _updateStatus(RTCStatus.disconnected);
  }

  /// 원격 스트림 가져오기
  Stream<MediaStream> get remoteStream => _streamController.stream;

  /// 종료
  Future<void> dispose() async {
    await _cleanupPeerConnection();
    await _streamController.close();
    await _statusController.close();
  }
}
