import 'package:firebase_auth/firebase_auth.dart';
import 'package:true_sight/core/error/failure.dart';

class FirebaseAuthExceptionHandler {
  static Failure handle(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'invalid-credential':
  return const InvalidCredentialFailure();

      case 'invalid-email':
        return const InvalidEmailFailure();
      case 'user-not-found':
        return const UserNotFoundFailure();
      case 'user-disabled':
        return const UserDisabledFailure();
      case 'wrong-password':
        return const WrongPasswordFailure();
      case 'email-already-in-use':
        return const EmailAlreadyInUseFailure();
      case 'account-exists-with-different-credential':
        return const CredentialsAlreadyInUseFailure();
      case 'operation-not-allowed':
        return const OperationNotAllowedFailure();
      case 'weak-password':
        return const WeakPasswordFailure();
      case 'too-many-requests':
        return const TooManyRequestsFailure();
      case 'network-request-failed':
        return const NetworkFailure();
      default:
        return const UnknownAuthFailure();
    }
  }
}
