import '../../../../core/models/paginated.dart';
import '../entities/post.dart';

abstract interface class PostsRepository {
  /// Published issues only, newest first.
  Future<Paginated<Post>> getPosts({
    required int page,
    required int limit,
    String? categoryId,
    String? search,
  });

  /// Recent published issues other than [excludeId].
  Future<List<Post>> getOtherIssues({required String excludeId, int limit = 8});

  /// Accepts either the id or the slug.
  Future<Post> getPost(String idOrSlug);

  Future<List<PostCategory>> getCategories();
}
