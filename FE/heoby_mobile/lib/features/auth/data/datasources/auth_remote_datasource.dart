import 'package:dio/dio.dart';
import 'package:heoby_mobile/core/constants/api_endpoints.dart';
import 'package:heoby_mobile/features/auth/data/models/auth_request_model.dart';
import 'package:heoby_mobile/features/auth/data/models/auth_response_model.dart';

class AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSource(this._dio);

  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      AuthApi.login,
      data: AuthRequestModel.login(email: email, password: password).toJson(),
    );

    return LoginResponseModel.fromJson(response.data);
  }

  /// Logout API
  Future<void> logout(
    String refreshToken,
  ) async {
    try {
      await _dio.post(
        AuthApi.logout,
        data: AuthRequestModel.logout(refreshToken: refreshToken).toJson(),
      );
    } on DioException catch (e) {
      throw Exception('로그아웃에 실패했습니다: ${e.message}');
    }
  }

  /// Refresh Token API
  Future<RefreshResponseModel> refreshToken(
    String refreshToken,
  ) async {
    try {
      final response = await _dio.post(
        AuthApi.refresh,
        // data: {"refreshToken": refreshToken},
        data: AuthRequestModel.refreshToken(refreshToken: refreshToken).toJson(),
      );

      if (response.data == null) {
        throw Exception('서버 응답이 비어있습니다');
      }

      if (response.data is! Map<String, dynamic>) {
        throw Exception('잘못된 응답 형식입니다');
      }

      return RefreshResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        // response.data가 Map인지 확인
        if (e.response!.data is Map<String, dynamic>) {
          throw Exception(e.response!.data['message'] ?? '토큰 갱신에 실패했습니다');
        }
        // 404 등의 HTML 응답인 경우
        throw Exception('토큰 갱신에 실패했습니다 (상태 코드: ${e.response!.statusCode})');
      }
      throw Exception('네트워크 오류가 발생했습니다: ${e.message}');
    }
  }
}
