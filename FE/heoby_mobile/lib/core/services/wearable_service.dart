import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class BloodPressureAlert {
  final String alertId;
  final int systolic;
  final int diastolic;
  final String severity;
  final int timestamp;
  final int createdAt;

  BloodPressureAlert({
    required this.alertId,
    required this.systolic,
    required this.diastolic,
    required this.severity,
    required this.timestamp,
    required this.createdAt,
  });

  factory BloodPressureAlert.fromMap(Map<dynamic, dynamic> map) {
    return BloodPressureAlert(
      alertId: map['alertId'] as String,
      systolic: map['systolic'] as int,
      diastolic: map['diastolic'] as int,
      severity: map['severity'] as String,
      timestamp: map['timestamp'] as int,
      createdAt: map['createdAt'] as int,
    );
  }

  bool get isCritical => severity == 'Critical';
  bool get isWarning => severity == 'Warning';

  String get severityText => isCritical ? '위험' : '주의';
  String get message => '$systolic/$diastolic mmHg - $severityText 수준';
}

class WearableService {
  static const platform = MethodChannel('com.sunshinemoongit.heoby_mobile/wearable');
  static final _logger = Logger();
  static Function(BloodPressureAlert)? _onBloodPressureAlertCallback;

  /// 혈압 알림 콜백 등록
  static void setBloodPressureAlertCallback(Function(BloodPressureAlert) callback) {
    _onBloodPressureAlertCallback = callback;
    _setupMethodCallHandler();
  }

  /// 메서드 채널 핸들러 설정
  static void _setupMethodCallHandler() {
    platform.setMethodCallHandler((call) async {
      if (call.method == 'onBloodPressureAlert') {
        try {
          final Map<dynamic, dynamic> data = call.arguments;
          final alert = BloodPressureAlert.fromMap(data);
          _logger.i('Blood pressure alert received: ${alert.message}');
          _onBloodPressureAlertCallback?.call(alert);
        } catch (e) {
          _logger.e('Error processing blood pressure alert: $e');
        }
      }
    });
  }

  /// 워치로 알림 전송
  static Future<void> sendNotificationToWatch({
    required String title,
    required String body,
    String? notificationId,
    String iconName = 'ic_launcher',
  }) async {
    try {
      await platform.invokeMethod('sendNotificationToWatch', {
        'title': title,
        'body': body,
        'notificationId': notificationId ?? DateTime.now().millisecondsSinceEpoch.toString(),
        'iconName': iconName,
      });
      _logger.i('Notification sent to watch: $title');
    } on PlatformException catch (e) {
      _logger.e('Failed to send notification to watch: ${e.message}');
    }
  }
}
