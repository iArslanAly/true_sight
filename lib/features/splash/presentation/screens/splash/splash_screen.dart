import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:true_sight/core/constants/colors.dart';
import 'package:true_sight/core/constants/image_strings.dart';
import 'package:true_sight/core/utils/status/api_status.dart';
import 'package:true_sight/features/splash/presentation/bloc/splash_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashBloc()..add(SplashStarted()),
      child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state.status is ApiSuccess) {
            context.go('/welcome');
          }
        },
        child: Container(
          color: XColors.primary,
          child: Center(
            child: Image.asset(XImages.appIcon, width: 220.w, height: 220.h),
          ),
        ),
      ),
    );
  }
}
