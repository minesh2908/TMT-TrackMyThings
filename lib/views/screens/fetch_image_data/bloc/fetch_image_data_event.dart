part of 'fetch_image_data_bloc.dart';

@immutable
class FetchImageDataEvent {}

final class FetchDetailsFromBillImageEvent extends FetchImageDataEvent {
  FetchDetailsFromBillImageEvent({this.billImage});
  final File? billImage;
}

final class ChangeStateEvent extends FetchImageDataEvent {}
