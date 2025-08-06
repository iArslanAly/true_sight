import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:true_sight/core/constants/sizes.dart';
import 'package:true_sight/core/constants/text_strings.dart';
import 'package:true_sight/core/localStorage/remember_me.dart';
import 'package:true_sight/core/logging/logger.dart';
import 'package:true_sight/features/auth/presentation/cubit/login/login_form_cubit.dart';
import 'package:true_sight/widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  void _handleLogin(BuildContext context) {
    final formCubit = context.read<LoginFormCubit>();
    final formKey = formCubit.formKey;
    if (formKey.currentState?.validate() ?? false) {
      final email = formCubit.emailController.text.trim();
      final password = formCubit.passwordController.text.trim();
      final remember = formCubit.state.rememberMe;

      /// Persist or clear
      if (remember) {
        RememberMeStorage.saveCredentials(email, password);
      } else {
        RememberMeStorage.clearCredentials(resetRememberFlag: true);
      }
      XLoggerHelper.debug(
        'Login with Email: $email, Password: $password, Remember: $remember',
      );
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final formCubit = context.read<LoginFormCubit>();
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(XSizes.d16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: XSizes.spaceBtwItems),
            Center(
              child: Text(
                XTextStrings.authLoginButton,
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium!.apply(fontWeightDelta: XSizes.i5),
              ),
            ),
            const SizedBox(height: XSizes.spaceBtwItems),
            SizedBox(
              width: XSizes.d300,
              child: Text(
                XTextStrings.authLoginTitle,
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium!.apply(fontWeightDelta: XSizes.i2),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 60.h),
            XLoginForm(
              formKey: formCubit.formKey,
              emailController: formCubit.emailController,
              passwordController: formCubit.passwordController,
              onLogin: () => _handleLogin(context),
              onForgotPassword: () => context.go('/forgot-password'),
              onSignup: () => context.go('/signup'),
              onGoogleLogin: () {
                // Handle Google login logic here
              },
            ),
          ],
        ),
      ),
    );
  }
}
