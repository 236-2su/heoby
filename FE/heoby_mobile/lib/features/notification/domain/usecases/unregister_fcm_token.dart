import '../repositories/notification_repository.dart';

class UnregisterFcmToken {
  final NotificationRepository repository;

  UnregisterFcmToken(this.repository);

  Future<void> call({
    required String userUuid,
    required String platform,
    required String token,
  }) async {
    return await repository.unregisterFcmToken(
      userUuid: userUuid,
      platform: platform,
      token: token,
    );
  }
}
