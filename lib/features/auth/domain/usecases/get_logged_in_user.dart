import 'package:fpdart/fpdart.dart';
import 'package:true_sight/core/error/failure.dart';
import 'package:true_sight/features/auth/domain/repositories/auth_repository.dart';

import '../entities/user_entity.dart';

abstract class GetLoggedInUser {
  final AuthRepository repository;

  GetLoggedInUser(this.repository);

  Future<Either<Failure, UserEntity?>> call() {
    return repository.getLoggedInUser();
  }
}
