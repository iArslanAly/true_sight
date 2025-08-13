part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

/// 1. AuthLoginEvent
class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginEvent({required this.email, required this.password});
}

/// 2. AuthRegisterEvent
class AuthSignupEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const AuthSignupEvent({
    required this.name,
    required this.email,
    required this.password,
  });
}

/// 3. AuthLogoutEvent
class AuthLogoutEvent extends AuthEvent {
  const AuthLogoutEvent();
}

/// 4. AuthReloadUserEvent
class AuthGetLoggedInUserEvent extends AuthEvent {
  const AuthGetLoggedInUserEvent();
}

/// 5. AuthResendVerifyEmailEvent
class AuthResendVerifyEmailEvent extends AuthEvent {
  ///final String email;

  const AuthResendVerifyEmailEvent();
}

/// 6. AuthCheckEmailVerified
class AuthCheckEmailVerified extends AuthEvent {}

/// 7. AuthSendOtpEvent
class AuthSendOtpEvent extends AuthEvent {
  final String email;

  const AuthSendOtpEvent({required this.email});
}

/// 8. AuthVerifyOtpEvent
class AuthVerifyOtpEvent extends AuthEvent {
  final String otp;

  const AuthVerifyOtpEvent({required this.otp});
}

/// 9. AuthUpdatePasswordEvent
class AuthUpdatePasswordEvent extends AuthEvent {
  final String email;
  final String newPassword;

  const AuthUpdatePasswordEvent({
    required this.email,
    required this.newPassword,
  });
}

/// 10. AuthGoogleLoginEvent
class AuthGoogleLoginEvent extends AuthEvent {}

class AuthResetEvent extends AuthEvent {}
