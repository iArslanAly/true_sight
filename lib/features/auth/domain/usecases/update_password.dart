import 'package:fpdart/fpdart.dart';
import 'package:true_sight/core/error/failure.dart';
import 'package:true_sight/core/utils/usecase/usecases.dart';
import 'package:true_sight/features/auth/domain/repositories/auth_repository.dart';

class UpdatePassword extends UseCase<void, UpdatePasswordParams> {
  final AuthRepository repository;

  UpdatePassword(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdatePasswordParams params) {
    return repository.updatePassword(
      email: params.email,
      newPassword: params.newPassword,
    );
  }
}

class UpdatePasswordParams {
  final String email;
  final String newPassword;

  UpdatePasswordParams({required this.email, required this.newPassword});
}
