// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NotificationSettingsController)
final notificationSettingsControllerProvider =
    NotificationSettingsControllerProvider._();

final class NotificationSettingsControllerProvider
    extends
        $AsyncNotifierProvider<
          NotificationSettingsController,
          NotificationSettings
        > {
  NotificationSettingsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationSettingsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationSettingsControllerHash();

  @$internal
  @override
  NotificationSettingsController create() => NotificationSettingsController();
}

String _$notificationSettingsControllerHash() =>
    r'a1fb1dd537064a58c6fbcc23bc6a9d42c7b85f3d';

abstract class _$NotificationSettingsController
    extends $AsyncNotifier<NotificationSettings> {
  FutureOr<NotificationSettings> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<NotificationSettings>, NotificationSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<NotificationSettings>,
                NotificationSettings
              >,
              AsyncValue<NotificationSettings>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
