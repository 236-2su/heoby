import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../bottom_nav_bar/bottom_nav_bar.dart';
import '../../../features/cctv/presentation/providers/cctv_tab_provider.dart';

/// BottomNavigationBar를 포함한 Scaffold
class ScaffoldWithNavBar extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(cctvTabActiveProvider.notifier).setActive(navigationShell.currentIndex == 2);

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          ref.read(cctvTabActiveProvider.notifier).setActive(index == 2);
          navigationShell.goBranch(index);
        },
      ),
    );
  }
}
