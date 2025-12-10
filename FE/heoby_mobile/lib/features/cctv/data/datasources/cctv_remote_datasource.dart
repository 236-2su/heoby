import 'package:dio/dio.dart';
import 'package:heoby_mobile/core/constants/api_endpoints.dart';
import 'package:heoby_mobile/core/network/dio_client.dart';
import 'package:heoby_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:heoby_mobile/features/cctv/data/models/workers_model.dart';

class CctvRemoteDatasource {
  final DioClient _client;

  CctvRemoteDatasource(this._client);

  Future<WorkersModel> getWorkers(UserRole role) async {
    try {
      final response = await _client.get(CctvApi.workers(role));

      return WorkersModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['message'] ?? '작업자 수 조회에 실패했습니다');
      }
      throw Exception('네트워크 오류가 발생했습니다');
    }
  }
}
