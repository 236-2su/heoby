import 'package:get_it/get_it.dart';
import 'package:heoby_mobile/features/cctv/data/datasources/cctv_remote_datasource.dart';
import 'package:heoby_mobile/features/cctv/data/repositories/cctv_repository_impl.dart';
import 'package:heoby_mobile/features/cctv/domain/repositories/cctv_repository.dart';
import 'package:heoby_mobile/features/cctv/domain/usecases/get_workers.dart';

import '../../../core/network/dio_client.dart';

final getIt = GetIt.instance;

Future<void> registerCctvModule() async {
  getIt.registerFactory<CctvRemoteDatasource>(
    () => CctvRemoteDatasource(getIt<DioClient>()),
  );

  getIt.registerFactory<CctvRepository>(
    () => CctvRepositoryImpl(getIt<CctvRemoteDatasource>()),
  );

  getIt.registerFactory<GetWorkers>(
    () => GetWorkers(getIt<CctvRepository>()),
  );
}
