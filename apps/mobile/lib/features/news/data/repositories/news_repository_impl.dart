import '../../../../core/network/api_exception.dart';
import '../../domain/entities/news.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_remote_datasource.dart';

class NewsRepositoryImpl implements NewsRepository {
  NewsRepositoryImpl(this._remote);

  final NewsRemoteDataSource _remote;

  @override
  Future<List<News>> getNews() => _guard(() async {
        final models = await _remote.getNews();
        return models.map((model) => model.toEntity()).toList();
      });

  @override
  Future<News> getNewsItem(String idOrSlug) =>
      _guard(() async => (await _remote.getNewsItem(idOrSlug)).toEntity());

  Future<T> _guard<T>(Future<T> Function() body) async {
    try {
      return await body();
    } catch (e) {
      throw ApiException.from(e);
    }
  }
}
