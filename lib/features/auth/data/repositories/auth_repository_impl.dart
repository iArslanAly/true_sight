import 'package:fpdart/fpdart.dart';
import 'package:true_sight/core/error/failure.dart';
import 'package:true_sight/features/auth/domain/entities/user_entity.dart';
import 'package:true_sight/features/auth/domain/repositories/auth_repository.dart';

import 'package:true_sight/features/auth/data/datasource/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  AuthRepositoryImpl({required this.remoteDataSource});
  @override
  @override
  Future<Either<Failure, UserEntity?>> getLoggedInUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      return Right(user?.toEntity());
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.loginWithEmail(email, password);
      if (user == null) {
        return Left(ServerFailure(message: "User is null"));
      }
      return Right(user.toEntity());
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.signup(name, email, password);

      if (user == null) {
        return Left(ServerFailure(message: "User is null after sign up"));
      }

      return Right(user.toEntity());
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isEmailVerified() async {
    try {
      final result = await remoteDataSource.isEmailVerified();
      return Right(result);
    } on Failure catch (f) {
      return Left(f);
    } catch (_) {
      return const Left(UnknownAuthFailure());
    }
  }

  @override
  Future<Either<Failure, void>> resendVerificationEmail() async {
    try {
      await remoteDataSource.resendVerificationEmail();
      return const Right(null); // Success
    } on Failure catch (failure) {
      return Left(failure);
    } catch (_) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(true);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    try {
      final user = await remoteDataSource.signInWithGoogle();

      if (user == null) {
        return Left(
          ServerFailure(message: "Google Sign-In returned null user"),
        );
      }

      return Right(user.toEntity());
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> updatePassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      await remoteDataSource.updatePassword(email, newPassword);
      return const Right(true);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> sendOtp({required String email}) async {
    try {
      await remoteDataSource.sendOtp(email);
      return const Right(true);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> verifyOtp({required String otp}) async {
    try {
      await remoteDataSource.verifyOtp(otp);
      return const Right(true);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(UnknownFailure());
    }
  }
}
