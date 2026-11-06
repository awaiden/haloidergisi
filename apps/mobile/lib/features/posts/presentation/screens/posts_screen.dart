import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/utils/cdn.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/halo.dart';
import '../../data/issue_file_cache.dart';
import '../../domain/entities/post.dart';
import '../controllers/posts_controller.dart';
import '../widgets/issue_download_sheet.dart';
import '../widgets/issue_tile.dart';
import '../widgets/post_cover.dart';

/// Home: the latest issue in its halo, then the searchable archive.
class PostsScreen extends ConsumerStatefulWidget {
  const PostsScreen({super.key});

  @override
  ConsumerState<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends ConsumerState<PostsScreen> {
  final _scroll = ScrollController();
  final _searchInput = TextEditingController();
  Timer? _debounce;
  String? _search;
  String? _categoryId;

  PostsFeedProvider get _feed =>
      postsFeedProvider(categoryId: _categoryId, search: _search);

  /// The halo hero only makes sense for the unfiltered archive.
  bool get _showHero => _search == null && _categoryId == null;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.extentAfter < 600) {
        ref.read(_feed.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scroll.dispose();
    _searchInput.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      final query = value.trim();
      setState(() => _search = query.isEmpty ? null : query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final feed = ref.watch(_feed);
    final items = feed.value?.items ?? const <Post>[];
    final hero = _showHero && items.isNotEmpty ? items.first : null;
    final archive = hero == null ? items : items.skip(1).toList();

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(_feed.future),
        child: CustomScrollView(
          controller: _scroll,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            const SliverAppBar(
              floating: true,
              toolbarHeight: 72,
              title: HaloMark(height: 54),
            ),
            if (hero != null)
              SliverToBoxAdapter(child: _LatestIssue(post: hero)),
            SliverToBoxAdapter(
              child: _ArchiveHeader(
                searchInput: _searchInput,
                onSearchChanged: _onSearchChanged,
                selectedCategoryId: _categoryId,
                onCategorySelected: (id) => setState(() => _categoryId = id),
              ),
            ),
            ...switch (feed) {
              AsyncValue(:final error?) when !feed.hasValue => [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _Message(
                    text: ApiException.from(error).message,
                    onRetry: () => ref.invalidate(_feed),
                  ),
                ),
              ],
              AsyncValue(hasValue: false) => const [
                SliverFillRemaining(hasScrollBody: false, child: HaloLoading()),
              ],
              _ when items.isEmpty => [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _Message(
                    text: _showHero
                        ? 'Henüz yayınlanmış dergi yok.'
                        : 'Aramanızla eşleşen dergi bulunamadı.',
                  ),
                ),
              ],
              _ => [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  sliver: SliverGrid.builder(
                    itemCount: archive.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 220,
                          mainAxisSpacing: 28,
                          crossAxisSpacing: 20,
                          // Cover (3:4) plus two title lines and the date.
                          childAspectRatio: 0.52,
                        ),
                    itemBuilder: (context, index) {
                      final post = archive[index];
                      return IssueTile(
                        post: post,
                        onTap: () => context.push(Routes.post(post.slug)),
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: _ListFooter(
                    state: feed.value!,
                    onRetry: () => ref.read(_feed.notifier).loadMore(),
                  ),
                ),
              ],
            },
          ],
        ),
      ),
    );
  }
}

/// The newest issue, centered in the magazine's halo.
class _LatestIssue extends ConsumerWidget {
  const _LatestIssue({required this.post});

  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final url = cdnUrl(post.attachment);
    final hasPdf = url != null;
    final cached = hasPdf ? (ref.watch(isIssueCachedProvider(url)).value ?? false) : false;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: Column(
        children: [
          HaloGlow(
            child: HaloRing(
              size: 300,
              child: GestureDetector(
                onTap: () => context.push(Routes.post(post.slug)),
                child: PostCover(path: post.coverImage, width: 168),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Son sayı',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            post.title,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            formatDate(post.createdAt),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              if (hasPdf) ...[
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () async {
                      if (cached) {
                        context.push(Routes.issueReader(post.slug));
                        return;
                      }

                      final confirmed =
                          await showIssueDownloadSheet(context, post: post);
                      if (confirmed == true && context.mounted) {
                        context.push(
                          Routes.issueReader(post.slug),
                          extra: {'autoDownload': true},
                        );
                      }
                    },
                    icon: Icon(cached
                        ? Icons.auto_stories_outlined
                        : Icons.download_rounded),
                    label: const Text('Dergiyi Oku'),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.push(Routes.post(post.slug)),
                  child: const Text('Ayrıntılar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ArchiveHeader extends ConsumerWidget {
  const _ArchiveHeader({
    required this.searchInput,
    required this.onSearchChanged,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  final TextEditingController searchInput;
  final ValueChanged<String> onSearchChanged;
  final String? selectedCategoryId;
  final ValueChanged<String?> onCategorySelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(postCategoriesProvider).value ?? const [];
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Text('Arşiv', style: theme.textTheme.headlineSmall),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            controller: searchInput,
            onChanged: onSearchChanged,
            textInputAction: TextInputAction.search,
            decoration: const InputDecoration(
              hintText: 'Sayılarda ara',
              prefixIcon: Icon(Icons.search),
              isDense: true,
            ),
          ),
        ),
        SizedBox(
          height: 60,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            children: [
              ChoiceChip(
                label: const Text('Tümü'),
                selected: selectedCategoryId == null,
                onSelected: (_) => onCategorySelected(null),
              ),
              for (final category in categories) ...[
                const SizedBox(width: 8),
                ChoiceChip(
                  label: Text(category.name),
                  selected: selectedCategoryId == category.id,
                  onSelected: (_) => onCategorySelected(category.id),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ListFooter extends StatelessWidget {
  const _ListFooter({required this.state, required this.onRetry});

  final PostsFeedState state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (state.loadMoreError != null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: TextButton(
            onPressed: onRetry,
            child: Text('${state.loadMoreError!.message} Tekrar dene'),
          ),
        ),
      );
    }
    if (state.hasMore) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: HaloSpinner(size: 28)),
      );
    }
    return const SizedBox(height: 32);
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text, this.onRetry});

  final String text;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text, textAlign: TextAlign.center),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: onRetry,
              child: const Text('Tekrar Dene'),
            ),
          ],
        ],
      ),
    );
  }
}
