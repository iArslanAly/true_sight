import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:true_sight/core/constants/sizes.dart';
import 'package:true_sight/core/constants/text_strings.dart';
import 'package:true_sight/core/utils/status/auth_status.dart';
import 'package:true_sight/core/widgets/flashbar_helper.dart';
import 'package:true_sight/core/widgets/loading_dialogue.dart';
import 'package:true_sight/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:true_sight/features/auth/presentation/cubit/signup/signup_form_cubit.dart';
import 'package:true_sight/widgets/signup_form.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  void _handleSignup(BuildContext context) {
    final formCubit = context.read<SignupFormCubit>();
    final formKey = formCubit.formKey;

    if (formKey.currentState?.validate() ?? false) {
      final name = formCubit.nameController.text.trim();
      final email = formCubit.emailController.text.trim();
      final password = formCubit.passwordController.text.trim();
      // Dispatch your signup event (or call your use-case)
      context.read<AuthBloc>().add(
        AuthSignupEvent(name: name, email: email, password: password),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formCubit = context.read<SignupFormCubit>();
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
            final failure = (state.status as AuthFailure);

            FlushbarHelper.showError(
              context,
              title: 'Signup Failed',
              message: failure.errorMessage,
            );
          } else if (state.status is AuthSuccess) {
            final user = (state.status as AuthSuccess).data;
            context.go(
              '/login',
              extra: {
                'title': 'Signup Successful!',
                'message':
                    'Welcome, ${user.name}. Email sent to ${user.email}. Please verify your email.',
              },
            );
            formCubit.close();
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(XSizes.d16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: XSizes.spaceBtwItems),
                  Center(
                    child: Text(
                      XTextStrings.authSignupButtonText,
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium!.apply(fontWeightDelta: 5),
                    ),
                  ),
                  const SizedBox(height: XSizes.spaceBtwItems),
                  SizedBox(
                    width: XSizes.d300,
                    child: Text(
                      XTextStrings.authSignupTitle,
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium!.apply(fontWeightDelta: 2),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(height: XSizes.spaceBtwSections),
                  SignupForm(
                    formKey: formCubit.formKey,
                    nameController: formCubit.nameController,
                    emailController: formCubit.emailController,
                    passwordController: formCubit.passwordController,
                    onLogin: () => context.go('/login'),
                    onSignup: () => _handleSignup(context),
                    onGoogleLogin: () =>
                        context.read<AuthBloc>().add(AuthGoogleLoginEvent()),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
