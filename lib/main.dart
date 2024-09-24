import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blog_clean_architecture/core/theme/app_theme.dart';
import 'package:flutter_blog_clean_architecture/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_blog_clean_architecture/features/auth/presentation/pages/signup_page.dart';
import 'package:flutter_blog_clean_architecture/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:flutter_blog_clean_architecture/init_dependencies.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();

  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
    BlocProvider(create: (_) => serviceLocator<BlogBloc>()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(428, 926),
        builder: (_, __) {
          return MaterialApp(
            title: 'Flutter Blog',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkThemeMode,
            home: const Scaffold(
              body: SignUpPage(),
            ),
          );
        });
  }
}
