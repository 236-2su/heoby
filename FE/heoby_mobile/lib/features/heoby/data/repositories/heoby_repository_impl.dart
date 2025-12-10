import 'package:heoby_mobile/features/heoby/data/datasources/heoby_remote_data_source.dart';
import 'package:heoby_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:heoby_mobile/features/heoby/data/models/heoby_model.dart';
import 'package:heoby_mobile/features/heoby/domain/entities/heoby_entity.dart';
import 'package:heoby_mobile/features/heoby/domain/repositories/heoby_repository.dart';

class HeobyRepositoryImpl implements HeobyRepository {
  final HeobyRemoteDataSource _remote;

  HeobyRepositoryImpl(this._remote);

  @override
  Future<List<HeobyEntity>> getHeobyList(UserRole role) async {
    final HeobyListResponse response = await _remote.getHeobyList(role);
    return response.allScarecrowEntities;
  }
}


