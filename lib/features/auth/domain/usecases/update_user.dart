import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:true_sight/core/error/failure.dart';
import 'package:true_sight/core/utils/usecase/usecases.dart';
import 'package:true_sight/features/auth/domain/entities/user_entity.dart';
import 'package:true_sight/features/auth/domain/repositories/auth_repository.dart';

class UpdateProfile extends UseCase<UserEntity, UpdateUserParams> {
  final AuthRepository repository;

  UpdateProfile(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(UpdateUserParams params) async {
    return await repository.updateProfile(
      name: params.name,
      email: params.email,
      photoUrl: params.photoUrl,
      country: params.country,
      gender: params.gender,
    );
  }
}

class UpdateUserParams {
  final String name;
  final String email;
  final String country;
  final String gender;
  final File? photoUrl;

  UpdateUserParams({
    required this.name,
    required this.email,
    required this.country,
    required this.gender,
    required this.photoUrl,
  });
}
