part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoadingState extends AuthState {}

final class AuthSuccessState extends AuthState {}

final class AuthFailureState extends AuthState {
  AuthFailureState(this.message);

  final String? message;
}

final class AccountUpdatedState extends AuthState {}

final class AccountDeletedState extends AuthState {}
