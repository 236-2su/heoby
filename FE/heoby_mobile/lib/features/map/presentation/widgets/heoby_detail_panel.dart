import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
// import 'package:heoby_mobile/core/services/geocoding_service.dart'; // TODO: Reverse Geocoding API 구독 후 활성화
import 'package:heoby_mobile/core/theme/theme.dart';
import 'package:heoby_mobile/features/heoby/domain/entities/heoby_entity.dart';
import 'package:heoby_mobile/features/map/presentation/widgets/heoby_battery_meter.dart';
import 'package:heoby_mobile/shared/widgets/box/base_box.dart';
import 'package:intl/intl.dart';

class HeobyDetailPanel extends StatefulWidget {
  const HeobyDetailPanel({super.key, required this.heoby});

  final HeobyEntity heoby;

  @override
  State<HeobyDetailPanel> createState() => _HeobyDetailPanelState();
}

class _HeobyDetailPanelState extends State<HeobyDetailPanel> {
  String? _address;
  bool _isLoadingAddress = false;

  @override
  void initState() {
    super.initState();
    _loadAddress();
  }

  Future<void> _loadAddress() async {
    setState(() {
      _isLoadingAddress = true;
    });

    String? fetchedAddress;

    try {
      final placemarks = await placemarkFromCoordinates(
        widget.heoby.location.lat,
        widget.heoby.location.lon,
        localeIdentifier: 'ko_KR',
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final addressParts = [
          place.administrativeArea,
          place.locality,
          place.subLocality,
          place.thoroughfare,
          place.subThoroughfare,
        ].whereType<String>().where((part) => part.isNotEmpty).join(' ');

        if (addressParts.isNotEmpty) {
          fetchedAddress = addressParts;
        } else {
          debugPrint(
            'placemarkFromCoordinates은 값을 반환했지만 주소 파트가 없음 (lat: ${widget.heoby.location.lat}, lon: ${widget.heoby.location.lon})',
          );
        }
      } else {
        debugPrint(
          '주소가 존재하지 않음 (lat: ${widget.heoby.location.lat}, lon: ${widget.heoby.location.lon})',
        );
      }
    } catch (error) {
      debugPrint('주소 변환 오류: $error');
      fetchedAddress = '주소 정보를 불러올 수 없습니다.';
    } finally {
      if (!mounted) return;
      setState(() {
        _address = fetchedAddress;
        _isLoadingAddress = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final parsedDate = _parseDate(widget.heoby.updatedAt);
    final relativeText = _relativeTime(parsedDate);
    final absoluteText = _formatAbsolute(parsedDate, widget.heoby.updatedAt);

    return BaseBox(
      title: '${widget.heoby.name} 상세 정보',
      padding: AppSpacing.paddingXl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: _InfoCard(
                  icon: Icons.person_outline_rounded,
                  label: '주인',
                  value: widget.heoby.ownerName,
                ),
              ),
              AppSpacing.gapHorizontalMd,
              Expanded(
                child: _InfoCard(
                  icon: Icons.home_outlined,
                  label: '위치',
                  value: _isLoadingAddress ? '주소를 불러오는 중...' : (_address ?? '주소 정보 없음'),
                ),
              ),
            ],
          ),
          AppSpacing.gapVerticalMd,
          Row(
            children: [
              Expanded(
                child: _InfoCard(
                  icon: Icons.refresh,
                  label: '업데이트',
                  value: '$relativeText · $absoluteText',
                ),
              ),
              AppSpacing.gapHorizontalMd,
              Expanded(
                child: _InfoCard(
                  icon: Icons.battery_charging_full_outlined,
                  label: '배터리',
                  child: HeobyBatteryMeter(label: '', percent: widget.heoby.battery ?? 0),
                ),
              ),
            ],
          ),
          AppSpacing.gapVerticalMd,
          Row(
            children: [
              Expanded(
                child: _InfoCard(
                  icon: Icons.thermostat_outlined,
                  label: '온도',
                  value: widget.heoby.temperature != null ? '${widget.heoby.temperature}°C' : '—',
                ),
              ),
              AppSpacing.gapHorizontalMd,
              Expanded(
                child: _InfoCard(
                  icon: Icons.water_drop_outlined,
                  label: '습도',
                  value: widget.heoby.humidity != null ? '${widget.heoby.humidity}%' : '—',
                ),
              ),
            ],
          ),
          AppSpacing.gapVerticalMd,
          Row(
            children: [
              Expanded(
                child: _InfoCard(
                  icon: Icons.location_on_outlined,
                  label: '위도',
                  value: widget.heoby.location.lat.toStringAsFixed(6),
                  action: IconButton(
                    icon: const Icon(Icons.copy, size: AppSpacing.iconSm),
                    color: AppColors.textMuted,
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: widget.heoby.location.lat.toStringAsFixed(6)));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('위도 값을 복사했어요')),
                      );
                    },
                  ),
                ),
              ),
              AppSpacing.gapHorizontalMd,
              Expanded(
                child: _InfoCard(
                  icon: Icons.location_on_outlined,
                  label: '경도',
                  value: widget.heoby.location.lon.toStringAsFixed(6),
                  action: IconButton(
                    icon: const Icon(Icons.copy, size: AppSpacing.iconSm),
                    color: AppColors.textMuted,
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: widget.heoby.location.lon.toStringAsFixed(6)));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('경도 값을 복사했어요')),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.gapVerticalMd,
          _InfoCardHorizontal(
            icon: Icons.badge_outlined,
            label: 'ID',
            value: widget.heoby.uuid,
          ),
        ],
      ),
    );
  }

  DateTime? _parseDate(String dateStr) {
    try {
      return DateTime.parse(dateStr).toLocal();
    } catch (_) {
      return null;
    }
  }

  String _relativeTime(DateTime? date) {
    if (date == null) return '알 수 없음';
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return '방금 전';
    if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    if (diff.inDays < 7) return '${diff.inDays}일 전';
    if (diff.inDays < 30) return '${diff.inDays ~/ 7}주 전';
    if (diff.inDays < 365) return '${diff.inDays ~/ 30}개월 전';
    return '${diff.inDays ~/ 365}년 전';
  }

  String _formatAbsolute(DateTime? date, String fallback) {
    if (date == null) return fallback;
    return DateFormat('yyyy.MM.dd HH:mm').format(date);
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.label,
    this.value,
    this.action,
    this.child,
  }) : assert(value != null || child != null, 'Either value or child must be provided');

  final IconData icon;
  final String label;
  final String? value;
  final Widget? action;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  size: AppSpacing.iconSm,
                  color: AppColors.textMuted,
                ),
              ),
              AppSpacing.gapHorizontalSm,
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              if (action != null) action!,
            ],
          ),
          AppSpacing.gapVerticalSm,
          if (value != null)
            Text(
              value!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.titleSmall.copyWith(
                fontWeight: AppTypography.fontWeightSemiBold,
                color: AppColors.textPrimary,
              ),
            ),
          if (child != null) child!,
        ],
      ),
    );
  }
}

class _InfoCardHorizontal extends StatelessWidget {
  const _InfoCardHorizontal({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(color: AppColors.borderLight),
        // boxShadow: [
        //   BoxShadow(
        //     color: AppColors.shadow.withOpacity(0.1),
        //     blurRadius: 12,
        //     offset: const Offset(0, 6),
        //   ),
        // ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Icon(
              icon,
              size: AppSpacing.iconSm,
              color: AppColors.textMuted,
            ),
          ),
          AppSpacing.gapHorizontalMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                AppSpacing.gapVerticalXs,
                Text(
                  value,
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: AppTypography.fontWeightBold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
