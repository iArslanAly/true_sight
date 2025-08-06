import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:true_sight/features/auth/presentation/cubit/login/login_form_cubit.dart';
import 'package:true_sight/features/auth/presentation/cubit/resend_cooldown_cubit.dart';
import 'package:true_sight/features/auth/presentation/cubit/signup/signup_form_cubit.dart';

class AppProviders {
  static MultiBlocProvider buildBlocs(Widget child) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginFormCubit()),
        BlocProvider(create: (context) => SignupFormCubit()),
        BlocProvider(create: (context) => ResendCooldownCubit()),
      ],
      child: child,
    );
  }
}
