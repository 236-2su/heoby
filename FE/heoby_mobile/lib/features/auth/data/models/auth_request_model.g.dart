// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginRequestImpl _$$LoginRequestImplFromJson(Map<String, dynamic> json) =>
    _$LoginRequestImpl(
      email: json['email'] as String,
      password: json['password'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$LoginRequestImplToJson(_$LoginRequestImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'runtimeType': instance.$type,
    };

_$LogoutRequestImpl _$$LogoutRequestImplFromJson(Map<String, dynamic> json) =>
    _$LogoutRequestImpl(
      refreshToken: json['refreshToken'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$LogoutRequestImplToJson(_$LogoutRequestImpl instance) =>
    <String, dynamic>{
      'refreshToken': instance.refreshToken,
      'runtimeType': instance.$type,
    };

_$RefreshTokenRequestImpl _$$RefreshTokenRequestImplFromJson(
  Map<String, dynamic> json,
) => _$RefreshTokenRequestImpl(
  refreshToken: json['refreshToken'] as String,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$RefreshTokenRequestImplToJson(
  _$RefreshTokenRequestImpl instance,
) => <String, dynamic>{
  'refreshToken': instance.refreshToken,
  'runtimeType': instance.$type,
};
