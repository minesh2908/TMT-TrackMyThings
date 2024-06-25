part of 'fetch_image_data_bloc.dart';

@immutable
sealed class FetchImageDataState {}

final class FetchImageDataInitial extends FetchImageDataState {}

final class FetchingImageDataLoadingState extends FetchImageDataState {}

final class FetchingImageDataSuccessState extends FetchImageDataState {
  FetchingImageDataSuccessState({this.productModal});
  final ProductModal? productModal;
}

final class FetchigImageDataFailedState extends FetchImageDataState {
  FetchigImageDataFailedState({required this.errorMsg});
  final String errorMsg;
}
