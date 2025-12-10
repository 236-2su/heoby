import 'package:heoby_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:heoby_mobile/features/heoby/domain/entities/heoby_entity.dart';
import 'package:heoby_mobile/features/heoby/domain/repositories/heoby_repository.dart';

class GetHeobyList {
  final HeobyRepository _repo;

  GetHeobyList(this._repo);

  Future<List<HeobyEntity>> call(UserRole role) async {
    return _repo.getHeobyList(role);
  }
}
