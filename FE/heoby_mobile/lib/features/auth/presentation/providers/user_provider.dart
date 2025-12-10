import 'dart:io';

import 'package:heoby_mobile/core/di/injection.dart';
import 'package:heoby_mobile/core/services/fcm_service.dart';
import 'package:heoby_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:heoby_mobile/features/auth/domain/usecases/get_user.dart';
import 'package:heoby_mobile/features/notification/domain/usecases/register_fcm_token.dart';
import 'package:heoby_mobile/shared/widgets/log/debug_log.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'auth_provider.dart';

part 'user_provider.g.dart';

@Riverpod(keepAlive: true)
class User extends _$User {
  GetUser get _getUserInfo => getIt<GetUser>();
  RegisterFcmToken get _registerFcmToken => getIt<RegisterFcmToken>();
  bool _isFetching = false;
  bool _isRegisteringFcm = false;

  @override
  UserEntity? build() {
    debugPrintLog('👤 [BUILD] UserProvider build 시작');

    // authProvider의 상태 변화 감시
    ref.listen(authProvider, (previous, next) {
      debugPrintLog('👤 [LISTEN] authProvider 변경 감지');
      debugPrintLog('👤 [LISTEN] prev token: ${previous?.data.accessToken?.substring(0, 10)}...');
      debugPrintLog('👤 [LISTEN] next token: ${next.data.accessToken?.substring(0, 10)}...');

      final prevToken = previous?.data.accessToken;
      final nextToken = next.data.accessToken;

      // 로그인 상태로 변경되면 사용자 정보 자동 로드
      if (nextToken != null && nextToken.isNotEmpty && prevToken != nextToken) {
        debugPrintLog('👤 [LISTEN] 사용자 정보 로드 시작');
        fetchUserInfo();
      }
      // 로그아웃 상태로 변경되면 사용자 정보 삭제
      else if ((nextToken == null || nextToken.isEmpty) && prevToken != nextToken) {
        debugPrintLog('👤 [LISTEN] 사용자 정보 삭제');
        clearUser();
      }
    });

    // 초기 빌드 시 이미 로그인되어 있으면 사용자 정보 로드
    final currentAuth = ref.read(authProvider);
    final currentToken = currentAuth.data.accessToken;
    if (currentToken != null && currentToken.isNotEmpty) {
      debugPrintLog('👤 [BUILD] 초기 로그인 상태 감지 - 사용자 정보 로드 예약');
      Future.microtask(() => fetchUserInfo());
    }

    debugPrintLog('👤 [BUILD] UserProvider build 완료');
    return null;
  }

  Future<void> fetchUserInfo() async {
    debugPrintLog('👤 [FETCH] fetchUserInfo 호출됨');
    // 이미 가져오는 중이면 중복 호출 방지
    if (_isFetching) {
      debugPrintLog('👤 [FETCH] 이미 가져오는 중 - 스킵');
      return;
    }

    _isFetching = true;
    debugPrintLog('👤 [FETCH] API 호출 시작');
    try {
      final user = await _getUserInfo();
      debugPrintLog('👤 [FETCH] API 호출 성공: ${user.username}');
      state = user;
      debugPrintLog('👤 [FETCH] state 업데이트 완료');

      // 사용자 정보 로드 성공 후 FCM 토큰 등록
      await _registerFcm();
    } catch (e) {
      // 오류 처리 - 사용자 정보를 가져오지 못해도 state를 null로 설정하지 않음
      // (이미 로그인은 성공했으므로)
      debugPrintLog('👤 [FETCH] 사용자 정보 로드 실패: $e');
    } finally {
      _isFetching = false;
      debugPrintLog('👤 [FETCH] fetchUserInfo 완료');
    }
  }

  Future<void> _registerFcm() async {
    if (_isRegisteringFcm) return;

    final fcmToken = FcmService.instance.fcmToken;
    final user = state;

    if (fcmToken == null || fcmToken.isEmpty) {
      debugPrintLog('👤 [FCM] FCM 토큰이 없습니다');
      return;
    }

    if (user == null) {
      debugPrintLog('👤 [FCM] 사용자 정보가 없습니다');
      return;
    }

    _isRegisteringFcm = true;
    debugPrintLog('👤 [FCM] FCM 토큰 등록 시작');
    try {
      // 플랫폼 정보 가져오기 (Android or iOS)
      final platform = Platform.isAndroid ? 'android' : 'ios';

      await _registerFcmToken(
        userUuid: user.userUuid,
        platform: platform,
        token: fcmToken,
      );
      debugPrintLog('👤 [FCM] FCM 토큰 등록 완료');
    } catch (e) {
      debugPrintLog('👤 [FCM] FCM 토큰 등록 실패: $e');
    } finally {
      _isRegisteringFcm = false;
    }
  }

  void clearUser() => state = null;

  /// 사용자 역할 확인 (helper)
  bool get isLeader => state?.role == UserRole.leader;
  bool get isUser => state?.role == UserRole.user;
}
