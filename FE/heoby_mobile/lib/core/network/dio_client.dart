import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heoby_mobile/core/constants/api_endpoints.dart';
import 'package:heoby_mobile/shared/widgets/log/debug_log.dart';

import 'auth_interceptor.dart';

class DioClient {
  late final Dio _dio;

  DioClient(ProviderContainer container) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(milliseconds: ApiEndpoints.connectTimeout),
        receiveTimeout: const Duration(milliseconds: ApiEndpoints.receiveTimeout),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      ),
    );

    // Auth Interceptor 추가 (AccessToken 자동 추가 & 401 에러 시 자동 갱신)
    _dio.interceptors.add(AuthInterceptor(container, _dio));

    // Logging Interceptor 추가 (간결한 request/response 로깅)
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrintLog('-----REQUEST-----');
          debugPrintLog('${options.method} ${options.uri}');
          if (options.data != null) {
            debugPrintLog('  Body: ${options.data}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrintLog('-----RESPONSE-----');
          debugPrintLog('${response.statusCode} ${response.requestOptions.uri.path}');
          if (response.data != null) {
            debugPrintLog('  Data: ${response.data}');
          }
          return handler.next(response);
        },
        onError: (error, handler) {
          debugPrintLog('✗ ${error.response?.statusCode ?? '???'} ${error.requestOptions.uri.path}');
          if (error.response?.data != null) {
            debugPrintLog('  Error: ${error.response?.data}');
          }
          return handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;

  // GET request
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters, options: options);
    } catch (e) {
      rethrow;
    }
  }

  // POST request
  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      return await _dio.post(path, data: data, queryParameters: queryParameters, options: options);
    } catch (e) {
      rethrow;
    }
  }

  // PUT request
  Future<Response> put(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      return await _dio.put(path, data: data, queryParameters: queryParameters, options: options);
    } catch (e) {
      rethrow;
    }
  }

  // DELETE request
  Future<Response> delete(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      return await _dio.delete(path, data: data, queryParameters: queryParameters, options: options);
    } catch (e) {
      rethrow;
    }
  }
}
