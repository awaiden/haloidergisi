import '../entities/post.dart';
import '../repositories/posts_repository.dart';

class GetPost {
  const GetPost(this._repository);

  final PostsRepository _repository;

  Future<Post> call(String idOrSlug) => _repository.getPost(idOrSlug);
}
