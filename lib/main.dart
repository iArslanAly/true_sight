// lib/main.dart
import 'package:flutter/material.dart';
import 'routes/app_router.dart';

void main() {
  runApp(const TrueSightApp());
}

class TrueSightApp extends StatelessWidget {
  const TrueSightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'TrueSight',
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
