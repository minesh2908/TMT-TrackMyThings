String calculateDateDifference(String warrantEndDate) {
  DateTime endDate;
  try {
    endDate = DateTime.parse(warrantEndDate);
  } catch (e) {
    return 'Invalid date';
  }

  final now = DateTime.now();
  final differenceInDays = endDate.difference(now).inDays;

  if (differenceInDays < 0) {
    return 'Warranty has expired';
  }

  if (differenceInDays > 30) {
    final differenceInMonths = (differenceInDays / 30).floor();
    return '$differenceInMonths months';
  }

  return '$differenceInDays days';
}

double calculateWarrantyPercentage(
  String productPurchaseDate,
  String warrantyEndDate,
) {
  final purchaseDate = DateTime.parse(productPurchaseDate);
  final warrantyEnd = DateTime.parse(warrantyEndDate);

  final totalWarrantyDays = warrantyEnd.difference(purchaseDate).inDays;
  final totalWarrantyMonths = totalWarrantyDays / 30;

  final remainingWarrantyDays = warrantyEnd.difference(DateTime.now()).inDays;
  final remainingWarrantyMonths = remainingWarrantyDays / 30;

  if (remainingWarrantyDays <= 0) {
    return 0;
  } else if (totalWarrantyMonths == 0) {
    final percentage = remainingWarrantyDays / totalWarrantyDays;
    return percentage.clamp(
      0.0,
      1.0,
    );
  } else {
    final percentage = remainingWarrantyMonths / totalWarrantyMonths;
    return percentage.clamp(
      0.0,
      1.0,
    ); // ensure the value is between 0.0 and 1.0
  }
}
