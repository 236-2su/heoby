import 'package:flutter/material.dart';
import 'package:heoby_mobile/core/theme/theme.dart';

class BaseBox extends StatelessWidget {
  const BaseBox({
    super.key,
    required this.title,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  final String title;
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        border: Border.all(color: Color.fromRGBO(15, 23, 42, 0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(),
            child: Padding(
              padding: EdgeInsetsGeometry.only(top: 16, left: 16, right: 16),
              child: Text(
                title,
                style: context.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Divider(
            color: Color(0xffF7F4ED),
            thickness: 3,
          ),
          Flexible(
            fit: FlexFit.loose,
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
