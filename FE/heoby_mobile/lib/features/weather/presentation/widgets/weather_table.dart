import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heoby_mobile/features/weather/presentation/providers/weather_providers.dart';
import 'package:heoby_mobile/shared/widgets/box/table_box.dart';
import 'package:heoby_mobile/shared/widgets/table/table_column.dart';
import 'package:heoby_mobile/shared/widgets/table/table_row_layout.dart';
import 'package:heoby_mobile/shared/widgets/table/table_states.dart';

class WeatherTable extends ConsumerWidget {
  const WeatherTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(todayForecastProvider);

    return asyncData.when(
      data: (weather) {
        if (weather.forecasts.isEmpty) {
          return TableBox(
            title: '날씨 예보',
            child: const TablePlaceholder(message: '예보 데이터가 없어요'),
          );
        }

        final items = [
          for (var i in [0, 2, 4, 6, 8, 10])
            if (i < weather.forecasts.length) weather.forecasts[i],
        ];

        final columns = items
            .map(
              (e) => TableColumnConfig(
                label: '${int.parse(e.time.substring(11, 13))}시',
              ),
            )
            .toList();

        return TableBox(
          title: '날씨 예보',
          columns: columns,
          bodyPadding: EdgeInsets.zero,
          child: WeatherSummary(items: items, columns: columns),
        );
      },
      loading: () => TableBox(
        title: '날씨 예보',
        columns: List.generate(6, (_) => const TableColumnConfig(label: '')),
        bodyPadding: EdgeInsets.zero,
        child: const TableLoadingState(),
      ),
      error: (err, stack) => TableBox(
        title: '날씨 예보',
        child: const TablePlaceholder(message: '불러오기 실패'),
      ),
    );
  }
}

class WeatherSummary extends StatelessWidget {
  final List<dynamic> items;
  final List<TableColumnConfig> columns;

  const WeatherSummary({super.key, required this.items, required this.columns});

  String _getConditionIconPath(String condition) {
    switch (condition.toUpperCase()) {
      case 'SUNNY':
        return 'assets/icons/sun.svg';
      case 'OVERCAST':
        return 'assets/icons/cloudy-forecast.svg';
      case 'RAINY':
        return 'assets/icons/rainy.svg';
      case 'SNOWY':
        return 'assets/icons/snowy.svg';
      default:
        return 'assets/icons/sun.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return TableRowLayout(
      columns: columns,
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 20),
      cells: [
        for (int i = 0; i < items.length; i++)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                _getConditionIconPath(items[i].condition ?? 'SUNNY'),
                width: 40,
                height: 40,
              ),
              const SizedBox(height: 8),
              Text(
                '${items[i].temperature.toStringAsFixed(0)}℃',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
