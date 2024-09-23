import 'package:flutter_blog_clean_architecture/core/common/entities/user.dart';
import 'package:flutter_blog_clean_architecture/core/common/usescases/usecase.dart';
import 'package:flutter_blog_clean_architecture/core/error/failures.dart';
import 'package:flutter_blog_clean_architecture/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignUp implements UseCase<User, UserSignUpParams> {
  final AuthRepository _authRepository;

  UserSignUp({required AuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  Future<Either<Failure, User>> call(UserSignUpParams params) async {
    return await _authRepository.signUp(
        name: params.name, email: params.email, password: params.password);
  }
}

class UserSignUpParams {
  final String email;
  final String password;
  final String name;
  UserSignUpParams({
    required this.email,
    required this.password,
    required this.name,
  });
}
