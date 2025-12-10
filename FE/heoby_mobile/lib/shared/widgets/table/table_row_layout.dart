import 'package:flutter/material.dart';
import 'package:heoby_mobile/shared/widgets/table/table_column.dart';

/// 헤더와 동일한 flex/정렬을 따르는 테이블 행 레이아웃.
class TableRowLayout extends StatelessWidget {
  const TableRowLayout({
    super.key,
    required this.columns,
    required this.cells,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.gap = 8,
  }) : assert(columns.length == cells.length, '컬럼과 셀 개수가 동일해야 합니다.');

  final List<TableColumnConfig> columns;
  final List<Widget> cells;
  final EdgeInsets padding;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (int i = 0; i < columns.length; i++) ...[
            Expanded(
              flex: columns[i].flex,
              child: Align(
                alignment: _alignmentFromTextAlign(columns[i].alignment),
                child: cells[i],
              ),
            ),
            if (i < columns.length - 1) SizedBox(width: gap),
          ],
        ],
      ),
    );
  }

  Alignment _alignmentFromTextAlign(TextAlign align) {
    switch (align) {
      case TextAlign.left:
      case TextAlign.start:
        return Alignment.centerLeft;
      case TextAlign.right:
      case TextAlign.end:
        return Alignment.centerRight;
      default:
        return Alignment.center;
    }
  }
}
