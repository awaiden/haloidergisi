import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/token_storage.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/register.dart';
import '../../domain/usecases/request_password_reset.dart';
import '../../domain/usecases/restore_session.dart';

part 'auth_controller.g.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    AuthRemoteDataSource(ref.watch(dioProvider)),
    ref.watch(tokenStorageProvider),
  ),
);

/// Current session: `AsyncData(null)` when signed out.
///
/// Mutations never put the state into loading, so the router only shows the
/// splash screen during the initial session restore. Errors from mutations
/// are thrown as `ApiException` for the calling screen to display.
@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  AuthRepository get _repository => ref.read(authRepositoryProvider);

  @override
  Future<User?> build() async {
    final subscription = ref.watch(sessionExpiredProvider).stream.listen((_) {
      if (state.value != null) state = const AsyncData(null);
    });
    ref.onDispose(subscription.cancel);

    return RestoreSession(ref.watch(authRepositoryProvider))();
  }

  Future<void> login({
    required String email,
    required String password,
    required String turnstileToken,
  }) async {
    final user = await Login(_repository)(
      email: email,
      password: password,
      turnstileToken: turnstileToken,
    );
    state = AsyncData(user);
  }

  /// Returns `false` if the user closed the Google page without signing in.
  Future<bool> signInWithGoogle() async {
    final user = await _repository.signInWithGoogle();
    if (user == null) return false;
    state = AsyncData(user);
    return true;
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String turnstileToken,
  }) =>
      Register(_repository)(
        name: name,
        email: email,
        password: password,
        turnstileToken: turnstileToken,
      );

  Future<void> requestPasswordReset({
    required String email,
    required String turnstileToken,
  }) =>
      RequestPasswordReset(_repository)(
        email: email,
        turnstileToken: turnstileToken,
      );

  /// Re-fetches `GET /account` after the user edits their own data.
  Future<void> refreshUser() async {
    final user = await RestoreSession(_repository)();
    state = AsyncData(user);
  }

  Future<void> logout() async {
    await Logout(_repository)();
    state = const AsyncData(null);
  }
}
