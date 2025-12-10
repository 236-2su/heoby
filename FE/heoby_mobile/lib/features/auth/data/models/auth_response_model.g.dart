// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginResponseModelImpl _$$LoginResponseModelImplFromJson(
  Map<String, dynamic> json,
) => _$LoginResponseModelImpl(
  accessToken: json['accessToken'] as String,
  accessTokenExpiresIn: (json['accessTokenExpiresIn'] as num).toInt(),
  refreshToken: json['refreshToken'] as String,
  refreshTokenExpiresIn: (json['refreshTokenExpiresIn'] as num).toInt(),
  user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$LoginResponseModelImplToJson(
  _$LoginResponseModelImpl instance,
) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'accessTokenExpiresIn': instance.accessTokenExpiresIn,
  'refreshToken': instance.refreshToken,
  'refreshTokenExpiresIn': instance.refreshTokenExpiresIn,
  'user': instance.user,
  'runtimeType': instance.$type,
};

_$RefreshResponseModelImpl _$$RefreshResponseModelImplFromJson(
  Map<String, dynamic> json,
) => _$RefreshResponseModelImpl(
  accessToken: json['accessToken'] as String,
  accessTokenExpiresIn: (json['accessTokenExpiresIn'] as num).toInt(),
  refreshToken: json['refreshToken'] as String,
  refreshTokenExpiresIn: (json['refreshTokenExpiresIn'] as num).toInt(),
  userUuid: json['userUuid'] as String,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$RefreshResponseModelImplToJson(
  _$RefreshResponseModelImpl instance,
) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'accessTokenExpiresIn': instance.accessTokenExpiresIn,
  'refreshToken': instance.refreshToken,
  'refreshTokenExpiresIn': instance.refreshTokenExpiresIn,
  'userUuid': instance.userUuid,
  'runtimeType': instance.$type,
};
