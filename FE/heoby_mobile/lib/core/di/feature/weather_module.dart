import 'package:get_it/get_it.dart';
import 'package:heoby_mobile/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:heoby_mobile/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:heoby_mobile/features/weather/domain/repositories/weather_repository.dart';
import 'package:heoby_mobile/features/weather/domain/usecases/get_today_forecast.dart';

import '../../../core/network/dio_client.dart';

final getIt = GetIt.instance;

Future<void> registerWeatherModule() async {
  getIt.registerFactory<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSource(getIt<DioClient>()),
  );

  getIt.registerFactory<WeatherRepository>(
    () => WeatherRepositoryImpl(getIt<WeatherRemoteDataSource>()),
  );

  getIt.registerFactory<GetForecast>(
    () => GetForecast(getIt<WeatherRepository>()),
  );
}
