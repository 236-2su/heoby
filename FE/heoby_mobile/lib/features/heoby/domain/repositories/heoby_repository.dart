import 'package:heoby_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:heoby_mobile/features/heoby/domain/entities/heoby_entity.dart';

abstract class HeobyRepository {
  Future<List<HeobyEntity>> getHeobyList(UserRole role);
}
