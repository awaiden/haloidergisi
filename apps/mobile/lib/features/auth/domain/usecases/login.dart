import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class Login {
  const Login(this._repository);

  final AuthRepository _repository;

  Future<User> call({
    required String email,
    required String password,
    required String turnstileToken,
  }) =>
      _repository.login(
        email: email.trim(),
        password: password,
        turnstileToken: turnstileToken,
      );
}
