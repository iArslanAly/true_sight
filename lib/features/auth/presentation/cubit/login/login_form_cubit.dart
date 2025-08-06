import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:true_sight/core/localStorage/remember_me.dart';
import 'package:true_sight/features/auth/presentation/cubit/login/login_form_state.dart';

class LoginFormCubit extends Cubit<LoginFormState> {
  LoginFormCubit()
    : super(const LoginFormState(isPasswordVisible: true, rememberMe: false));

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  void toggleRememberMe() async {
    final newValue = !state.rememberMe;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remember_me', newValue);
    emit(state.copyWith(rememberMe: newValue));
  }

  Future<void> loadSavedCredentials() async {
    final remembered = await RememberMeStorage.isRemembered();

    if (remembered) {
      final (savedEmail, savedPassword) =
          await RememberMeStorage.loadCredentials();
      if (savedEmail != null && savedPassword != null) {
        emailController.text = savedEmail;
        passwordController.text = savedPassword;
      }
    }

    emit(state.copyWith(rememberMe: remembered));
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
