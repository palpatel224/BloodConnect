import 'package:bloodconnect/login/0_data/models/auth_model.dart';
import 'package:bloodconnect/login/1_domain/repository/login_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'login_screen_state.dart';
part 'login_screen_event.dart';

class LoginScreenBloc extends Bloc<LoginScreenEvent, LoginScreenState> {
  final AuthRepository _authRepository;

  LoginScreenBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    on<LoginWithEmail>(_handleLogin);
    on<SignUpWithEmailEvent>(_handleSignUp);
    on<ToggleAuthModeEvent>(_handleToggle);
    on<GoogleSignInEvent>(_handleGoogleSignIn); // New event
  }

  void _handleToggle(ToggleAuthModeEvent event, Emitter<LoginScreenState> emit) {
    if (state is ToggleAuthMode) {
      emit(ToggleAuthMode(!(state as ToggleAuthMode).isLogin));
    } else {
      emit(ToggleAuthMode(true));
    }
  }

  Future<void> _handleLogin(LoginWithEmail event, Emitter<LoginScreenState> emit) async {
    try {
      emit(AuthLoading());
      final result = await _authRepository.signin(event.userSignInReq);
      result.fold(
        (error) {
          emit(AuthFailure(error: error));
        },
        (success) {
          emit(AuthSuccess());
        },
      );
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _handleSignUp(SignUpWithEmailEvent event, Emitter<LoginScreenState> emit) async {
    try {
      emit(AuthLoading());
      final result = await _authRepository.signup(event.user);
      result.fold(
        (error) {
          emit(AuthFailure(error: error));
        },
        (success) {
          emit(AuthSuccess());
        },
      );
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _handleGoogleSignIn(GoogleSignInEvent event, Emitter<LoginScreenState> emit) async {
    try {
      emit(AuthLoading());
      final result = await _authRepository.signInWithGoogle();
      result.fold(
        (error) {
          emit(AuthFailure(error: error));
        },
        (success) {
          emit(AuthSuccess());
        },
      );
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }
}