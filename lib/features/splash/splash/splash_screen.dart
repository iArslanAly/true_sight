import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:true_sight/core/constants/colors.dart';
import 'package:true_sight/core/constants/image_strings.dart';
import 'package:true_sight/core/utils/status/auth_status.dart';
import 'package:true_sight/core/widgets/flashbar_helper.dart';
import 'package:true_sight/features/auth/presentation/bloc/auth_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(AuthGetLoggedInUserEvent());
    });

    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.status is AuthSuccess) {
              context.go('/upload');
            } else if (state.status is AuthFailure) {
              final failure = (state.status as AuthFailure);
              FlushbarHelper.showError(
                context,
                title: 'Signup Failed',
                message: failure.errorMessage,
              );
              context.go('/welcome');
            }
          },
        ),
      ],
      child: Container(
        color: XColors.primary,
        child: Center(
          child: Image.asset(XImages.appIcon, width: 220.w, height: 220.h),
        ),
      ),
    );
  }
}
