import 'package:flutter/material.dart';
import 'package:heoby_mobile/core/theme/theme.dart';

enum StatColor { red, yellow, green, blue, gray }

class StatItem {
  final IconData icon;
  final String label;
  final int value;
  final StatColor color;

  const StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
}

class StatsBar extends StatelessWidget {
  const StatsBar({super.key, required this.items});

  final List<StatItem> items;

  Color _getIconBgColor(StatColor color) {
    switch (color) {
      case StatColor.red:
        return AppColors.dangerLight.withValues(alpha: 0.2);
      case StatColor.yellow:
        return AppColors.warningLight.withValues(alpha: 0.2);
      case StatColor.green:
        return AppColors.successLight.withValues(alpha: 0.2);
      case StatColor.blue:
        return AppColors.infoLight.withValues(alpha: 0.2);
      case StatColor.gray:
        return AppColors.backgroundAlt;
    }
  }

  Color _getIconColor(StatColor color) {
    switch (color) {
      case StatColor.red:
        return AppColors.danger;
      case StatColor.yellow:
        return AppColors.warning;
      case StatColor.green:
        return AppColors.success;
      case StatColor.blue:
        return AppColors.info;
      case StatColor.gray:
        return AppColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(color: Color.fromRGBO(15, 23, 42, 0.3)),
        // boxShadow: [
        //   BoxShadow(
        //     color: AppColors.shadow,
        //     blurRadius: 4,
        //     offset: const Offset(0, 2),
        //   ),
        // ],
      ),
      padding: AppSpacing.paddingMd,
      child: Row(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;

          return Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: index < items.length - 1 ? BorderSide(color: AppColors.borderLight) : BorderSide.none,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                children: [
                  Container(
                    padding: AppSpacing.paddingSm,
                    decoration: BoxDecoration(
                      color: _getIconBgColor(item.color),
                      borderRadius: AppSpacing.borderRadiusMd,
                    ),
                    child: Icon(
                      item.icon,
                      size: AppSpacing.iconMd,
                      color: _getIconColor(item.color),
                    ),
                  ),
                  AppSpacing.gapHorizontalMd,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.label,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      AppSpacing.gapVerticalXs,
                      Text(
                        '${item.value}',
                        style: AppTypography.headlineMedium.copyWith(
                          fontWeight: AppTypography.fontWeightBold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
