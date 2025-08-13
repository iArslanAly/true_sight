// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:true_sight/core/constants/colors.dart';
import 'package:true_sight/core/constants/image_strings.dart';
import 'package:true_sight/core/constants/sizes.dart';
import 'package:true_sight/core/constants/text_strings.dart';
import 'package:true_sight/core/validators/validators.dart';
import 'package:true_sight/features/auth/presentation/cubit/login/login_form_cubit.dart';
import 'package:true_sight/features/auth/presentation/cubit/login/login_form_state.dart';
import 'package:true_sight/features/auth/presentation/widgets/form_divider.dart';
import 'package:true_sight/features/auth/presentation/widgets/password_field.dart';
import 'package:true_sight/features/auth/presentation/widgets/social_button.dart';

class XLoginForm extends StatelessWidget {
  const XLoginForm({
    super.key,
    required this.onLogin,
    required this.onForgotPassword,
    required this.onSignup,
    required this.onGoogleLogin,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });
  final VoidCallback onLogin;
  final VoidCallback onForgotPassword;
  final VoidCallback onSignup;
  final VoidCallback onGoogleLogin;
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    Future.microtask(
      () => context.read<LoginFormCubit>().loadSavedCredentials(),
    );

    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: Column(
        children: [
          /// Email Field
          TextFormField(
            controller: emailController,
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
          EPasswordField(controller: passwordController),
          const SizedBox(height: XSizes.spaceBtwInputFields / 2),

          /// Remember Me and Forgot Password
          BlocBuilder<LoginFormCubit, LoginFormState>(
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: state.rememberMe,
                        onChanged: (value) =>
                            context.read<LoginFormCubit>().toggleRememberMe(),
                      ),
                      Text(XTextStrings.authRememberMe),
                    ],
                  ),
                  TextButton(
                    onPressed: onForgotPassword,
                    child: Text(XTextStrings.authForgotPasswordButton),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 30.h),

          /// Login Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onLogin,
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
            onPressed: onGoogleLogin,
          ),

          /// Don't have an account?
          const SizedBox(height: XSizes.spaceBtwItems),
          GestureDetector(
            onTap: onSignup,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  XTextStrings.authDontHaveAccount,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  XTextStrings.authSignupButtonText,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: XColors.secondary,
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
