import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';

class XLoggerHelper {
  static void info(String message, {String tag = 'INFO'}) {
    if (kDebugMode) _log(tag, message);
  }

  static void debug(String message, {String tag = 'DEBUG'}) {
    if (kDebugMode) _log(tag, message);
  }

  static void warning(String message, {String tag = 'WARNING'}) {
    _log(tag, message);
  }

  static void error(
    String message, {
    String tag = 'ERROR',
    StackTrace? stackTrace,
    Object? exception,
  }) {
    _log(tag, message);
    if (exception != null) dev.log('Exception: $exception');
    if (stackTrace != null) dev.log('StackTrace:\n$stackTrace');
  }

  static void json(String label, dynamic data) {
    if (kDebugMode) {
      // Use JsonEncoder for pretty printing JSON data
      final formatted = const JsonEncoder.withIndent('  ').convert(data);
      _log('JSON', '$label:\n$formatted');
    }
  }

  static void separator({String tag = '---'}) {
    if (kDebugMode) _log(tag, '⎯' * 60);
  }

  static void _log(String tag, String message) {
    final timestamp = DateTime.now().toIso8601String();
    dev.log('[$timestamp] [$tag] $message');
  }
}
