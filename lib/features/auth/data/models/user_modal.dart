import 'package:true_sight/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.uid,
    required super.email,
    required super.name,
    required super.emailVerified,
    required super.provider,
    required super.createdAt,
    required super.photoUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      emailVerified: json['emailVerified'] as bool,
      provider: json['provider'] as String,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      photoUrl: json['photoUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'emailVerified': emailVerified,
      'provider': provider,
      'createdAt': createdAt?.toIso8601String(),
      'photoUrl': photoUrl,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      email: email,
      name: name,
      emailVerified: emailVerified,
      provider: provider,
      createdAt: createdAt,
      photoUrl: photoUrl,
    );
  }
}
