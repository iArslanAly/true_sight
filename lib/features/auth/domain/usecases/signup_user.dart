import 'package:fpdart/fpdart.dart';
import 'package:true_sight/core/error/failure.dart';
import 'package:true_sight/features/auth/domain/entities/user_entity.dart';
import 'package:true_sight/features/auth/domain/repositories/auth_repository.dart';

abstract class SignupUser {
  final AuthRepository repository;

  SignupUser(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String name,
    required String email,
    required String password,
  }) {
    return repository.signup(name: name, email: email, password: password);
  }
}
