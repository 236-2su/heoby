import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heoby_mobile/features/cctv/presentation/providers/cctv_provider.dart';
import 'package:heoby_mobile/shared/widgets/box/base_box.dart';

class WorkingSummary extends ConsumerWidget {
  const WorkingSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cctvState = ref.watch(cctvProvider);
    final workers = cctvState.data?.workers ?? 0;

    return AspectRatio(
      aspectRatio: 1,
      child: BaseBox(
        title: '작업 중',
        padding: EdgeInsets.all(0),
        child: Center(
          child: Text(
            '$workers',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3B82F6),
            ),
          ),
        ),
      ),
    );
  }
}
