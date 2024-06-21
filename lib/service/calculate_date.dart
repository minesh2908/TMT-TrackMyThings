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

//Calculate Percentage of Days remaing

double calculateWarrantyPercentage(
  String productPurchaseDate,
  String warrantyEndDate,
) {
  // Parse the dates from ISO strings
  final purchaseDate = DateTime.parse(productPurchaseDate);
  final warrantyEnd = DateTime.parse(warrantyEndDate);

  // Calculate the total warranty period in months and days
  final totalWarrantyDays = warrantyEnd.difference(purchaseDate).inDays;
  final totalWarrantyMonths = totalWarrantyDays / 30;

  // Calculate the remaining warranty period in months and days
  final remainingWarrantyDays = warrantyEnd.difference(DateTime.now()).inDays;
  final remainingWarrantyMonths = remainingWarrantyDays / 30;

  // Calculate the percentage based on the remaining warranty period
  if (remainingWarrantyDays <= 0) {
    // If the warranty has expired, return 0
    return 0;
  } else if (totalWarrantyMonths == 0) {
    // If the total warranty is less than 1 month, calculate the percentage based on days
    final percentage = remainingWarrantyDays / totalWarrantyDays;
    return percentage.clamp(
      0.0,
      1.0,
    ); // ensure the value is between 0.0 and 1.0
  } else {
    // Calculate the percentage of months remaining
    final percentage = remainingWarrantyMonths / totalWarrantyMonths;
    return percentage.clamp(
      0.0,
      1.0,
    ); // ensure the value is between 0.0 and 1.0
  }
}
