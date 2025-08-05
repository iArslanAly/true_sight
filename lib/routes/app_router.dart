import 'package:go_router/go_router.dart';
import 'package:true_sight/features/auth/presentation/screens/login/login_screen.dart';
import 'package:true_sight/features/auth/presentation/screens/signup/signup_screen.dart';
import 'package:true_sight/features/detection/presentation/screens/result_screen.dart';
import 'package:true_sight/features/splash/presentation/screens/splash_screen.dart';
import 'package:true_sight/features/welcome/presentation/screens/welcome_screen.dart';
import '../features/detection/presentation/screens/upload_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',  // your splash route
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/welcome',
      name: 'welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      name: 'signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/upload',
      name: 'upload',
      builder: (context, state) => const UploadScreen(),
    ),
    GoRoute(
      path: '/result',
      name: 'result',
      builder: (context, state) => const ResultScreen(),
    ),
  ],
);
