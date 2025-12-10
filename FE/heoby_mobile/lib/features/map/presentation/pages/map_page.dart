import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heoby_mobile/core/theme/theme.dart';
import 'package:heoby_mobile/features/heoby/presentation/providers/heoby_providers.dart';
import 'package:heoby_mobile/features/heoby/presentation/widgets/heoby_table.dart';
import 'package:heoby_mobile/features/map/presentation/widgets/heoby_detail_panel.dart';
import 'package:heoby_mobile/shared/widgets/layout/base_layout.dart';

/// 지도 페이지 (허수아비 위치 표시)
class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  NaverMapController? _mapController;
  bool _markersInitialized = false;

  // 모든 마커 추가
  void _addAllMarkers(List heobyList, String? selectedId) async {
    if (_mapController == null) return;

    for (var heoby in heobyList) {
      final isSelected = heoby.uuid == selectedId;
      final marker = NMarker(
        id: heoby.uuid,
        position: NLatLng(heoby.location.lat, heoby.location.lon),
        caption: NOverlayCaption(
          text: heoby.name,
          textSize: isSelected ? 14 : 12,
        ),
        // 선택된 허비는 다른 아이콘과 크기
        icon: isSelected
            ? const NOverlayImage.fromAssetImage('assets/icons/selected_heoby.png')
            : const NOverlayImage.fromAssetImage('assets/icons/heoby.png'),
        size: isSelected ? const Size(50, 50) : const Size(40, 40),
      );

      // 마커를 지도에 추가만 함 (클릭 이벤트는 테이블에서 처리)
      _mapController?.addOverlay(marker);
    }
  }

  // 마커 업데이트 (선택 상태 변경 시)
  void _updateMarkers(List heobyList, String? selectedId) {
    if (_mapController == null) return;

    for (var heoby in heobyList) {
      _mapController?.deleteOverlay(NOverlayInfo(type: NOverlayType.marker, id: heoby.uuid));
    }
    _addAllMarkers(heobyList, selectedId);
  }

  @override
  Widget build(BuildContext context) {
    final heobyListAsync = ref.watch(heobyListProvider);
    final selectedHeoby = ref.watch(selectedHeobyProvider);

    // selectedHeoby 변경 감지하여 마커 업데이트 및 지도 이동
    ref.listen(selectedHeobyProvider, (previous, next) {
      if (next != null && _mapController != null) {
        final newLocation = NLatLng(next.location.lat, next.location.lon);

        // 마커 업데이트
        heobyListAsync.whenData((heobyList) {
          _updateMarkers(heobyList, next.uuid);
        });

        // 카메라 이동
        _mapController?.updateCamera(
          NCameraUpdate.scrollAndZoomTo(target: newLocation, zoom: 15),
        );
      }
    });

    return heobyListAsync.when(
      data: (heobyList) {
        if (heobyList.isEmpty) {
          return BaseLayout(
            title: '지도',
            children: [
              Container(
                padding: const EdgeInsets.all(40),
                child: const Center(child: Text('등록된 허수아비가 없습니다')),
              ),
            ],
          );
        }

        // 첫 번째 허비 또는 선택된 허비의 위치로 초기 지도 위치 설정
        final initialHeoby = selectedHeoby ?? heobyList.first;
        final initialLocation = NLatLng(initialHeoby.location.lat, initialHeoby.location.lon);

        return BaseLayout(
          title: '지도',
          children: [
            // 지도 섹션
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color.fromRGBO(15, 23, 42, 0.3)),
                // boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(19),
                child: Stack(
                  children: [
                    // 네이버 맵
                    NaverMap(
                      options: NaverMapViewOptions(
                        initialCameraPosition: NCameraPosition(target: initialLocation, zoom: 13),
                      ),
                      onMapReady: (controller) {
                        _mapController = controller;
                        if (!_markersInitialized) {
                          _addAllMarkers(heobyList, selectedHeoby?.uuid);
                          _markersInitialized = true;
                        }
                      },
                      onMapTapped: (point, latLng) {
                        // 지도 배경 클릭 시 (마커가 아닌 경우)
                      },
                      onSymbolTapped: (symbol) {
                        // 심볼 클릭 시
                      },
                    ),
                  ],
                ),
              ),
            ),
            AppSpacing.gapVerticalLg,
            // 허수아비 목록
            HeobyTable(),
            AppSpacing.gapVerticalLg,
            // 허수아비 상세 정보 (선택된 허비가 있을 때만 표시)
            if (selectedHeoby != null) HeobyDetailPanel(heoby: selectedHeoby),
          ],
        );
      },
      loading: () => BaseLayout(
        title: '지도',
        children: [
          Container(
            padding: const EdgeInsets.all(40),
            child: const Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
      error: (error, stack) => BaseLayout(
        title: '지도',
        children: [
          Container(
            padding: const EdgeInsets.all(40),
            child: Center(child: Text('오류: $error')),
          ),
        ],
      ),
    );
  }
}
