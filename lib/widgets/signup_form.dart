import 'package:flutter/material.dart';
import 'package:true_sight/core/constants/colors.dart';
import 'package:true_sight/core/constants/image_strings.dart';
import 'package:true_sight/core/constants/sizes.dart';
import 'package:true_sight/core/constants/text_strings.dart';
import 'package:true_sight/core/validators/validators.dart';
import 'package:true_sight/widgets/form_divider.dart';
import 'package:true_sight/widgets/password_field.dart';
import 'package:true_sight/widgets/social_button.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({
    super.key,
    required this.onLogin,
    required this.onSignup,
    required this.onGoogleLogin,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
  });

  final VoidCallback onLogin;
  final VoidCallback onSignup;
  final VoidCallback onGoogleLogin;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  @override
  Widget build(BuildContext context) {
    // In SignupForm:

    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: Column(
        children: [
          /// Name Field
          TextFormField(
            controller: nameController,
            validator: EValidators.validateName,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person_outline, color: XColors.secondary),
              labelText: XTextStrings.authName,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: XSizes.spaceBtwInputFields),

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
          const SizedBox(height: XSizes.spaceBtwSections),

          /// Signup Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSignup,
              child: Text(XTextStrings.authSignupButtonText),
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
          const SizedBox(height: XSizes.spaceBtwItems),

          /// Already have an account?
          GestureDetector(
            onTap: onLogin,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  XTextStrings.authAlreadyHaveAccount,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  XTextStrings.authLoginButton,
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
