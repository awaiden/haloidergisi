import '../entities/post.dart';
import '../repositories/posts_repository.dart';

class GetCategories {
  const GetCategories(this._repository);

  final PostsRepository _repository;

  Future<List<PostCategory>> call() => _repository.getCategories();
}
