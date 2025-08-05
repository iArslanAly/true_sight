import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:true_sight/core/constants/colors.dart';
import 'package:true_sight/core/constants/image_strings.dart';
import 'package:true_sight/core/constants/sizes.dart';
import 'package:true_sight/core/constants/text_strings.dart';
import 'package:true_sight/core/validators/validators.dart';
import 'package:true_sight/features/auth/presentation/blocs/authCubit/auth_cubit.dart';
import 'package:true_sight/features/auth/presentation/blocs/authCubit/auth_form_state.dart';
import 'package:true_sight/widgets/form_divider.dart';
import 'package:true_sight/widgets/password_field.dart';
import 'package:true_sight/widgets/social_button.dart';

class XLoginForm extends StatelessWidget {
  const XLoginForm({super.key});

  void _loadCredentialsOnce(BuildContext context) {
    Future.microtask(
      () => context.read<AuthFormCubit>().loadSavedCredentials(),
    );
  }

  void submitLogin(BuildContext context) async {}

  @override
  Widget build(BuildContext context) {
    // Trigger the loading once after build
    _loadCredentialsOnce(context);

    final formCubit = context.read<AuthFormCubit>();
    final formKey = formCubit.formKey;

    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: Column(
        children: [
          /// Email Field
          TextFormField(
            controller: formCubit.emailController,
            autovalidateMode: AutovalidateMode.onUnfocus,
            keyboardType: TextInputType.emailAddress,
            validator: EValidators.validateEmail,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email_outlined, color: XColors.secondary),
              labelText: XTextStrings.authEmail,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: XSizes.spaceBtwInputFields),

          /// Password Field
          EPasswordField(controller: formCubit.passwordController),
          const SizedBox(height: XSizes.spaceBtwInputFields / 2),

          /// Remember Me and Forgot Password
          BlocBuilder<AuthFormCubit, AuthFormState>(
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: state.rememberMe,
                        onChanged: (value) =>
                            context.read<AuthFormCubit>().toggleRememberMe(),
                      ),
                      Text(XTextStrings.authRememberMe),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      context.push('/forgot-password');
                    },
                    child: Text(XTextStrings.authForgotPasswordButton),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: XSizes.spaceBtwSections),

          /// Login Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => submitLogin(context),
              child: Text(XTextStrings.authLoginButton),
            ),
          ),
          const SizedBox(height: XSizes.spaceBtwItems),

          /// Divider
          XFormDivider(text: XTextStrings.authOrWith),
          const SizedBox(height: XSizes.spaceBtwItems),

          /// Social Buttons
          SocialButton(
            imagePath: XImages.google,
            buttonText: 'Continue with Google',
            onPressed: () {},
          ),

          /// Don't have an account?
          const SizedBox(height: XSizes.spaceBtwItems),
          GestureDetector(
            onTap: () {
              context.go('/signup');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  XTextStrings.authDontHaveAccount,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  XTextStrings.authSignupButtonText,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: XColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
