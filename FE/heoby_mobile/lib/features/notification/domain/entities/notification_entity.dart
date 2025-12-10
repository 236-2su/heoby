import 'package:heoby_mobile/core/models/location.dart';

class NotificationEntity {
  final NotificationSummaryEntity summary;
  final List<NotificationAlertEntity> alerts;

  NotificationEntity({
    required this.summary,
    required this.alerts,
  });
}

class NotificationSummaryEntity {
  final int criticalUnread;
  final int warningUnread;
  final int totalUnread;

  NotificationSummaryEntity({
    required this.criticalUnread,
    required this.warningUnread,
    required this.totalUnread,
  });
}

class NotificationAlertEntity {
  final String alertUuid;
  final String level;
  final String type;
  final String message;
  final String heobyUuid;
  final String heobyName;
  final Location location;
  final String occurredAt;
  final String snapshotUrl;
  final bool isRead;

  NotificationAlertEntity({
    required this.alertUuid,
    required this.level,
    required this.type,
    required this.message,
    required this.heobyUuid,
    required this.heobyName,
    required this.location,
    required this.occurredAt,
    required this.snapshotUrl,
    required this.isRead,
  });
}
