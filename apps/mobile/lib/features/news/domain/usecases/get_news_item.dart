import '../entities/news.dart';
import '../repositories/news_repository.dart';

class GetNewsItem {
  const GetNewsItem(this._repository);

  final NewsRepository _repository;

  Future<News> call(String idOrSlug) => _repository.getNewsItem(idOrSlug);
}
