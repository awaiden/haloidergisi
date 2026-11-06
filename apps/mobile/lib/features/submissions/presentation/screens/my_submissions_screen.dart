import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/error_retry.dart';
import '../controllers/submissions_controller.dart';
import '../widgets/status_chip.dart';
import '../../../../core/widgets/halo.dart';

class MySubmissionsScreen extends ConsumerWidget {
  const MySubmissionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final submissions = ref.watch(mySubmissionsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Yazılarım')),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(mySubmissionsProvider.future),
        child: submissions.when(
          loading: () => const HaloLoading(),
          error: (error, _) => ErrorRetry(
            error: error,
            onRetry: () => ref.invalidate(mySubmissionsProvider),
          ),
          data: (items) {
            if (items.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(32),
                children: [
                  const SizedBox(height: 64),
                  const Text(
                    'Henüz bir yazı göndermediniz.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: OutlinedButton(
                      onPressed: () => context.go(Routes.calls),
                      child: const Text('Açık çağrılara göz at'),
                    ),
                  ),
                ],
              );
            }
            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  margin: EdgeInsets.zero,
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => context.push(Routes.call(item.callId)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: theme.textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(width: 8),
                              StatusChip(status: item.status),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            [item.call?.title.trim(), formatDate(item.createdAt)]
                                .whereType<String>()
                                .join('\n'),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          if (item.adminNote?.isNotEmpty ?? false) ...[
                            const SizedBox(height: 8),
                            Text('Editör notu: ${item.adminNote}'),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
