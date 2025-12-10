enum UserRole {
  user('주민'),
  leader('이장');

  final String displayName;
  const UserRole(this.displayName);
}

class UserEntity {
  final String userUuid;
  final String email;
  final String username;
  final UserRole role;
  final int villageId;

  const UserEntity({
    required this.userUuid,
    required this.email,
    required this.username,
    required this.role,
    required this.villageId,
  });
}
