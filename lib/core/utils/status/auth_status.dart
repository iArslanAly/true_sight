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

  const AuthSuccess({this.data, this.message = ''});
}

class AuthFailure extends AuthStatus {
  final dynamic errorCode;
  final String errorMessage;
  @override
  final bool showSettings;

  const AuthFailure(
    this.errorCode,
    this.errorMessage, {
    this.showSettings = false,
  });
}
