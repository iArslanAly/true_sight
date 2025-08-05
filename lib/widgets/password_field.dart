import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:true_sight/core/constants/colors.dart';
import 'package:true_sight/core/constants/text_strings.dart';
import 'package:true_sight/core/validators/validators.dart';
import 'package:true_sight/features/auth/presentation/blocs/authCubit/auth_cubit.dart';
import 'package:true_sight/features/auth/presentation/blocs/authCubit/auth_form_state.dart';

class EPasswordField extends StatelessWidget {
  final TextEditingController controller;

  const EPasswordField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthFormCubit, AuthFormState>(
      builder: (context, state) {
        return TextFormField(
          controller: controller,
          obscureText: state.isPasswordVisible,
          validator: EValidators.validatePassword,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock_outline, color: XColors.secondary),
            suffixIcon: IconButton(
              icon: Icon(
                state.isPasswordVisible
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: XColors.secondary,
              ),
              onPressed: () =>
                  context.read<AuthFormCubit>().togglePasswordVisibility(),
            ),
            labelText: XTextStrings.authPassword,
            border: const OutlineInputBorder(),
          ),
        );
      },
    );
  }
}
