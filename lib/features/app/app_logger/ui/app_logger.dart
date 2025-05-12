import 'dart:convert';

import 'package:get_it/get_it.dart';

import '../domain/abstract_app_logger.dart';

void log(String message) {
  GetIt.instance<AppLogger>().logDebug(message);
}

const int logLineLength = 115;

void logTitle(String title) {
  if (title.length > 80) {
    title = '${title.substring(0, 77)}...';
  }
  String message = '$title${'.' * (logLineLength - title.length)}>';
  log(message);
}

void logInfo(String message) {
  GetIt.instance<AppLogger>().logInfo(message);
}

void logError(String message, [Error? error, StackTrace? stacktrace]) {
  GetIt.instance<AppLogger>().logError(
    message,
    error ?? Error(),
    stacktrace ?? StackTrace.current,
  );
}

void logJson(Object jsonObject) {
  final prettyJson = const JsonEncoder.withIndent('  ').convert(jsonObject);
  log('\nSerialized JSON:\n$prettyJson');
}
