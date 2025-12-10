import 'package:heoby_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:heoby_mobile/features/notification/data/datasources/notification_remote_data_source.dart';
import 'package:heoby_mobile/features/notification/data/models/notification_model.dart';
import 'package:heoby_mobile/features/notification/domain/entities/notification_entity.dart';
import 'package:heoby_mobile/features/notification/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remote;

  NotificationRepositoryImpl(this._remote);

  @override
  Future<NotificationEntity> getNotification(UserRole role) async {
    final NotificationModel response = await _remote.getNotification(role);

    return response.toEntity();
  }

  @override
  Future<void> registerFcmToken({
    required String userUuid,
    required String platform,
    required String token,
  }) async {
    await _remote.registerFcmToken(
      userUuid: userUuid,
      platform: platform,
      token: token,
    );
  }

  @override
  Future<void> unregisterFcmToken({
    required String userUuid,
    required String platform,
    required String token,
  }) async {
    await _remote.unregisterFcmToken(
      userUuid: userUuid,
      platform: platform,
      token: token,
    );
  }

  @override
  Future<void> markAsRead(String alertUuid) async {
    await _remote.markAsRead(alertUuid);
  }
}
