import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heoby_mobile/features/notification/presentation/providers/notification_providers.dart';
import 'package:heoby_mobile/shared/widgets/log/debug_log.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logger/logger.dart';

import 'app.dart';
import 'core/di/injection.dart';
import 'core/services/fcm_service.dart';
import 'core/services/wearable_service.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'firebase_options.dart';

/// 백그라운드 메시지 핸들러 (Top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Firebase 초기화 (백그라운드에서 실행될 때 필요)
  await Firebase.initializeApp();

  final logger = Logger();
  logger.i('백그라운드 메시지 수신: ${message.messageId}');
  logger.i('제목: ${message.notification?.title}');
  logger.i('내용: ${message.notification?.body}');
  logger.i('데이터: ${message.data}');

  // TODO: 백그라운드에서 필요한 처리 (예: 로컬 알림 표시)
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 환경 변수 로드
  await dotenv.load(fileName: '.env');

  // Firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 백그라운드 메시지 핸들러 등록
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 네이버 맵 SDK 초기화
  await FlutterNaverMap().init(
    clientId: dotenv.env['NAVER_MAP_CLIENT_ID'],
    onAuthFailed: (ex) {
      switch (ex) {
        case NQuotaExceededException(:final message):
          debugPrintLog("사용량 초과 (message: $message)");
          break;
        case NUnauthorizedClientException() || NClientUnspecifiedException() || NAnotherAuthFailedException():
          debugPrintLog("인증 실패: $ex");
          break;
      }
    },
  );

  final container = ProviderContainer();

  await setupDependencies(container);

  FcmService.instance.setNotificationRefreshHandler((message) {
    container.invalidate(notificationListProvider);
  });

  // FCM 초기화
  await FcmService.instance.initialize();

  // 앱 시작 전에 자동 로그인 시도
  await container.read(authProvider.notifier).initializeAuth();

  // Wearable 혈압 알림 핸들러 설정
  final logger = Logger();
  WearableService.setBloodPressureAlertCallback((alert) {
    logger.w('혈압 알림: ${alert.message}');
    logger.w('심각도: ${alert.severityText}, 수축기: ${alert.systolic}, 이완기: ${alert.diastolic}');

    // TODO: 여기서 UI 알림을 표시하거나 다른 처리를 할 수 있습니다
    // 예: 로컬 알림 표시, 특정 화면으로 이동 등
  });

  await initializeDateFormatting('ko');

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const App(),
    ),
  );
}
