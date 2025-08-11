import 'package:fpdart/fpdart.dart';
import 'package:true_sight/core/error/failure.dart';
import 'package:true_sight/core/utils/usecase/usecases.dart';
import 'package:true_sight/features/auth/domain/entities/user_entity.dart';
import 'package:true_sight/features/auth/domain/repositories/auth_repository.dart';

// UseCase for login with email and password
class LoginUser extends UseCase<UserEntity, LoginUserParams> {
  final AuthRepository repository;

  LoginUser(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginUserParams params) {
    return repository.loginWithEmail(
      email: params.email,
      password: params.password,
    );
  }
}

// Parameters class for login
class LoginUserParams {
  final String email;
  final String password;

  LoginUserParams({required this.email, required this.password});
}
