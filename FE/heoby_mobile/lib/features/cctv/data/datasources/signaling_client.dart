import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../../core/utils/logger.dart';
import '../models/webrtc_models.dart';

typedef SignalingEventHandler = void Function(Map<String, dynamic> message);

/// WebSocket 기반 시그널링 클라이언트
class SignalingClient {
  final String url;
  final int maxReconnectAttempts;
  final String? Function()? getToken;

  final bool _useHttp;
  final Dio _httpClient;
  final Map<String, Uri> _httpResources = {};

  WebSocketChannel? _channel;
  SignalingStatus _status = SignalingStatus.disconnected;
  int _reconnectAttempts = 0;
  Timer? _reconnectTimer;

  final Map<SignalingMessageType, Set<SignalingEventHandler>> _eventHandlers = {};

  SignalingClient({
    required this.url,
    this.maxReconnectAttempts = 5,
    this.getToken,
  })  : _useHttp = _isHttp(url),
        _httpClient = Dio(BaseOptions(responseType: ResponseType.plain));

  static bool _isHttp(String targetUrl) {
    final scheme = Uri.parse(targetUrl).scheme;
    return scheme == 'http' || scheme == 'https';
  }

  /// 연결 시작
  void connect() {
    if (_status == SignalingStatus.connected || _status == SignalingStatus.connecting) {
      return;
    }

    if (_useHttp) {
      _setStatus(SignalingStatus.connected);
      AppLogger.i('Signaling (HTTP/WHEP) ready: $url');
      return;
    }

    try {
      _setStatus(SignalingStatus.connecting);

      // WebSocket URL에 토큰 추가 (필요한 경우)
      String wsUrl = url;
      if (getToken != null) {
        final token = getToken!();
        if (token != null) {
          wsUrl = '$url?token=$token';
        }
      }

      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

      // 메시지 수신 리스너
      _channel!.stream.listen(
        _handleMessage,
        onError: _handleError,
        onDone: _handleDisconnect,
      );

      _setStatus(SignalingStatus.connected);
      _reconnectAttempts = 0;
      AppLogger.i('Signaling connected to $url');
    } catch (e) {
      AppLogger.e('Failed to connect signaling: $e');
      _handleError(e);
    }
  }

  /// 메시지 전송
  Future<void> send(Map<String, dynamic> message) async {
    if (_useHttp) {
      await _handleHttpMessage(message);
      return;
    }

    if (_status != SignalingStatus.connected || _channel == null) {
      AppLogger.w('Cannot send message: not connected');
      return;
    }

    try {
      final jsonString = json.encode(message);
      _channel!.sink.add(jsonString);
      AppLogger.d('Sent signaling message: ${message['type']}');
    } catch (e) {
      AppLogger.e('Failed to send message: $e');
    }
  }

  Future<void> _handleHttpMessage(Map<String, dynamic> message) async {
    final type = message['type'] as String?;
    if (type == null) return;

    switch (type) {
      case 'offer':
        await _sendWhepOffer(message);
        break;
      case 'ice-candidate':
        await _sendWhepIceCandidate(message);
        break;
      default:
        break;
    }
  }

  Future<void> _sendWhepOffer(Map<String, dynamic> message) async {
    final payload = message['payload'] as Map<String, dynamic>?;
    final peerId = message['to'] as String?;
    final sdp = payload?['sdp'] as String?;
    if (sdp == null) return;

    final uri = _buildHttpUri(peerId);

    try {
      final response = await _httpClient.postUri(
        uri,
        data: sdp,
        options: Options(
          headers: {'Content-Type': 'application/sdp'},
        ),
      );

      final answerSdp = response.data as String?;
      if (peerId != null) {
        final location = response.headers.value('location');
        if (location != null && location.isNotEmpty) {
          _httpResources[peerId] = Uri.parse(location);
        }
      }

      if (answerSdp != null) {
        _emit(
          SignalingMessageType.answer,
          {
            'from': peerId,
            'payload': {
              'sdp': answerSdp,
              'type': 'answer',
            },
          },
        );
      }
    } catch (e) {
      AppLogger.e('Failed WHEP offer: $e');
    }
  }

  Future<void> _sendWhepIceCandidate(Map<String, dynamic> message) async {
    // 현재 WHEP 엔드포인트에서는 Trickle ICE가 필요하지 않습니다.
    // 필요 시 Location 헤더를 사용해 PATCH 요청을 구현하세요.
  }

  Uri _buildHttpUri(String? peerId) {
    final uri = Uri.parse(url);
    final query = Map<String, String>.from(uri.queryParameters);
    if (getToken != null) {
      final token = getToken!();
      if (token != null && token.isNotEmpty) {
        query['token'] = token;
      }
    }
    if (peerId != null) {
      query['peer'] = peerId;
    }
    return uri.replace(queryParameters: query);
  }

  /// 메시지 수신 처리
  void _handleMessage(dynamic data) {
    try {
      final message = json.decode(data as String) as Map<String, dynamic>;
      final typeStr = message['type'] as String?;

      if (typeStr == null) return;

      // 메시지 타입 매핑
      SignalingMessageType? messageType;
      switch (typeStr) {
        case 'offer':
          messageType = SignalingMessageType.offer;
          break;
        case 'answer':
          messageType = SignalingMessageType.answer;
          break;
        case 'ice-candidate':
          messageType = SignalingMessageType.iceCandidate;
          break;
        case 'join':
          messageType = SignalingMessageType.join;
          break;
        case 'leave':
          messageType = SignalingMessageType.leave;
          break;
        case 'error':
          messageType = SignalingMessageType.error;
          break;
      }

      if (messageType != null) {
        _emit(messageType, message);
      }
    } catch (e) {
      AppLogger.e('Failed to handle message: $e');
    }
  }

  /// 에러 처리
  void _handleError(dynamic error) {
    AppLogger.e('Signaling error: $error');
    if (!_useHttp) {
      _tryReconnect();
    }
  }

  /// 연결 해제 처리
  void _handleDisconnect() {
    AppLogger.w('Signaling disconnected');
    _setStatus(SignalingStatus.disconnected);
    if (!_useHttp) {
      _tryReconnect();
    }
  }

  /// 재연결 시도
  void _tryReconnect() {
    if (_useHttp) return;
    if (_reconnectAttempts >= maxReconnectAttempts) {
      AppLogger.e('Max reconnect attempts reached');
      return;
    }

    _reconnectAttempts++;
    final delay = Duration(seconds: _reconnectAttempts * 2);

    AppLogger.i('Reconnecting in ${delay.inSeconds}s... (attempt $_reconnectAttempts/$maxReconnectAttempts)');

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, () {
      connect();
    });
  }

  /// 이벤트 핸들러 등록
  void on(SignalingMessageType type, SignalingEventHandler handler) {
    _eventHandlers.putIfAbsent(type, () => {});
    _eventHandlers[type]!.add(handler);
  }

  /// 이벤트 핸들러 제거
  void off(SignalingMessageType type, SignalingEventHandler handler) {
    _eventHandlers[type]?.remove(handler);
  }

  /// 이벤트 발생
  void _emit(SignalingMessageType type, Map<String, dynamic> data) {
    final handlers = _eventHandlers[type];
    if (handlers != null) {
      for (final handler in handlers) {
        try {
          handler(data);
        } catch (e) {
          AppLogger.e('Error in signaling event handler: $e');
        }
      }
    }
  }

  /// 상태 변경
  void _setStatus(SignalingStatus status) {
    _status = status;
  }

  /// 현재 상태
  SignalingStatus get status => _status;

  /// 연결 종료
  void close() {
    _reconnectTimer?.cancel();
    if (_channel != null) {
      _channel?.sink.close();
      _channel = null;
    }
    _httpResources.clear();
    _eventHandlers.clear();
    _setStatus(SignalingStatus.disconnected);
    AppLogger.i('Signaling client closed');
  }

  bool get supportsTrickleIce => !_useHttp;
}
