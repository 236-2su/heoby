import 'package:dio/dio.dart';
import 'package:heoby_mobile/core/constants/api_endpoints.dart';
import 'package:heoby_mobile/core/network/dio_client.dart';
import 'package:heoby_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:heoby_mobile/features/notification/data/models/notification_model.dart';

class NotificationRemoteDataSource {
  final DioClient _client;
  NotificationRemoteDataSource(this._client);

  /// GET /dashboard/alarms
  Future<NotificationModel> getNotification(UserRole role) async {
    final Response response = await _client.get(NotificationApi.list(role));

    final data = response.data;

    if (data is Map<String, dynamic>) {
      return NotificationModel.fromJson(data);
    }

    throw Exception('Invalid response format');
  }

  /// POST /fcm/register - FCM 토큰 등록
  Future<void> registerFcmToken({
    required String userUuid,
    required String platform,
    required String token,
  }) async {
    await _client.post(FcmApi.register, data: {
      'userUuid': userUuid,
      'platform': platform,
      'token': token,
    });
  }

  /// POST /fcm/unregister - FCM 토큰 해제
  Future<void> unregisterFcmToken({
    required String userUuid,
    required String platform,
    required String token,
  }) async {
    await _client.post(FcmApi.unregister, data: {
      'userUuid': userUuid,
      'platform': platform,
      'token': token,
    });
  }

  /// PUT /dashboard/alarms/{alertUuid} - 알림 읽음 처리
  Future<void> markAsRead(String alertUuid) async {
    await _client.put(NotificationApi.markAsRead(alertUuid));
  }
}
