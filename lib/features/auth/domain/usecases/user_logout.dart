import 'package:fpdart/fpdart.dart';
import 'package:true_sight/core/error/failure.dart';
import 'package:true_sight/core/utils/status/usecases.dart';
import 'package:true_sight/features/auth/domain/repositories/auth_repository.dart';

class UserLogout extends UseCase<void, NoParams> {
  final AuthRepository repository;

  UserLogout(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return repository.logout();
  }
}
