/// 앱 전체 상수 정의
/// API 엔드포인트는 swagger_endpoints.dart 참고
class AppConstants {
  AppConstants._();

  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';

  // App Info
  static const String appName = 'Heoby Mobile';
  static const String appVersion = '1.0.0';

  // Routes
  static const AppPath splashPath = AppPath(path: '/splash', name: 'splash');
  static const AppPath loginPath = AppPath(path: '/login', name: 'login');
  static const AppPath dashboardPath = AppPath(path: '/', name: 'home');
  static const AppPath mapPath = AppPath(path: '/map', name: 'map');
  static const AppPath cctvPath = AppPath(path: '/cctv', name: 'cctv');
  static const AppPath profilePath = AppPath(path: '/profile', name: 'profile');
  static const AppPath notificationPath = AppPath(path: '/notification', name: 'notification');
  static const AppPath notificationDetailPath = AppPath(path: '/notification/detail', name: 'notificationDetail');
}

class AppPath {
  final String path;
  final String name;

  const AppPath({required this.path, required this.name});
}
