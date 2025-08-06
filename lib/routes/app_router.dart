import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:true_sight/features/auth/presentation/screens/forgotPassword/forgot_password.dart';
import 'package:true_sight/features/auth/presentation/screens/forgotPassword/update_password.dart';
import 'package:true_sight/features/auth/presentation/screens/login/login_screen.dart';
import 'package:true_sight/features/auth/presentation/screens/signup/signup_screen.dart';
import 'package:true_sight/features/auth/presentation/screens/forgotPassword/otp_verification_screen.dart';
import 'package:true_sight/features/detection/presentation/screens/result_screen.dart';
import 'package:true_sight/features/splash/presentation/screens/splash/splash_screen.dart';
import 'package:true_sight/features/splash/presentation/screens/welcome/welcome_screen.dart';

import '../features/detection/presentation/screens/upload_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <GoRoute>[
    smoothFadeRoute(path: '/', name: 'splash', child: const SplashScreen()),
    smoothFadeRoute(
      path: '/welcome',
      name: 'welcome',
      child: const WelcomeScreen(),
    ),
    smoothFadeRoute(path: '/login', name: 'login', child: const LoginScreen()),
    smoothFadeRoute(
      path: '/signup',
      name: 'signup',
      child: const SignupScreen(),
    ),
    smoothFadeRoute(
      path: '/forgot-password',
      name: 'forgot-password',
      child: const ForgetPasswordScreen(),
    ),
    smoothFadeRoute(
      path: '/otp',
      name: 'otp',
      child: const OtpVerificationScreen(),
    ),
    smoothFadeRoute(
      path: '/update-password',
      name: 'update-password',
      child: const UpdatePasswordScreen(),
    ),
    smoothFadeRoute(
      path: '/upload',
      name: 'upload',
      child: const UploadScreen(),
    ),
    smoothFadeRoute(
      path: '/result',
      name: 'result',
      child: const ResultScreen(),
    ),
    // add more screens here via fadeRoute(...)
  ],
);

GoRoute smoothFadeRoute({
  required String path,
  required String name,
  required Widget child,
}) {
  return GoRoute(
    path: path,
    name: name,
    pageBuilder: (context, state) => CustomTransitionPage(
      key: state.pageKey,
      child: child,
      // a bit longer so you really feel the fade
      transitionDuration: const Duration(milliseconds: 450),
      transitionsBuilder: (ctx, animation, secondaryAnimation, ch) {
        // wrap in an easeInOut curve
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        );
        return FadeTransition(opacity: curved, child: ch);
      },
    ),
  );
}
