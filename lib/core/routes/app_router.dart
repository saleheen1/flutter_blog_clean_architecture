import 'package:flutter/material.dart';
import 'package:flutter_blog_clean_architecture/core/routes/route_names.dart';
import 'package:flutter_blog_clean_architecture/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_blog_clean_architecture/features/auth/presentation/pages/signup_page.dart';
import 'package:flutter_blog_clean_architecture/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:flutter_blog_clean_architecture/features/blog/presentation/pages/blog_page.dart';
import 'package:flutter_blog_clean_architecture/features/blog/presentation/pages/blog_viewer_page.dart';
import 'package:flutter_blog_clean_architecture/init_dependencies.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  GoRouter goRouter = GoRouter(
      errorPageBuilder: (context, state) => _errorPage(state),
      routes: [
        GoRoute(
          path: RouteNames.login,
          name: RouteNames.login,
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: RouteNames.blogPage,
          name: RouteNames.blogPage,
          builder: (context, state) => const BlogPage(),
        ),
        GoRoute(
          path: RouteNames.signUp,
          name: RouteNames.signUp,
          builder: (context, state) => const SignUpPage(),
        ),
        GoRoute(
          path: RouteNames.addBlog,
          name: RouteNames.addBlog,
          builder: (context, state) => const AddNewBlogPage(),
        ),
        GoRoute(
          path: RouteNames.blogView,
          name: RouteNames.blogView,
          builder: (context, state) => BlogViewerPage(
            blog: serviceLocator(),
          ),
        ),
      ]);
}

MaterialPage<dynamic> _errorPage(GoRouterState state) {
  return MaterialPage(
    key: state.pageKey,
    child: _errorPageContent(state),
  );
}

Scaffold _errorPageContent(GoRouterState state) {
  return Scaffold(
    appBar: AppBar(title: const Text('Error')),
    body: Center(child: Text(state.error.toString())),
  );
}
