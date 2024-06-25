part of 'product_bloc.dart';

@immutable
sealed class ProductEvent {}

final class AddProductEvent extends ProductEvent {
  AddProductEvent({
    required this.productModal,
    this.billImage,
    this.productImage,
  });
  final ProductModal productModal;
  final File? billImage;
  final File? productImage;
}

final class GetAllProductEvent extends ProductEvent {
  GetAllProductEvent({this.test = 'Test Data'});

  final String test;
}

final class UpdateProductEvent extends ProductEvent {
  UpdateProductEvent({required this.productModal});
  final ProductModal productModal;
}

final class DeleteProductEvent extends ProductEvent {
  DeleteProductEvent({required this.productModal});
  final ProductModal productModal;
}

final class SearchProductEvent extends ProductEvent {
  SearchProductEvent({required this.searchProductName});
  final String searchProductName;
}


