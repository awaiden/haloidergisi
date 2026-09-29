import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/text.dart';
import '../../../../core/widgets/entry_row.dart';
import '../../../../core/widgets/error_retry.dart';
import '../controllers/submissions_controller.dart';
import '../../../../core/widgets/halo.dart';

/// Open calls for submissions.
class CallsScreen extends ConsumerWidget {
  const CallsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calls = ref.watch(activeCallsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Yazı Çağrıları')),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(activeCallsProvider.future),
        child: calls.when(
          loading: () => const HaloLoading(),
          error: (error, _) => ErrorRetry(
            error: error,
            onRetry: () => ref.invalidate(activeCallsProvider),
          ),
          data: (items) {
            if (items.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(32),
                children: const [
                  SizedBox(height: 64),
                  Text(
                    'Şu anda açık bir yazı çağrısı yok.',
                    textAlign: TextAlign.center,
                  ),
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
                final call = items[index];
                final daysLeft = call.endDate.difference(DateTime.now()).inDays;
                return EntryRow(
                  title: call.title.trim(),
                  detail: formatDateRange(call.startDate, call.endDate),
                  excerpt: plainTextExcerpt(call.description ?? ''),
                  // Only an approaching deadline earns a marker.
                  badge: daysLeft <= 7
                      ? Chip(
                          visualDensity: VisualDensity.compact,
                          backgroundColor: theme.colorScheme.primaryContainer,
                          side: BorderSide.none,
                          label: Text(
                            daysLeft <= 0 ? 'Son gün' : 'Son $daysLeft gün',
                          ),
                        )
                      : null,
                  onTap: () => context.push(Routes.call(call.id)),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
