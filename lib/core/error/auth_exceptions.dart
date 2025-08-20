// auth_exceptions.dart
class AuthException implements Exception {
  final String? message;
  const AuthException([this.message]);
  @override
  String toString() => 'AuthException: ${message ?? ''}';
}

class InvalidEmailException extends AuthException {
  const InvalidEmailException([super.message]);
}

class InvalidCredentialException extends AuthException {
  const InvalidCredentialException([super.message]);
}

class UserNotFoundException extends AuthException {
  const UserNotFoundException([super.message]);
}

class UserDisabledException extends AuthException {
  const UserDisabledException([super.message]);
}

class WrongPasswordException extends AuthException {
  const WrongPasswordException([super.message]);
}

class EmailAlreadyInUseException extends AuthException {
  const EmailAlreadyInUseException([super.message]);
}

class CredentialsAlreadyInUseException extends AuthException {
  const CredentialsAlreadyInUseException([super.message]);
}

class OperationNotAllowedException extends AuthException {
  const OperationNotAllowedException([super.message]);
}

class WeakPasswordException extends AuthException {
  const WeakPasswordException([super.message]);
}

class TooManyRequestsException extends AuthException {
  const TooManyRequestsException([super.message]);
}

class NetworkException extends AuthException {
  const NetworkException([super.message]);
}

class ServerException extends AuthException {
  const ServerException([String? message, int? statusCode])
    : super(
        'Server error: ${statusCode ?? ''}${message != null ? ' - $message' : ''}',
      );
}

class UnknownAuthException extends AuthException {
  const UnknownAuthException([super.message]);
}
class UnknownException extends AuthException {
  const UnknownException([super.message]);
}

class EmailNotVerifiedException extends AuthException {
  const EmailNotVerifiedException([super.message]);
}

// Timeout and other exceptions
class SigninTimeoutException extends AuthException {
  const SigninTimeoutException([super.message]);
}

class SignupTimeoutException extends AuthException {
  const SignupTimeoutException([super.message]);
}
