import 'package:flutter/material.dart';

/// 허수아비 배터리 미터 위젯
class HeobyBatteryMeter extends StatelessWidget {
  const HeobyBatteryMeter({
    super.key,
    required this.label,
    required this.percent,
  });

  final String label;
  final double percent;

  @override
  Widget build(BuildContext context) {
    final color = percent >= 60
        ? Colors.green
        : percent >= 30
        ? Colors.amber
        : Colors.red;

    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
              ),
              Text(
                '$percent%',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: percent / 100,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
