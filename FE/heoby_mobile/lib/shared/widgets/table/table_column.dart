import 'package:flutter/material.dart';

/// 테이블 헤더 및 본문 정렬을 정의하는 컬럼 설정 값.
class TableColumnConfig {
  const TableColumnConfig({
    required this.label,
    this.flex = 1,
    this.alignment = TextAlign.center,
    this.headerStyle,
  });

  final String label;
  final int flex;
  final TextAlign alignment;
  final TextStyle? headerStyle;
}
