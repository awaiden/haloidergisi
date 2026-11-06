import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../app/theme/theme_mode_controller.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../posts/data/issue_file_cache.dart';

/// "Ayarlar": app preferences and the magazine's pages. Public; the
/// notification settings only appear when signed in (they belong to an account).
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signedIn = ref.watch(authControllerProvider).value != null;

    ListTile tile(IconData icon, String title, String route) => ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.push(route),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: ListView(
        children: [
          const _AppearanceTile(),
          if (signedIn)
            tile(
              Icons.notifications_outlined,
              'Bildirimler',
              Routes.notificationSettings,
            ),
          const _DownloadsTile(),
          const Divider(),
          const _SectionTitle('HALO'),
          tile(Icons.info_outline, 'Hakkımızda', Routes.about),
          tile(Icons.groups_outlined, 'Ekibimiz', Routes.team),
          tile(Icons.mail_outline, 'İletişim', Routes.contact),
          const Divider(),
          tile(
            Icons.privacy_tip_outlined,
            'Gizlilik Politikası',
            Routes.privacy,
          ),
          tile(Icons.gavel_outlined, 'Kullanım Şartları', Routes.terms),
        ],
      ),
    );
  }
}

final _downloadsSizeProvider = FutureProvider.autoDispose<int>(
  (ref) => ref.watch(issueFileCacheProvider).sizeBytes(),
);

/// Space used by downloaded issues, with a way to free it.
class _DownloadsTile extends ConsumerWidget {
  const _DownloadsTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bytes = ref.watch(_downloadsSizeProvider).value ?? 0;
    final mb = (bytes / (1024 * 1024)).toStringAsFixed(0);

    return ListTile(
      leading: const Icon(Icons.download_done_outlined),
      title: const Text('İndirilen dergiler'),
      subtitle: Text(bytes == 0 ? 'İndirilmiş dergi yok' : '$mb MB kullanılıyor'),
      trailing: bytes == 0
          ? null
          : TextButton(
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('İndirilenleri sil'),
                    content: Text(
                      'İndirilen dergiler silinecek ($mb MB). Bir dergiyi tekrar açtığınızda yeniden indirilir.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Vazgeç'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Sil'),
                      ),
                    ],
                  ),
                );
                if (confirmed != true) return;
                await ref.read(issueFileCacheProvider).clear();
                ref.invalidate(_downloadsSizeProvider);
              },
              child: const Text('Sil'),
            ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        text,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}

/// Sistem / Açık / Koyu, applied immediately and remembered.
class _AppearanceTile extends ConsumerWidget {
  const _AppearanceTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeControllerProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Görünüm', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(
                  value: ThemeMode.system,
                  icon: Icon(Icons.brightness_auto_outlined),
                  label: Text('Sistem'),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  icon: Icon(Icons.light_mode_outlined),
                  label: Text('Açık'),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  icon: Icon(Icons.dark_mode_outlined),
                  label: Text('Koyu'),
                ),
              ],
              selected: {mode},
              showSelectedIcon: false,
              onSelectionChanged: (selection) => ref
                  .read(themeModeControllerProvider.notifier)
                  .set(selection.first),
            ),
          ),
        ],
      ),
    );
  }
}
