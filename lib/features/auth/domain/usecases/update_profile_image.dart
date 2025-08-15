import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:true_sight/core/error/failure.dart';
import 'package:true_sight/features/auth/domain/entities/user_entity.dart';
import 'package:true_sight/features/auth/domain/repositories/auth_repository.dart';

class UpdateProfileImage {
  final AuthRepository repository;
  UpdateProfileImage(this.repository);

  Future<Either<Failure, UserEntity>> call(File imageFile) {
    return repository.updateProfileImage(imageFile);
  }
}
