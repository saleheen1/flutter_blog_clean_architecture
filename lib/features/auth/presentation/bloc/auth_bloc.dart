import 'package:bloc/bloc.dart';
import 'package:flutter_blog_clean_architecture/core/common/entities/user.dart';
import 'package:flutter_blog_clean_architecture/features/auth/domain/usescases/user_sign_up.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;

  AuthBloc({required UserSignUp userSignUp})
      : _userSignUp = userSignUp,
        super(AuthInitial()) {
    on<AuthEvent>((event, emit) => emit(AuthLoading()));
    on<AuthSignUpPressed>(_onAuthSignUpPressed);
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
}
