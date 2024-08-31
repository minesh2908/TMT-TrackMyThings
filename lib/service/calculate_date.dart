import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String calculateDateDifference(String warrantEndDate, BuildContext context) {
  DateTime endDate;
  try {
    endDate = DateTime.parse(warrantEndDate);
  } catch (e) {
    return 'Invalid date';
  }

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final endDateStartOfDay = DateTime(endDate.year, endDate.month, endDate.day);

  final differenceInDays = endDateStartOfDay.difference(today).inDays + 1;
  if (differenceInDays <= 0) {
    if (differenceInDays == 0) {
      return AppLocalizations.of(context)!.warrantyExpiredYesterday;
    } else {
      return AppLocalizations.of(context)!.warrantyHasExpired;
    }
  } else if (differenceInDays == 1) {
    return AppLocalizations.of(context)!.warrantyExpiringToday;
  } else if (differenceInDays == 2) {
    return AppLocalizations.of(context)!.warrantyExpiringTomorrow;
  } else if (differenceInDays > 30) {
    final differenceInMonths = (differenceInDays / 30).floor();
    return '$differenceInMonths ${AppLocalizations.of(context)!.monthsLeft}';
  } else {
    return '$differenceInDays ${AppLocalizations.of(context)!.daysLeft}';
  }
}

double calculateWarrantyPercentage(
  String productPurchaseDate,
  String warrantyEndDate,
) {
  final purchaseDate = DateTime.parse(productPurchaseDate);
  final warrantyEnd = DateTime.parse(warrantyEndDate);

  final totalWarrantyDays = warrantyEnd.difference(purchaseDate).inDays;
  final remainingWarrantyDays = warrantyEnd.difference(DateTime.now()).inDays;

  if (remainingWarrantyDays == 0) {
    return 0;
  } else if (remainingWarrantyDays < 0) {
    return -1;
  } else {
    final percentage = remainingWarrantyDays / totalWarrantyDays;
    return percentage.clamp(0.0, 1.0);
  }
}
