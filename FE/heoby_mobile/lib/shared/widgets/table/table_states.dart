import 'package:flutter/material.dart';

class TableLoadingState extends StatelessWidget {
  const TableLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 3),
        ),
      ),
    );
  }
}

class TablePlaceholder extends StatelessWidget {
  const TablePlaceholder({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
