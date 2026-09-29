import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';

import '../../../../core/utils/cdn.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/open_url.dart';
import '../../../../core/widgets/error_retry.dart';
import '../../../../core/widgets/halo.dart';
import '../../data/issue_file_cache.dart';
import '../../domain/entities/post.dart';
import '../controllers/posts_controller.dart';
import '../widgets/feedback_sheet.dart';
import '../widgets/issue_download_sheet.dart';
import '../widgets/issue_tile.dart';
import '../widgets/post_cover.dart';

class PostDetailScreen extends ConsumerWidget {
  const PostDetailScreen({super.key, required this.idOrSlug});

  final String idOrSlug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = ref.watch(postDetailProvider(idOrSlug));

    return Scaffold(
      appBar: AppBar(),
      body: post.when(
        loading: () => const HaloLoading(),
        error: (error, _) => ErrorRetry(
          error: error,
          onRetry: () => ref.invalidate(postDetailProvider(idOrSlug)),
        ),
        data: (post) => _PostDetail(post: post),
      ),
    );
  }
}

class _PostDetail extends StatelessWidget {
  const _PostDetail({required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final hasPdf = cdnUrl(post.attachment) != null;

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
      children: [
        Center(
          child: HaloGlow(
            spread: 1.4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 28),
              child: PostCover(path: post.coverImage, width: 210),
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (post.category != null)
          Text(
            post.category!.name,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        const SizedBox(height: 6),
        Text(
          post.title,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium,
        ),
        const SizedBox(height: 6),
        Text(
          formatDate(post.createdAt),
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(color: muted),
        ),
        if (hasPdf) ...[
          const SizedBox(height: 24),
          _ReadButton(post: post, url: cdnUrl(post.attachment)!),
        ],
        if (post.content?.isNotEmpty ?? false) ...[
          const SizedBox(height: 28),
          MarkdownBody(
            data: post.content!,
            selectable: true,
            styleSheet: _readingStyle(theme),
            onTapLink: (_, href, _) => openExternalUrl(context, href),
          ),
        ],
        const SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: () => showFeedbackSheet(context, post),
          icon: const Icon(Icons.rate_review_outlined),
          label: const Text('Geri Bildirim Gönder'),
        ),
        const SizedBox(height: 36),
        _OtherIssues(currentId: post.id),
      ],
    );
  }
}

/// "Diğer sayılarımıza göz atın": a shelf of other recent issues.
class _OtherIssues extends ConsumerWidget {
  const _OtherIssues({required this.currentId});

  final String currentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final issues = ref.watch(otherIssuesProvider(currentId)).value;
    if (issues == null || issues.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Diğer sayılarımıza göz atın', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        SizedBox(
          height: 290,
          // Bleed to the screen edges so the shelf visibly scrolls sideways.
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: issues.length,
            separatorBuilder: (_, _) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final issue = issues[index];
              return SizedBox(
                width: 150,
                child: IssueTile(
                  post: issue,
                  onTap: () => context.push(Routes.post(issue.slug)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Long-form text: slightly larger body with generous leading, serif headings.
MarkdownStyleSheet _readingStyle(ThemeData theme) {
  final text = theme.textTheme;
  return MarkdownStyleSheet.fromTheme(theme).copyWith(
    p: text.bodyLarge?.copyWith(fontSize: 16.5, height: 1.7),
    h1: text.headlineSmall,
    h2: text.titleLarge,
    h3: text.titleLarge?.copyWith(fontSize: 18),
    blockquote: text.bodyLarge?.copyWith(
      fontFamily: 'PlayfairDisplay',
      fontStyle: FontStyle.italic,
      height: 1.6,
    ),
    blockquoteDecoration: BoxDecoration(
      border: Border(
        left: BorderSide(color: theme.colorScheme.primary, width: 2),
      ),
    ),
    blockquotePadding: const EdgeInsets.only(left: 16),
  );
}

class _ReadButton extends ConsumerWidget {
  const _ReadButton({required this.post, required this.url});

  final Post post;
  final String url;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cached = ref.watch(isIssueCachedProvider(url)).value ?? false;

    return FilledButton.icon(
      onPressed: () async {
        if (cached) {
          context.push(Routes.issueReader(post.slug));
          return;
        }

        final confirmed = await showIssueDownloadSheet(context, post: post);
        if (confirmed == true && context.mounted) {
          context.push(
            Routes.issueReader(post.slug),
            extra: {'autoDownload': true},
          );
        }
      },
      icon: Icon(cached ? Icons.auto_stories_outlined : Icons.download_rounded),
      label: Text(cached ? 'Dergiyi Oku' : 'Dergiyi İndir ve Oku'),
    );
  }
}
