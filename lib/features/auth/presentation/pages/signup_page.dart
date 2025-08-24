
import 'package:bloggg/core/common/utils/show_snackbar.dart';
import 'package:bloggg/core/common/widgets/loader.dart';
import 'package:bloggg/features/auth/presentation/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../blog/presention/pages/blog_page.dart';
import '../widgets/auth_field.dart';
import '../widgets/auth_gradient_button.dart';
import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context)=>SignUpPage());

  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController= TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (authProvider.error != null) {
                showSnackBar(context, authProvider.error!);
                authProvider.reset();
              } else if (authProvider.isLoggedIn) {
                authProvider.reset();
                Navigator.pushAndRemoveUntil(
                  context,
                  BlogPage.route(),
                      (route) => false,
                );
              }


            });

            if (authProvider.isLoading) {
              return const Loader();
            }

            return Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  AuthField(
                    hintText: 'Name',
                    controller: nameController,
                  ),
                  const SizedBox(height: 15),
                  AuthField(
                    hintText: 'Email',
                    controller: emailController,
                  ),
                  const SizedBox(height: 15),
                  AuthField(
                    hintText: 'Password',
                    controller: passwordController,
                    isObscureText: true,
                  ),
                  const SizedBox(height: 20),
                  AuthGradientButton(
                    buttonText: 'Sign Up',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        authProvider.signUp(
                          name: nameController.text.trim(),
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, LogInPage.route());
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account?',
                        style: Theme.of(context).textTheme.titleMedium,
                        children: [
                          TextSpan(
                            text: ' Sign In',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppPallete.gradient2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}