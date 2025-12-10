// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'heoby_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$HeobyEntity {
  String get uuid => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  Location get location => throw _privateConstructorUsedError;
  String get ownerName => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get updatedAt => throw _privateConstructorUsedError;
  double? get temperature => throw _privateConstructorUsedError;
  double? get humidity => throw _privateConstructorUsedError;
  bool? get camera => throw _privateConstructorUsedError;
  bool? get heatDetection => throw _privateConstructorUsedError;
  bool? get voice => throw _privateConstructorUsedError;
  double? get battery =>
      throw _privateConstructorUsedError; // required bool isOwner,
  String? get serialNumber => throw _privateConstructorUsedError;
  bool get isOwner => throw _privateConstructorUsedError;

  /// Create a copy of HeobyEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HeobyEntityCopyWith<HeobyEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HeobyEntityCopyWith<$Res> {
  factory $HeobyEntityCopyWith(
    HeobyEntity value,
    $Res Function(HeobyEntity) then,
  ) = _$HeobyEntityCopyWithImpl<$Res, HeobyEntity>;
  @useResult
  $Res call({
    String uuid,
    String name,
    Location location,
    String ownerName,
    String status,
    String updatedAt,
    double? temperature,
    double? humidity,
    bool? camera,
    bool? heatDetection,
    bool? voice,
    double? battery,
    String? serialNumber,
    bool isOwner,
  });

  $LocationCopyWith<$Res> get location;
}

/// @nodoc
class _$HeobyEntityCopyWithImpl<$Res, $Val extends HeobyEntity>
    implements $HeobyEntityCopyWith<$Res> {
  _$HeobyEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HeobyEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? name = null,
    Object? location = null,
    Object? ownerName = null,
    Object? status = null,
    Object? updatedAt = null,
    Object? temperature = freezed,
    Object? humidity = freezed,
    Object? camera = freezed,
    Object? heatDetection = freezed,
    Object? voice = freezed,
    Object? battery = freezed,
    Object? serialNumber = freezed,
    Object? isOwner = null,
  }) {
    return _then(
      _value.copyWith(
            uuid: null == uuid
                ? _value.uuid
                : uuid // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            location: null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as Location,
            ownerName: null == ownerName
                ? _value.ownerName
                : ownerName // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String,
            temperature: freezed == temperature
                ? _value.temperature
                : temperature // ignore: cast_nullable_to_non_nullable
                      as double?,
            humidity: freezed == humidity
                ? _value.humidity
                : humidity // ignore: cast_nullable_to_non_nullable
                      as double?,
            camera: freezed == camera
                ? _value.camera
                : camera // ignore: cast_nullable_to_non_nullable
                      as bool?,
            heatDetection: freezed == heatDetection
                ? _value.heatDetection
                : heatDetection // ignore: cast_nullable_to_non_nullable
                      as bool?,
            voice: freezed == voice
                ? _value.voice
                : voice // ignore: cast_nullable_to_non_nullable
                      as bool?,
            battery: freezed == battery
                ? _value.battery
                : battery // ignore: cast_nullable_to_non_nullable
                      as double?,
            serialNumber: freezed == serialNumber
                ? _value.serialNumber
                : serialNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            isOwner: null == isOwner
                ? _value.isOwner
                : isOwner // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of HeobyEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LocationCopyWith<$Res> get location {
    return $LocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HeobyEntityImplCopyWith<$Res>
    implements $HeobyEntityCopyWith<$Res> {
  factory _$$HeobyEntityImplCopyWith(
    _$HeobyEntityImpl value,
    $Res Function(_$HeobyEntityImpl) then,
  ) = __$$HeobyEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String uuid,
    String name,
    Location location,
    String ownerName,
    String status,
    String updatedAt,
    double? temperature,
    double? humidity,
    bool? camera,
    bool? heatDetection,
    bool? voice,
    double? battery,
    String? serialNumber,
    bool isOwner,
  });

  @override
  $LocationCopyWith<$Res> get location;
}

/// @nodoc
class __$$HeobyEntityImplCopyWithImpl<$Res>
    extends _$HeobyEntityCopyWithImpl<$Res, _$HeobyEntityImpl>
    implements _$$HeobyEntityImplCopyWith<$Res> {
  __$$HeobyEntityImplCopyWithImpl(
    _$HeobyEntityImpl _value,
    $Res Function(_$HeobyEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HeobyEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? name = null,
    Object? location = null,
    Object? ownerName = null,
    Object? status = null,
    Object? updatedAt = null,
    Object? temperature = freezed,
    Object? humidity = freezed,
    Object? camera = freezed,
    Object? heatDetection = freezed,
    Object? voice = freezed,
    Object? battery = freezed,
    Object? serialNumber = freezed,
    Object? isOwner = null,
  }) {
    return _then(
      _$HeobyEntityImpl(
        uuid: null == uuid
            ? _value.uuid
            : uuid // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        location: null == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as Location,
        ownerName: null == ownerName
            ? _value.ownerName
            : ownerName // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String,
        temperature: freezed == temperature
            ? _value.temperature
            : temperature // ignore: cast_nullable_to_non_nullable
                  as double?,
        humidity: freezed == humidity
            ? _value.humidity
            : humidity // ignore: cast_nullable_to_non_nullable
                  as double?,
        camera: freezed == camera
            ? _value.camera
            : camera // ignore: cast_nullable_to_non_nullable
                  as bool?,
        heatDetection: freezed == heatDetection
            ? _value.heatDetection
            : heatDetection // ignore: cast_nullable_to_non_nullable
                  as bool?,
        voice: freezed == voice
            ? _value.voice
            : voice // ignore: cast_nullable_to_non_nullable
                  as bool?,
        battery: freezed == battery
            ? _value.battery
            : battery // ignore: cast_nullable_to_non_nullable
                  as double?,
        serialNumber: freezed == serialNumber
            ? _value.serialNumber
            : serialNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        isOwner: null == isOwner
            ? _value.isOwner
            : isOwner // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$HeobyEntityImpl extends _HeobyEntity {
  const _$HeobyEntityImpl({
    required this.uuid,
    required this.name,
    required this.location,
    required this.ownerName,
    required this.status,
    required this.updatedAt,
    required this.temperature,
    required this.humidity,
    required this.camera,
    required this.heatDetection,
    required this.voice,
    required this.battery,
    required this.serialNumber,
    required this.isOwner,
  }) : super._();

  @override
  final String uuid;
  @override
  final String name;
  @override
  final Location location;
  @override
  final String ownerName;
  @override
  final String status;
  @override
  final String updatedAt;
  @override
  final double? temperature;
  @override
  final double? humidity;
  @override
  final bool? camera;
  @override
  final bool? heatDetection;
  @override
  final bool? voice;
  @override
  final double? battery;
  // required bool isOwner,
  @override
  final String? serialNumber;
  @override
  final bool isOwner;

  @override
  String toString() {
    return 'HeobyEntity(uuid: $uuid, name: $name, location: $location, ownerName: $ownerName, status: $status, updatedAt: $updatedAt, temperature: $temperature, humidity: $humidity, camera: $camera, heatDetection: $heatDetection, voice: $voice, battery: $battery, serialNumber: $serialNumber, isOwner: $isOwner)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HeobyEntityImpl &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.ownerName, ownerName) ||
                other.ownerName == ownerName) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.humidity, humidity) ||
                other.humidity == humidity) &&
            (identical(other.camera, camera) || other.camera == camera) &&
            (identical(other.heatDetection, heatDetection) ||
                other.heatDetection == heatDetection) &&
            (identical(other.voice, voice) || other.voice == voice) &&
            (identical(other.battery, battery) || other.battery == battery) &&
            (identical(other.serialNumber, serialNumber) ||
                other.serialNumber == serialNumber) &&
            (identical(other.isOwner, isOwner) || other.isOwner == isOwner));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    uuid,
    name,
    location,
    ownerName,
    status,
    updatedAt,
    temperature,
    humidity,
    camera,
    heatDetection,
    voice,
    battery,
    serialNumber,
    isOwner,
  );

  /// Create a copy of HeobyEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HeobyEntityImplCopyWith<_$HeobyEntityImpl> get copyWith =>
      __$$HeobyEntityImplCopyWithImpl<_$HeobyEntityImpl>(this, _$identity);
}

abstract class _HeobyEntity extends HeobyEntity {
  const factory _HeobyEntity({
    required final String uuid,
    required final String name,
    required final Location location,
    required final String ownerName,
    required final String status,
    required final String updatedAt,
    required final double? temperature,
    required final double? humidity,
    required final bool? camera,
    required final bool? heatDetection,
    required final bool? voice,
    required final double? battery,
    required final String? serialNumber,
    required final bool isOwner,
  }) = _$HeobyEntityImpl;
  const _HeobyEntity._() : super._();

  @override
  String get uuid;
  @override
  String get name;
  @override
  Location get location;
  @override
  String get ownerName;
  @override
  String get status;
  @override
  String get updatedAt;
  @override
  double? get temperature;
  @override
  double? get humidity;
  @override
  bool? get camera;
  @override
  bool? get heatDetection;
  @override
  bool? get voice;
  @override
  double? get battery; // required bool isOwner,
  @override
  String? get serialNumber;
  @override
  bool get isOwner;

  /// Create a copy of HeobyEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HeobyEntityImplCopyWith<_$HeobyEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
