import '../../../../core/models/paginated.dart';
import '../../../../core/network/api_exception.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/posts_repository.dart';
import '../datasources/posts_remote_datasource.dart';

class PostsRepositoryImpl implements PostsRepository {
  PostsRepositoryImpl(this._remote);

  final PostsRemoteDataSource _remote;

  @override
  Future<Paginated<Post>> getPosts({
    required int page,
    required int limit,
    String? categoryId,
    String? search,
  }) => _guard(() async {
    final result = await _remote.getPosts(
      page: page,
      limit: limit,
      categoryId: categoryId,
      search: search,
    );
    return result.map((model) => model.toEntity());
  });

  @override
  Future<List<Post>> getOtherIssues({required String excludeId, int limit = 8}) =>
      _guard(() async {
        final result = await _remote.getPosts(page: 1, limit: limit, excludeId: excludeId);
        return result.items.map((model) => model.toEntity()).toList();
      });

  @override
  Future<Post> getPost(String idOrSlug) =>
      _guard(() async => (await _remote.getPost(idOrSlug)).toEntity());

  @override
  Future<List<PostCategory>> getCategories() => _guard(() async {
    final models = await _remote.getCategories();
    return models.map((model) => model.toEntity()).toList();
  });

  Future<T> _guard<T>(Future<T> Function() body) async {
    try {
      return await body();
    } catch (e) {
      throw ApiException.from(e);
    }
  }
}
