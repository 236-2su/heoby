// lib/core/utils/logger.dart

import 'package:logger/logger.dart';

/// 커스텀 프린터: 모든 로그를 이모지 + 메시지 형식으로 간단하게 출력
class CustomPrinter extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    final emoji = _getEmoji(event.level);
    final message = _stringifyMessage(event.message);

    // 에러나 스택트레이스가 있는 경우 추가 출력
    if (event.error != null) {
      return [
        '$emoji $message',
        '   Error: ${event.error}',
      ];
    }

    return ['$emoji $message'];
  }

  String _getEmoji(Level level) {
    switch (level) {
      case Level.trace:
        return '🔍';
      case Level.debug:
        return '🐛';
      case Level.info:
        return '💡';
      case Level.warning:
        return '⚠️';
      case Level.error:
        return '❌';
      case Level.fatal:
        return '💀';
      default:
        return '📝';
    }
  }

  String _stringifyMessage(dynamic message) {
    if (message is Map || message is Iterable) {
      return message.toString();
    }
    return message.toString();
  }
}

/// AppLogger 유틸 클래스
class AppLogger {
  static final Logger _logger = Logger(
    // release 모드 등에서 로그를 필터링하려면 filter 옵션을 추가할 수 있습니다.
    printer: CustomPrinter(),
  );

  static void t(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.t(message, error: error, stackTrace: stackTrace);
  }

  static void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  // 성공 로그에 사용되는 메서드입니다.
  static void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  static void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  static void f(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }
}
