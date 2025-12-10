import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

final _logger = Logger(
  printer: PrettyPrinter(
    methodCount: 1,
    errorMethodCount: 5,
    lineLength: 120,
    colors: true,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.none,
  ),
);

void debugPrintLog(String message) {
  if (kDebugMode) {
    _logger.i(message);
  }
}
