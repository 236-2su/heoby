import 'dart:async';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../../../../core/utils/logger.dart';

typedef PeerEventHandler = void Function(dynamic data);

/// Peer Connection 관리자
class PeerConnectionManager {
  final String peerId;
  final Map<String, dynamic> configuration;

  RTCPeerConnection? _peerConnection;
  RTCDataChannel? _dataChannel;
  final StreamController<MediaStream> _remoteStreamController = StreamController.broadcast();
  final Map<String, Set<PeerEventHandler>> _eventHandlers = {};

  PeerConnectionManager({
    required this.peerId,
    required this.configuration,
  });

  /// Peer Connection 초기화
  Future<void> initialize() async {
    try {
      _peerConnection = await createPeerConnection(configuration);

      // ICE Candidate 이벤트
      _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
        _emit('ice-candidate', {
          'candidate': candidate.candidate,
          'sdpMid': candidate.sdpMid,
          'sdpMLineIndex': candidate.sdpMLineIndex,
        });
      };

      // Track 수신 이벤트
      _peerConnection!.onTrack = (RTCTrackEvent event) {
        if (event.streams.isNotEmpty) {
          _remoteStreamController.add(event.streams[0]);
          _emit('track', event.streams[0]);
        }
      };

      // 연결 상태 변경 이벤트
      _peerConnection!.onConnectionState = (RTCPeerConnectionState state) {
        AppLogger.d('Peer $peerId connection state: $state');
        _emit('connection-state-change', state.name);
      };

      // ICE 연결 상태 변경
      _peerConnection!.onIceConnectionState = (RTCIceConnectionState state) {
        AppLogger.d('Peer $peerId ICE connection state: $state');
      };

      AppLogger.i('Peer connection initialized for $peerId');
    } catch (e) {
      AppLogger.e('Failed to initialize peer connection: $e');
      rethrow;
    }
  }

  /// Offer 생성
  Future<Map<String, dynamic>> createOffer() async {
    if (_peerConnection == null) {
      throw Exception('Peer connection not initialized');
    }

    try {
      final offer = await _peerConnection!.createOffer();
      await _peerConnection!.setLocalDescription(offer);

      return {
        'sdp': offer.sdp,
        'type': offer.type,
      };
    } catch (e) {
      AppLogger.e('Failed to create offer: $e');
      rethrow;
    }
  }

  /// Answer 생성
  Future<Map<String, dynamic>> createAnswer() async {
    if (_peerConnection == null) {
      throw Exception('Peer connection not initialized');
    }

    try {
      final answer = await _peerConnection!.createAnswer();
      await _peerConnection!.setLocalDescription(answer);

      return {
        'sdp': answer.sdp,
        'type': answer.type,
      };
    } catch (e) {
      AppLogger.e('Failed to create answer: $e');
      rethrow;
    }
  }

  /// Remote Description 설정
  Future<void> setRemoteDescription(Map<String, dynamic> sdp) async {
    if (_peerConnection == null) {
      throw Exception('Peer connection not initialized');
    }

    try {
      final description = RTCSessionDescription(
        sdp['sdp'] as String,
        sdp['type'] as String,
      );
      await _peerConnection!.setRemoteDescription(description);
      AppLogger.d('Remote description set for $peerId');
    } catch (e) {
      AppLogger.e('Failed to set remote description: $e');
      rethrow;
    }
  }

  /// ICE Candidate 추가
  Future<void> addIceCandidate(Map<String, dynamic> candidateData) async {
    if (_peerConnection == null) {
      throw Exception('Peer connection not initialized');
    }

    try {
      final candidate = RTCIceCandidate(
        candidateData['candidate'] as String,
        candidateData['sdpMid'] as String?,
        candidateData['sdpMLineIndex'] as int?,
      );
      await _peerConnection!.addCandidate(candidate);
      AppLogger.d('ICE candidate added for $peerId');
    } catch (e) {
      AppLogger.e('Failed to add ICE candidate: $e');
      rethrow;
    }
  }

  /// 로컬 스트림 추가
  Future<void> addLocalStream(MediaStream stream) async {
    if (_peerConnection == null) {
      throw Exception('Peer connection not initialized');
    }

    try {
      stream.getTracks().forEach((track) {
        _peerConnection!.addTrack(track, stream);
      });
      AppLogger.d('Local stream added to $peerId');
    } catch (e) {
      AppLogger.e('Failed to add local stream: $e');
      rethrow;
    }
  }

  /// 데이터 채널 생성
  Future<void> createDataChannel(String label) async {
    if (_peerConnection == null) {
      throw Exception('Peer connection not initialized');
    }

    try {
      _dataChannel = await _peerConnection!.createDataChannel(label, RTCDataChannelInit());

      _dataChannel!.onMessage = (RTCDataChannelMessage message) {
        _emit('data-channel-message', message.text);
      };

      AppLogger.d('Data channel created: $label');
    } catch (e) {
      AppLogger.e('Failed to create data channel: $e');
      rethrow;
    }
  }

  /// 데이터 전송
  void sendData(String message) {
    if (_dataChannel == null) {
      AppLogger.w('Data channel not available');
      return;
    }

    try {
      _dataChannel!.send(RTCDataChannelMessage(message));
    } catch (e) {
      AppLogger.e('Failed to send data: $e');
    }
  }

  /// 이벤트 핸들러 등록
  void on(String event, PeerEventHandler handler) {
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
          AppLogger.e('Error in peer event handler: $e');
        }
      }
    }
  }

  /// 원격 스트림
  Stream<MediaStream> get remoteStream => _remoteStreamController.stream;

  /// Peer ID
  String getPeerId() => peerId;

  /// 연결 종료
  Future<void> close() async {
    await _dataChannel?.close();
    await _peerConnection?.close();
    await _remoteStreamController.close();
    _eventHandlers.clear();
    AppLogger.d('Peer connection closed for $peerId');
  }
}
