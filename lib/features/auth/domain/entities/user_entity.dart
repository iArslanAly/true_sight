class UserEntity {
  final String uid;
  final String name;
  final String email;
  final String? gender;
  final String provider;
  final String? country;
  final String? photoUrl;
  final bool emailVerified;
  final DateTime? createdAt;

  const UserEntity({
    required this.uid,
    required this.name,
    required this.email,
    required this.emailVerified,
    required this.provider,
    this.photoUrl,
    this.country,
    this.gender,
    this.createdAt,
  });
}
