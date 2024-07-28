import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_my_things/modal/product_modal.dart';
import 'package:track_my_things/repository/product_repository.dart';
import 'package:track_my_things/service/shared_prefrence.dart';
import 'package:track_my_things/service/sort_product.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial()) {
    on<ProductEvent>((event, emit) {});
    on<AddProductEvent>(addProductEvent);
    on<GetAllProductEvent>(getAllProductEvent);
    on<UpdateProductEvent>(updateProductEvent);
    on<DeleteProductEvent>(deleteProductEvent);
    on<SearchProductEvent>(searchProductEvent);
  }

  FutureOr<void> addProductEvent(
    AddProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoadingState());
    try {
      
      String? productImageRef;
      String? billImageRef;
      final uid = DateTime.now().microsecondsSinceEpoch.toString();
      if (event.billImage != null) {
        billImageRef = await ProductRepository().addImage(event.billImage);
      }

      if (event.productImage != null) {
        productImageRef =
            await ProductRepository().addImage(event.productImage);
      }

      await ProductRepository().addProduct(
        event.productModal.copyWith(
          billImage: billImageRef,
          productImage: productImageRef,
          productId: uid,
        ),
        uid,
      );
      final productList = await ProductRepository().getAllProducts();
      emit(ProductSuccessState(productList: productList));
    } catch (e) {
      emit(ProductFailureState(errorMsg: e.toString()));
    }
  }

  FutureOr<void> getAllProductEvent(
    GetAllProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoadingState());
    var filterProductList = <ProductModal>[];
    try {
      final productList = await ProductRepository().getAllProducts();
      if (event.filterValue == '1') {
        filterProductList = productList;
      } else if (event.filterValue == '2') {
        filterProductList = productList
            .where(
              (value) =>
                  value.warrantyEndsDate != null &&
                  DateTime.parse(value.warrantyEndsDate!)
                          .compareTo(DateTime.now()) >=
                      0,
            )
            .toList();
      } else {
        filterProductList = productList
            .where(
              (value) =>
                  value.warrantyEndsDate != null &&
                  DateTime.parse(value.warrantyEndsDate!)
                          .compareTo(DateTime.now()) <=
                      0,
            )
            .toList();
      }
      if (filterProductList.isEmpty && productList.isNotEmpty) {
        emit(NoFilterProductAvailableState());
      } else {
        final sortedProductList = sortProductList(
          filterProductList,
          AppPrefHelper.getSortProductBy(),
        );
        emit(ProductSuccessState(productList: sortedProductList));
      }
    } catch (e) {
      emit(ProductFailureState(errorMsg: e.toString()));
    }
  }

  FutureOr<void> updateProductEvent(
    UpdateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoadingState());
    try {
      await ProductRepository().updateProduct(event.productModal);
      final productList = await ProductRepository().getAllProducts();
      emit(ProductSuccessState(productList: productList));
    } catch (e) {
      emit(ProductFailureState(errorMsg: e.toString()));
    }
  }

  FutureOr<void> deleteProductEvent(
    DeleteProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoadingState());
    try {
      await ProductRepository().deleteProduct(event.productModal);
      final productList = await ProductRepository().getAllProducts();
      emit(ProductSuccessState(productList: productList));
    } catch (e) {
      emit(ProductFailureState(errorMsg: e.toString()));
    }
  }

  FutureOr<void> searchProductEvent(
    SearchProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    try {
      final productList = await ProductRepository().getAllProducts();
      if (event.searchProductName.isEmpty) {
        emit(ProductSuccessState(productList: productList));
      } else {
        final filteredList = productList
            .where(
              (product) => product.productName!
                  .toLowerCase()
                  .contains(event.searchProductName.toLowerCase()),
            )
            .toList();
        emit(ProductSuccessState(productList: filteredList));
      }
    } catch (e) {
      emit(ProductFailureState(errorMsg: e.toString()));
    }
  }
}
