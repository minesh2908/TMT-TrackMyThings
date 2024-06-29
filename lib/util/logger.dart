import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  static final _logger = Logger();

  static void info(String message) {
    if (kDebugMode) {
      _logger.i(message);
    } else {
      // Add Firebase Events
    }
  }

  static void error(String message) {
    if (kDebugMode) {
      _logger.e(message);
    } else {
      // Add Firebase Events
    }
  }
}
