// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'heoby_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HeobyModelImpl _$$HeobyModelImplFromJson(Map<String, dynamic> json) =>
    _$HeobyModelImpl(
      scarecrowUuid: json['scarecrow_uuid'] as String,
      name: json['name'] as String,
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      ownerName: json['owner_name'] as String,
      status: json['status'] as String,
      updatedAt: json['updated_at'] as String,
      serialNumber: json['serial_number'] as String,
      temperature: (json['temperature'] as num?)?.toDouble(),
      humidity: (json['humidity'] as num?)?.toDouble(),
      camera: json['camera'] as bool?,
      heatDetection: json['heatDetection'] as bool?,
      voice: json['voice'] as bool?,
      battery: (json['battery'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$HeobyModelImplToJson(_$HeobyModelImpl instance) =>
    <String, dynamic>{
      'scarecrow_uuid': instance.scarecrowUuid,
      'name': instance.name,
      'location': instance.location,
      'owner_name': instance.ownerName,
      'status': instance.status,
      'updated_at': instance.updatedAt,
      'serial_number': instance.serialNumber,
      'temperature': instance.temperature,
      'humidity': instance.humidity,
      'camera': instance.camera,
      'heatDetection': instance.heatDetection,
      'voice': instance.voice,
      'battery': instance.battery,
    };

_$HeobyListResponseImpl _$$HeobyListResponseImplFromJson(
  Map<String, dynamic> json,
) => _$HeobyListResponseImpl(
  myScarecrows: (json['my_scarecrows'] as List<dynamic>)
      .map((e) => HeobyModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  villageScarecrows: (json['village_scarecrows'] as List<dynamic>)
      .map((e) => HeobyModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$HeobyListResponseImplToJson(
  _$HeobyListResponseImpl instance,
) => <String, dynamic>{
  'my_scarecrows': instance.myScarecrows,
  'village_scarecrows': instance.villageScarecrows,
};
