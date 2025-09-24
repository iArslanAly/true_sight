import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:true_sight/core/cubits/permission_cubit.dart';
import 'package:true_sight/core/cubits/theme_cubit.dart';
import 'package:true_sight/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:true_sight/features/auth/presentation/cubit/login/login_form_cubit.dart';
import 'package:true_sight/features/auth/presentation/cubit/otp_cubit.dart';
import 'package:true_sight/features/auth/presentation/cubit/profile_cubit.dart';
import 'package:true_sight/features/auth/presentation/cubit/resend_cooldown_cubit.dart';
import 'package:true_sight/features/auth/presentation/cubit/signup/signup_form_cubit.dart';
import 'package:true_sight/features/detection/presentation/bloc/detection_bloc.dart';
import 'package:true_sight/service_locator.dart';

class AppProviders {
  static MultiBlocProvider buildBlocs(Widget child) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginFormCubit()),
        BlocProvider(create: (context) => SignupFormCubit()),
        BlocProvider(create: (context) => ResendCooldownCubit()),
        BlocProvider(create: (context) => OtpCubit()),
        BlocProvider(create: (context) => sl<AuthBloc>()),
        BlocProvider(create: (context) => PermissionCubit()),
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => EditProfileCubit()),
        BlocProvider(create: (context) => sl<DetectionBloc>()),
      ],
      child: child,
    );
  }
}
