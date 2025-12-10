import 'package:get_it/get_it.dart';
import 'package:heoby_mobile/features/notification/data/datasources/notification_remote_data_source.dart';
import 'package:heoby_mobile/features/notification/data/repositories/notification_repository_impl.dart';
import 'package:heoby_mobile/features/notification/domain/repositories/notification_repository.dart';
import 'package:heoby_mobile/features/notification/domain/usecases/get_notification.dart';
import 'package:heoby_mobile/features/notification/domain/usecases/mark_as_read.dart';
import 'package:heoby_mobile/features/notification/domain/usecases/register_fcm_token.dart';
import 'package:heoby_mobile/features/notification/domain/usecases/unregister_fcm_token.dart';

import '../../../core/network/dio_client.dart';

final getIt = GetIt.instance;

Future<void> registerNotificationModule() async {
  getIt.registerFactory<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSource(getIt<DioClient>()),
  );

  getIt.registerFactory<NotificationRepository>(
    () => NotificationRepositoryImpl(getIt<NotificationRemoteDataSource>()),
  );

  getIt.registerFactory<GetNotification>(
    () => GetNotification(getIt<NotificationRepository>()),
  );

  getIt.registerFactory<RegisterFcmToken>(
    () => RegisterFcmToken(getIt<NotificationRepository>()),
  );

  getIt.registerFactory<UnregisterFcmToken>(
    () => UnregisterFcmToken(getIt<NotificationRepository>()),
  );

  getIt.registerFactory<MarkAsRead>(
    () => MarkAsRead(getIt<NotificationRepository>()),
  );
}
