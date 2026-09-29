import '../entities/news.dart';

abstract interface class NewsRepository {
  /// Published news, newest first (the API does not paginate this list).
  Future<List<News>> getNews();

  Future<News> getNewsItem(String idOrSlug);
}
