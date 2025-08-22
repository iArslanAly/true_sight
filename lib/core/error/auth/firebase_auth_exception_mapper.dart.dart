// firebase_auth_exception_mapper.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_exceptions.dart';

class FirebaseAuthExceptionMapper {
  static Exception map(FirebaseAuthException exception) {
    final msg = exception.message ?? 'An unknown error occurred';
    switch (exception.code) {
      case 'invalid-credential':
        return InvalidCredentialException(msg);
      case 'invalid-email':
        return InvalidEmailException(msg);
      case 'user-not-found':
        return UserNotFoundException(msg);
      case 'user-disabled':
        return UserDisabledException(msg);
      case 'wrong-password':
        return WrongPasswordException(msg);
      case 'email-already-in-use':
        return EmailAlreadyInUseException(msg);
      case 'account-exists-with-different-credential':
        return CredentialsAlreadyInUseException(msg);
      case 'operation-not-allowed':
        return OperationNotAllowedException(msg);
      case 'weak-password':
        return WeakPasswordException(msg);
      case 'too-many-requests':
        return TooManyRequestsException(msg);
      case 'network-request-failed':
        return NetworkException(msg);
      default:
        return UnknownAuthException(msg);
    }
  }
}
