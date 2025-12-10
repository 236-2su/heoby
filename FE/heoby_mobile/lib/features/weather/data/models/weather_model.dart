import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:heoby_mobile/core/models/location.dart';

import '../../domain/entities/weather_entity.dart';

part 'weather_model.freezed.dart';
part 'weather_model.g.dart';

@freezed
class WeatherModel with _$WeatherModel {
  const factory WeatherModel({
    required Location location,
    required Sensor sensor,
    @JsonKey(name: 'weather_forecast') required List<WeatherForecastModel> forecasts,
  }) = _WeatherModel;

  factory WeatherModel.fromJson(Map<String, dynamic> json) => _$WeatherModelFromJson(json);
}

extension WeatherModelX on WeatherModel {
  WeatherEntity toEntity() => WeatherEntity(
    location: location,
    sensor: sensor,
    forecasts: forecasts.map((e) => e.toEntity()).toList(),
  );
}

@freezed
class Sensor with _$Sensor {
  const factory Sensor({
    required double temperature,
    required double humidity,
  }) = _Sensor;

  factory Sensor.fromJson(Map<String, dynamic> json) => _$SensorFromJson(json);
}

@freezed
class WeatherForecastModel with _$WeatherForecastModel {
  const factory WeatherForecastModel({
    required String time,
    required double temperature_c,
    required double humidity_pct,
    required double precip_mm,
    required double wind_ms,
    required String wind_dir,
    required String condition,
  }) = _WeatherForecastModel;

  factory WeatherForecastModel.fromJson(Map<String, dynamic> json) => _$WeatherForecastModelFromJson(json);
}

extension WeatherForecastModelX on WeatherForecastModel {
  WeatherForecastEntity toEntity() => WeatherForecastEntity(
    time: time,
    temperature: temperature_c,
    humidity: humidity_pct,
    precip: precip_mm,
    windSpeed: wind_ms,
    windDir: wind_dir,
    condition: condition,
  );
}
