import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:true_sight/core/constants/sizes.dart';
import 'package:true_sight/core/constants/text_strings.dart';
import 'package:true_sight/core/localStorage/remember_me.dart';
import 'package:true_sight/core/logging/logger.dart';
import 'package:true_sight/core/utils/navigation_helper.dart';
import 'package:true_sight/core/utils/status/auth_status.dart';
import 'package:true_sight/core/widgets/flashbar_helper.dart';
import 'package:true_sight/core/widgets/loading_dialogue.dart';
import 'package:true_sight/features/auth/presentation/bloc/auth_bloc.dart';
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
      context.read<AuthBloc>().add(
        AuthLoginEvent(email: email, password: password),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formCubit = context.read<LoginFormCubit>();
    final extras = GoRouterState.of(context).extra as Map<String, String>?;

    if (extras != null && extras.isNotEmpty && LoginExtrasCache.consumeOnce()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FlushbarHelper.showSuccess(
          context,
          title: extras['title'] ?? '',
          message: extras['message'] ?? '',
        );
      });
    }

    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status is AuthLoading) {
            LoadingDialog.show(context);
          } else {
            LoadingDialog.hide(context);
          }
          if (state.status is AuthFailure) {
            final failure = state.status as AuthFailure;
            FlushbarHelper.showError(context, message: failure.errorMessage);
          } else if (state.status is AuthSuccess) {
            FlushbarHelper.showSuccess(
              context,
              title: 'Login successful!',
              message: 'Welcome back, ${state.user?.name ?? 'User'}!',
            );
            context.go('/home');
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(XSizes.d16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: XSizes.spaceBtwItems),
                Center(
                  child: Text(
                    XTextStrings.authLoginButton,
                    style: Theme.of(context).textTheme.headlineMedium!.apply(
                      fontWeightDelta: XSizes.i5,
                    ),
                  ),
                ),
                const SizedBox(height: XSizes.spaceBtwItems),
                SizedBox(
                  width: XSizes.d300,
                  child: Text(
                    XTextStrings.authLoginTitle,
                    style: Theme.of(context).textTheme.headlineMedium!.apply(
                      fontWeightDelta: XSizes.i2,
                    ),
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
                  onGoogleLogin: () =>
                      context.read<AuthBloc>().add(AuthGoogleLoginEvent()),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
