import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:heoby_mobile/core/di/feature/auth_module.dart';
import 'package:heoby_mobile/core/di/feature/cctv_module.dart';
import 'package:heoby_mobile/core/di/feature/heoby_module.dart';
import 'package:heoby_mobile/core/di/feature/notification_module.dart';
import 'package:heoby_mobile/core/di/feature/weather_module.dart';

// Features

// Core
import 'core_module.dart';

final getIt = GetIt.instance;

/// 전체 의존성 초기화 (앱 시작 시 main.dart에서 호출)
Future<void> setupDependencies(ProviderContainer container) async {
  await registerCoreModule(container);

  await registerAuthModule();
  await registerUserModule();
  await registerCctvModule();
  await registerHeobyModule();
  await registerWeatherModule();
  await registerNotificationModule();
}
