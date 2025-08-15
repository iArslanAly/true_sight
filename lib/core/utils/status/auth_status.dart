import 'package:meta/meta.dart';

@immutable
abstract class AuthStatus {
  const AuthStatus();

  get showSettings => null;
}

class AuthInitial extends AuthStatus {
  const AuthInitial();
}

class AuthLoading extends AuthStatus {}

class AuthSuccess extends AuthStatus {
  final dynamic data;
  final String message;
  final bool otpSent;
  final bool otpVerified;

  const AuthSuccess({
    this.data,
    this.message = '',
    this.otpSent = false,
    this.otpVerified = false,
  });
}

class AuthFailure extends AuthStatus {
  final bool isEmailNotVerified;
  final dynamic errorCode;
  final String errorMessage;
  @override
  final bool showSettings;
  final bool isOtpInvalid;

  const AuthFailure(
    this.errorMessage, {
    this.showSettings = false,
    this.isEmailNotVerified = false,
    this.errorCode,
    this.isOtpInvalid = false,
  });
}

class AuthResendEmailSuccess extends AuthStatus {
  final String message;
  const AuthResendEmailSuccess(this.message);
}

class AuthLoggedOut extends AuthStatus {}
