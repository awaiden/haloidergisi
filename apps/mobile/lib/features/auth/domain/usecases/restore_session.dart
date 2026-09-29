import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RestoreSession {
  const RestoreSession(this._repository);

  final AuthRepository _repository;

  Future<User?> call() => _repository.restoreSession();
}
