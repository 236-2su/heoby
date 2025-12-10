import 'package:heoby_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:heoby_mobile/features/notification/domain/entities/notification_entity.dart';
import 'package:heoby_mobile/features/notification/domain/repositories/notification_repository.dart';

class GetNotification {
  final NotificationRepository _repo;

  GetNotification(this._repo);

  Future<NotificationEntity> call(UserRole role) async {
    return _repo.getNotification(role);
  }
}
