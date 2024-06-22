import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:warranty_tracker/modal/user_model.dart';
import 'package:warranty_tracker/repository/auth_repository.dart';
import 'package:warranty_tracker/repository/product_repository.dart';
import 'package:warranty_tracker/repository/user_repository.dart';
import 'package:warranty_tracker/service/shared_prefrence.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) {});
    on<GoogleSignInEvent>(googleSignInEvent);
    on<GoogleSignOutEvent>(googleSignOutEvent);
    on<UpdateUserAccountDetails>(updateUserAccountDetails);
    on<DeleteAccount>(deleteAccount);
    on<GetCurrentUserData>(getCurrentUserData);
  }

  FutureOr<void> googleSignInEvent(
    GoogleSignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final user = await AuthRepository().signInWithGoogle();
      if (user != null) {
        emit(AuthSuccessState());
      }
    } catch (e) {
      // print('Sign in failure');
      emit(AuthFailureState(e.toString()));
    }
  }

  FutureOr<void> googleSignOutEvent(
    GoogleSignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final isSignOut = await AuthRepository().signOutFromGoogle();
      if (isSignOut) {
        // print('Log out success');
        emit(AuthSuccessState());
      }
    } catch (e) {
      emit(AuthFailureState(e.toString()));
    }
  }

  FutureOr<void> updateUserAccountDetails(
    UpdateUserAccountDetails event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    // print(state.runtimeType);
    try {
      await UserRepository().updateUser(event.userModel);
      emit(AccountUpdatedState());
      // print(state.runtimeType);
    } catch (e) {
      throw Exception(e);
    }
  }

  FutureOr<void> deleteAccount(
    DeleteAccount event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final productList = await ProductRepository().getAllProducts();
      // print(productList);
      await ProductRepository().deleteAllProduct(productList);
      await UserRepository().deleteUser(AppPrefHelper.getUID());
      // print('account deleted');
      emit(AccountDeletedState());
    } catch (e) {
      emit(AuthFailureState(e.toString()));
    }
  }

  FutureOr<void> getCurrentUserData(
    GetCurrentUserData event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser?.uid;
      final userData =
          await UserRepository().getCurrentUserDetails(currentUser!);
      // print(userData);
    } catch (e) {
      throw Exception(e);
    }
  }
}
