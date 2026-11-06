class PostCategory {
  const PostCategory({required this.id, required this.name});

  final String id;
  final String name;
}

/// A magazine issue: cover, markdown description and an optional PDF.
class Post {
  const Post({
    required this.id,
    required this.slug,
    required this.title,
    required this.createdAt,
    this.content,
    this.coverImage,
    this.attachment,
    this.category,
  });

  final String id;
  final String slug;
  final String title;
  final DateTime createdAt;
  final String? content;

  /// CDN paths; resolve with `cdnUrl`.
  final String? coverImage;
  final String? attachment;

  final PostCategory? category;
}
