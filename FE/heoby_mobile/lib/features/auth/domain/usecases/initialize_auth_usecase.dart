import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

/// 앱 시작 시 자동 로그인을 시도하는 UseCase
class InitializeAuthUseCase {
  final AuthRepository repository;

  InitializeAuthUseCase(this.repository);

  /// 저장된 refreshToken으로 자동 로그인 시도
  ///
  /// Returns:
  /// - AuthResult: 자동 로그인 성공
  /// - null: refreshToken이 없거나 만료됨
  Future<AuthEntity?> call() async {
    try {
      // 1. 저장된 refreshToken 가져오기
      final refreshToken = await repository.getRefreshToken();

      if (refreshToken == null) {
        return null;
      }

      // 2. refreshToken으로 갱신 시도
      final result = await repository.refresh(refreshToken);

      return result;
    } catch (e) {
      // 3. 실패 (만료, 재사용 감지 등) → 저장된 토큰 삭제 후 null 반환

      // 무효화된 refresh token 삭제
      try {
        await repository.logout();
      } catch (clearError) {}

      return null;
    }
  }
}
