import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heoby_mobile/core/theme/theme.dart';
import 'package:heoby_mobile/features/cctv/presentation/widgets/working_summary.dart';
import 'package:heoby_mobile/features/heoby/presentation/widgets/heoby_table.dart';
import 'package:heoby_mobile/features/notification/presentation/widgets/notification_summary.dart';
import 'package:heoby_mobile/features/weather/presentation/widgets/weather_table.dart';
import 'package:heoby_mobile/shared/widgets/layout/base_layout.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseLayout(
      title: '허비',
      children: [
        AppSpacing.gapVerticalMd,
        Row(
          children: [
            Expanded(child: WorkingSummary()),
            const SizedBox(width: 12),
            Expanded(child: const NotificationSummary()),
          ],
        ),
        AppSpacing.gapVerticalLg,
        const WeatherTable(),
        AppSpacing.gapVerticalLg,
        const HeobyTable(),
        AppSpacing.gapVerticalMd,
      ],
    );
  }
}
