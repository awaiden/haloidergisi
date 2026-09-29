import '../entities/profile_update.dart';
import '../repositories/account_repository.dart';

class UpdateProfile {
  const UpdateProfile(this._repository);

  final AccountRepository _repository;

  Future<void> call(String profileId, ProfileUpdate update) {
    String? clean(String? value) {
      final trimmed = value?.trim();
      return trimmed == null || trimmed.isEmpty ? null : trimmed;
    }

    return _repository.updateProfile(
      profileId,
      ProfileUpdate(
        name: update.name.trim(),
        title: clean(update.title),
        bio: clean(update.bio),
        website: clean(update.website),
        avatarUrl: update.avatarUrl,
        updateTitle: update.updateTitle,
      ),
    );
  }
}
