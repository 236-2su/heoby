import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heoby_mobile/core/theme/theme.dart';
import 'package:heoby_mobile/features/notification/domain/entities/notification_entity.dart';
import 'package:heoby_mobile/features/notification/presentation/providers/notification_providers.dart';
import 'package:heoby_mobile/features/notification/presentation/widgets/notification_list_item.dart';
import 'package:heoby_mobile/shared/widgets/layout/notification_layout.dart';

enum FilterType { all, emergency, warning, unread }

/// 알림 페이지
class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({super.key});

  @override
  ConsumerState<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage> {
  FilterType filter = FilterType.all;

  List<NotificationAlertEntity> _getFilteredAlerts(
    List<NotificationAlertEntity> alerts,
  ) {
    return alerts.where((alert) {
      switch (filter) {
        case FilterType.all:
          return true;
        case FilterType.emergency:
          return alert.level.toLowerCase() == 'critical' || alert.level.toLowerCase() == 'emergency';
        case FilterType.warning:
          return alert.level.toLowerCase() == 'warning';
        case FilterType.unread:
          return !alert.isRead;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final notificationAsync = ref.watch(notificationListProvider);

    return NotificationLayout(
      title: '알림',
      hideNotificationIcon: true,
      children: [
        AppSpacing.gapVerticalMd,
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppSpacing.borderRadiusLg,
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _FilterToolbar(
                  current: filter,
                  onChanged: (next) => setState(() => filter = next),
                ),
                Expanded(
                  child: notificationAsync.when(
                    data: (notification) => _NotificationListView(
                      alerts: _getFilteredAlerts(notification.alerts),
                    ),
                    loading: () => const _LoadingState(),
                    error: (error, stack) => _ErrorState(
                      onRetry: () => ref.invalidate(notificationListProvider),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterToolbar extends StatelessWidget {
  const _FilterToolbar({required this.current, required this.onChanged});

  final FilterType current;
  final ValueChanged<FilterType> onChanged;

  @override
  Widget build(BuildContext context) {
    final entries = [
      (label: '전체', type: FilterType.all, color: AppColors.info),
      (label: '긴급', type: FilterType.emergency, color: AppColors.danger),
      (label: '주의', type: FilterType.warning, color: AppColors.warning),
      (label: '읽지 않음', type: FilterType.unread, color: AppColors.info),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          for (final entry in entries)
            _FilterChip(
              label: entry.label,
              color: entry.color,
              isSelected: current == entry.type,
              onTap: () => onChanged(entry.type),
            ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: AppSpacing.borderRadiusFull,
          color: isSelected ? color : Colors.white,
          border: Border.all(color: isSelected ? color : AppColors.borderLight),
        ),
        child: Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: isSelected ? Colors.white : color,
            fontWeight: AppTypography.fontWeightSemiBold,
          ),
        ),
      ),
    );
  }
}

class _NotificationListView extends StatelessWidget {
  const _NotificationListView({required this.alerts});

  final List<NotificationAlertEntity> alerts;

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) {
      return const _EmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
      itemCount: alerts.length,
      itemBuilder: (context, index) => NotificationListItem(alert: alerts[index]),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.mail_outline,
            size: AppSpacing.iconXl2,
            color: AppColors.border,
          ),
          AppSpacing.gapVerticalLg,
          Text(
            '알림이 없습니다',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: AppSpacing.iconXl2,
            color: AppColors.dangerLight,
          ),
          AppSpacing.gapVerticalLg,
          Text(
            '알림을 불러오는데 실패했습니다',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          AppSpacing.gapVerticalSm,
          TextButton(
            onPressed: onRetry,
            child: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }
}
