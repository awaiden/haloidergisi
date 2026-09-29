import '../entities/user.dart';

abstract interface class AuthRepository {
  /// Returns the signed-in user, or `null` when there is no valid session.
  Future<User?> restoreSession();

  Future<User> login({
    required String email,
    required String password,
    required String turnstileToken,
  });

  /// Google sign-in through the API's browser flow. Returns `null` if the
  /// user closed the browser.
  Future<User?> signInWithGoogle();

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String turnstileToken,
  });

  Future<void> requestPasswordReset({
    required String email,
    required String turnstileToken,
  });

  Future<void> logout();
}
