import 'package:heoby_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:heoby_mobile/features/weather/data/models/weather_model.dart';

import '../../domain/entities/weather_entity.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_remote_data_source.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource _remote;
  WeatherRepositoryImpl(this._remote);

  @override
  Future<WeatherEntity> getForecast(UserRole role, String crowId) async {
    final models = await _remote.fetchTodayForecast(role, crowId);
    return models.toEntity();
  }
}
