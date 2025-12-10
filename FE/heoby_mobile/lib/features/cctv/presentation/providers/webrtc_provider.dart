import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/webrtc_models.dart';
import '../../../../core/services/webrtc_service.dart';

part 'webrtc_provider.g.dart';

/// WebRTC 서비스 Provider (WHEP 기반)
@riverpod
WebRTCService webrtcService(Ref ref) {
  // .env에서 CCTV Base URL 가져오기
  final whepBaseUrl = dotenv.env['CCTV_BASE_URL'] ?? 'http://k13e106.p.ssafy.io:8889/whep';
  final service = WebRTCService(whepBaseUrl: whepBaseUrl);

  ref.onDispose(() {
    service.dispose();
  });

  return service;
}

/// WebRTC 연결 상태
@riverpod
class WebrtcConnection extends _$WebrtcConnection {
  @override
  RTCStatus build() {
    // 서비스의 상태 스트림을 구독하여 상태 동기화
    final service = ref.watch(webrtcServiceProvider);
    service.statusStream.listen((status) {
      state = status;
    });
    return service.status;
  }

  /// CCTV 연결 (Serial Number 사용)
  Future<void> connectToCctv(String serialNumber) async {
    try {
      final service = ref.read(webrtcServiceProvider);
      await service.connectToCctv(serialNumber);
    } catch (e) {
      rethrow;
    }
  }

  /// CCTV 연결 해제
  Future<void> disconnectCctv() async {
    final service = ref.read(webrtcServiceProvider);
    await service.disconnectCctv();
  }
}

/// 현재 연결된 CCTV Serial Number
@riverpod
class ConnectedCctv extends _$ConnectedCctv {
  @override
  String? build() {
    return null;
  }

  void setCctv(String? serialNumber) {
    state = serialNumber;
  }
}

/// CCTV 스트림 Provider
@riverpod
Stream<MediaStream> cctvStream(Ref ref, String serialNumber) {
  final service = ref.watch(webrtcServiceProvider);
  return service.remoteStream;
}
