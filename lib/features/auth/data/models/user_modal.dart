import 'package:true_sight/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.email,
    required super.name,
    required super.emailVerified,
    required super.provider,
    super.createdAt,
    super.photoUrl,
    super.country,
    super.gender,
  });

  /// Factory for creating model from JSON (e.g. Firebase document)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      emailVerified: json['emailVerified'] as bool? ?? false,
      provider: json['provider'] as String,
      country: json['country'] as String?,
      gender: json['gender'] as String?,
      photoUrl: json['photoUrl'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }

  /// Factory for creating model from Firebase `DocumentSnapshot`
  factory UserModel.fromDocument(Map<String, dynamic> doc) {
    return UserModel(
      uid: doc['uid'] as String,
      email: doc['email'] as String,
      name: doc['name'] as String,
      emailVerified: doc['emailVerified'] as bool? ?? false,
      provider: doc['provider'] as String,
      country: doc['country'] as String?,
      gender: doc['gender'] as String?,
      photoUrl: doc['photoUrl'] as String?,
      createdAt: doc['createdAt'] != null
          ? (doc['createdAt'] is DateTime
                ? doc['createdAt'] as DateTime
                : DateTime.tryParse(doc['createdAt'].toString()))
          : null,
    );
  }

  /// Convert to JSON (for Firebase or local storage)
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'emailVerified': emailVerified,
      'provider': provider,
      'country': country,
      'gender': gender,
      'photoUrl': photoUrl,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  /// Convert to domain entity
  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      email: email,
      name: name,
      emailVerified: emailVerified,
      provider: provider,
      country: country,
      gender: gender,
      photoUrl: photoUrl,
      createdAt: createdAt,
    );
  }

  /// Create model from entity (useful for saving to Firebase)
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      uid: entity.uid,
      email: entity.email,
      name: entity.name,
      emailVerified: entity.emailVerified,
      provider: entity.provider,
      country: entity.country,
      gender: entity.gender,
      photoUrl: entity.photoUrl,
      createdAt: entity.createdAt,
    );
  }
}
