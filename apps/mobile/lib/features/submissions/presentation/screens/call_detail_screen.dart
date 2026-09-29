import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/open_url.dart';
import '../../../../core/widgets/error_retry.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/submissions_controller.dart';
import '../widgets/status_chip.dart';
import '../../../../core/widgets/halo.dart';

class CallDetailScreen extends ConsumerWidget {
  const CallDetailScreen({super.key, required this.callId});

  final String callId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final call = ref.watch(callDetailProvider(callId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      // Pinned at the bottom: in reach after reading the call's details.
      bottomNavigationBar: call.hasValue
          ? SafeArea(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  border: Border(
                    top: BorderSide(color: theme.colorScheme.outlineVariant),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: _SubmissionAction(callId: callId),
                ),
              ),
            )
          : null,
      body: call.when(
        loading: () => const HaloLoading(),
        error: (error, _) => ErrorRetry(
          error: error,
          onRetry: () => ref.invalidate(callDetailProvider(callId)),
        ),
        data: (call) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
          children: [
            Text(
              call.title.trim(),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              formatDateRange(call.startDate, call.endDate),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (call.description?.isNotEmpty ?? false) ...[
              const SizedBox(height: 20),
              MarkdownBody(
                data: call.description!,
                selectable: true,
                onTapLink: (_, href, _) => openExternalUrl(context, href),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Send / edit / status, depending on the user's existing submission.
class _SubmissionAction extends ConsumerWidget {
  const _SubmissionAction({required this.callId});

  final String callId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).value;
    if (user == null) {
      return OutlinedButton(
        onPressed: () => context.push(Routes.loginFrom(Routes.call(callId))),
        child: const Text('Yazı göndermek için giriş yapın'),
      );
    }

    final mine = ref.watch(mySubmissionForProvider(callId));
    return mine.when(
      loading: () => const LinearProgressIndicator(),
      error: (error, _) => TextButton(
        onPressed: () => ref.invalidate(mySubmissionForProvider(callId)),
        child: const Text('Gönderim durumu alınamadı. Tekrar dene'),
      ),
      data: (submission) {
        if (submission == null) {
          return FilledButton.icon(
            onPressed: () => context.push(Routes.submit(callId)),
            icon: const Icon(Icons.upload_file),
            label: const Text('Yazı Gönder'),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Gönderiniz: ${submission.title}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                StatusChip(status: submission.status),
              ],
            ),
            if (submission.status.canEdit) ...[
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => context.push(Routes.submit(callId)),
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Yazımı Düzenle'),
              ),
            ],
          ],
        );
      },
    );
  }
}
