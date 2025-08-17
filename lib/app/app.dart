import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:true_sight/core/cubits/theme_cubit.dart';
import 'package:true_sight/routes/app_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocBuilder<ThemeCubit, ThemeData>(
          builder: (context, theme) {
            return MaterialApp.router(
              theme: theme,
              title: 'TrueSight',
              routerConfig: appRouter,
              debugShowCheckedModeBanner: false,
            );
          },
        );
      },
    );
  }
}
