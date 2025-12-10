import 'package:flutter/material.dart';

/// 허수아비 기능 상태 칩 위젯
class HeobyFeatureChip extends StatelessWidget {
  const HeobyFeatureChip({
    super.key,
    required this.label,
    required this.icon,
    required this.active,
  });

  final String label;
  final String icon;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: active ? Colors.green.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: active ? Colors.green.shade200 : Colors.grey.shade300,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text(
            '$label ${active ? "ON" : "OFF"}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: active ? Colors.green.shade700 : Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
