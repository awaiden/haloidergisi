import '../repositories/account_repository.dart';

class ChangePassword {
  const ChangePassword(this._repository);

  final AccountRepository _repository;

  Future<void> call({
    required String currentPassword,
    required String newPassword,
  }) =>
      _repository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
}
