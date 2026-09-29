/// Editable profile fields (`PATCH /profile/:id`). Empty bio/website clear
/// the value; [avatarUrl] is only sent when a new photo was uploaded.
/// [title] ("unvan") is admin-managed: only sent when [updateTitle] is set,
/// which the API allows for admins only.
class ProfileUpdate {
  const ProfileUpdate({
    required this.name,
    this.title,
    this.bio,
    this.website,
    this.avatarUrl,
    this.updateTitle = false,
  });

  final String name;
  final String? title;
  final String? bio;
  final String? website;

  /// CDN key of a newly uploaded photo; `null` keeps the current one.
  final String? avatarUrl;
  final bool updateTitle;
}
