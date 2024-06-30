part of 'product_bloc.dart';

@immutable
sealed class ProductState {
  const ProductState({this.productList = const []});
  final List<ProductModal> productList;
}

final class ProductInitial extends ProductState {}

final class ProductLoadingState extends ProductState {}

final class ProductSuccessState extends ProductState {
  const ProductSuccessState({required super.productList});
}

final class ProductFailureState extends ProductState {
  const ProductFailureState({required this.errorMsg});
  final String errorMsg;
}

final class NoFilterProductAvailableState extends ProductState {}
