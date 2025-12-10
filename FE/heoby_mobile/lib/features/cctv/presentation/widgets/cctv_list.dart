import 'package:flutter/material.dart';
import 'package:heoby_mobile/core/theme/theme.dart';
import 'package:heoby_mobile/features/heoby/domain/entities/heoby_entity.dart';
import 'package:heoby_mobile/shared/widgets/box/base_box.dart';

class CctvList extends StatelessWidget {
  final List<HeobyEntity> heobys;
  final HeobyEntity? selectedHeoby;
  final Function(String) onSelectHeoby;

  const CctvList({
    super.key,
    required this.heobys,
    required this.selectedHeoby,
    required this.onSelectHeoby,
  });

  bool _isOnlineStatus(String status) {
    final normalized = status.toLowerCase();
    return normalized.contains('online') ||
        normalized.contains('working') ||
        normalized.contains('active') ||
        normalized.contains('운영') ||
        normalized.contains('작동');
  }

  String _formatCoordinates(HeobyEntity heoby) {
    final lat = heoby.location.lat.toStringAsFixed(4);
    final lon = heoby.location.lon.toStringAsFixed(4);
    return '$lat, $lon';
  }

  String _relativeTime(String dateStr) {
    try {
      final parsed = DateTime.parse(dateStr).toLocal();
      final diff = DateTime.now().difference(parsed);

      if (diff.inMinutes < 1) return '방금 전';
      if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
      if (diff.inHours < 24) return '${diff.inHours}시간 전';
      if (diff.inDays < 7) return '${diff.inDays}일 전';
      if (diff.inDays < 30) return '${diff.inDays ~/ 7}주 전';
      if (diff.inDays < 365) return '${diff.inDays ~/ 30}개월 전';
      return '${diff.inDays ~/ 365}년 전';
    } catch (_) {
      return '알 수 없음';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseBox(
      title: 'CCTV 목록',
      padding: AppSpacing.paddingLg,
      child: Column(
        children: [
          for (int index = 0; index < heobys.length; index++) ...[
            _buildCctvItem(heobys[index]),
            if (index < heobys.length - 1) AppSpacing.gapVerticalMd,
          ],
        ],
      ),
    );
  }

  Widget _buildCctvItem(HeobyEntity heoby) {
    final isSelected = selectedHeoby?.uuid == heoby.uuid;
    final hasSerial = heoby.serialNumber != null;

    return Opacity(
      opacity: hasSerial ? 1 : 0.6,
      child: InkWell(
        onTap: hasSerial ? () => onSelectHeoby(heoby.uuid) : null,
        child: Container(
          padding: AppSpacing.paddingMd,
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? AppColors.info : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: AppSpacing.borderRadiusMd,
            color: isSelected ? AppColors.info.withValues(alpha: 0.05) : Colors.transparent,
          ),
          child: _CctvListTile(
            heoby: heoby,
            hasSerial: hasSerial,
            isOnline: _isOnlineStatus(heoby.status),
            coordinates: _formatCoordinates(heoby),
            relativeTime: _relativeTime(heoby.updatedAt),
          ),
        ),
      ),
    );
  }
}

class _CctvListTile extends StatelessWidget {
  final HeobyEntity heoby;
  final bool hasSerial;
  final bool isOnline;
  final String coordinates;
  final String relativeTime;

  const _CctvListTile({
    required this.heoby,
    required this.hasSerial,
    required this.isOnline,
    required this.coordinates,
    required this.relativeTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    heoby.name,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: AppTypography.fontWeightSemiBold,
                    ),
                  ),
                  AppSpacing.gapVerticalXs,
                  Text(
                    hasSerial ? 'SN ${heoby.serialNumber}' : '시리얼 번호 없음',
                    style: AppTypography.bodySmall.copyWith(
                      color: hasSerial ? AppColors.textSecondary : AppColors.dangerDark,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
              decoration: BoxDecoration(
                color: isOnline ? AppColors.successLight.withOpacity(0.2) : AppColors.dangerLight.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Text(
                heoby.status,
                style: AppTypography.caption.copyWith(
                  color: isOnline ? AppColors.successDark : AppColors.dangerDark,
                ),
              ),
            ),
          ],
        ),
        AppSpacing.gapVerticalSm,
        Text(
          '소유자 ${heoby.ownerName}',
          style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
        ),
        AppSpacing.gapVerticalXs,
        Text(
          '위치 $coordinates',
          style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
        ),
        AppSpacing.gapVerticalXs,
        Text(
          '업데이트 $relativeTime',
          style: AppTypography.caption.copyWith(color: AppColors.textMuted),
        ),
      ],
    );
  }
}
