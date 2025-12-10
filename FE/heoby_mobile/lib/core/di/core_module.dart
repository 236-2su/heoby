import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../network/dio_client.dart';

final getIt = GetIt.instance;

Future<void> registerCoreModule(ProviderContainer container) async {
  // Secure Storage
  getIt.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage());

  // Dio Client (AuthInterceptor 등에서 Provider 접근)
  getIt.registerLazySingleton<DioClient>(() => DioClient(container));
}
