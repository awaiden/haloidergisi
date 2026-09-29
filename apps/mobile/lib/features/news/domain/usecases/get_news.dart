import '../entities/news.dart';
import '../repositories/news_repository.dart';

class GetNews {
  const GetNews(this._repository);

  final NewsRepository _repository;

  Future<List<News>> call() => _repository.getNews();
}
