// failures.dart
abstract class Failure {
  final String message;
  const Failure(this.message);
}

// Common failures
class NetworkFailure extends Failure {
  const NetworkFailure() : super("Please check your internet connection.");
}

class UnknownFailure extends Failure {
  const UnknownFailure()
    : super("An unknown error occurred. Please try again.");
}

class ServerFailure extends Failure {
  ServerFailure({required String message}) : super(message);
}

// Auth-specific failures
class InvalidEmailFailure extends Failure {
  const InvalidEmailFailure() : super("The email address is not valid.");
}

class InvalidCredentialFailure extends Failure {
  const InvalidCredentialFailure()
    : super(
        "The Provided Credentials are invalid. Please check your email and password and try again.",
      );
}

class UserNotFoundFailure extends Failure {
  const UserNotFoundFailure() : super("No user found with this email.");
}

class UserNotSignedInFailure extends Failure {
  const UserNotSignedInFailure() : super("User is not signed in.");
}

class UserAlreadyVerified extends Failure {
  const UserAlreadyVerified() : super("User is already verified.");
}

class SigninTimeoutFailure extends Failure {
  const SigninTimeoutFailure() : super('Signin Timeout Failure.');
}

class UserDisabledFailure extends Failure {
  const UserDisabledFailure() : super("This user has been disabled.");
}

class WrongPasswordFailure extends Failure {
  const WrongPasswordFailure() : super("Incorrect password.");
}

class CredentialsAlreadyInUseFailure extends Failure {
  const CredentialsAlreadyInUseFailure()
    : super("This email is already in use.");
}

class EmailAlreadyInUseFailure extends Failure {
  const EmailAlreadyInUseFailure()
    : super("This email is already associated with another account.");
}

class OperationNotAllowedFailure extends Failure {
  const OperationNotAllowedFailure()
    : super("Operation not allowed. Please contact support.");
}

class WeakPasswordFailure extends Failure {
  const WeakPasswordFailure() : super("The password provided is too weak.");
}

class TooManyRequestsFailure extends Failure {
  const TooManyRequestsFailure() : super("Too many requests. Try again later.");
}

class EmailNotVerifiedFailure extends Failure {
  const EmailNotVerifiedFailure()
    : super("Email is not verified. Please check your inbox.");
}

// Custom app failures
class UserCreationFailure extends Failure {
  const UserCreationFailure() : super('User could not be created.');
}

class SignupTimeoutFailure extends Failure {
  const SignupTimeoutFailure() : super('Sign up timed out. Please try again.');
}

class UnknownAuthFailure extends Failure {
  const UnknownAuthFailure()
    : super("An unknown authentication error occurred.");
}

class GetCurrentUserTimeoutFailure extends Failure {
  GetCurrentUserTimeoutFailure() : super('Get Current User Timeout Failure');
}

class OtpSendFailure extends Failure {
  OtpSendFailure() : super('OTP Send Failure');
}

class InvalidOtpFailure extends Failure {
  InvalidOtpFailure() : super('Invalid OTP');
}

class OtpTimeoutFailure extends Failure {
  OtpTimeoutFailure() : super('OTP Timeout Failure');
}
