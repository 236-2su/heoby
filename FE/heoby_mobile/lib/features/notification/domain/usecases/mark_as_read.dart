import 'package:heoby_mobile/features/notification/domain/repositories/notification_repository.dart';

class MarkAsRead {
  final NotificationRepository _repo;

  MarkAsRead(this._repo);

  Future<void> call(String alertUuid) async {
    return _repo.markAsRead(alertUuid);
  }
}
