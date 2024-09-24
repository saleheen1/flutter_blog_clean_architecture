import 'package:flutter_blog_clean_architecture/core/common/entities/user.dart';
import 'package:flutter_blog_clean_architecture/core/common/usescases/usecase.dart';
import 'package:flutter_blog_clean_architecture/core/error/failures.dart';
import 'package:flutter_blog_clean_architecture/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/src/either.dart';

class UserLogin implements UseCase<User, UserLoginParams> {
  final AuthRepository _authRepository;

  UserLogin({required AuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  Future<Either<Failure, User>> call(UserLoginParams params) async {
    return await _authRepository.login(
        email: params.email, password: params.password);
  }
}

class UserLoginParams {
  final String email;
  final String password;
  UserLoginParams({
    required this.email,
    required this.password,
  });
}
