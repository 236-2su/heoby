import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heoby_mobile/core/constants/app_constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/cctv/presentation/pages/cctv_page.dart';
import '../../features/home/presentation/pages/dashboard_page.dart';
import '../../features/map/presentation/pages/map_page.dart';
import '../../features/notification/presentation/pages/notification_page.dart';
import '../../features/notification/presentation/pages/notification_detail_page.dart';
import '../../features/notification/domain/entities/notification_entity.dart';
import '../../features/auth/presentation/pages/profile_page.dart';
import '../../shared/widgets/layout/scaffold_with_nav_bar.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  // Auth 상태 변화 감지
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: AppConstants.dashboardPath.path,
    redirect: (context, state) {
      final isAuthenticated = authState.data.isAuthenticated;
      final isLoginPage = state.matchedLocation == AppConstants.loginPath.path;

      // 로그인하지 않았고 로그인 페이지가 아니면 → 로그인 페이지로 리다이렉트
      if (!isAuthenticated && !isLoginPage) {
        return AppConstants.loginPath.path;
      }

      // 로그인했는데 로그인 페이지에 있으면 → 홈으로 리다이렉트
      if (isAuthenticated && isLoginPage) {
        return AppConstants.dashboardPath.path;
      }

      // 그 외에는 리다이렉트 없음
      return null;
    },
    routes: [
      // 로그인 페이지 (인증 불필요)
      GoRoute(
        path: AppConstants.loginPath.path,
        name: AppConstants.loginPath.name,
        builder: (context, state) => const LoginPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          // 홈 탭
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppConstants.dashboardPath.path,
                name: AppConstants.dashboardPath.name,
                builder: (context, state) => const DashboardPage(),
              ),
            ],
          ),
          // 지도 탭
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppConstants.mapPath.path,
                name: AppConstants.mapPath.name,
                builder: (context, state) => const MapPage(),
              ),
            ],
          ),
          // CCTV 탭
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppConstants.cctvPath.path,
                name: AppConstants.cctvPath.name,
                builder: (context, state) => const CctvPage(),
              ),
            ],
          ),
          // 프로필 탭
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppConstants.profilePath.path,
                name: AppConstants.profilePath.name,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
      // 알림 페이지 (AppBar에서 접근)
      GoRoute(
        path: '/notification',
        name: 'notification',
        builder: (context, state) => const NotificationPage(),
        routes: [
          // 알림 상세 페이지
          GoRoute(
            path: 'detail',
            name: 'notificationDetail',
            builder: (context, state) {
              final alert = state.extra as NotificationAlertEntity;
              return NotificationDetailPage(alert: alert);
            },
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
  );
}
