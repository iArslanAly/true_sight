import 'package:fpdart/fpdart.dart';
import 'package:true_sight/core/error/failure.dart';
import 'package:true_sight/core/utils/usecases.dart';
import 'package:true_sight/features/auth/domain/entities/user_entity.dart';
import 'package:true_sight/features/auth/domain/repositories/auth_repository.dart';

// UseCase for login with email and password
class LoginUser extends UseCase<UserEntity, UserLogInParams> {
  final AuthRepository repository;

  LoginUser(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(UserLogInParams params) {
    return repository.loginWithEmail(
      email: params.email,
      password: params.password,
    );
  }
}

// Parameters class for login
class UserLogInParams {
  final String email;
  final String password;

  UserLogInParams({required this.email, required this.password});
}
