// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      userUuid: json['userUuid'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      role: json['role'] as String,
      villageId: (json['villageId'] as num).toInt(),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'userUuid': instance.userUuid,
      'email': instance.email,
      'username': instance.username,
      'role': instance.role,
      'villageId': instance.villageId,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
