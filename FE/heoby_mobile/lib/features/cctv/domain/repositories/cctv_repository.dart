import 'package:heoby_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:heoby_mobile/features/cctv/domain/entities/workers_entity.dart';

abstract class CctvRepository {
  Future<WorkersEntity> getWorkers(UserRole role);
}
