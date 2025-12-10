import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heoby_mobile/core/di/injection.dart';
import 'package:heoby_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:heoby_mobile/features/auth/presentation/providers/user_provider.dart';
import 'package:heoby_mobile/features/heoby/domain/entities/heoby_entity.dart';
import 'package:heoby_mobile/features/heoby/domain/usecases/get_heoby_list.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'heoby_providers.g.dart';

/// 전체 허수아비 목록 Provider
/// 내 허수아비가 먼저, 마을 허수아비가 나중에 표시됨
@riverpod
Future<List<HeobyEntity>> heobyList(Ref ref) async {
  final user = ref.read(userProvider);
  final role = user?.role ?? UserRole.user;
  final usecase = getIt<GetHeobyList>();
  return usecase(role);
}

/// 선택된 허수아비 ID Provider
/// 날씨, 지도 등에서 선택된 허수아비의 정보를 보여줄 때 사용
@riverpod
class SelectedHeoby extends _$SelectedHeoby {
  @override
  HeobyEntity? build() {
    // 초기값: 허수아비 목록이 로드되면 첫 번째 허수아비 자동 선택
    ref.listen(heobyListProvider, (previous, next) {
      next.whenData((list) {
        if (list.isNotEmpty && state == null) {
          state = list.first;
        }
      });
    });
    return null;
  }

  /// 허수아비 선택
  void select(String crowId) {
    final heobyList = ref.read(heobyListProvider).valueOrNull;
    if (heobyList == null) return;

    final found = heobyList.firstWhere(
      (heoby) => heoby.uuid == crowId,
      orElse: () => state ?? heobyList.first,
    );

    state = found;
  }

  /// 선택 해제
  void clear() {
    state = null;
  }
}

/// 선택된 허수아비의 시리얼 넘버 Provider
final selectedHeobySerialProvider = Provider<String?>((ref) {
  final selected = ref.watch(selectedHeobyProvider);
  return selected?.serialNumber;
});
