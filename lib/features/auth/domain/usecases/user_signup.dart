import 'package:fpdart/fpdart.dart';
import 'package:true_sight/core/error/failure.dart';
import 'package:true_sight/core/utils/status/usecases.dart' show UseCase;
import 'package:true_sight/features/auth/domain/entities/user_entity.dart';
import 'package:true_sight/features/auth/domain/repositories/auth_repository.dart';

class SignupUser extends UseCase<UserEntity, SignupParams> {
  final AuthRepository repository;

  SignupUser(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(SignupParams params) {
    return repository.signup(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class SignupParams {
  final String name;
  final String email;
  final String password;

  SignupParams({
    required this.name,
    required this.email,
    required this.password,
  });
}
