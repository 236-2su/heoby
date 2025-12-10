import 'package:get_it/get_it.dart';
import 'package:heoby_mobile/features/heoby/data/datasources/heoby_remote_data_source.dart';
import 'package:heoby_mobile/features/heoby/data/repositories/heoby_repository_impl.dart';
import 'package:heoby_mobile/features/heoby/domain/repositories/heoby_repository.dart';
import 'package:heoby_mobile/features/heoby/domain/usecases/get_heoby_list.dart';

import '../../../core/network/dio_client.dart';

final getIt = GetIt.instance;

Future<void> registerHeobyModule() async {
  getIt.registerFactory<HeobyRemoteDataSource>(
    () => HeobyRemoteDataSource(getIt<DioClient>()),
  );

  getIt.registerFactory<HeobyRepository>(
    () => HeobyRepositoryImpl(getIt<HeobyRemoteDataSource>()),
  );

  getIt.registerFactory<GetHeobyList>(
    () => GetHeobyList(getIt<HeobyRepository>()),
  );
}
