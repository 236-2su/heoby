import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthLocalDataSource {
  static const String _refreshTokenKey = 'refresh_token';

  final FlutterSecureStorage _secureStorage;

  AuthLocalDataSource(this._secureStorage);

  /// Refresh Token 저장
  Future<void> save(String token) async {
    await _secureStorage.write(key: _refreshTokenKey, value: token);
  }

  /// 저장된 Refresh Token 읽기
  Future<String?> get() async {
    final token = await _secureStorage.read(key: _refreshTokenKey);
    if (token != null) {
    } else {}
    return token;
  }

  /// 모든 토큰 삭제
  Future<void> clear() async {
    await _secureStorage.delete(key: _refreshTokenKey);
  }

  /// 사용자 인증 유효성 체크
  Future<bool> hasValidTokens() async {
    final refreshToken = await get();
    return refreshToken != null;
  }
}
