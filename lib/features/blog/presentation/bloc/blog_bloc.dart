import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter_blog_clean_architecture/core/common/usescases/usecase.dart';
import 'package:flutter_blog_clean_architecture/features/blog/domain/entities/blog.dart';
import 'package:flutter_blog_clean_architecture/features/blog/domain/usescases/get_all_blogs.dart';
import 'package:flutter_blog_clean_architecture/features/blog/domain/usescases/upload_blog.dart';
import 'package:meta/meta.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;

  BlogBloc(this._uploadBlog, this._getAllBlogs) : super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));
    on<BlogUploadPressed>(_onBlogUpload);
    on<BlogFetchAllBlogsPressed>(_onFetchAllBlogs);
  }

  void _onBlogUpload(
    BlogUploadPressed event,
    Emitter<BlogState> emit,
  ) async {
    final res = await _uploadBlog(
      UploadBlogParams(
        posterId: event.posterId,
        title: event.title,
        content: event.content,
        image: event.image,
        topics: event.topics,
      ),
    );

    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogUploadSuccess()),
    );
  }

  void _onFetchAllBlogs(
    BlogFetchAllBlogsPressed event,
    Emitter<BlogState> emit,
  ) async {
    final res = await _getAllBlogs(NoParams());

    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogsDisplaySuccess(r)),
    );
  }
}
