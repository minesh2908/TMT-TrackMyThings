import 'dart:developer';

import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String get toFormattedDate {
    return DateFormat('dd MMM yyyy').format(this);
  }
}

extension StringExtension on String {
  DateTime? toDate() {
    // Define the date format matching the format you want to parse
    final format = DateFormat('dd MMM yyyy');

    try {
      // Parse the string into a DateTime object using the defined format
      return format.parse(this);
    } catch (e) {
      // If parsing fails, return null or handle the error as needed
      log('Error parsing date: $e');
      return null;
    }
  }
}

extension Iso8601Extensions on String {
  DateTime? toDateTime() {
    return DateTime.tryParse(this);
  }
}

extension NameStringExtension on String {
  String truncate(int maxLength) {
    if (length <= maxLength) {
      return this;
    } else {
      return substring(0, maxLength);
    }
  }
}

extension StringExtensions on String {
  String get beforeFirstSpace {
    final spaceIndex = indexOf(' ');
    return spaceIndex == -1 ? this : substring(0, spaceIndex);
  }

String truncateAtFirstSpace() {
    int spaceIndex = this.indexOf(' ');
    if (spaceIndex != -1) {
      return this.substring(0, spaceIndex);
    } else {
      return this;
    }
  }
}
