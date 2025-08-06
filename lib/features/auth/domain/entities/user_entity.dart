class UserEntity {
  final String uid;
  final String email;
  final String name;
  final bool emailVerified;
  final String provider;
  final DateTime? createdAt;
  final String? photoUrl;

  const UserEntity({
    required this.uid,
    required this.email,
    required this.name,
    required this.emailVerified,
    required this.provider,
    this.createdAt,
    this.photoUrl,
  });
}
