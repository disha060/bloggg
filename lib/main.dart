import 'package:bloggg/core/common/provider/app_user/app_user_provider.dart';
import 'package:bloggg/core/secrets/app_secrets.dart';
import 'package:bloggg/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:bloggg/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:bloggg/features/auth/presentation/auth_provider.dart';
import 'package:bloggg/features/auth/presentation/pages/login_page.dart';
import 'package:bloggg/features/blog/presention/pages/blog_page.dart';
import 'package:bloggg/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/theme.dart';
import 'features/auth/domain/usecases/user_sign_up.dart';
import 'features/auth/presentation/pages/signup_page.dart';
import 'features/blog/presention/provider/blog_provider.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => serviceLocator<AppUserProvider>()),
        ChangeNotifierProvider(create: (context) => serviceLocator<AuthProvider>()),
        ChangeNotifierProvider(create: (context) => serviceLocator<BlogProvider>()),
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().checkCurrentUser();
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blog App',
      theme: AppTheme.darkThemeMode,
      home: Consumer<AppUserProvider>(
        builder: (context, appUserProvider, _) {
          return appUserProvider.isLoggedIn
              ? const BlogPage()
              : const LogInPage();
        },
      )


    );
  }
}