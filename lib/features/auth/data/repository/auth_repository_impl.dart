import 'package:flutter_blog_clean_architecture/core/common/entities/user.dart';
import 'package:flutter_blog_clean_architecture/core/constants/constants.dart';
import 'package:flutter_blog_clean_architecture/core/error/exceptions.dart';
import 'package:flutter_blog_clean_architecture/core/error/failures.dart';
import 'package:flutter_blog_clean_architecture/core/network/connection_checker.dart';
import 'package:flutter_blog_clean_architecture/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:flutter_blog_clean_architecture/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final ConnectionChecker connectionChecker;

  AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, User>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    return _loginOrSignUp(() async => await authRemoteDataSource.signUp(
        name: name, email: email, password: password));
  }

  @override
  Future<Either<Failure, User>> login(
      {required String email, required String password}) {
    return _loginOrSignUp(() async =>
        await authRemoteDataSource.login(email: email, password: password));
  }

  Future<Either<Failure, User>> _loginOrSignUp(
    Future<User> Function() fn,
  ) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }
      final user = await fn();

      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
