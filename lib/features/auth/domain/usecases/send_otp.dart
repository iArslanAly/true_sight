import 'package:fpdart/fpdart.dart';
import 'package:true_sight/core/error/failure.dart';
import 'package:true_sight/features/auth/domain/repositories/auth_repository.dart';

abstract class SendOtp {
  final AuthRepository repository;

  SendOtp(this.repository);

  Future<Either<Failure, bool>> call(String email) {
    return repository.sendOtp(email: email);
  }
}
