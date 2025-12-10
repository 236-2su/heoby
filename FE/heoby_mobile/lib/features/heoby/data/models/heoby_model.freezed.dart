// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'heoby_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

HeobyModel _$HeobyModelFromJson(Map<String, dynamic> json) {
  return _HeobyModel.fromJson(json);
}

/// @nodoc
mixin _$HeobyModel {
  @JsonKey(name: 'scarecrow_uuid')
  String get scarecrowUuid => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  Location get location => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner_name')
  String get ownerName => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'serial_number')
  String get serialNumber => throw _privateConstructorUsedError;
  double? get temperature => throw _privateConstructorUsedError;
  double? get humidity => throw _privateConstructorUsedError;
  bool? get camera => throw _privateConstructorUsedError;
  bool? get heatDetection => throw _privateConstructorUsedError;
  bool? get voice => throw _privateConstructorUsedError;
  double? get battery => throw _privateConstructorUsedError;

  /// Serializes this HeobyModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HeobyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HeobyModelCopyWith<HeobyModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HeobyModelCopyWith<$Res> {
  factory $HeobyModelCopyWith(
    HeobyModel value,
    $Res Function(HeobyModel) then,
  ) = _$HeobyModelCopyWithImpl<$Res, HeobyModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'scarecrow_uuid') String scarecrowUuid,
    String name,
    Location location,
    @JsonKey(name: 'owner_name') String ownerName,
    String status,
    @JsonKey(name: 'updated_at') String updatedAt,
    @JsonKey(name: 'serial_number') String serialNumber,
    double? temperature,
    double? humidity,
    bool? camera,
    bool? heatDetection,
    bool? voice,
    double? battery,
  });

  $LocationCopyWith<$Res> get location;
}

/// @nodoc
class _$HeobyModelCopyWithImpl<$Res, $Val extends HeobyModel>
    implements $HeobyModelCopyWith<$Res> {
  _$HeobyModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HeobyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scarecrowUuid = null,
    Object? name = null,
    Object? location = null,
    Object? ownerName = null,
    Object? status = null,
    Object? updatedAt = null,
    Object? serialNumber = null,
    Object? temperature = freezed,
    Object? humidity = freezed,
    Object? camera = freezed,
    Object? heatDetection = freezed,
    Object? voice = freezed,
    Object? battery = freezed,
  }) {
    return _then(
      _value.copyWith(
            scarecrowUuid: null == scarecrowUuid
                ? _value.scarecrowUuid
                : scarecrowUuid // ignore: cast_nullable_to_non_nullable
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
            serialNumber: null == serialNumber
                ? _value.serialNumber
                : serialNumber // ignore: cast_nullable_to_non_nullable
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
          )
          as $Val,
    );
  }

  /// Create a copy of HeobyModel
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
abstract class _$$HeobyModelImplCopyWith<$Res>
    implements $HeobyModelCopyWith<$Res> {
  factory _$$HeobyModelImplCopyWith(
    _$HeobyModelImpl value,
    $Res Function(_$HeobyModelImpl) then,
  ) = __$$HeobyModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'scarecrow_uuid') String scarecrowUuid,
    String name,
    Location location,
    @JsonKey(name: 'owner_name') String ownerName,
    String status,
    @JsonKey(name: 'updated_at') String updatedAt,
    @JsonKey(name: 'serial_number') String serialNumber,
    double? temperature,
    double? humidity,
    bool? camera,
    bool? heatDetection,
    bool? voice,
    double? battery,
  });

  @override
  $LocationCopyWith<$Res> get location;
}

/// @nodoc
class __$$HeobyModelImplCopyWithImpl<$Res>
    extends _$HeobyModelCopyWithImpl<$Res, _$HeobyModelImpl>
    implements _$$HeobyModelImplCopyWith<$Res> {
  __$$HeobyModelImplCopyWithImpl(
    _$HeobyModelImpl _value,
    $Res Function(_$HeobyModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HeobyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scarecrowUuid = null,
    Object? name = null,
    Object? location = null,
    Object? ownerName = null,
    Object? status = null,
    Object? updatedAt = null,
    Object? serialNumber = null,
    Object? temperature = freezed,
    Object? humidity = freezed,
    Object? camera = freezed,
    Object? heatDetection = freezed,
    Object? voice = freezed,
    Object? battery = freezed,
  }) {
    return _then(
      _$HeobyModelImpl(
        scarecrowUuid: null == scarecrowUuid
            ? _value.scarecrowUuid
            : scarecrowUuid // ignore: cast_nullable_to_non_nullable
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
        serialNumber: null == serialNumber
            ? _value.serialNumber
            : serialNumber // ignore: cast_nullable_to_non_nullable
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HeobyModelImpl implements _HeobyModel {
  const _$HeobyModelImpl({
    @JsonKey(name: 'scarecrow_uuid') required this.scarecrowUuid,
    required this.name,
    required this.location,
    @JsonKey(name: 'owner_name') required this.ownerName,
    required this.status,
    @JsonKey(name: 'updated_at') required this.updatedAt,
    @JsonKey(name: 'serial_number') required this.serialNumber,
    required this.temperature,
    required this.humidity,
    required this.camera,
    required this.heatDetection,
    required this.voice,
    required this.battery,
  });

  factory _$HeobyModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$HeobyModelImplFromJson(json);

  @override
  @JsonKey(name: 'scarecrow_uuid')
  final String scarecrowUuid;
  @override
  final String name;
  @override
  final Location location;
  @override
  @JsonKey(name: 'owner_name')
  final String ownerName;
  @override
  final String status;
  @override
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @override
  @JsonKey(name: 'serial_number')
  final String serialNumber;
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

  @override
  String toString() {
    return 'HeobyModel(scarecrowUuid: $scarecrowUuid, name: $name, location: $location, ownerName: $ownerName, status: $status, updatedAt: $updatedAt, serialNumber: $serialNumber, temperature: $temperature, humidity: $humidity, camera: $camera, heatDetection: $heatDetection, voice: $voice, battery: $battery)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HeobyModelImpl &&
            (identical(other.scarecrowUuid, scarecrowUuid) ||
                other.scarecrowUuid == scarecrowUuid) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.ownerName, ownerName) ||
                other.ownerName == ownerName) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.serialNumber, serialNumber) ||
                other.serialNumber == serialNumber) &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.humidity, humidity) ||
                other.humidity == humidity) &&
            (identical(other.camera, camera) || other.camera == camera) &&
            (identical(other.heatDetection, heatDetection) ||
                other.heatDetection == heatDetection) &&
            (identical(other.voice, voice) || other.voice == voice) &&
            (identical(other.battery, battery) || other.battery == battery));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    scarecrowUuid,
    name,
    location,
    ownerName,
    status,
    updatedAt,
    serialNumber,
    temperature,
    humidity,
    camera,
    heatDetection,
    voice,
    battery,
  );

  /// Create a copy of HeobyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HeobyModelImplCopyWith<_$HeobyModelImpl> get copyWith =>
      __$$HeobyModelImplCopyWithImpl<_$HeobyModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HeobyModelImplToJson(this);
  }
}

abstract class _HeobyModel implements HeobyModel {
  const factory _HeobyModel({
    @JsonKey(name: 'scarecrow_uuid') required final String scarecrowUuid,
    required final String name,
    required final Location location,
    @JsonKey(name: 'owner_name') required final String ownerName,
    required final String status,
    @JsonKey(name: 'updated_at') required final String updatedAt,
    @JsonKey(name: 'serial_number') required final String serialNumber,
    required final double? temperature,
    required final double? humidity,
    required final bool? camera,
    required final bool? heatDetection,
    required final bool? voice,
    required final double? battery,
  }) = _$HeobyModelImpl;

  factory _HeobyModel.fromJson(Map<String, dynamic> json) =
      _$HeobyModelImpl.fromJson;

  @override
  @JsonKey(name: 'scarecrow_uuid')
  String get scarecrowUuid;
  @override
  String get name;
  @override
  Location get location;
  @override
  @JsonKey(name: 'owner_name')
  String get ownerName;
  @override
  String get status;
  @override
  @JsonKey(name: 'updated_at')
  String get updatedAt;
  @override
  @JsonKey(name: 'serial_number')
  String get serialNumber;
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
  double? get battery;

  /// Create a copy of HeobyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HeobyModelImplCopyWith<_$HeobyModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HeobyListResponse _$HeobyListResponseFromJson(Map<String, dynamic> json) {
  return _HeobyListResponse.fromJson(json);
}

/// @nodoc
mixin _$HeobyListResponse {
  @JsonKey(name: 'my_scarecrows')
  List<HeobyModel> get myScarecrows => throw _privateConstructorUsedError;
  @JsonKey(name: 'village_scarecrows')
  List<HeobyModel> get villageScarecrows => throw _privateConstructorUsedError;

  /// Serializes this HeobyListResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HeobyListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HeobyListResponseCopyWith<HeobyListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HeobyListResponseCopyWith<$Res> {
  factory $HeobyListResponseCopyWith(
    HeobyListResponse value,
    $Res Function(HeobyListResponse) then,
  ) = _$HeobyListResponseCopyWithImpl<$Res, HeobyListResponse>;
  @useResult
  $Res call({
    @JsonKey(name: 'my_scarecrows') List<HeobyModel> myScarecrows,
    @JsonKey(name: 'village_scarecrows') List<HeobyModel> villageScarecrows,
  });
}

/// @nodoc
class _$HeobyListResponseCopyWithImpl<$Res, $Val extends HeobyListResponse>
    implements $HeobyListResponseCopyWith<$Res> {
  _$HeobyListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HeobyListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? myScarecrows = null, Object? villageScarecrows = null}) {
    return _then(
      _value.copyWith(
            myScarecrows: null == myScarecrows
                ? _value.myScarecrows
                : myScarecrows // ignore: cast_nullable_to_non_nullable
                      as List<HeobyModel>,
            villageScarecrows: null == villageScarecrows
                ? _value.villageScarecrows
                : villageScarecrows // ignore: cast_nullable_to_non_nullable
                      as List<HeobyModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HeobyListResponseImplCopyWith<$Res>
    implements $HeobyListResponseCopyWith<$Res> {
  factory _$$HeobyListResponseImplCopyWith(
    _$HeobyListResponseImpl value,
    $Res Function(_$HeobyListResponseImpl) then,
  ) = __$$HeobyListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'my_scarecrows') List<HeobyModel> myScarecrows,
    @JsonKey(name: 'village_scarecrows') List<HeobyModel> villageScarecrows,
  });
}

/// @nodoc
class __$$HeobyListResponseImplCopyWithImpl<$Res>
    extends _$HeobyListResponseCopyWithImpl<$Res, _$HeobyListResponseImpl>
    implements _$$HeobyListResponseImplCopyWith<$Res> {
  __$$HeobyListResponseImplCopyWithImpl(
    _$HeobyListResponseImpl _value,
    $Res Function(_$HeobyListResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HeobyListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? myScarecrows = null, Object? villageScarecrows = null}) {
    return _then(
      _$HeobyListResponseImpl(
        myScarecrows: null == myScarecrows
            ? _value._myScarecrows
            : myScarecrows // ignore: cast_nullable_to_non_nullable
                  as List<HeobyModel>,
        villageScarecrows: null == villageScarecrows
            ? _value._villageScarecrows
            : villageScarecrows // ignore: cast_nullable_to_non_nullable
                  as List<HeobyModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HeobyListResponseImpl extends _HeobyListResponse {
  const _$HeobyListResponseImpl({
    @JsonKey(name: 'my_scarecrows')
    required final List<HeobyModel> myScarecrows,
    @JsonKey(name: 'village_scarecrows')
    required final List<HeobyModel> villageScarecrows,
  }) : _myScarecrows = myScarecrows,
       _villageScarecrows = villageScarecrows,
       super._();

  factory _$HeobyListResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$HeobyListResponseImplFromJson(json);

  final List<HeobyModel> _myScarecrows;
  @override
  @JsonKey(name: 'my_scarecrows')
  List<HeobyModel> get myScarecrows {
    if (_myScarecrows is EqualUnmodifiableListView) return _myScarecrows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_myScarecrows);
  }

  final List<HeobyModel> _villageScarecrows;
  @override
  @JsonKey(name: 'village_scarecrows')
  List<HeobyModel> get villageScarecrows {
    if (_villageScarecrows is EqualUnmodifiableListView)
      return _villageScarecrows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_villageScarecrows);
  }

  @override
  String toString() {
    return 'HeobyListResponse(myScarecrows: $myScarecrows, villageScarecrows: $villageScarecrows)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HeobyListResponseImpl &&
            const DeepCollectionEquality().equals(
              other._myScarecrows,
              _myScarecrows,
            ) &&
            const DeepCollectionEquality().equals(
              other._villageScarecrows,
              _villageScarecrows,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_myScarecrows),
    const DeepCollectionEquality().hash(_villageScarecrows),
  );

  /// Create a copy of HeobyListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HeobyListResponseImplCopyWith<_$HeobyListResponseImpl> get copyWith =>
      __$$HeobyListResponseImplCopyWithImpl<_$HeobyListResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$HeobyListResponseImplToJson(this);
  }
}

abstract class _HeobyListResponse extends HeobyListResponse {
  const factory _HeobyListResponse({
    @JsonKey(name: 'my_scarecrows')
    required final List<HeobyModel> myScarecrows,
    @JsonKey(name: 'village_scarecrows')
    required final List<HeobyModel> villageScarecrows,
  }) = _$HeobyListResponseImpl;
  const _HeobyListResponse._() : super._();

  factory _HeobyListResponse.fromJson(Map<String, dynamic> json) =
      _$HeobyListResponseImpl.fromJson;

  @override
  @JsonKey(name: 'my_scarecrows')
  List<HeobyModel> get myScarecrows;
  @override
  @JsonKey(name: 'village_scarecrows')
  List<HeobyModel> get villageScarecrows;

  /// Create a copy of HeobyListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HeobyListResponseImplCopyWith<_$HeobyListResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
