import 'dart:io';
import 'package:flutter_blog_clean_architecture/core/constants/constants.dart';
import 'package:flutter_blog_clean_architecture/core/error/exceptions.dart';
import 'package:flutter_blog_clean_architecture/core/error/failures.dart';
import 'package:flutter_blog_clean_architecture/core/network/connection_checker.dart';
import 'package:flutter_blog_clean_architecture/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:flutter_blog_clean_architecture/features/blog/data/datasources/blog_remote_datasources.dart';
import 'package:flutter_blog_clean_architecture/features/blog/data/models/blog_model.dart';
import 'package:flutter_blog_clean_architecture/features/blog/domain/entities/blog.dart';
import 'package:flutter_blog_clean_architecture/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDatasources _blogRemoteDatasources;
  final ConnectionChecker _connectionChecker;
  final BlogLocalDataSource _blogLocalDataSource;

  BlogRepositoryImpl(
      {required BlogRemoteDatasources blogRemoteDatasources,
      required ConnectionChecker connectionChecker,
      required BlogLocalDataSource blogLocalDataSource})
      : _blogRemoteDatasources = blogRemoteDatasources,
        _blogLocalDataSource = blogLocalDataSource,
        _connectionChecker = connectionChecker;

  @override
  Future<Either<Failure, Blog>> uploadBlog(
      {required File image,
      required String title,
      required String content,
      required String posterId,
      required List<String> topics}) async {
    try {
      if (!await (_connectionChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }
      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: '',
        topics: topics,
        updatedAt: DateTime.now(),
      );

      final imageUrl = await _blogRemoteDatasources.uploadBlogImage(
        image: image,
        blog: blogModel,
      );

      blogModel = blogModel.copyWith(
        imageUrl: imageUrl,
      );

      final uploadedBlog = await _blogRemoteDatasources.uploadBlog(blogModel);
      return right(uploadedBlog);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {
      if (!await (_connectionChecker.isConnected)) {
        final blogs = _blogLocalDataSource.loadBlogs();
        return right(blogs);
      }
      final blogs = await _blogRemoteDatasources.getAllBlogs();
      _blogLocalDataSource.uploadLocalBlogs(blogs: blogs);
      return right(blogs);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
