part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class GoogleSignInEvent extends AuthEvent {}

class GoogleSignOutEvent extends AuthEvent {}

class UpdateUserAccountDetails extends AuthEvent {
  UpdateUserAccountDetails({required this.userModel});

  UserModel userModel;
}

class DeleteAccount extends AuthEvent {
  
}
