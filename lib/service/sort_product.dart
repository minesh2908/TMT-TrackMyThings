import 'package:track_my_things/modal/product_modal.dart';

List<ProductModal> sortProductList(
  List<ProductModal> productList,
  String sortBy,
) {
  switch (sortBy) {
    case 'Warranty end date':
      productList.sort(
        (a, b) => DateTime.parse(a.warrantyEndsDate!)
            .compareTo(DateTime.parse(b.warrantyEndsDate!)),
      );

    case 'Purchased date':
      productList.sort(
        (a, b) => DateTime.parse(a.purchasedDate!)
            .compareTo(DateTime.parse(b.purchasedDate!)),
      );

    case 'Product name':
      productList.sort((a, b) => a.productName!.compareTo(b.productName!));

    default:
      break;
  }
  return productList;
}
