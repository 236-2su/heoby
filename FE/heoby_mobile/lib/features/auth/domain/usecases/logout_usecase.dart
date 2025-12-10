import '../repositories/auth_repository.dart';

/// Logout Use Case (Domain Layer)
class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<void> call() async {
    await repository.logout();
  }
}
