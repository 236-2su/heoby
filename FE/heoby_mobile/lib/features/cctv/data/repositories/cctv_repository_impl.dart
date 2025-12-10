import 'package:heoby_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:heoby_mobile/features/cctv/data/datasources/cctv_remote_datasource.dart';
import 'package:heoby_mobile/features/cctv/domain/entities/workers_entity.dart';
import 'package:heoby_mobile/features/cctv/domain/repositories/cctv_repository.dart';

class CctvRepositoryImpl implements CctvRepository {
  final CctvRemoteDatasource _remote;

  CctvRepositoryImpl(this._remote);

  @override
  Future<WorkersEntity> getWorkers(UserRole role) async {
    final response = await _remote.getWorkers(role);

    return response.toEntity();
  }
}
