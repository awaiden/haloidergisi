import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/text.dart';
import '../../../../core/widgets/entry_row.dart';
import '../../../../core/widgets/error_retry.dart';
import '../controllers/news_controller.dart';
import '../../../../core/widgets/halo.dart';

class NewsScreen extends ConsumerWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final news = ref.watch(newsListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Haberler')),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(newsListProvider.future),
        child: news.when(
          loading: () => const HaloLoading(),
          error: (error, _) => ErrorRetry(
            error: error,
            onRetry: () => ref.invalidate(newsListProvider),
          ),
          data: (items) {
            if (items.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(32),
                children: const [
                  SizedBox(height: 64),
                  Text('Henüz haber yok.', textAlign: TextAlign.center),
                ],
              );
            }
            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: items.length,
              separatorBuilder: (_, _) =>
                  const Divider(indent: 20, endIndent: 20),
              itemBuilder: (context, index) {
                final item = items[index];
                return EntryRow(
                  title: item.title,
                  detail: formatDate(item.date),
                  excerpt: plainTextExcerpt(item.content),
                  onTap: () => context.push(Routes.newsItem(item.slug)),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
