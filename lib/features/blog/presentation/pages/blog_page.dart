import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blog_clean_architecture/core/common/widgets/loader.dart';
import 'package:flutter_blog_clean_architecture/core/routes/route_names.dart';
import 'package:flutter_blog_clean_architecture/core/theme/app_pallete.dart';
import 'package:flutter_blog_clean_architecture/core/utils/show_snackbar.dart';
import 'package:flutter_blog_clean_architecture/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:flutter_blog_clean_architecture/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:flutter_blog_clean_architecture/features/blog/presentation/widgets/blog_card.dart';
import 'package:go_router/go_router.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(BlogFetchAllBlogsPressed());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog App'),
        actions: [
          IconButton(
            onPressed: () {
              context.push(RouteNames.addBlog);
            },
            icon: const Icon(
              CupertinoIcons.add_circled,
            ),
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }
          if (state is BlogsDisplaySuccess) {
            return ListView.builder(
              itemCount: 4,
              itemBuilder: (context, i) {
                final blog = state.blogs[i];
                return BlogCard(
                  blog: blog,
                  color:
                      i % 2 == 0 ? AppPallete.gradient1 : AppPallete.gradient2,
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
