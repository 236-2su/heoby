import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heoby_mobile/core/constants/app_constants.dart';
import 'package:heoby_mobile/core/theme/theme.dart';
import 'package:heoby_mobile/features/notification/domain/entities/notification_entity.dart';
import 'package:heoby_mobile/features/notification/presentation/providers/notification_providers.dart';
import 'package:intl/intl.dart';

class NotificationListItem extends ConsumerWidget {
  const NotificationListItem({super.key, required this.alert});

  final NotificationAlertEntity alert;

  Color _getLevelColor() {
    final level = alert.level.toLowerCase();
    if (level == 'critical' || level == 'emergency') {
      return Colors.red;
    } else if (level == 'warning') {
      return Colors.orange;
    }
    return Colors.green;
  }

  Color _getLevelBackgroundColor() {
    final level = alert.level.toLowerCase();
    if (level == 'critical' || level == 'emergency') {
      return Colors.red.shade100;
    } else if (level == 'warning') {
      return Colors.orange.shade100;
    }
    return Colors.green.shade100;
  }

  String _getLevelText() {
    final level = alert.level.toLowerCase();
    if (level == 'critical' || level == 'emergency') {
      return '긴급';
    } else if (level == 'warning') {
      return '경고';
    }
    return '정보';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime parsedDate;

    try {
      parsedDate = DateTime.parse(alert.occurredAt);
    } catch (e) {
      parsedDate = DateTime.now();
    }

    final indicatorColor = alert.isRead ? Colors.grey.shade300 : const Color(0xFFEDB4B4);
    final cardBorder = alert.isRead ? AppColors.borderLight : AppColors.info.withOpacity(0.2);
    final formattedDate = DateFormat(
      'yyyy. MM. dd. a hh:mm:ss',
      'ko',
    ).format(parsedDate);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () async {
        // 읽지 않은 알림인 경우에만 읽음 처리
        if (!alert.isRead) {
          final actions = ref.read(notificationActionsProvider);
          await actions.markAsRead(alert.alertUuid);
        }

        if (context.mounted) {
          context.push(AppConstants.notificationDetailPath.path, extra: alert);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: cardBorder),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: indicatorColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.mail, size: 20, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        alert.heobyName,
                        style: AppTypography.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    alert.message,
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: !alert.isRead ? FontWeight.w700 : FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.black54,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        formattedDate,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
