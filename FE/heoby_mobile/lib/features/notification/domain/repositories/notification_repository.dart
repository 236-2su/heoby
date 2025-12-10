import 'package:heoby_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:heoby_mobile/features/notification/domain/entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<NotificationEntity> getNotification(UserRole role);

  /// FCM 토큰 등록
  Future<void> registerFcmToken({
    required String userUuid,
    required String platform,
    required String token,
  });

  /// FCM 토큰 해제
  Future<void> unregisterFcmToken({
    required String userUuid,
    required String platform,
    required String token,
  });

  /// 알림 읽음 처리
  Future<void> markAsRead(String alertUuid);
}
