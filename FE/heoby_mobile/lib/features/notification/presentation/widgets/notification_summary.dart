import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heoby_mobile/core/theme/theme.dart';
import 'package:heoby_mobile/features/notification/domain/entities/notification_entity.dart';
import 'package:heoby_mobile/features/notification/presentation/providers/notification_providers.dart';
import 'package:heoby_mobile/shared/widgets/box/base_box.dart';

class NotificationSummary extends ConsumerWidget {
  const NotificationSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationAsync = ref.watch(notificationListProvider);

    return notificationAsync.when(
      data: (notification) => _NotificationSummaryView(notification: notification),
      loading: () => const _NotificationSummarySkeleton(),
      error: (error, stack) => const _NotificationSummaryError(),
    );
  }
}

class _NotificationSummaryView extends StatelessWidget {
  const _NotificationSummaryView({required this.notification});

  final NotificationEntity notification;

  Widget _buildPriorityContent() {
    final summary = notification.summary;
    final latestAlert = notification.alerts.isNotEmpty ? notification.alerts.first : null;

    // 우선순위: 긴급 > 주의 > 알림 없음
    if (summary.criticalUnread > 0) {
      return NotificationSummaryChip(
        label: '긴급',
        count: summary.criticalUnread,
        accent: AlertAccent.red,
        latestAlert: latestAlert,
      );
    } else if (summary.warningUnread > 0) {
      return NotificationSummaryChip(
        label: '주의',
        count: summary.warningUnread,
        accent: AlertAccent.amber,
        latestAlert: latestAlert,
      );
    } else {
      return _NoAlertMessage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _ResponsiveCard(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: _buildPriorityContent(),
    );
  }
}

class _NoAlertMessage extends StatelessWidget {
  const _NoAlertMessage();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.successLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.successLight.withValues(alpha: 0.3)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 48,
              color: AppColors.success,
            ),
            const SizedBox(height: 12),
            Text(
              '알림이 없습니다',
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.success,
                fontWeight: AppTypography.fontWeightSemiBold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationSummaryChip extends StatelessWidget {
  const NotificationSummaryChip({
    super.key,
    required this.label,
    required this.count,
    required this.accent,
    this.latestAlert,
  });

  final String label;
  final int count;
  final AlertAccent accent;
  final NotificationAlertEntity? latestAlert;

  String _formatRelativeTime() {
    if (latestAlert == null) return '';
    try {
      final date = DateTime.parse(latestAlert!.occurredAt).toLocal();
      final diff = DateTime.now().difference(date);

      if (diff.inMinutes < 1) return '방금 전';
      if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
      if (diff.inHours < 24) return '${diff.inHours}시간 전';
      if (diff.inDays < 7) return '${diff.inDays}일 전';
      return '${diff.inDays ~/ 7}주 전';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = _alertPalette(accent);

    return Container(
      constraints: const BoxConstraints.expand(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 상단: 라벨 + 카운트
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: palette.bg,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: palette.border, width: 1),
                ),
                child: Text(
                  label,
                  style: AppTypography.labelMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: palette.text,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                count.toString(),
                style: AppTypography.displaySmall.copyWith(
                  fontWeight: FontWeight.w800,
                  color: palette.text,
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '건',
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: palette.text.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),

          // 하단: 허수아비 정보
          if (latestAlert != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      latestAlert!.heobyName,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatRelativeTime(),
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _NotificationSummarySkeleton extends StatelessWidget {
  const _NotificationSummarySkeleton();

  @override
  Widget build(BuildContext context) {
    return _ResponsiveCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 20,
            width: 120,
            decoration: BoxDecoration(
              color: AppColors.borderLight,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.borderLight.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationSummaryError extends StatelessWidget {
  const _NotificationSummaryError();

  @override
  Widget build(BuildContext context) {
    return _ResponsiveCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: AppColors.danger, size: 32),
          const SizedBox(height: 12),
          Text(
            '알림을 불러오지 못했어요',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _ResponsiveCard extends StatelessWidget {
  const _ResponsiveCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final baseBox = BaseBox(
      title: '최근 알림',
      padding: padding,
      child: child,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.hasBoundedHeight) {
          return SizedBox.expand(child: baseBox);
        }
        return AspectRatio(aspectRatio: 1, child: baseBox);
      },
    );
  }
}

enum AlertAccent { red, amber }

({Color bg, Color border, Color iconBg, Color badgeBg, Color text}) _alertPalette(AlertAccent accent) {
  switch (accent) {
    case AlertAccent.red:
      return (
        bg: const Color(0xFFFFF5F5),
        border: const Color(0xFFFECACA),
        iconBg: const Color(0xFFFFE4E6),
        badgeBg: const Color(0xFFFFE4E6),
        text: const Color(0xFF7F1D1D), // 더 어두운 빨강 (높은 대비)
      );
    case AlertAccent.amber:
      return (
        bg: const Color(0xFFFFFBEB),
        border: const Color(0xFFFDE68A),
        iconBg: const Color(0xFFFFF3C7),
        badgeBg: const Color(0xFFFFF3C7),
        text: const Color(0xFF78350F), // 더 어두운 갈색 (높은 대비)
      );
  }
}
