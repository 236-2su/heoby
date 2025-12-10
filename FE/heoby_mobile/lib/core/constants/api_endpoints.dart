import 'package:heoby_mobile/features/auth/domain/entities/user_entity.dart';

/// Swagger API 엔드포인트 정의
class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://k13e106.p.ssafy.io/dev/api',
  );

  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
}

class AuthApi {
  AuthApi._();

  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String refresh = '/auth/refresh';
  static const String signup = '/auth/signup';
}

class UserApi {
  UserApi._();

  static const String me = '/users/me'; // GET, DELETE, PATCH
}

class HeobyApi {
  HeobyApi._();

  static const Map<UserRole, String> _listByRole = {
    UserRole.user: '/dashboard/scarecrows',
    UserRole.leader: '/dashboard/leader/scarecrows',
  };

  static String list(UserRole role) => _listByRole[role] ?? _listByRole[UserRole.user]!;
}

class WeatherApi {
  WeatherApi._();

  static String forecast(UserRole role, String crowId) {
    switch (role) {
      case UserRole.leader:
        return '/dashboard/leader/weather/$crowId';
      case UserRole.user:
      default:
        return '/dashboard/weather/$crowId';
    }
  }
}

class NotificationApi {
  NotificationApi._();

  static String list(UserRole role) {
    if (role == UserRole.leader) {
      return '/dashboard/leader/alarms';
    }
    return '/dashboard/alarms';
  }

  static String markAsRead(String alertUuid) => '/dashboard/alarms/$alertUuid';
}

class MapApi {
  MapApi._();

  static String summary(UserRole role, String crowId) {
    if (role == UserRole.leader) {
      return '/dashboard/leader/map/$crowId';
    }
    return '/dashboard/map/$crowId';
  }

  static String detail(UserRole role, String crowId) {
    if (role == UserRole.leader) {
      return '/dashboard/leader/map/detail/$crowId';
    }
    return '/dashboard/map/detail/$crowId';
  }
}

class CctvApi {
  CctvApi._();

  static const Map<UserRole, String> _workersByRole = {
    UserRole.user: '/dashboard/workers',
    UserRole.leader: '/dashboard/leader/workers',
  };

  static String workers(UserRole role) => _workersByRole[role] ?? _workersByRole[UserRole.user]!;
}

class FcmApi {
  FcmApi._();

  static const String register = '/fcm/register';
  static const String unregister = '/fcm/unregister';
  static const String send = '/fcm/send';
  static const String sendMulti = '/fcm/send-multi';
}

class FileApi {
  FileApi._();

  static const String upload = '/files';
  static const String update = '/files';
  static const String delete = '/files';
  static const String presign = '/files/presign';
}

class HealthApi {
  HealthApi._();

  static const String check = '/health';
}
