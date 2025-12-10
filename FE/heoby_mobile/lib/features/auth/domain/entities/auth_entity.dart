class AuthEntity {
  final String? accessToken;
  final String? userUuid;

  const AuthEntity({
    this.accessToken,
    this.userUuid,
  });

  bool get isAuthenticated => accessToken != null && accessToken!.isNotEmpty;
}
