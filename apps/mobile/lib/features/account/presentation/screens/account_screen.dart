import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/widgets/user_avatar.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

/// "Hesap" tab: the account itself (sign-in prompt when signed out). App
/// preferences and the magazine's pages live in Ayarlar (gear icon).
class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).value;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hesap'),
        actions: [
          IconButton(
            tooltip: 'Ayarlar',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(Routes.settings),
          ),
        ],
      ),
      body: user == null
          ? ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.account_circle_outlined,
                        size: 64,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Hesap ayarlarınızı yönetmek için giriş yapın.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: () =>
                            context.push(Routes.loginFrom(Routes.account)),
                        child: const Text('Giriş Yap'),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: () => context.push(Routes.register),
                        child: const Text('Kayıt Ol'),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : ListView(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: UserAvatar(
                    name: user.displayName,
                    avatarPath: user.profile?.avatarUrl,
                    radius: 28,
                  ),
                  title: Text(
                    user.displayName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    [
                      user.profile?.title,
                      user.email,
                    ].whereType<String>().join('\n'),
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('Yazılarım'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(Routes.mySubmissions),
                ),
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Profil'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(Routes.editProfile),
                ),
                ListTile(
                  leading: const Icon(Icons.lock_outline),
                  title: const Text('Parola ve Güvenlik'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(Routes.changePassword),
                ),
                const Divider(),
                ListTile(
                  leading: Icon(Icons.logout, color: theme.colorScheme.error),
                  title: Text(
                    'Çıkış Yap',
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                  onTap: () =>
                      ref.read(authControllerProvider.notifier).logout(),
                ),
              ],
            ),
    );
  }
}
