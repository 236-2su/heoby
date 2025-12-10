import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:heoby_mobile/core/network/dio_client.dart';
import 'package:heoby_mobile/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:heoby_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:heoby_mobile/features/auth/data/datasources/user_remote_datasource.dart';
import 'package:heoby_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:heoby_mobile/features/auth/data/repositories/user_repository_impl.dart';
import 'package:heoby_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:heoby_mobile/features/auth/domain/repositories/user_repository.dart';
import 'package:heoby_mobile/features/auth/domain/usecases/get_user.dart';
import 'package:heoby_mobile/features/auth/domain/usecases/initialize_auth_usecase.dart';
import 'package:heoby_mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:heoby_mobile/features/auth/domain/usecases/logout_usecase.dart';

final getIt = GetIt.instance;

// auth
Future<void> registerAuthModule() async {
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSource(getIt<FlutterSecureStorage>()),
  );

  getIt.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(getIt<DioClient>().dio),
  );

  getIt.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      localDataSource: getIt<AuthLocalDataSource>(),
    ),
  );

  getIt.registerFactory<LoginUseCase>(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerFactory<LogoutUseCase>(() => LogoutUseCase(getIt<AuthRepository>()));
  getIt.registerFactory<InitializeAuthUseCase>(() => InitializeAuthUseCase(getIt<AuthRepository>()));
}

// user
Future<void> registerUserModule() async {
  getIt.registerFactory<UserRemoteDatasource>(
    () => UserRemoteDatasource(getIt<DioClient>()),
  );

  getIt.registerFactory<UserRepository>(
    () => UserRepositoryImpl(getIt<UserRemoteDatasource>()),
  );

  getIt.registerFactory<GetUser>(() => GetUser(getIt<UserRepository>()));
}
