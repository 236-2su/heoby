import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../utils/logger.dart';

/// 인증 토큰 자동 관리 Interceptor
/// - 모든 요청에 AccessToken 헤더 자동 추가
/// - 401 에러 발생 시 RefreshToken으로 자동 갱신 후 재시도
class AuthInterceptor extends Interceptor {
  final ProviderContainer container;
  final Dio dio;
  bool _isRefreshing = false;

  AuthInterceptor(this.container, this.dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 로그인/회원가입/토큰갱신 등 공개 API는 Authorization 헤더 제외
    final publicPaths = ['/auth/login', '/auth/signup', '/auth/refresh'];
    final isPublicApi = publicPaths.any((path) => options.path.contains(path));

    if (!isPublicApi) {
      // AccessToken을 요청 헤더에 자동 추가
      final accessToken = container.read(authProvider).data.accessToken;
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 로그인/회원가입/토큰갱신 API는 401 처리하지 않음
    final publicPaths = ['/auth/login', '/auth/signup', '/auth/refresh'];
    final isPublicApi = publicPaths.any((path) => err.requestOptions.path.contains(path));

    // 401 Unauthorized 에러인 경우 토큰 갱신 시도
    if (err.response?.statusCode == 401 && !isPublicApi && !_isRefreshing) {
      _isRefreshing = true;
      AppLogger.w('🔑 토큰 갱신 시도...');

      try {
        // 토큰 갱신 시도
        final newAccessToken = await container.read(authProvider.notifier).refreshAccessToken();

        if (newAccessToken != null) {
          // 토큰 갱신 성공 → 원래 요청 재시도
          AppLogger.i('🔑 토큰 갱신 완료');

          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $newAccessToken';

          try {
            // 원래 Dio 인스턴스로 재시도 (interceptor는 이미 통과했으므로 재귀 방지됨)
            final response = await dio.fetch(options);
            return handler.resolve(response);
          } catch (e) {
            // 재시도 실패
            return handler.next(err);
          }
        } else {
          // 토큰 갱신 실패 → 로그아웃 처리됨 (refreshAccessToken에서 처리)
          AppLogger.e('🔑 토큰 갱신 실패');
          return handler.next(err);
        }
      } finally {
        _isRefreshing = false;
      }
    }

    // 401이 아닌 다른 에러는 그대로 전달
    return handler.next(err);
  }
}
