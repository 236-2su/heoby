import 'package:heoby_mobile/core/constants/api_endpoints.dart';
import 'package:heoby_mobile/core/network/dio_client.dart';
import 'package:heoby_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:heoby_mobile/features/weather/data/models/weather_model.dart';

class WeatherRemoteDataSource {
  final DioClient _client;
  WeatherRemoteDataSource(this._client);

  Future<WeatherModel> fetchTodayForecast(UserRole role, String crowId) async {
    final response = await _client.get(
      WeatherApi.forecast(role, crowId),
    );

    final data = response.data;

    return WeatherModel.fromJson(data);
  }
}
