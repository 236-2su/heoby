// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      summary: NotificationSummaryModel.fromJson(
        json['summary'] as Map<String, dynamic>,
      ),
      alerts: (json['alerts'] as List<dynamic>)
          .map(
            (e) => NotificationAlertModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{'summary': instance.summary, 'alerts': instance.alerts};

NotificationSummaryModel _$NotificationSummaryModelFromJson(
  Map<String, dynamic> json,
) => NotificationSummaryModel(
  critical_unread: (json['critical_unread'] as num).toInt(),
  warning_unread: (json['warning_unread'] as num).toInt(),
  total_unread: (json['total_unread'] as num).toInt(),
);

Map<String, dynamic> _$NotificationSummaryModelToJson(
  NotificationSummaryModel instance,
) => <String, dynamic>{
  'critical_unread': instance.critical_unread,
  'warning_unread': instance.warning_unread,
  'total_unread': instance.total_unread,
};

NotificationAlertModel _$NotificationAlertModelFromJson(
  Map<String, dynamic> json,
) => NotificationAlertModel(
  alert_uuid: json['alert_uuid'] as String,
  severity: json['severity'] as String,
  type: json['type'] as String,
  message: json['message'] as String,
  scarecrow_uuid: json['scarecrow_uuid'] as String,
  scarecrow_name: json['scarecrow_name'] as String,
  location: Location.fromJson(json['location'] as Map<String, dynamic>),
  occurred_at: json['occurred_at'] as String,
  snapshot_url: json['snapshot_url'] as String?,
  read: json['read'] as bool,
);

Map<String, dynamic> _$NotificationAlertModelToJson(
  NotificationAlertModel instance,
) => <String, dynamic>{
  'alert_uuid': instance.alert_uuid,
  'severity': instance.severity,
  'type': instance.type,
  'message': instance.message,
  'scarecrow_uuid': instance.scarecrow_uuid,
  'scarecrow_name': instance.scarecrow_name,
  'location': instance.location,
  'occurred_at': instance.occurred_at,
  'snapshot_url': instance.snapshot_url,
  'read': instance.read,
};
