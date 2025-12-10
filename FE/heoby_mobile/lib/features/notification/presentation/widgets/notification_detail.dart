import 'package:flutter/material.dart';
import 'package:heoby_mobile/core/theme/theme.dart';
import 'package:heoby_mobile/features/notification/domain/entities/notification_entity.dart';
import 'package:intl/intl.dart';

class NotificationDetail extends StatelessWidget {
  const NotificationDetail({super.key, required this.alert});

  final NotificationAlertEntity alert;

  Color _getLevelColor() {
    final level = alert.level.toUpperCase();
    if (level == 'CRITICAL') {
      return Colors.red;
    } else if (level == 'WARNING') {
      return Colors.orange;
    } else if (level == 'INFO') {
      return Colors.green;
    }
    return Colors.blue;
  }

  Color _getLevelBackgroundColor() {
    final level = alert.level.toUpperCase();
    if (level == 'CRITICAL') {
      return Colors.red.shade100;
    } else if (level == 'WARNING') {
      return Colors.orange.shade100;
    } else if (level == 'INFO') {
      return Colors.green.shade100;
    }
    return Colors.blue.shade100;
  }

  String _getLevelText() {
    final level = alert.level.toUpperCase();
    if (level == 'CRITICAL') {
      return '긴급';
    } else if (level == 'WARNING') {
      return '경고';
    } else if (level == 'INFO') {
      return '정보';
    }
    return '알림';
  }

  String _getTypeText() {
    final type = alert.type.toUpperCase();
    switch (type) {
      case 'INTRUDER':
        return '침입자 감지';
      case 'BOAR':
        return '멧돼지 감지';
      case 'ROE_DEER':
        return '고라니 감지';
      case 'MAGPIE':
        return '까치 감지';
      case 'BEAR':
        return '곰 감지';
      case 'OTHER':
        return '기타 동물 감지';
      case 'HEAT_STRESS':
        return '온열 스트레스';
      case 'FALL_DETECTED':
        return '낙상 감지';
      case 'NO_MOVEMENT':
        return '무활동 감지';
      default:
        return alert.type;
    }
  }

  String _getTypeIcon() {
    final type = alert.type.toUpperCase();
    switch (type) {
      case 'INTRUDER':
        return '👤';
      case 'BOAR':
        return '🐗';
      case 'ROE_DEER':
        return '🦌';
      case 'MAGPIE':
        return '🐦';
      case 'BEAR':
        return '🐻';
      case 'OTHER':
        return '🐾';
      case 'HEAT_STRESS':
        return '🌡️';
      case 'FALL_DETECTED':
        return '🚨';
      case 'NO_MOVEMENT':
        return '⏸️';
      default:
        return '🔔';
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime parsedDate;

    try {
      parsedDate = DateTime.parse(alert.occurredAt);
    } catch (e) {
      parsedDate = DateTime.now();
    }
    final formattedDate = DateFormat(
      'yyyy. MM. dd. a hh:mm:ss',
      'ko',
    ).format(parsedDate);

    final ReadIcon = alert.isRead ? Icons.mark_email_read : Icons.mark_email_unread;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              // decoration: BoxDecoration(
              //   // shape: BoxShape.circle,
              //   // color: _getLevelBackgroundColor(),
              // ),
              child: Text(
                _getTypeIcon(),
                style: const TextStyle(fontSize: 32),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getLevelBackgroundColor(),
                          borderRadius: AppSpacing.borderRadiusFull,
                          border: Border.all(
                            color: _getLevelColor().withOpacity(0.4),
                          ),
                        ),
                        child: Text(
                          _getLevelText(),
                          style: AppTypography.labelMedium.copyWith(
                            fontWeight: AppTypography.fontWeightExtraBold,
                            color: _getLevelColor().withOpacity(0.9),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                  AppSpacing.gapVerticalSm,
                  Text(
                    _getTypeText(),
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: AppTypography.fontWeightSemiBold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceAlt,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: AppSpacing.iconMd,
                    color: AppColors.textSecondary,
                  ),
                  AppSpacing.gapHorizontalSm,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '허수아비 이름',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                      Text(
                        alert.heobyName,
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.map,
                    size: AppSpacing.iconMd,
                    color: AppColors.textSecondary,
                  ),
                  AppSpacing.gapHorizontalSm,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '위치 좌표',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                      Text(
                        '${alert.location.lat}, ${alert.location.lon}',
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Text(
              formattedDate,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          '알림 내용',
          style: AppTypography.headlineMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: AppTypography.fontWeightBold,
          ),
        ),
        AppSpacing.gapVerticalSm,
        Text(
          alert.message,
          style: AppTypography.bodyLarge.copyWith(
            height: AppTypography.lineHeightRelaxed,
            color: AppColors.textPrimary,
            fontSize: 16,
          ),
        ),
        if (alert.snapshotUrl.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text(
            '첨부 이미지',
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: AppTypography.fontWeightBold,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              alert.snapshotUrl,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.broken_image,
                          size: 48,
                          color: AppColors.textMuted,
                        ),
                        AppSpacing.gapVerticalSm,
                        Text(
                          '이미지를 불러올 수 없습니다',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
