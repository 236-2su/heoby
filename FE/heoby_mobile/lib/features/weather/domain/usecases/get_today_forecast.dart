import 'package:heoby_mobile/features/auth/domain/entities/user_entity.dart';

import '../entities/weather_entity.dart';
import '../repositories/weather_repository.dart';

class GetForecast {
  final WeatherRepository _repo;
  GetForecast(this._repo);

  Future<WeatherEntity> call(UserRole role, String crowId) {
    return _repo.getForecast(role, crowId);
  }
}
