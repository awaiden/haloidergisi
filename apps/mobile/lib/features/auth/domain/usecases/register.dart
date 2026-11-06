import '../repositories/auth_repository.dart';

class Register {
  const Register(this._repository);

  final AuthRepository _repository;

  Future<void> call({
    required String name,
    required String email,
    required String password,
    required String turnstileToken,
  }) =>
      _repository.register(
        name: name.trim(),
        email: email.trim(),
        password: password,
        turnstileToken: turnstileToken,
      );
}
