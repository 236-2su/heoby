import 'package:heoby_mobile/features/auth/domain/entities/auth_entity.dart';

abstract class AuthRepository {
  /// Login with email and password
  Future<AuthEntity> login({
    required String email,
    required String password,
  });

  /// Logout
  Future<void> logout();

  /// Refresh access token using refresh token
  Future<AuthEntity> refresh(String refreshToken);

  /// Get refresh token from local storage
  Future<String?> getRefreshToken();
}
