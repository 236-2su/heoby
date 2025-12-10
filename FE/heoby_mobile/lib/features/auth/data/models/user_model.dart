import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:heoby_mobile/features/auth/domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  factory UserModel({
    required String userUuid,
    required String email,
    required String username,
    required String role,
    required int villageId,
    String? createdAt,
    String? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}

extension UserModelX on UserModel {
  /// Convert DTO to Domain Entity
  UserEntity toEntity() {
    return UserEntity(
      userUuid: userUuid,
      email: email,
      username: username,
      role: _parseUserRole(role),
      villageId: villageId,
    );
  }

  UserRole _parseUserRole(String role) {
    switch (role) {
      case 'USER':
        return UserRole.user;
      case 'LEADER':
        return UserRole.leader;
      default:
        return UserRole.user;
    }
  }
}
