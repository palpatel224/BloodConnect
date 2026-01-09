part of 'login_screen_bloc.dart';

abstract class LoginScreenState {}

class AuthInitial extends LoginScreenState {}

class AuthLoading extends LoginScreenState {}

class AuthSuccess extends LoginScreenState {}

class AuthFailure extends LoginScreenState {
  final String error;
  AuthFailure({required this.error});
}

class ToggleAuthMode extends LoginScreenState {
  final bool isLogin;
  ToggleAuthMode(this.isLogin);
}
