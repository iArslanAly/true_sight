import 'package:fpdart/fpdart.dart';
import 'package:true_sight/core/error/failure.dart';
import 'package:true_sight/core/utils/usecase/usecases.dart';
import 'package:true_sight/features/auth/domain/repositories/auth_repository.dart';

class ResendVerificationEmail extends UseCase<void, NoParams> {
  final AuthRepository repository;

  ResendVerificationEmail(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.resendVerificationEmail();
  }
}
