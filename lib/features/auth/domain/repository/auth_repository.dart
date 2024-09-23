import 'package:flutter_blog_clean_architecture/core/common/entities/user.dart';
import 'package:flutter_blog_clean_architecture/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signUp({
    required String name,
    required String email,
    required String password,
  });
}
