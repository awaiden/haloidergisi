import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/models/paginated.dart';
import 'package:mobile/core/network/api_exception.dart';
import 'package:mobile/features/posts/domain/entities/post.dart';
import 'package:mobile/features/posts/domain/repositories/posts_repository.dart';
import 'package:mobile/features/posts/presentation/controllers/posts_controller.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements PostsRepository {}

Post _post(int i) => Post(
      id: 'p$i',
      slug: 'post-$i',
      title: 'Sayı $i',
      createdAt: DateTime(2026, 1, i),
    );

Paginated<Post> _page(Iterable<int> ids, {int total = 14}) =>
    Paginated(items: ids.map(_post).toList(), total: total);

void main() {
  late _MockRepository repository;
  late ProviderContainer container;
  final feed = postsFeedProvider();

  setUp(() {
    repository = _MockRepository();
    container = ProviderContainer(
      overrides: [postsRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
  });

  // Subscribe after stubbing: subscribing builds the (auto-dispose) provider.
  Future<PostsFeedState> load() {
    container.listen(feed, (_, _) {});
    return container.read(feed.future);
  }

  void stubPage(int page, Paginated<Post> result) => when(
        () => repository.getPosts(
          page: page,
          limit: PostsFeed.pageSize,
          categoryId: any(named: 'categoryId'),
          search: any(named: 'search'),
        ),
      ).thenAnswer((_) async => result);

  test('loads the first page, then appends the next', () async {
    stubPage(1, _page(List.generate(12, (i) => i + 1)));
    stubPage(2, _page([13, 14]));

    final first = await load();
    expect(first.items, hasLength(12));
    expect(first.hasMore, isTrue);

    await container.read(feed.notifier).loadMore();

    final state = container.read(feed).value!;
    expect(state.items.map((p) => p.id).last, 'p14');
    expect(state.page, 2);
    expect(state.hasMore, isFalse);
  });

  test('does not request past the last page', () async {
    stubPage(1, _page([1, 2], total: 2));
    await load();

    await container.read(feed.notifier).loadMore();

    verifyNever(
      () => repository.getPosts(
        page: 2,
        limit: any(named: 'limit'),
        categoryId: any(named: 'categoryId'),
        search: any(named: 'search'),
      ),
    );
  });

  test('keeps loaded items and exposes the error when a page fails', () async {
    stubPage(1, _page(List.generate(12, (i) => i + 1)));
    when(
      () => repository.getPosts(
        page: 2,
        limit: PostsFeed.pageSize,
        categoryId: any(named: 'categoryId'),
        search: any(named: 'search'),
      ),
    ).thenThrow(const ApiException('Sunucuya ulaşılamıyor.'));
    await load();

    await container.read(feed.notifier).loadMore();

    final state = container.read(feed).value!;
    expect(state.items, hasLength(12));
    expect(state.loadMoreError?.message, 'Sunucuya ulaşılamıyor.');
    expect(state.loadingMore, isFalse);
  });
}
