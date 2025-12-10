// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WeatherModelImpl _$$WeatherModelImplFromJson(Map<String, dynamic> json) =>
    _$WeatherModelImpl(
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      sensor: Sensor.fromJson(json['sensor'] as Map<String, dynamic>),
      forecasts: (json['weather_forecast'] as List<dynamic>)
          .map((e) => WeatherForecastModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$WeatherModelImplToJson(_$WeatherModelImpl instance) =>
    <String, dynamic>{
      'location': instance.location,
      'sensor': instance.sensor,
      'weather_forecast': instance.forecasts,
    };

_$SensorImpl _$$SensorImplFromJson(Map<String, dynamic> json) => _$SensorImpl(
  temperature: (json['temperature'] as num).toDouble(),
  humidity: (json['humidity'] as num).toDouble(),
);

Map<String, dynamic> _$$SensorImplToJson(_$SensorImpl instance) =>
    <String, dynamic>{
      'temperature': instance.temperature,
      'humidity': instance.humidity,
    };

_$WeatherForecastModelImpl _$$WeatherForecastModelImplFromJson(
  Map<String, dynamic> json,
) => _$WeatherForecastModelImpl(
  time: json['time'] as String,
  temperature_c: (json['temperature_c'] as num).toDouble(),
  humidity_pct: (json['humidity_pct'] as num).toDouble(),
  precip_mm: (json['precip_mm'] as num).toDouble(),
  wind_ms: (json['wind_ms'] as num).toDouble(),
  wind_dir: json['wind_dir'] as String,
  condition: json['condition'] as String,
);

Map<String, dynamic> _$$WeatherForecastModelImplToJson(
  _$WeatherForecastModelImpl instance,
) => <String, dynamic>{
  'time': instance.time,
  'temperature_c': instance.temperature_c,
  'humidity_pct': instance.humidity_pct,
  'precip_mm': instance.precip_mm,
  'wind_ms': instance.wind_ms,
  'wind_dir': instance.wind_dir,
  'condition': instance.condition,
};
