import 'package:bloc/bloc.dart';
import 'package:flutter_blog_clean_architecture/core/common/entities/user.dart';
import 'package:flutter_blog_clean_architecture/features/auth/domain/usescases/user_login.dart';
import 'package:flutter_blog_clean_architecture/features/auth/domain/usescases/user_sign_up.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
  })  : _userSignUp = userSignUp,
        _userLogin = userLogin,
        super(AuthInitial()) {
    on<AuthEvent>((event, emit) => emit(AuthLoading()));
    on<AuthSignUpPressed>(_onAuthSignUpPressed);
    on<AuthLoginPressed>(_onAuthLoginPressed);
  }

  _onAuthSignUpPressed(
    AuthSignUpPressed event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _userSignUp(UserSignUpParams(
        email: event.email, password: event.password, name: event.name));

    res.fold((f) => emit(AuthFailure(message: f.message)),
        (r) => emit(AuthSuccess(user: r)));
  }

  _onAuthLoginPressed(
    AuthLoginPressed event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _userLogin(
        UserLoginParams(email: event.email, password: event.password));

    res.fold((f) => emit(AuthFailure(message: f.message)),
        (r) => emit(AuthSuccess(user: r)));
  }
}
