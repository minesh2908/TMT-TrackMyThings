import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:warranty_tracker/modal/product_modal.dart';
import 'package:warranty_tracker/repository/gemini_repository.dart';

part 'fetch_image_data_event.dart';
part 'fetch_image_data_state.dart';

class FetchImageDataBloc
    extends Bloc<FetchImageDataEvent, FetchImageDataState> {
  FetchImageDataBloc() : super(FetchImageDataInitial()) {
    on<FetchImageDataEvent>((event, emit) {});
    on<FetchDetailsFromBillImageEvent>(fetchingDetailsFromBillImage);
    on<ChangeStateEvent>(changeStateEvent);
  }

  FutureOr<void> fetchingDetailsFromBillImage(
    FetchDetailsFromBillImageEvent event,
    Emitter<FetchImageDataState> emit,
  ) async {
    emit(FetchingImageDataLoadingState());
    try {
      final productModal =
          await GeminiRepository().getDataFromImage(event.billImage);
      emit(FetchingImageDataSuccessState(productModal: productModal));
    } catch (e) {
      log(e.toString());
      emit(FetchigImageDataFailedState(errorMsg: e.toString()));
    }
  }

  FutureOr<void> changeStateEvent(
    ChangeStateEvent event,
    Emitter<FetchImageDataState> emit,
  ) async {
    emit(FetchImageDataInitial());
  }
}
