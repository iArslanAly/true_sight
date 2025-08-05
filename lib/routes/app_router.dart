import 'package:go_router/go_router.dart';
import 'package:true_sight/features/detection/presentation/screens/result_screen.dart';
import '../features/detection/presentation/screens/upload_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
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
