import 'package:fpdart/fpdart.dart';
import 'package:true_sight/core/error/failure.dart';
import 'package:true_sight/core/utils/usecase/usecases.dart' show UseCase, NoParams;
import 'package:true_sight/features/auth/domain/repositories/auth_repository.dart';

import '../entities/user_entity.dart';

class GetLoggedInUser extends UseCase<UserEntity?, NoParams> {
  final AuthRepository repository;

  GetLoggedInUser(this.repository);

  @override
  Future<Either<Failure, UserEntity?>> call(NoParams params) {
    return repository.getLoggedInUser();
  }
}
