import 'package:flutter/material.dart';
import 'package:heoby_mobile/shared/widgets/app_bar/base_app_bar.dart';

class BaseLayout extends StatelessWidget {
  const BaseLayout({
    super.key,
    required this.title,
    required this.children,
    this.background = Colors.white,
    this.hideNotificationIcon = false,
  });

  final String title;
  final List<Widget> children;
  final Color background;
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
        appBar: BaseAppBar(title: title, hideNotificationIcon: hideNotificationIcon, backButtonColor: Colors.black),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 8,
                ),
              ),
              ...children.map((widget) => SliverToBoxAdapter(child: widget)),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
