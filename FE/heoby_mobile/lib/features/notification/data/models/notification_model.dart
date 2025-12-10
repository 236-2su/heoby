import 'package:heoby_mobile/core/models/location.dart';
import 'package:heoby_mobile/features/notification/domain/entities/notification_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  final NotificationSummaryModel summary;
  final List<NotificationAlertModel> alerts;

  NotificationModel({
    required this.summary,
    required this.alerts,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

  NotificationEntity toEntity() => NotificationEntity(
    summary: summary.toEntity(),
    alerts: alerts.map((alert) => alert.toEntity()).toList(),
  );
}

@JsonSerializable()
class NotificationSummaryModel {
  final int critical_unread;
  final int warning_unread;
  final int total_unread;

  NotificationSummaryModel({
    required this.critical_unread,
    required this.warning_unread,
    required this.total_unread,
  });

  factory NotificationSummaryModel.fromJson(Map<String, dynamic> json) => _$NotificationSummaryModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationSummaryModelToJson(this);
}

extension NotificationSummaryModelX on NotificationSummaryModel {
  NotificationSummaryEntity toEntity() => NotificationSummaryEntity(
    criticalUnread: critical_unread,
    warningUnread: warning_unread,
    totalUnread: total_unread,
  );
}

@JsonSerializable()
class NotificationAlertModel {
  final String alert_uuid;
  final String severity;
  final String type;
  final String message;
  final String scarecrow_uuid;
  final String scarecrow_name;
  final Location location;
  final String occurred_at;
  final String? snapshot_url;
  final bool read;

  NotificationAlertModel({
    required this.alert_uuid,
    required this.severity,
    required this.type,
    required this.message,
    required this.scarecrow_uuid,
    required this.scarecrow_name,
    required this.location,
    required this.occurred_at,
    required this.snapshot_url,
    required this.read,
  });

  factory NotificationAlertModel.fromJson(Map<String, dynamic> json) => _$NotificationAlertModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationAlertModelToJson(this);
}

extension NotificationAlertModelX on NotificationAlertModel {
  NotificationAlertEntity toEntity() => NotificationAlertEntity(
    alertUuid: alert_uuid,
    level: severity,
    type: type,
    message: message,
    heobyUuid: scarecrow_uuid,
    heobyName: scarecrow_name,
    location: location,
    occurredAt: occurred_at,
    snapshotUrl: snapshot_url ?? "",
    isRead: read,
  );
}
