import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:heoby_mobile/core/di/injection.dart';
import 'package:heoby_mobile/features/auth/domain/entities/auth_entity.dart';
import 'package:heoby_mobile/shared/widgets/log/debug_log.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/usecases/initialize_auth_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';

part 'auth_provider.freezed.dart';
part 'auth_provider.g.dart';

/// Auth State (Presentation Layer)
@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(AuthEntity()) AuthEntity data,

    // String? accessToken, // In-memory AccessToken 저장
    @Default(false) bool isLoading,
    String? error,
  }) = _AuthState;
}

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  LoginUseCase get _loginUseCase => getIt<LoginUseCase>();
  LogoutUseCase get _logoutUseCase => getIt<LogoutUseCase>();
  InitializeAuthUseCase get _initializeAuthUseCase => getIt<InitializeAuthUseCase>();

  @override
  AuthState build() => const AuthState();

  /// 앱 시작 시 자동 로그인 시도
  Future<void> initializeAuth() async {
    state = state.copyWith(isLoading: true);
    try {
      final result = await _initializeAuthUseCase();

      if (result != null) {
        // 자동 로그인 성공
        state = state.copyWith(
          data: result,
          isLoading: false,
        );
      } else {
        // refreshToken 없거나 만료됨
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      // refresh 실패 → localStorage 삭제 및 로그아웃 처리
      await logout();
    }
  }

  Future<void> login({required String email, required String password}) async {
    debugPrintLog('🔑 로그인 시작: $email');
    state = state.copyWith(isLoading: true, error: null);
    try {
      debugPrintLog('🔑 LoginUseCase 호출');
      final result = await _loginUseCase(email: email, password: password);
      debugPrintLog('🔑 로그인 성공: $result');

      state = state.copyWith(
        data: result,
        isLoading: false,
      );

      debugPrintLog('🔑 State 업데이트 완료: isAuthenticated=${state.data.isAuthenticated}');
    } catch (e, s) {
      debugPrintLog('🔑 로그인 실패: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
      Error.throwWithStackTrace(e, s);
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _logoutUseCase();
      state = const AuthState();
    } catch (e, s) {
      state = state.copyWith(isLoading: false, error: e.toString());
      Error.throwWithStackTrace(e, s);
    }
  }

  /// RefreshToken으로 AccessToken 갱신
  /// Dio Interceptor에서 401 에러 발생 시 호출됨
  Future<String?> refreshAccessToken() async {
    try {
      final result = await _initializeAuthUseCase();

      if (result != null) {
        // 토큰 갱신 성공 → state 업데이트
        state = state.copyWith(
          data: result,
          isLoading: false,
        );
        return result.accessToken;
      } else {
        // RefreshToken도 만료됨 → 로그아웃 처리
        state = const AuthState();
        return null;
      }
    } catch (e) {
      // 토큰 갱신 실패 → 로그아웃 처리
      state = const AuthState();
      return null;
    }
  }
}
