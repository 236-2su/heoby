import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

/// Login Use Case (Domain Layer)
/// Contains business logic for login operation
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<AuthEntity> call({
    required String email,
    required String password,
  }) async {
    // Business logic validation
    if (email.isEmpty) {
      throw Exception('이메일을 입력해주세요');
    }
    if (!email.contains('@')) {
      throw Exception('올바른 이메일 형식이 아닙니다');
    }
    if (password.isEmpty) {
      throw Exception('비밀번호를 입력해주세요');
    }
    if (password.length < 6) {
      throw Exception('비밀번호는 6자 이상이어야 합니다');
    }

    return await repository.login(email: email, password: password);
  }
}
