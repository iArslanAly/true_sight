import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:true_sight/core/constants/sizes.dart';
import 'package:true_sight/core/constants/text_strings.dart';
import 'package:true_sight/core/logging/logger.dart';
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

      XLoggerHelper.debug(
        'Signup with Name: $name, Email: $email, Password: $password',
      );
      // Dispatch your signup event (or call your use-case)
      // context.read<AuthBloc>().add(SignupRequested(name, email, password));

      // Or immediately navigate:
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final formCubit = context.read<SignupFormCubit>();
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
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
                onGoogleLogin: () {
                  // Handle Google signup logic here
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
