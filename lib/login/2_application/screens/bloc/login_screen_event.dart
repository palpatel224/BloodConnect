part of 'login_screen_bloc.dart';

abstract class LoginScreenEvent {}

class LoginWithEmail extends LoginScreenEvent {
  final UserSignInReq userSignInReq;

  LoginWithEmail({required this.userSignInReq});
}

class SignUpWithEmailEvent extends LoginScreenEvent {
  final UserSignUpReq user;

  SignUpWithEmailEvent({required this.user});
}

class ToggleAuthModeEvent extends LoginScreenEvent {}

class GoogleSignInEvent extends LoginScreenEvent {}