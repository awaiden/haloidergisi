class News {
  const News({
    required this.id,
    required this.slug,
    required this.title,
    required this.content,
    required this.createdAt,
    this.publishedAt,
    this.keywords = const [],
    this.authorName,
  });

  final String id;
  final String slug;
  final String title;

  /// Markdown.
  final String content;
  final DateTime createdAt;
  final DateTime? publishedAt;
  final List<String> keywords;
  final String? authorName;

  DateTime get date => publishedAt ?? createdAt;
}
