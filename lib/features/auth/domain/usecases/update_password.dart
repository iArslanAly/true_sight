import 'package:fpdart/fpdart.dart';
import 'package:true_sight/core/error/failure.dart';
import 'package:true_sight/features/auth/domain/repositories/auth_repository.dart';

abstract class UpdatePassword {
  final AuthRepository repository;

  UpdatePassword(this.repository);

  Future<Either<Failure, void>> call({
    required String email,
    required String newPassword,
  }) {
    return repository.updatePassword(email: email, newPassword: newPassword);
  }
}
