import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_request_model.freezed.dart';
part 'auth_request_model.g.dart';

@Freezed()
class AuthRequestModel with _$AuthRequestModel {
  @JsonSerializable()
  const factory AuthRequestModel.login({
    required String email,
    required String password,
  }) = LoginRequest;

  const factory AuthRequestModel.logout({
    required String refreshToken,
  }) = LogoutRequest;

  @JsonSerializable()
  const factory AuthRequestModel.refreshToken({
    required String refreshToken,
  }) = RefreshTokenRequest;

  factory AuthRequestModel.fromJson(Map<String, dynamic> json) => _$AuthRequestModelFromJson(json);
}
