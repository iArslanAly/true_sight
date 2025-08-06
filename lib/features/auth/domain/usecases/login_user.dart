import 'package:fpdart/fpdart.dart';
import 'package:true_sight/core/error/failure.dart';
import 'package:true_sight/features/auth/domain/entities/user_entity.dart';
import 'package:true_sight/features/auth/domain/repositories/auth_repository.dart';

abstract class LoginUser {
  final AuthRepository repository;

  LoginUser(this.repository);

  Future<Either<Failure, UserEntity>> call(String email, String password) {
    return repository.loginWithEmail(email:email, password:password);
  }
}
