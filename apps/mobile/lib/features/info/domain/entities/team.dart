class TeamMember {
  const TeamMember({
    required this.id,
    required this.name,
    this.title,
    this.bio,
    this.website,
    this.avatarUrl,
  });

  final String id;
  final String name;
  final String? title;
  final String? bio;
  final String? website;

  /// CDN path.
  final String? avatarUrl;
}

/// A team section ("Editörler", …) shown in `sort` order.
class Crew {
  const Crew({
    required this.id,
    required this.name,
    required this.sort,
    required this.members,
  });

  final String id;
  final String name;
  final int sort;
  final List<TeamMember> members;
}
