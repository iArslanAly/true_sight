// exception_to_failure.dart
import 'dart:io';
import 'package:true_sight/core/error/failure.dart';
import 'auth_exceptions.dart';
import '../api_exception.dart';

class ExceptionToFailure {
  static Failure map(Object e) {
    // If remote wrapped a Failure and rethrew (legacy), handle it:
    if (e is Failure) return e;

    // ApiException contains a Failure already
    if (e is ApiException) return e.failure;

    // Auth exceptions
    if (e is InvalidEmailException) return const InvalidEmailFailure();
    if (e is InvalidCredentialException) return const InvalidCredentialFailure();
    if (e is UserNotFoundException) return const UserNotFoundFailure();
    if (e is UserDisabledException) return const UserDisabledFailure();
    if (e is WrongPasswordException) return const WrongPasswordFailure();
    if (e is EmailAlreadyInUseException) return const EmailAlreadyInUseFailure();
    if (e is CredentialsAlreadyInUseException) return const CredentialsAlreadyInUseFailure();
    if (e is OperationNotAllowedException) return const OperationNotAllowedFailure();
    if (e is WeakPasswordException) return const WeakPasswordFailure();
    if (e is TooManyRequestsException) return const TooManyRequestsFailure();
    if (e is NetworkException) return const NetworkFailure();
    if (e is EmailNotVerifiedException) return const EmailNotVerifiedFailure();
    if (e is SigninTimeoutException) return const SigninTimeoutFailure();
    if (e is SignupTimeoutException) return const SignupTimeoutFailure();

    // Socket-level
    if (e is SocketException) return const ServerUnreachableFailure();

    // Fallback
    return const UnknownAuthFailure();
  }
}
