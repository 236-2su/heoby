import 'package:heoby_mobile/features/auth/domain/entities/user_entity.dart';

import '../entities/weather_entity.dart';

abstract class WeatherRepository {
  Future<WeatherEntity> getForecast(UserRole role, String crowId);
}
