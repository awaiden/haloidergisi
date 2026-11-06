import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/datasources/account_remote_datasource.dart';
import '../../data/repositories/account_repository_impl.dart';
import '../../domain/entities/notification_settings.dart';
import '../../domain/repositories/account_repository.dart';
import '../../domain/usecases/notification_settings_usecases.dart';

part 'account_controller.g.dart';

final accountRepositoryProvider = Provider<AccountRepository>(
  (ref) => AccountRepositoryImpl(AccountRemoteDataSource(ref.watch(dioProvider))),
);

@riverpod
class NotificationSettingsController extends _$NotificationSettingsController {
  @override
  Future<NotificationSettings> build() =>
      GetNotificationSettings(ref.watch(accountRepositoryProvider))();

  /// Optimistic: the switch flips immediately and reverts if saving fails.
  Future<void> save(NotificationSettings next) async {
    final previous = state.value;
    state = AsyncData(next);
    try {
      final saved = await UpdateNotificationSettings(
        ref.read(accountRepositoryProvider),
      )(next);
      if (ref.mounted) state = AsyncData(saved);
    } catch (_) {
      if (ref.mounted && previous != null) state = AsyncData(previous);
      rethrow;
    }
  }
}
