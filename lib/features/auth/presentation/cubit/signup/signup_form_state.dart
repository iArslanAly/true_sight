class SignupFormState {
  final bool isPasswordVisible;

  const SignupFormState({this.isPasswordVisible = true});

  SignupFormState copyWith({bool? isPasswordVisible}) {
    return SignupFormState(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }
  
}
