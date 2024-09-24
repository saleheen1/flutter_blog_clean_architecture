import 'package:flutter_blog_clean_architecture/core/network/connection_checker.dart';
import 'package:flutter_blog_clean_architecture/core/secrets/app_secrets.dart';
import 'package:flutter_blog_clean_architecture/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:flutter_blog_clean_architecture/features/auth/data/repository/auth_repository_impl.dart';
import 'package:flutter_blog_clean_architecture/features/auth/domain/repository/auth_repository.dart';
import 'package:flutter_blog_clean_architecture/features/auth/domain/usescases/user_login.dart';
import 'package:flutter_blog_clean_architecture/features/auth/domain/usescases/user_sign_up.dart';
import 'package:flutter_blog_clean_architecture/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_blog_clean_architecture/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:flutter_blog_clean_architecture/features/blog/data/datasources/blog_remote_datasources.dart';
import 'package:flutter_blog_clean_architecture/features/blog/data/repository/blog_repository_impl.dart';
import 'package:flutter_blog_clean_architecture/features/blog/domain/repository/blog_repository.dart';
import 'package:flutter_blog_clean_architecture/features/blog/domain/usescases/get_all_blogs.dart';
import 'package:flutter_blog_clean_architecture/features/blog/domain/usescases/upload_blog.dart';
import 'package:flutter_blog_clean_architecture/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );

  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  serviceLocator.registerLazySingleton(() => supabase.client);

  serviceLocator.registerLazySingleton(
    () => Hive.box(name: 'blogs'),
  );
  serviceLocator.registerFactory(() => InternetConnection());
  serviceLocator.registerFactory<ConnectionChecker>(
      () => ConnectionCheckerImpl(serviceLocator()));

  _initAuth();
  _initBlog();
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
    ..registerFactory(() => UserLogin(authRepository: serviceLocator()))

    // Bloc
    ..registerFactory(() =>
        AuthBloc(userSignUp: serviceLocator(), userLogin: serviceLocator()));
}

_initBlog() {
  serviceLocator.registerFactory<BlogRemoteDatasources>(
      () => BlogRemoteDataSourcesImpl(supabaseClient: serviceLocator()));

  serviceLocator.registerFactory<BlogLocalDataSource>(
      () => BlogLocalDataSourceImpl(serviceLocator()));

  serviceLocator.registerFactory(() => GetAllBlogs(serviceLocator()));

  serviceLocator.registerFactory<BlogRepository>(() => BlogRepositoryImpl(
      blogRemoteDatasources: serviceLocator(),
      blogLocalDataSource: serviceLocator(),
      connectionChecker: serviceLocator()));
  serviceLocator.registerFactory(() => UploadBlog(serviceLocator()));
  serviceLocator
      .registerFactory(() => BlogBloc(serviceLocator(), serviceLocator()));
}
