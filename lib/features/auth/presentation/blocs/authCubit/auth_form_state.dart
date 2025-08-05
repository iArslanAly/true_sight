class AuthFormState {
  final bool isPasswordVisible;
  final bool rememberMe;

  const AuthFormState({
    required this.isPasswordVisible,
    required this.rememberMe,
  });

  AuthFormState copyWith({
    bool? isPasswordVisible,
    bool? rememberMe,
  }) {
    return AuthFormState(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }
}
