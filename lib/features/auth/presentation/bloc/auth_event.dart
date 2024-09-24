part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthSignUpPressed extends AuthEvent {
  final String email;
  final String password;
  final String name;

  AuthSignUpPressed(
      {required this.email, required this.password, required this.name});
}

class AuthLoginPressed extends AuthEvent {
  final String email;
  final String password;

  AuthLoginPressed({required this.email, required this.password});
}
