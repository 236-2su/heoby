import 'package:heoby_mobile/features/auth/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity> getUser();
}
