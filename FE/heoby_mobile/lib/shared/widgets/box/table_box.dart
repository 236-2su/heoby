import 'package:flutter/material.dart';
import 'package:heoby_mobile/core/theme/app_theme.dart';
import 'package:heoby_mobile/shared/widgets/table/table_column.dart';

class TableBox extends StatelessWidget {
  const TableBox({
    super.key,
    required this.title,
    required this.child,
    this.columns = const [],
    this.bodyPadding = const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
  });

  final String title;
  final Widget child;
  final List<TableColumnConfig> columns;
  final EdgeInsets bodyPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        border: Border.all(color: Color.fromRGBO(15, 23, 42, 0.3)),
        // boxShadow: const [
        //   BoxShadow(
        //     color: Color.fromRGBO(0, 0, 0, 0.10),
        //     offset: Offset(0, 4),
        //     blurRadius: 6,
        //     spreadRadius: -1,
        //   ),
        //   BoxShadow(
        //     color: Color.fromRGBO(0, 0, 0, 0.10),
        //     offset: Offset(0, 2),
        //     blurRadius: 4,
        //     spreadRadius: -2,
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Text(
              title,
              style: context.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ),

          // 헤더
          if (columns.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: const BoxDecoration(color: Color(0xffF7F4ED)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for (int i = 0; i < columns.length; i++) ...[
                    Expanded(
                      flex: columns[i].flex,
                      child: Align(
                        alignment: _alignmentFromTextAlign(columns[i].alignment),
                        child: Text(
                          columns[i].label,
                          style:
                              columns[i].headerStyle ??
                              const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Color(0xFF111827),
                                letterSpacing: -0.3,
                              ),
                        ),
                      ),
                    ),
                    if (i < columns.length - 1) const SizedBox(width: 8),
                  ],
                ],
              ),
            ),

          // 본문
          Padding(
            padding: bodyPadding,
            child: child,
          ),
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
