import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heoby_mobile/core/di/injection.dart';
import 'package:heoby_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:heoby_mobile/features/auth/presentation/providers/user_provider.dart';
import 'package:heoby_mobile/features/notification/domain/entities/notification_entity.dart';
import 'package:heoby_mobile/features/notification/domain/usecases/get_notification.dart';
import 'package:heoby_mobile/features/notification/domain/usecases/mark_as_read.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_providers.g.dart';

/// 알림 목록 Provider
@riverpod
Future<NotificationEntity> notificationList(Ref ref) async {
  final user = ref.read(userProvider);
  final role = user?.role ?? UserRole.user;
  final usecase = getIt<GetNotification>();

  return usecase(role);
}

/// 알림 읽음 처리 Provider
final notificationActionsProvider = Provider<NotificationActions>((ref) {
  return NotificationActions(ref);
});

class NotificationActions {
  final Ref _ref;

  NotificationActions(this._ref);

  /// 알림을 읽음 처리하고 목록을 새로고침
  Future<void> markAsRead(String alertUuid) async {
    final usecase = getIt<MarkAsRead>();
    await usecase(alertUuid);

    // 알림 목록 새로고침
    _ref.invalidate(notificationListProvider);
  }
}
