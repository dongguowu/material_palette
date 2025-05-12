import 'package:logger/logger.dart';

import '../domain/abstract_app_logger.dart';

class LoggerImpl implements AppLogger {
  final Logger logger = Logger(
    filter: null,
    printer: PrettyPrinter(
      methodCount: 0, // Number of method calls to be displayed
      errorMethodCount: 8, // Number of method calls if stacktrace is provided
      lineLength: 120, // Width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      // Should each log print contain a timestamp
      // dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    output: null,
    level: Level.debug,
  );

  @override
  void logDebug(String message) {
    logger.d(message);
  }

  @override
  void logInfo(String message) {
    logger.i(message);
  }

  @override
  void logError(String message, [Error? error, StackTrace? stacktrace]) {
    logger.e(message, error: error, stackTrace: stacktrace);
  }
}
