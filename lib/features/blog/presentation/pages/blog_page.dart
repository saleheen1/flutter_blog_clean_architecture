import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blog_clean_architecture/core/common/widgets/loader.dart';
import 'package:flutter_blog_clean_architecture/core/utils/show_snackbar.dart';
import 'package:flutter_blog_clean_architecture/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:flutter_blog_clean_architecture/features/blog/presentation/pages/add_new_blog_page.dart';

class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const BlogPage(),
      );
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog App'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, AddNewBlogPage.route());
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
                return Text(
                  'Blog $i',
                  style: const TextStyle(color: Colors.white),
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
