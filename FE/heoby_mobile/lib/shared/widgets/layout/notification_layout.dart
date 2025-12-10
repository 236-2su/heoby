import 'package:flutter/material.dart';
import 'package:heoby_mobile/shared/widgets/app_bar/base_app_bar.dart';

class NotificationLayout extends StatelessWidget {
  const NotificationLayout({
    super.key,
    required this.title,
    required this.children,
    this.hideNotificationIcon = false,
  });

  final String title;
  final List<Widget> children;
  final bool hideNotificationIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xffeeedec), Color(0xfff0e6c6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: BaseAppBar(title: title, hideNotificationIcon: hideNotificationIcon),
        body: SafeArea(
          bottom: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
