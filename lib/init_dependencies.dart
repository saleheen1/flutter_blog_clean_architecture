import 'package:flutter_blog_clean_architecture/core/network/connection_checker.dart';
import 'package:flutter_blog_clean_architecture/core/secrets/app_secrets.dart';
import 'package:flutter_blog_clean_architecture/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:flutter_blog_clean_architecture/features/auth/data/repository/auth_repository_impl.dart';
import 'package:flutter_blog_clean_architecture/features/auth/domain/repository/auth_repository.dart';
import 'package:flutter_blog_clean_architecture/features/auth/domain/usescases/user_sign_up.dart';
import 'package:flutter_blog_clean_architecture/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );

  serviceLocator.registerLazySingleton(() => supabase.client);

  serviceLocator.registerFactory(() => InternetConnection());
  serviceLocator.registerFactory<ConnectionChecker>(
      () => ConnectionCheckerImpl(serviceLocator()));

  _initAuth();
}

void _initAuth() {
  // Datasource
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(supabaseClient: serviceLocator()))

    // Repository
    ..registerFactory<AuthRepository>(() => AuthRepositoryImpl(
        authRemoteDataSource: serviceLocator(),
        connectionChecker: serviceLocator()))

    // Use case
    ..registerFactory(() => UserSignUp(authRepository: serviceLocator()))

    // Bloc
    ..registerFactory(() => AuthBloc(userSignUp: serviceLocator()));
}
