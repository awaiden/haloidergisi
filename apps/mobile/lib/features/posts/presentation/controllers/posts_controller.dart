import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/posts_remote_datasource.dart';
import '../../data/repositories/posts_repository_impl.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/posts_repository.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/get_post.dart';
import '../../domain/usecases/get_posts.dart';

part 'posts_controller.g.dart';

final postsRepositoryProvider = Provider<PostsRepository>(
  (ref) => PostsRepositoryImpl(PostsRemoteDataSource(ref.watch(dioProvider))),
);

@riverpod
Future<List<PostCategory>> postCategories(Ref ref) =>
    GetCategories(ref.watch(postsRepositoryProvider))();

/// "Diğer sayılarımız" on an issue page.
@riverpod
Future<List<Post>> otherIssues(Ref ref, String excludeId) =>
    ref.watch(postsRepositoryProvider).getOtherIssues(excludeId: excludeId);

@riverpod
Future<Post> postDetail(Ref ref, String idOrSlug) =>
    GetPost(ref.watch(postsRepositoryProvider))(idOrSlug);

class PostsFeedState {
  const PostsFeedState({
    required this.items,
    required this.total,
    required this.page,
    this.loadingMore = false,
    this.loadMoreError,
  });

  final List<Post> items;
  final int total;
  final int page;
  final bool loadingMore;
  final ApiException? loadMoreError;

  bool get hasMore => items.length < total;

  PostsFeedState copyWith({
    List<Post>? items,
    int? total,
    int? page,
    bool? loadingMore,
    ApiException? loadMoreError,
  }) => PostsFeedState(
    items: items ?? this.items,
    total: total ?? this.total,
    page: page ?? this.page,
    loadingMore: loadingMore ?? this.loadingMore,
    loadMoreError: loadMoreError,
  );
}

/// Paginated list of published issues for one filter combination.
@riverpod
class PostsFeed extends _$PostsFeed {
  static const pageSize = 12;

  GetPosts get _getPosts => GetPosts(ref.read(postsRepositoryProvider));

  @override
  Future<PostsFeedState> build({String? categoryId, String? search}) async {
    final first = await GetPosts(ref.watch(postsRepositoryProvider))(
      page: 1,
      limit: pageSize,
      categoryId: categoryId,
      search: search,
    );
    return PostsFeedState(items: first.items, total: first.total, page: 1);
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || current.loadingMore || !current.hasMore) return;

    state = AsyncData(current.copyWith(loadingMore: true));
    try {
      final next = await _getPosts(
        page: current.page + 1,
        limit: pageSize,
        categoryId: categoryId,
        search: search,
      );
      if (!ref.mounted) return;
      state = AsyncData(
        current.copyWith(
          items: [...current.items, ...next.items],
          total: next.total,
          page: current.page + 1,
        ),
      );
    } catch (e) {
      if (!ref.mounted) return;
      state = AsyncData(current.copyWith(loadMoreError: ApiException.from(e)));
    }
  }
}
