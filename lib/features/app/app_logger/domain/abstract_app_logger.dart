abstract class AppLogger {
  void logDebug(String message); // For DEBUG level logs
  void logInfo(String message); // For INFO level logs
  void logError(String message,
      [Error? error, StackTrace? stacktrace]); // For ERROR level logs
}
