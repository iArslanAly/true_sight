import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:true_sight/features/auth/presentation/blocs/authCubit/auth_cubit.dart';

class AppProviders {
  static MultiBlocProvider buildBlocs(Widget child) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => AuthFormCubit())],
      child: child,
    );
  }
}
