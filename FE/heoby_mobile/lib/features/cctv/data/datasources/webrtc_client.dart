import 'dart:async';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../../../../core/utils/logger.dart';
import '../models/webrtc_models.dart';
import 'peer_connection_manager.dart';
import 'signaling_client.dart';

typedef WebRTCEventHandler = void Function(dynamic data);

/// WebRTC 클라이언트
class WebRTCClient {
  final WebRTCConfig config;
  late final SignalingClient _signaling;
  final Map<String, PeerConnectionManager> _peers = {};
  RTCStatus _status = RTCStatus.disconnected;
  MediaStream? _localStream;

  final Map<String, Set<WebRTCEventHandler>> _eventHandlers = {};

  WebRTCClient(this.config) {
    _signaling = SignalingClient(
      url: config.signalingServerUrl,
      maxReconnectAttempts: config.maxReconnectAttempts,
      getToken: config.getToken,
    );

    _setupSignalingHandlers();
  }

  /// 시그널링 핸들러 설정
  void _setupSignalingHandlers() {
    // Offer 수신
    _signaling.on(SignalingMessageType.offer, (message) async {
      final from = message['from'] as String?;
      if (from == null) return;

      await _handleOffer(from, message['payload'] as Map<String, dynamic>);
    });

    // Answer 수신
    _signaling.on(SignalingMessageType.answer, (message) async {
      final from = message['from'] as String?;
      if (from == null) return;

      await _handleAnswer(from, message['payload'] as Map<String, dynamic>);
    });

    // ICE Candidate 수신
    _signaling.on(SignalingMessageType.iceCandidate, (message) async {
      final from = message['from'] as String?;
      if (from == null) return;

      await _handleIceCandidate(from, message['payload'] as Map<String, dynamic>);
    });

    // Peer 연결 해제
    _signaling.on(SignalingMessageType.leave, (message) {
      final from = message['from'] as String?;
      if (from != null) {
        removePeer(from);
      }
    });
  }

  /// 연결 시작
  Future<void> connect({String? roomId}) async {
    try {
      _setStatus(RTCStatus.connecting);
      _signaling.connect();

      if (roomId != null) {
        await _signaling.send({
          'type': 'join',
          'payload': {'roomId': roomId},
        });
      }

      _setStatus(RTCStatus.connected);
      AppLogger.i('WebRTC connected');
    } catch (e) {
      _setStatus(RTCStatus.failed);
      AppLogger.e('Failed to connect WebRTC: $e');
      rethrow;
    }
  }

  /// 로컬 미디어 스트림 초기화
  Future<MediaStream> initLocalStream({
    bool video = true,
    bool audio = true,
  }) async {
    try {
      final constraints = {
        'video': video,
        'audio': audio,
      };

      _localStream = await navigator.mediaDevices.getUserMedia(constraints);
      AppLogger.i('Local stream initialized');
      return _localStream!;
    } catch (e) {
      AppLogger.e('Failed to get local media: $e');
      rethrow;
    }
  }

  /// Peer Connection 생성
  Future<PeerConnectionManager> _createPeerConnection(String peerId) async {
    if (_peers.containsKey(peerId)) {
      return _peers[peerId]!;
    }

    final peer = PeerConnectionManager(
      peerId: peerId,
      configuration: {
        'iceServers': config.iceServers,
      },
    );

    await peer.initialize();

    // ICE Candidate 전송
    peer.on('ice-candidate', (candidate) {
      if (_signaling.supportsTrickleIce) {
        unawaited(
          _signaling.send({
            'type': 'ice-candidate',
            'to': peerId,
            'payload': candidate,
          }),
        );
      }
    });

    // Track 수신
    peer.on('track', (stream) {
      _emit('track', {'peerId': peerId, 'stream': stream});
    });

    // 연결 상태 변경
    peer.on('connection-state-change', (state) {
      if (state == 'connected') {
        _emit('peer-connected', {'peerId': peerId});
      } else if (state == 'disconnected' || state == 'failed') {
        removePeer(peerId);
      }
    });

    // 데이터 채널 메시지
    peer.on('data-channel-message', (message) {
      _emit('data', {'peerId': peerId, 'message': message});
    });

    // 로컬 스트림이 있으면 추가
    if (_localStream != null) {
      await peer.addLocalStream(_localStream!);
    }

    _peers[peerId] = peer;
    return peer;
  }

  /// Offer 생성 및 전송
  Future<void> sendOffer(String peerId) async {
    final peer = await _createPeerConnection(peerId);
    final offer = await peer.createOffer();

    await _signaling.send({
      'type': 'offer',
      'to': peerId,
      'payload': offer,
    });

    AppLogger.d('Offer sent to $peerId');
  }

  /// Offer 처리
  Future<void> _handleOffer(String peerId, Map<String, dynamic> offer) async {
    final peer = await _createPeerConnection(peerId);
    await peer.setRemoteDescription(offer);

    final answer = await peer.createAnswer();
    await _signaling.send({
      'type': 'answer',
      'to': peerId,
      'payload': answer,
    });

    AppLogger.d('Answer sent to $peerId');
  }

  /// Answer 처리
  Future<void> _handleAnswer(String peerId, Map<String, dynamic> answer) async {
    final peer = _peers[peerId];
    if (peer == null) {
      AppLogger.e('Peer $peerId not found');
      return;
    }

    await peer.setRemoteDescription(answer);
    AppLogger.d('Answer received from $peerId');
  }

  /// ICE Candidate 처리
  Future<void> _handleIceCandidate(String peerId, Map<String, dynamic> candidate) async {
    final peer = _peers[peerId];
    if (peer == null) {
      AppLogger.e('Peer $peerId not found');
      return;
    }

    await peer.addIceCandidate(candidate);
  }

  /// 데이터 전송
  void sendData(String peerId, String message) {
    final peer = _peers[peerId];
    if (peer == null) {
      AppLogger.w('Peer $peerId not found');
      return;
    }
    peer.sendData(message);
  }

  /// 모든 Peer에게 데이터 전송
  void broadcastData(String message) {
    for (final peer in _peers.values) {
      try {
        peer.sendData(message);
      } catch (e) {
        AppLogger.e('Failed to send data to ${peer.getPeerId()}: $e');
      }
    }
  }

  /// Peer 제거
  void removePeer(String peerId) {
    final peer = _peers.remove(peerId);
    if (peer != null) {
      peer.close();
      _emit('peer-disconnected', {'peerId': peerId});
      AppLogger.d('Peer removed: $peerId');
    }
  }

  /// 모든 Peer 제거
  void removeAllPeers() {
    for (final peer in _peers.values) {
      peer.close();
    }
    _peers.clear();
    AppLogger.d('All peers removed');
  }

  /// 상태 변경
  void _setStatus(RTCStatus status) {
    _status = status;
  }

  /// 현재 상태
  RTCStatus getStatus() => _status;

  /// 연결된 Peer 목록
  List<String> getPeers() => _peers.keys.toList();

  /// 특정 Peer의 원격 스트림
  Stream<MediaStream>? getRemoteStream(String peerId) {
    return _peers[peerId]?.remoteStream;
  }

  /// 이벤트 핸들러 등록
  void on(String event, WebRTCEventHandler handler) {
    _eventHandlers.putIfAbsent(event, () => {});
    _eventHandlers[event]!.add(handler);
  }

  /// 이벤트 발생
  void _emit(String event, dynamic data) {
    final handlers = _eventHandlers[event];
    if (handlers != null) {
      for (final handler in handlers) {
        try {
          handler(data);
        } catch (e) {
          AppLogger.e('Error in WebRTC event handler for $event: $e');
        }
      }
    }
  }

  /// 연결 종료
  Future<void> close() async {
    for (final peer in _peers.values) {
      await peer.close();
    }
    _peers.clear();

    _localStream?.getTracks().forEach((track) => track.stop());
    _localStream?.dispose();
    _localStream = null;

    _signaling.close();
    _eventHandlers.clear();
    _setStatus(RTCStatus.disconnected);
    AppLogger.i('WebRTC client closed');
  }
}
