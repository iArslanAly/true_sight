import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:true_sight/features/auth/presentation/cubit/signup/signup_form_state.dart';

class SignupFormCubit extends Cubit<SignupFormState> {
  SignupFormCubit() : super(const SignupFormState(isPasswordVisible: true));

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  @override
  Future<void> close() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    return super.close();
  }
}
