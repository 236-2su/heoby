import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/injection.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/providers/user_provider.dart';
import '../../../heoby/presentation/providers/heoby_providers.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/usecases/get_today_forecast.dart';

part 'weather_providers.g.dart';

/// 오늘 날씨 예보 Provider
/// 선택된 허수아비의 날씨 예보를 가져옴
@riverpod
Future<WeatherEntity> todayForecast(Ref ref) async {
  final selectedHeoby = ref.watch(selectedHeobyProvider);

  // 선택된 허수아비가 없으면 에러
  if (selectedHeoby == null) {
    throw Exception('선택된 허수아비가 없습니다');
  }

  final user = ref.read(userProvider);
  final role = user?.role ?? UserRole.user;
  final usecase = getIt<GetForecast>();
  return usecase(role, selectedHeoby.uuid);
}
