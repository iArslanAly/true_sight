import 'package:flutter/material.dart';
import 'package:true_sight/core/constants/sizes.dart';
import 'package:true_sight/core/constants/text_strings.dart';
import 'package:true_sight/widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(height: XSizes.spaceBtwSections),
            const XLoginForm(),
          ],
        ),
      ),
    );
  }
}
