import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:true_sight/core/error/failure.dart';
import 'package:true_sight/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> loginWithEmail({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> signup({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> signInWithGoogle();

  Future<Either<Failure, UserEntity?>> getLoggedInUser();
  Future<Either<Failure, bool>> isEmailVerified();
  Future<Either<Failure, void>> resendVerificationEmail();

  Future<Either<Failure, bool>> sendOtp({required String email});

  Future<Either<Failure, bool>> verifyOtp({required String otp});

  Future<Either<Failure, bool>> updatePassword({
    required String email,
    required String newPassword,
  });

  Future<Either<Failure, bool>> logout();
  Future<Either<Failure, UserEntity>> updateProfileImage(File imageFile);
}
