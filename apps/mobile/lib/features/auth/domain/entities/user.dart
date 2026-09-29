class Profile {
  const Profile({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.title,
    this.bio,
    this.website,
  });

  final String id;
  final String name;
  final String? avatarUrl;
  final String? title;
  final String? bio;
  final String? website;
}

class User {
  const User({
    required this.id,
    required this.email,
    required this.roles,
    required this.createdAt,
    this.emailVerifiedAt,
    this.profile,
  });

  final String id;
  final String email;
  final List<String> roles;
  final DateTime createdAt;
  final DateTime? emailVerifiedAt;
  final Profile? profile;

  String get displayName => profile?.name ?? email;
  bool get isAdmin => roles.contains('ADMIN');
}
