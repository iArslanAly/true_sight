import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:true_sight/core/constants/colors.dart';
import 'package:true_sight/core/constants/image_strings.dart';
import 'package:true_sight/core/constants/sizes.dart';
import 'package:true_sight/features/auth/presentation/widgets/social_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: XColors.primary,
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Spacer at top (optional)
              SizedBox(height: 40.h),
              // Welcome image
              Center(
                child: Image.asset(
                  XImages.welcomeImage2,
                  width: 200.w,
                  height: 200.h,
                ),
              ),
              Text(
                'TrueSight',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontFamily: 'Formula',
                  fontSize: XSizes.d48,
                  color: XColors.secondary,
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Welcome to ',
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            TextSpan(
                              text: 'TrueSight',
                              style: Theme.of(context).textTheme.headlineLarge
                                  ?.copyWith(
                                    fontFamily: 'Formula',
                                    fontSize: XSizes.d38,
                                    color: XColors.secondary,
                                  ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'Not sure if a video is real? We can help. Scan, detect, and verify in seconds. TrueSight brings truth into focus.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: XSizes.fontSizeMd,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Buttons at bottom
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () => context.go('/login'),
                    child: Text('Login'),
                  ),
                  SizedBox(height: 10.h),
                  OutlinedButton(
                    onPressed: () => context.go('/signup'),
                    child: Text('Signup'),
                  ),
                  SizedBox(height: 10.h),
                  SocialButton(
                    imagePath: XImages.google,
                    buttonText: 'Continue with Google',
                    onPressed: () {},
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
