import '../repositories/notification_repository.dart';

class RegisterFcmToken {
  final NotificationRepository repository;

  RegisterFcmToken(this.repository);

  Future<void> call({
    required String userUuid,
    required String platform,
    required String token,
  }) async {
    return await repository.registerFcmToken(
      userUuid: userUuid,
      platform: platform,
      token: token,
    );
  }
}
