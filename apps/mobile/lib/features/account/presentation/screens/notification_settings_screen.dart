import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/widgets/error_retry.dart';
import '../../domain/entities/notification_settings.dart';
import '../controllers/account_controller.dart';
import '../../../../core/widgets/halo.dart';

class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(notificationSettingsControllerProvider);

    Future<void> save(NotificationSettings next) async {
      try {
        await ref
            .read(notificationSettingsControllerProvider.notifier)
            .save(next);
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ApiException.from(e).message)),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Bildirimler')),
      body: settings.when(
        loading: () => const HaloLoading(),
        error: (error, _) => ErrorRetry(
          error: error,
          onRetry: () => ref.invalidate(notificationSettingsControllerProvider),
        ),
        data: (s) => ListView(
          children: [
            SwitchListTile(
              title: const Text('E-posta Bildirimleri'),
              subtitle: const Text('Hesabınızla ilgili e-postalar alın.'),
              value: s.emailNotifications,
              onChanged: (v) => save(s.copyWith(emailNotifications: v)),
            ),
            SwitchListTile(
              title: const Text('Yeni Dergi Bildirimleri'),
              subtitle: const Text('Yeni sayı yayınlandığında haber alın.'),
              value: s.newPost,
              onChanged: (v) => save(s.copyWith(newPost: v)),
            ),
            SwitchListTile(
              title: const Text('Güvenlik Bildirimleri'),
              subtitle: const Text('Hesap güvenliğiyle ilgili uyarılar alın.'),
              value: s.securityAlert,
              onChanged: (v) => save(s.copyWith(securityAlert: v)),
            ),
          ],
        ),
      ),
    );
  }
}
