import 'package:fpdart/fpdart.dart';
import 'package:true_sight/core/error/failure.dart';

import '../repositories/auth_repository.dart';

abstract class VerifyOtp {
  final AuthRepository repository;
  VerifyOtp(this.repository);
  Future<Either<Failure, bool>> call({required String otp}) {
    return repository.verifyOtp(otp: otp);
  }
}
