import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/widgets/halo.dart';
import '../controllers/auth_controller.dart';

/// Shown while the stored session is restored. If that fails for a reason
/// other than an invalid token (e.g. API unreachable), offers a retry.
class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const HaloGlow(
                spread: 1.6,
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: HaloMark(height: 110),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Aylık fikir, sanat ve edebiyat dergisi',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 32),
              if (auth.hasError && !auth.isLoading) ...[
                Text(
                  ApiException.from(auth.error!).message,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () => ref.invalidate(authControllerProvider),
                  child: const Text('Tekrar Dene'),
                ),
              ] else
                const HaloSpinner(),
            ],
          ),
        ),
      ),
    );
  }
}
