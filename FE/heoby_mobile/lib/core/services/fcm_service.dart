import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';

/// 백그라운드/종료 상태 메시지 핸들러 (⭐️ 반드시 top-level)
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // 백그라운드 isolate에서 Firebase 초기화 필요
  await Firebase.initializeApp();
  // 필요하면 로깅/분석 처리
  // debugPrintLog('🔕 BG message: ${message.messageId}, data: ${message.data}');
}

/// Firebase Cloud Messaging + 로컬 알림 통합 서비스
class FcmService {
  FcmService._();
  static final FcmService instance = FcmService._();

  final _log = Logger();
  final _messaging = FirebaseMessaging.instance;
  final _local = FlutterLocalNotificationsPlugin();

  void Function(RemoteMessage message)? _onNotificationMessage;

  void setNotificationRefreshHandler(void Function(RemoteMessage message) handler) {
    _onNotificationMessage = handler;
  }

  static const AndroidNotificationChannel _androidChannel = AndroidNotificationChannel(
    'heoby_default_channel',
    'Heoby Notifications',
    description: 'Heoby foreground notifications',
    importance: Importance.high,
  );

  String? _token;
  String? get fcmToken => _token;

  /// 초기화 (main.dart에서 Firebase.initializeApp() 이후 호출 필수)
  Future<void> initialize() async {
    try {
      // iOS 권한 요청 (Android에서는 불필요)
      if (Platform.isIOS) {
        final settings = await _messaging.requestPermission(
          alert: true,
          badge: true,
          sound: true,
          provisional: false,
        );
        _log.i('FCM 권한 상태: ${settings.authorizationStatus}');
        if (settings.authorizationStatus == AuthorizationStatus.denied) {
          _log.w('알림 권한이 거부됨. 알림 표시 불가.');
          // 계속 진행은 하되 표시만 안 됨
        }
        // iOS 포그라운드 알림 표시 옵션
        await _messaging.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
      }

      // 로컬 알림 초기화 + 채널 생성
      await _initLocalNotifications();

      // 토큰 획득/갱신
      _token = await _messaging.getToken();
      _log.i('FCM 토큰: $_token');
      _messaging.onTokenRefresh.listen((t) {
        _token = t;
        _log.i('FCM 토큰 갱신: $t');
        // TODO: 서버 갱신 API 호출
      });

      // 포그라운드 메시지 → 로컬 알림 표시
      FirebaseMessaging.onMessage.listen(_onForegroundMessage);

      // 앱이 백그라운드/종료 상태에서 알림 탭으로 열릴 때
      FirebaseMessaging.onMessageOpenedApp.listen(_onOpenFromNotification);

      // 완전 종료 상태에서 시작 시 초기 메시지 확인
      final initial = await _messaging.getInitialMessage();
      if (initial != null) {
        _onOpenFromNotification(initial);
      }

      _log.i('FCM 초기화 완료');
    } catch (e, s) {
      _log.e('FCM 초기화 실패: $e');
      _log.d(s);
    }
  }

  /// 로컬 알림 초기화
  Future<void> _initLocalNotifications() async {
    // 클릭 콜백 (로컬 알림 탭 시)
    void onSelect(NotificationResponse r) {
      // r.payload 등을 이용해 라우팅 가능
      // _log.i('로컬 알림 탭: ${r.payload}');
    }

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const init = InitializationSettings(android: androidInit, iOS: iosInit);

    await _local.initialize(init, onDidReceiveNotificationResponse: onSelect);

    // Android 8.0+ 채널 생성
    await _local
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);
  }

  /// 포그라운드 수신 처리 → 로컬 알림 표시 + 워치로 전송
  void _onForegroundMessage(RemoteMessage message) {
    _log.i('포그라운드 메시지 수신: ${message.messageId}');
    _log.i('제목: ${message.notification?.title}');
    _log.i('내용: ${message.notification?.body}');
    _log.i('데이터: ${message.data}');

    final n = message.notification;
    if (n == null) return;

    // 로컬 알림 표시
    _local.show(
      n.hashCode,
      n.title ?? 'Heoby',
      n.body ?? '',
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          icon: '@mipmap/ic_launcher',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: message.data.isEmpty ? null : message.data.toString(),
    );

    _onNotificationMessage?.call(message);
  }

  /// 알림 탭으로 앱이 열렸을 때 처리 (백그라운드/종료 → 포그라운드)
  void _onOpenFromNotification(RemoteMessage message) {
    _log.i('알림 탭으로 앱 열림: ${message.messageId}');
    _log.i('데이터: ${message.data}');
    // TODO: message.data['screen'] 등에 따라 라우팅

    _onNotificationMessage?.call(message);
  }

  /// 토픽 구독/해제/토큰 삭제
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      _log.i('토픽 구독 완료: $topic');
    } catch (e) {
      _log.e('토픽 구독 실패: $e');
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      _log.i('토픽 구독 해제 완료: $topic');
    } catch (e) {
      _log.e('토픽 구독 해제 실패: $e');
    }
  }

  Future<void> deleteToken() async {
    try {
      await _messaging.deleteToken();
      _token = null;
      _log.i('FCM 토큰 삭제 완료');
    } catch (e) {
      _log.e('FCM 토큰 삭제 실패: $e');
    }
  }
}
