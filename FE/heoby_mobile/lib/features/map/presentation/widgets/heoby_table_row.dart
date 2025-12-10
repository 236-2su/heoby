import 'package:flutter/material.dart';
import 'package:heoby_mobile/shared/widgets/table/table_column.dart';
import 'package:heoby_mobile/shared/widgets/table/table_row_layout.dart';

const heobyTableColumns = [
  TableColumnConfig(label: '이름', flex: 3),
  TableColumnConfig(label: '상태', flex: 2),
  TableColumnConfig(label: '주인', flex: 3),
  TableColumnConfig(label: '업데이트', flex: 2),
];

/// 허수아비 테이블 로우 위젯
class HeobyTableRow extends StatelessWidget {
  const HeobyTableRow({
    super.key,
    required this.name,
    required this.status,
    required this.master,
    required this.date,
  });

  final String name;
  final String status;
  final String master;
  final String date;

  @override
  Widget build(BuildContext context) {
    return TableRowLayout(
      columns: heobyTableColumns,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      cells: [
        Text(name, textAlign: TextAlign.center),
        Text(status, textAlign: TextAlign.center),
        Text(master, textAlign: TextAlign.center),
        Text(date, textAlign: TextAlign.center),
      ],
    );
  }
}
