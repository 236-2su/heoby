import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:heoby_mobile/features/auth/data/models/user_model.dart';
import 'package:heoby_mobile/features/auth/domain/entities/auth_entity.dart';

part 'auth_response_model.freezed.dart';
part 'auth_response_model.g.dart';

@freezed
class AuthResponseModel with _$AuthResponseModel {
  /// 로그인 응답
  const factory AuthResponseModel.login({
    required String accessToken,
    required int accessTokenExpiresIn,
    required String refreshToken,
    required int refreshTokenExpiresIn,
    required UserModel user,
  }) = LoginResponseModel;

  /// 리프레시 응답
  const factory AuthResponseModel.refresh({
    required String accessToken,
    required int accessTokenExpiresIn,
    required String refreshToken,
    required int refreshTokenExpiresIn,
    required String userUuid,
  }) = RefreshResponseModel;

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) => _$AuthResponseModelFromJson(json);
}

extension AuthResponseMapper on AuthResponseModel {
  AuthEntity toEntity() => when(
    login: (accessToken, _, __, ___, user) => AuthEntity(
      accessToken: accessToken,
      userUuid: user.userUuid,
    ),
    refresh: (accessToken, _, __, ___, userUuid) => AuthEntity(
      accessToken: accessToken,
      userUuid: userUuid,
    ),
  );
}
