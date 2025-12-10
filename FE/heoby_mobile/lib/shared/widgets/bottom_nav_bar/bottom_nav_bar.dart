import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xff333333),
      elevation: 8,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      selectedFontSize: 13,
      unselectedFontSize: 12,
      selectedIconTheme: const IconThemeData(size: 28),
      unselectedIconTheme: const IconThemeData(size: 24),
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(icon: Icon(LucideIcons.house), label: '홈'),
        BottomNavigationBarItem(icon: Icon(LucideIcons.mapPin), label: '지도'),
        BottomNavigationBarItem(icon: Icon(LucideIcons.camera), label: 'CCTV'),
        BottomNavigationBarItem(icon: Icon(LucideIcons.user), label: '프로필'),
      ],
    );
  }
}
