import '../repositories/auth_repository.dart';

class RequestPasswordReset {
  const RequestPasswordReset(this._repository);

  final AuthRepository _repository;

  Future<void> call({required String email, required String turnstileToken}) =>
      _repository.requestPasswordReset(
        email: email.trim(),
        turnstileToken: turnstileToken,
      );
}
