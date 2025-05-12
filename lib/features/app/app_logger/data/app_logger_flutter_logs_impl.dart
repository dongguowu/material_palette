import 'package:flutter_logs/flutter_logs.dart';

import '../domain/abstract_app_logger.dart';

class FlutterLogsImplementation implements AppLogger {
  final String tag;

  FlutterLogsImplementation({required this.tag});

  @override
  void logDebug(String message) {
    FlutterLogs.logThis(
      tag: tag,
      subTag: 'DEBUG',
      logMessage: message,
      level: LogLevel.INFO,
    );
  }

  @override
  void logInfo(String message) {
    FlutterLogs.logThis(
      tag: tag,
      subTag: 'INFO',
      logMessage: message,
      level: LogLevel.INFO,
    );
  }

  @override
  void logError(String message, [Error? error, StackTrace? stacktrace]) {
    FlutterLogs.logThis(
      tag: tag,
      subTag: 'ERROR',
      logMessage: message,
      level: LogLevel.ERROR,
      error: error,
    );
  }
}
