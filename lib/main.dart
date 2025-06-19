import 'package:bloggg/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:bloggg/core/secrets/app_secrets.dart';
import 'package:bloggg/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:bloggg/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:bloggg/features/auth/presentation/auth_bloc.dart';
import 'package:bloggg/features/auth/presentation/pages/login_page.dart';
import 'package:bloggg/features/blog/presention/pages/blog_page.dart';
import 'package:bloggg/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/theme.dart';
import 'features/auth/domain/usecases/user_sign_up.dart';
import 'features/auth/presentation/pages/signup_page.dart';
import 'features/blog/presention/bloc/blog_bloc.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AppUserCubit>(
          create: (context) => serviceLocator<AppUserCubit>(),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => serviceLocator<AuthBloc>(),
        ),
        BlocProvider<BlogBloc>(
          create: (context) => serviceLocator<BlogBloc>(),
        ),
      ],
      child: const MyApp(),
    ),
  );

}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState(){
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blog App',
      theme: AppTheme.darkThemeMode,
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
            return state is AppUserLoggedIn;

        },
        builder: (context, isLoggedIn) {
          if(isLoggedIn){
            return const BlogPage();
          }
            return const LogInPage();
        },
      ),

    );
  }
}