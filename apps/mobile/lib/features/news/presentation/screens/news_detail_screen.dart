import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/open_url.dart';
import '../../../../core/widgets/error_retry.dart';
import '../controllers/news_controller.dart';
import '../../../../core/widgets/halo.dart';

class NewsDetailScreen extends ConsumerWidget {
  const NewsDetailScreen({super.key, required this.idOrSlug});

  final String idOrSlug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final news = ref.watch(newsDetailProvider(idOrSlug));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: news.when(
        loading: () => const HaloLoading(),
        error: (error, _) => ErrorRetry(
          error: error,
          onRetry: () => ref.invalidate(newsDetailProvider(idOrSlug)),
        ),
        data: (item) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
          children: [
            Text(
              item.title,
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              '${item.authorName ?? 'HALO Editör'}\n${formatDate(item.date)}',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 20),
            MarkdownBody(
              data: item.content,
              selectable: true,
              onTapLink: (_, href, _) => openExternalUrl(context, href),
            ),
            if (item.keywords.isNotEmpty) ...[
              const SizedBox(height: 24),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final keyword in item.keywords) Chip(label: Text(keyword)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
