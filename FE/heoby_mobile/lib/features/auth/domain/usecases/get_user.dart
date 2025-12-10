import 'package:heoby_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:heoby_mobile/features/auth/domain/repositories/user_repository.dart';

/// Logout Use Case (Domain Layer)
class GetUser {
  final UserRepository repository;

  GetUser(this.repository);

  Future<UserEntity> call() async {
    return await repository.getUser();
  }
}
