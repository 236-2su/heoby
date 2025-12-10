import '../entities/workers_entity.dart';
import '../repositories/cctv_repository.dart';
import 'package:heoby_mobile/features/auth/domain/entities/user_entity.dart';

class GetWorkers {
  final CctvRepository _repo;
  GetWorkers(this._repo);

  Future<WorkersEntity> call(UserRole role) => _repo.getWorkers(role);
}
