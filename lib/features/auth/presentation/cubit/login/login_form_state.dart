class LoginFormState {
  final bool isPasswordVisible;
  final bool rememberMe;

  const LoginFormState({
    required this.isPasswordVisible,
    required this.rememberMe,
  });

  LoginFormState copyWith({bool? isPasswordVisible, bool? rememberMe}) {
    return LoginFormState(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }
}
