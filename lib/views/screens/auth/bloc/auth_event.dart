part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class GoogleSignInEvent extends AuthEvent {}

class GoogleSignOutEvent extends AuthEvent {}

class UpdateUserAccountDetails extends AuthEvent {
  UpdateUserAccountDetails({required this.userModel});

 final UserModel userModel;
}

class DeleteAccount extends AuthEvent {}

class GetCurrentUserData extends AuthEvent {}
