import 'package:heoby_mobile/core/models/location.dart';
import 'package:heoby_mobile/features/weather/data/models/weather_model.dart';

class WeatherEntity {
  final Location location;
  final Sensor sensor;
  final List<WeatherForecastEntity> forecasts;

  WeatherEntity({
    required this.location,
    required this.sensor,
    required this.forecasts,
  });
}

class WeatherForecastEntity {
  final String time;
  final double temperature;
  final double humidity;
  final double precip;
  final double windSpeed;
  final String windDir;
  final String condition;

  WeatherForecastEntity({
    required this.time,
    required this.temperature,
    required this.humidity,
    required this.precip,
    required this.windSpeed,
    required this.windDir,
    required this.condition,
  });
}
