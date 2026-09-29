import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../controllers/auth_controller.dart';

/// Centered card layout shared by the auth screens (mirrors the web `_auth` pages).
///
/// Leaves the screen on sign-in itself: when login is *pushed* (from the
/// account tab, a call, …) go_router re-runs its redirect for the page
/// underneath, so `authRedirect` alone never takes the user off this screen.
class AuthScaffold extends ConsumerWidget {
  const AuthScaffold({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.child,
  });

  final IconData icon;
  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    ref.listen(authControllerProvider, (previous, next) {
      final signedIn = previous?.value == null && next.value != null;
      final router = GoRouter.maybeOf(context);
      if (signedIn && router != null) {
        router.go(Routes.afterSignIn(GoRouterState.of(context).uri));
      }
    });
    // Router-agnostic (the screens are also pumped without GoRouter in tests).
    final canPop = Navigator.of(context).canPop();
    final router = GoRouter.maybeOf(context);

    return PopScope(
      // The system back button also returns home instead of closing the app.
      canPop: canPop,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) router?.go(Routes.home);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          // Always offer a way out: back when there is a page underneath (e.g.
          // pushed from the feed), otherwise close to the home feed (e.g. after
          // switching login ↔ register, which replaces the page).
          leading: canPop
              ? const BackButton()
              : IconButton(
                  tooltip: 'Ana Sayfa',
                  icon: const Icon(Icons.close),
                  onPressed: () => router?.go(Routes.home),
                ),
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: theme.colorScheme.secondary,
                          child: Icon(icon, color: theme.colorScheme.primary),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 24),
                        child,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
