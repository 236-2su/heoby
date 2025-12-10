import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:heoby_mobile/core/di/injection.dart';
import 'package:heoby_mobile/features/auth/domain/entities/user_entity.dart';
import 'package:heoby_mobile/features/auth/presentation/providers/user_provider.dart';
import 'package:heoby_mobile/features/cctv/domain/entities/workers_entity.dart';
import 'package:heoby_mobile/features/cctv/domain/usecases/get_workers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cctv_provider.freezed.dart';
part 'cctv_provider.g.dart';

/// CCTV State (Presentation Layer)
@freezed
class CctvState with _$CctvState {
  const factory CctvState({
    WorkersEntity? data,
    @Default(false) bool isLoading,
    String? error,
  }) = _CctvState;
}

@Riverpod(keepAlive: true)
class Cctv extends _$Cctv {
  GetWorkers get _getWorkers => getIt<GetWorkers>();

  @override
  CctvState build() {
    // Provider가 처음 생성될 때 자동 실행 (build 완료 후)
    Future.microtask(() => getWorkers());
    return const CctvState();
  }

  /// 작업자 수 조회
  Future<void> getWorkers() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = ref.watch(userProvider);
      final role = user?.role ?? UserRole.user;
      final workers = await _getWorkers(role);
      state = state.copyWith(
        data: workers,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}
