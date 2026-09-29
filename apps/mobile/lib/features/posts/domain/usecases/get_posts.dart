import '../../../../core/models/paginated.dart';
import '../entities/post.dart';
import '../repositories/posts_repository.dart';

class GetPosts {
  const GetPosts(this._repository);

  final PostsRepository _repository;

  Future<Paginated<Post>> call({
    required int page,
    required int limit,
    String? categoryId,
    String? search,
  }) {
    final query = search?.trim();
    return _repository.getPosts(
      page: page,
      limit: limit,
      categoryId: categoryId,
      search: query == null || query.isEmpty ? null : query,
    );
  }
}
