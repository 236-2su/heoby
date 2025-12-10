import 'package:heoby_mobile/features/auth/data/datasources/user_remote_datasource.dart';
import 'package:heoby_mobile/features/auth/data/models/user_model.dart';
import 'package:heoby_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:heoby_mobile/features/auth/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDatasource _remote;

  UserRepositoryImpl(this._remote);

  @override
  Future<UserEntity> getUser() async {
    final response = await _remote.getUser();

    return response.toEntity();
  }
}
