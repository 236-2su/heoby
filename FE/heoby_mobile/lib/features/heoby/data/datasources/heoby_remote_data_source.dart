import 'package:dio/dio.dart';
import 'package:heoby_mobile/core/constants/api_endpoints.dart';
import 'package:heoby_mobile/core/network/dio_client.dart';
import 'package:heoby_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:heoby_mobile/features/heoby/data/models/heoby_model.dart';

class HeobyRemoteDataSource {
  final DioClient _client;
  HeobyRemoteDataSource(this._client);

  /// GET /dashboard/scarecrows - 허수아비 목록 조회
  Future<HeobyListResponse> getHeobyList(UserRole role) async {
    final Response response = await _client.get(HeobyApi.list(role));

    final data = response.data;

    if (data is Map<String, dynamic>) {
      return HeobyListResponse.fromJson(data);
    }

    throw Exception('Invalid response format');
  }
}
