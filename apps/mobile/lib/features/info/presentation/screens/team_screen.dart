import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/open_url.dart';
import '../../../../core/widgets/error_retry.dart';
import '../../../../core/widgets/user_avatar.dart';
import '../../domain/entities/team.dart';
import '../controllers/info_controller.dart';
import '../../../../core/widgets/halo.dart';

class TeamScreen extends ConsumerWidget {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final team = ref.watch(teamProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Ekibimiz')),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(teamProvider.future),
        child: team.when(
          loading: () => const HaloLoading(),
          error: (error, _) => ErrorRetry(
            error: error,
            onRetry: () => ref.invalidate(teamProvider),
          ),
          data: (crews) => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              for (final crew in crews) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Text(
                    crew.name,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                for (final member in crew.members)
                  ListTile(
                    leading: UserAvatar(
                      name: member.name,
                      avatarPath: member.avatarUrl,
                    ),
                    title: Text(member.name),
                    subtitle: member.title == null ? null : Text(member.title!),
                    onTap: () => _showMember(context, member),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showMember(BuildContext context, TeamMember member) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            children: [
              UserAvatar(name: member.name, avatarPath: member.avatarUrl, radius: 40),
              const SizedBox(height: 12),
              Text(member.name, style: Theme.of(context).textTheme.titleLarge),
              if (member.title != null) Text(member.title!),
              if (member.bio?.isNotEmpty ?? false) ...[
                const SizedBox(height: 16),
                MarkdownBody(
                  data: member.bio!,
                  onTapLink: (_, href, _) => openExternalUrl(context, href),
                ),
              ],
              if (member.website?.isNotEmpty ?? false) ...[
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () => openExternalUrl(context, member.website),
                  icon: const Icon(Icons.link),
                  label: const Text('Web sitesi'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
