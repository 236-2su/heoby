// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weather_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WeatherModel _$WeatherModelFromJson(Map<String, dynamic> json) {
  return _WeatherModel.fromJson(json);
}

/// @nodoc
mixin _$WeatherModel {
  Location get location => throw _privateConstructorUsedError;
  Sensor get sensor => throw _privateConstructorUsedError;
  @JsonKey(name: 'weather_forecast')
  List<WeatherForecastModel> get forecasts =>
      throw _privateConstructorUsedError;

  /// Serializes this WeatherModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WeatherModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WeatherModelCopyWith<WeatherModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeatherModelCopyWith<$Res> {
  factory $WeatherModelCopyWith(
    WeatherModel value,
    $Res Function(WeatherModel) then,
  ) = _$WeatherModelCopyWithImpl<$Res, WeatherModel>;
  @useResult
  $Res call({
    Location location,
    Sensor sensor,
    @JsonKey(name: 'weather_forecast') List<WeatherForecastModel> forecasts,
  });

  $LocationCopyWith<$Res> get location;
  $SensorCopyWith<$Res> get sensor;
}

/// @nodoc
class _$WeatherModelCopyWithImpl<$Res, $Val extends WeatherModel>
    implements $WeatherModelCopyWith<$Res> {
  _$WeatherModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WeatherModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? sensor = null,
    Object? forecasts = null,
  }) {
    return _then(
      _value.copyWith(
            location: null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as Location,
            sensor: null == sensor
                ? _value.sensor
                : sensor // ignore: cast_nullable_to_non_nullable
                      as Sensor,
            forecasts: null == forecasts
                ? _value.forecasts
                : forecasts // ignore: cast_nullable_to_non_nullable
                      as List<WeatherForecastModel>,
          )
          as $Val,
    );
  }

  /// Create a copy of WeatherModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LocationCopyWith<$Res> get location {
    return $LocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }

  /// Create a copy of WeatherModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SensorCopyWith<$Res> get sensor {
    return $SensorCopyWith<$Res>(_value.sensor, (value) {
      return _then(_value.copyWith(sensor: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WeatherModelImplCopyWith<$Res>
    implements $WeatherModelCopyWith<$Res> {
  factory _$$WeatherModelImplCopyWith(
    _$WeatherModelImpl value,
    $Res Function(_$WeatherModelImpl) then,
  ) = __$$WeatherModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Location location,
    Sensor sensor,
    @JsonKey(name: 'weather_forecast') List<WeatherForecastModel> forecasts,
  });

  @override
  $LocationCopyWith<$Res> get location;
  @override
  $SensorCopyWith<$Res> get sensor;
}

/// @nodoc
class __$$WeatherModelImplCopyWithImpl<$Res>
    extends _$WeatherModelCopyWithImpl<$Res, _$WeatherModelImpl>
    implements _$$WeatherModelImplCopyWith<$Res> {
  __$$WeatherModelImplCopyWithImpl(
    _$WeatherModelImpl _value,
    $Res Function(_$WeatherModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WeatherModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? sensor = null,
    Object? forecasts = null,
  }) {
    return _then(
      _$WeatherModelImpl(
        location: null == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as Location,
        sensor: null == sensor
            ? _value.sensor
            : sensor // ignore: cast_nullable_to_non_nullable
                  as Sensor,
        forecasts: null == forecasts
            ? _value._forecasts
            : forecasts // ignore: cast_nullable_to_non_nullable
                  as List<WeatherForecastModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WeatherModelImpl implements _WeatherModel {
  const _$WeatherModelImpl({
    required this.location,
    required this.sensor,
    @JsonKey(name: 'weather_forecast')
    required final List<WeatherForecastModel> forecasts,
  }) : _forecasts = forecasts;

  factory _$WeatherModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeatherModelImplFromJson(json);

  @override
  final Location location;
  @override
  final Sensor sensor;
  final List<WeatherForecastModel> _forecasts;
  @override
  @JsonKey(name: 'weather_forecast')
  List<WeatherForecastModel> get forecasts {
    if (_forecasts is EqualUnmodifiableListView) return _forecasts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_forecasts);
  }

  @override
  String toString() {
    return 'WeatherModel(location: $location, sensor: $sensor, forecasts: $forecasts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeatherModelImpl &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.sensor, sensor) || other.sensor == sensor) &&
            const DeepCollectionEquality().equals(
              other._forecasts,
              _forecasts,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    location,
    sensor,
    const DeepCollectionEquality().hash(_forecasts),
  );

  /// Create a copy of WeatherModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WeatherModelImplCopyWith<_$WeatherModelImpl> get copyWith =>
      __$$WeatherModelImplCopyWithImpl<_$WeatherModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeatherModelImplToJson(this);
  }
}

abstract class _WeatherModel implements WeatherModel {
  const factory _WeatherModel({
    required final Location location,
    required final Sensor sensor,
    @JsonKey(name: 'weather_forecast')
    required final List<WeatherForecastModel> forecasts,
  }) = _$WeatherModelImpl;

  factory _WeatherModel.fromJson(Map<String, dynamic> json) =
      _$WeatherModelImpl.fromJson;

  @override
  Location get location;
  @override
  Sensor get sensor;
  @override
  @JsonKey(name: 'weather_forecast')
  List<WeatherForecastModel> get forecasts;

  /// Create a copy of WeatherModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeatherModelImplCopyWith<_$WeatherModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Sensor _$SensorFromJson(Map<String, dynamic> json) {
  return _Sensor.fromJson(json);
}

/// @nodoc
mixin _$Sensor {
  double get temperature => throw _privateConstructorUsedError;
  double get humidity => throw _privateConstructorUsedError;

  /// Serializes this Sensor to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Sensor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SensorCopyWith<Sensor> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SensorCopyWith<$Res> {
  factory $SensorCopyWith(Sensor value, $Res Function(Sensor) then) =
      _$SensorCopyWithImpl<$Res, Sensor>;
  @useResult
  $Res call({double temperature, double humidity});
}

/// @nodoc
class _$SensorCopyWithImpl<$Res, $Val extends Sensor>
    implements $SensorCopyWith<$Res> {
  _$SensorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Sensor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? temperature = null, Object? humidity = null}) {
    return _then(
      _value.copyWith(
            temperature: null == temperature
                ? _value.temperature
                : temperature // ignore: cast_nullable_to_non_nullable
                      as double,
            humidity: null == humidity
                ? _value.humidity
                : humidity // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SensorImplCopyWith<$Res> implements $SensorCopyWith<$Res> {
  factory _$$SensorImplCopyWith(
    _$SensorImpl value,
    $Res Function(_$SensorImpl) then,
  ) = __$$SensorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double temperature, double humidity});
}

/// @nodoc
class __$$SensorImplCopyWithImpl<$Res>
    extends _$SensorCopyWithImpl<$Res, _$SensorImpl>
    implements _$$SensorImplCopyWith<$Res> {
  __$$SensorImplCopyWithImpl(
    _$SensorImpl _value,
    $Res Function(_$SensorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Sensor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? temperature = null, Object? humidity = null}) {
    return _then(
      _$SensorImpl(
        temperature: null == temperature
            ? _value.temperature
            : temperature // ignore: cast_nullable_to_non_nullable
                  as double,
        humidity: null == humidity
            ? _value.humidity
            : humidity // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SensorImpl implements _Sensor {
  const _$SensorImpl({required this.temperature, required this.humidity});

  factory _$SensorImpl.fromJson(Map<String, dynamic> json) =>
      _$$SensorImplFromJson(json);

  @override
  final double temperature;
  @override
  final double humidity;

  @override
  String toString() {
    return 'Sensor(temperature: $temperature, humidity: $humidity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SensorImpl &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.humidity, humidity) ||
                other.humidity == humidity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, temperature, humidity);

  /// Create a copy of Sensor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SensorImplCopyWith<_$SensorImpl> get copyWith =>
      __$$SensorImplCopyWithImpl<_$SensorImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SensorImplToJson(this);
  }
}

abstract class _Sensor implements Sensor {
  const factory _Sensor({
    required final double temperature,
    required final double humidity,
  }) = _$SensorImpl;

  factory _Sensor.fromJson(Map<String, dynamic> json) = _$SensorImpl.fromJson;

  @override
  double get temperature;
  @override
  double get humidity;

  /// Create a copy of Sensor
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SensorImplCopyWith<_$SensorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WeatherForecastModel _$WeatherForecastModelFromJson(Map<String, dynamic> json) {
  return _WeatherForecastModel.fromJson(json);
}

/// @nodoc
mixin _$WeatherForecastModel {
  String get time => throw _privateConstructorUsedError;
  double get temperature_c => throw _privateConstructorUsedError;
  double get humidity_pct => throw _privateConstructorUsedError;
  double get precip_mm => throw _privateConstructorUsedError;
  double get wind_ms => throw _privateConstructorUsedError;
  String get wind_dir => throw _privateConstructorUsedError;
  String get condition => throw _privateConstructorUsedError;

  /// Serializes this WeatherForecastModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WeatherForecastModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WeatherForecastModelCopyWith<WeatherForecastModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeatherForecastModelCopyWith<$Res> {
  factory $WeatherForecastModelCopyWith(
    WeatherForecastModel value,
    $Res Function(WeatherForecastModel) then,
  ) = _$WeatherForecastModelCopyWithImpl<$Res, WeatherForecastModel>;
  @useResult
  $Res call({
    String time,
    double temperature_c,
    double humidity_pct,
    double precip_mm,
    double wind_ms,
    String wind_dir,
    String condition,
  });
}

/// @nodoc
class _$WeatherForecastModelCopyWithImpl<
  $Res,
  $Val extends WeatherForecastModel
>
    implements $WeatherForecastModelCopyWith<$Res> {
  _$WeatherForecastModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WeatherForecastModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? time = null,
    Object? temperature_c = null,
    Object? humidity_pct = null,
    Object? precip_mm = null,
    Object? wind_ms = null,
    Object? wind_dir = null,
    Object? condition = null,
  }) {
    return _then(
      _value.copyWith(
            time: null == time
                ? _value.time
                : time // ignore: cast_nullable_to_non_nullable
                      as String,
            temperature_c: null == temperature_c
                ? _value.temperature_c
                : temperature_c // ignore: cast_nullable_to_non_nullable
                      as double,
            humidity_pct: null == humidity_pct
                ? _value.humidity_pct
                : humidity_pct // ignore: cast_nullable_to_non_nullable
                      as double,
            precip_mm: null == precip_mm
                ? _value.precip_mm
                : precip_mm // ignore: cast_nullable_to_non_nullable
                      as double,
            wind_ms: null == wind_ms
                ? _value.wind_ms
                : wind_ms // ignore: cast_nullable_to_non_nullable
                      as double,
            wind_dir: null == wind_dir
                ? _value.wind_dir
                : wind_dir // ignore: cast_nullable_to_non_nullable
                      as String,
            condition: null == condition
                ? _value.condition
                : condition // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WeatherForecastModelImplCopyWith<$Res>
    implements $WeatherForecastModelCopyWith<$Res> {
  factory _$$WeatherForecastModelImplCopyWith(
    _$WeatherForecastModelImpl value,
    $Res Function(_$WeatherForecastModelImpl) then,
  ) = __$$WeatherForecastModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String time,
    double temperature_c,
    double humidity_pct,
    double precip_mm,
    double wind_ms,
    String wind_dir,
    String condition,
  });
}

/// @nodoc
class __$$WeatherForecastModelImplCopyWithImpl<$Res>
    extends _$WeatherForecastModelCopyWithImpl<$Res, _$WeatherForecastModelImpl>
    implements _$$WeatherForecastModelImplCopyWith<$Res> {
  __$$WeatherForecastModelImplCopyWithImpl(
    _$WeatherForecastModelImpl _value,
    $Res Function(_$WeatherForecastModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WeatherForecastModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? time = null,
    Object? temperature_c = null,
    Object? humidity_pct = null,
    Object? precip_mm = null,
    Object? wind_ms = null,
    Object? wind_dir = null,
    Object? condition = null,
  }) {
    return _then(
      _$WeatherForecastModelImpl(
        time: null == time
            ? _value.time
            : time // ignore: cast_nullable_to_non_nullable
                  as String,
        temperature_c: null == temperature_c
            ? _value.temperature_c
            : temperature_c // ignore: cast_nullable_to_non_nullable
                  as double,
        humidity_pct: null == humidity_pct
            ? _value.humidity_pct
            : humidity_pct // ignore: cast_nullable_to_non_nullable
                  as double,
        precip_mm: null == precip_mm
            ? _value.precip_mm
            : precip_mm // ignore: cast_nullable_to_non_nullable
                  as double,
        wind_ms: null == wind_ms
            ? _value.wind_ms
            : wind_ms // ignore: cast_nullable_to_non_nullable
                  as double,
        wind_dir: null == wind_dir
            ? _value.wind_dir
            : wind_dir // ignore: cast_nullable_to_non_nullable
                  as String,
        condition: null == condition
            ? _value.condition
            : condition // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WeatherForecastModelImpl implements _WeatherForecastModel {
  const _$WeatherForecastModelImpl({
    required this.time,
    required this.temperature_c,
    required this.humidity_pct,
    required this.precip_mm,
    required this.wind_ms,
    required this.wind_dir,
    required this.condition,
  });

  factory _$WeatherForecastModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeatherForecastModelImplFromJson(json);

  @override
  final String time;
  @override
  final double temperature_c;
  @override
  final double humidity_pct;
  @override
  final double precip_mm;
  @override
  final double wind_ms;
  @override
  final String wind_dir;
  @override
  final String condition;

  @override
  String toString() {
    return 'WeatherForecastModel(time: $time, temperature_c: $temperature_c, humidity_pct: $humidity_pct, precip_mm: $precip_mm, wind_ms: $wind_ms, wind_dir: $wind_dir, condition: $condition)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeatherForecastModelImpl &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.temperature_c, temperature_c) ||
                other.temperature_c == temperature_c) &&
            (identical(other.humidity_pct, humidity_pct) ||
                other.humidity_pct == humidity_pct) &&
            (identical(other.precip_mm, precip_mm) ||
                other.precip_mm == precip_mm) &&
            (identical(other.wind_ms, wind_ms) || other.wind_ms == wind_ms) &&
            (identical(other.wind_dir, wind_dir) ||
                other.wind_dir == wind_dir) &&
            (identical(other.condition, condition) ||
                other.condition == condition));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    time,
    temperature_c,
    humidity_pct,
    precip_mm,
    wind_ms,
    wind_dir,
    condition,
  );

  /// Create a copy of WeatherForecastModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WeatherForecastModelImplCopyWith<_$WeatherForecastModelImpl>
  get copyWith =>
      __$$WeatherForecastModelImplCopyWithImpl<_$WeatherForecastModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WeatherForecastModelImplToJson(this);
  }
}

abstract class _WeatherForecastModel implements WeatherForecastModel {
  const factory _WeatherForecastModel({
    required final String time,
    required final double temperature_c,
    required final double humidity_pct,
    required final double precip_mm,
    required final double wind_ms,
    required final String wind_dir,
    required final String condition,
  }) = _$WeatherForecastModelImpl;

  factory _WeatherForecastModel.fromJson(Map<String, dynamic> json) =
      _$WeatherForecastModelImpl.fromJson;

  @override
  String get time;
  @override
  double get temperature_c;
  @override
  double get humidity_pct;
  @override
  double get precip_mm;
  @override
  double get wind_ms;
  @override
  String get wind_dir;
  @override
  String get condition;

  /// Create a copy of WeatherForecastModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeatherForecastModelImplCopyWith<_$WeatherForecastModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
