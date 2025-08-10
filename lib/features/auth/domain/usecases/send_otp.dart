import 'package:fpdart/fpdart.dart';
import 'package:true_sight/core/error/failure.dart';
import 'package:true_sight/core/utils/usecases.dart' show UseCase;
import 'package:true_sight/features/auth/domain/repositories/auth_repository.dart';

class SendOtp extends UseCase<bool, SendOtpParams> {
  final AuthRepository repository;

  SendOtp(this.repository);

  @override
  Future<Either<Failure, bool>> call(SendOtpParams params) {
    return repository.sendOtp(email: params.email);
  }
}

class SendOtpParams {
  final String email;

  SendOtpParams({required this.email});
}
