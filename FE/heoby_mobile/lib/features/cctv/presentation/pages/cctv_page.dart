import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heoby_mobile/core/theme/theme.dart';
import 'package:heoby_mobile/features/cctv/presentation/providers/cctv_tab_provider.dart';
import 'package:heoby_mobile/features/cctv/presentation/providers/webrtc_provider.dart';
import 'package:heoby_mobile/features/cctv/presentation/widgets/cctv_list.dart';
import 'package:heoby_mobile/features/cctv/presentation/widgets/cctv_video_section.dart';
import 'package:heoby_mobile/features/heoby/domain/entities/heoby_entity.dart';
import 'package:heoby_mobile/features/heoby/presentation/providers/heoby_providers.dart';
import 'package:heoby_mobile/shared/widgets/box/base_box.dart';
import 'package:heoby_mobile/shared/widgets/box/stats_bar.dart';
import 'package:heoby_mobile/shared/widgets/layout/base_layout.dart';

class CctvPage extends ConsumerStatefulWidget {
  const CctvPage({super.key});

  @override
  ConsumerState<CctvPage> createState() => _CctvPageState();
}

class _CctvPageState extends ConsumerState<CctvPage> {
  bool _isTabActive = false;
  String? _currentSerial;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _onTabActiveChanged(ref.read(cctvTabActiveProvider));
    });
  }

  @override
  void dispose() {
    ref.read(webrtcConnectionProvider.notifier).disconnectCctv();
    super.dispose();
  }

  void _onTabActiveChanged(bool active) {
    if (_isTabActive == active) return;
    _isTabActive = active;
    if (!active) {
      _handleSerialChange(null);
    } else {
      final serial = ref.read(selectedHeobyProvider)?.serialNumber;
      _handleSerialChange(serial);
    }
  }

  void _onSelectedHeobyChanged(HeobyEntity? heoby) {
    if (!_isTabActive) return;
    final serial = heoby?.serialNumber;
    _handleSerialChange(serial);
  }

  void _onSelectHeoby(String heobyId) {
    ref.read(selectedHeobyProvider.notifier).select(heobyId);
  }

  Future<void> _handleSerialChange(String? serial) async {
    if (!mounted) return;
    final connectionNotifier = ref.read(webrtcConnectionProvider.notifier);

    if (serial == null) {
      if (_currentSerial == null) {
        await connectionNotifier.disconnectCctv();
        return;
      }
      _currentSerial = null;
      ref.read(connectedCctvProvider.notifier).setCctv(null);
      await connectionNotifier.disconnectCctv();
      return;
    }

    if (!_isTabActive) return;
    if (_currentSerial == serial) return;

    _currentSerial = serial;
    ref.read(connectedCctvProvider.notifier).setCctv(serial);

    try {
      await connectionNotifier.connectToCctv(serial);
      debugPrint('CCTV 연결 성공: $serial');
    } catch (e) {
      debugPrint('CCTV 스트림 전환 실패 ($serial): $e');
      debugPrint('기본 스트림(cctv)으로 연결 시도...');

      try {
        await connectionNotifier.connectToCctv('cctv');
      } catch (fallbackErr) {
        debugPrint('기본 스트림 연결도 실패: $fallbackErr');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<bool>(cctvTabActiveProvider, (previous, next) {
      if (previous == next) return;
      Future.microtask(() => _onTabActiveChanged(next));
    });

    ref.listen<HeobyEntity?>(selectedHeobyProvider, (previous, next) {
      if (previous?.serialNumber == next?.serialNumber) return;
      Future.microtask(() => _onSelectedHeobyChanged(next));
    });

    final heobyListAsync = ref.watch(heobyListProvider);
    final selectedHeoby = ref.watch(selectedHeobyProvider);
    final connectionStatus = ref.watch(webrtcConnectionProvider);
    final connectedSerial = ref.watch(connectedCctvProvider);
    final streamAsync = connectedSerial != null ? ref.watch(cctvStreamProvider(connectedSerial)) : null;

    return heobyListAsync.when(
      data: (heobys) {
        if (heobys.isEmpty) {
          return BaseLayout(
            title: 'CCTV',
            children: [
              BaseBox(
                title: 'CCTV 상태',
                padding: AppSpacing.paddingXl,
                child: const Center(child: Text('등록된 허수아비가 없습니다')),
              ),
            ],
          );
        }

        return BaseLayout(
          title: 'CCTV',
          children: [
            // StatsBar(items: statsItems),
            // AppSpacing.gapVerticalLg,
            CctvVideoSection(
              selectedHeoby: selectedHeoby,
              status: connectionStatus,
              streamAsync: streamAsync,
              serial: connectedSerial,
            ),
            AppSpacing.gapVerticalLg,
            CctvList(
              heobys: heobys,
              selectedHeoby: selectedHeoby,
              onSelectHeoby: _onSelectHeoby,
            ),
          ],
        );
      },
      loading: () => BaseLayout(
        title: 'CCTV',
        children: const [
          Center(child: CircularProgressIndicator()),
        ],
      ),
      error: (err, stack) => BaseLayout(
        title: 'CCTV',
        children: [
          BaseBox(
            title: '오류',
            padding: AppSpacing.paddingXl,
            child: Center(child: Text('오류가 발생했습니다: $err')),
          ),
        ],
      ),
    );
  }

  List<StatItem> _buildStats(List<HeobyEntity> heobys) {
    final onlineCount = heobys.where((heoby) => _isOnlineStatus(heoby.status)).length;
    final offlineCount = heobys.length - onlineCount;

    return [
      StatItem(icon: Icons.videocam, label: '온라인', value: onlineCount, color: StatColor.green),
      StatItem(icon: Icons.videocam_off, label: '오프라인', value: offlineCount, color: StatColor.red),
    ];
  }

  bool _isOnlineStatus(String status) {
    final normalized = status.toLowerCase();
    return normalized.contains('online') ||
        normalized.contains('working') ||
        normalized.contains('active') ||
        normalized.contains('운영') ||
        normalized.contains('작동');
  }
}
