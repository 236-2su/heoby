import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heoby_mobile/features/heoby/presentation/providers/heoby_providers.dart';
import 'package:heoby_mobile/shared/widgets/box/table_box.dart';
import 'package:heoby_mobile/shared/widgets/table/table_column.dart';
import 'package:heoby_mobile/shared/widgets/table/table_row_layout.dart';
import 'package:heoby_mobile/shared/widgets/table/table_states.dart';

class HeobyTable extends ConsumerWidget {
  const HeobyTable({super.key});

  static const _columns = [
    TableColumnConfig(label: '', flex: 1, alignment: TextAlign.left),
    TableColumnConfig(label: '이름', flex: 3, alignment: TextAlign.left),
    TableColumnConfig(label: '상태', flex: 2, alignment: TextAlign.center),
    TableColumnConfig(label: '주인', flex: 3, alignment: TextAlign.left),
    TableColumnConfig(label: '업데이트', flex: 2, alignment: TextAlign.right),
  ];

  Widget _getStatusColor(String status) {
    final s = status.toLowerCase();

    if (s.contains('경고') || s.contains('warning')) return const Text('🟡');
    if (s.contains('오류') || s.contains('error')) return const Text('🔴');
    return const Text('🟢');
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final heobyList = ref.watch(heobyListProvider);

    return heobyList.when(
      data: (heobys) {
        if (heobys.isEmpty) {
          return TableBox(
            title: '허수아비 목록',
            child: const TablePlaceholder(message: '등록된 허수아비가 없습니다'),
          );
        }

        return TableBox(
          title: '허수아비 목록',
          columns: _columns,
          bodyPadding: EdgeInsets.zero,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: heobys.length,
            separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFE5E7EB)),
            itemBuilder: (context, index) {
              final heoby = heobys[index];
              final parsedDate = _parseDate(heoby.updatedAt);
              final relativeText = _relativeTime(parsedDate);

              return GestureDetector(
                onTap: () => ref.read(selectedHeobyProvider.notifier).select(heoby.uuid),
                behavior: HitTestBehavior.opaque,
                child: TableRowLayout(
                  columns: _columns,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  cells: [
                    Icon(
                      heoby.isOwner ? Icons.person : Icons.group,
                      color: heoby.isOwner ? Colors.blue : Colors.grey,
                      size: 22,
                    ),
                    Text(
                      heoby.name,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.grey.shade900,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: _getStatusColor(heoby.status),
                    ),
                    Text(
                      heoby.ownerName,
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          relativeText,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
      loading: () => TableBox(
        title: '허수아비 목록',
        columns: _columns,
        bodyPadding: EdgeInsets.zero,
        child: const TableLoadingState(),
      ),
      error: (error, stack) => TableBox(
        title: '허수아비 목록',
        child: TablePlaceholder(message: '데이터를 불러오지 못했습니다'),
      ),
    );
  }
}
