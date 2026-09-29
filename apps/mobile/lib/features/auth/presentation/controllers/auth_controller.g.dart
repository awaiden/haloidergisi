// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Current session: `AsyncData(null)` when signed out.
///
/// Mutations never put the state into loading, so the router only shows the
/// splash screen during the initial session restore. Errors from mutations
/// are thrown as `ApiException` for the calling screen to display.

@ProviderFor(AuthController)
final authControllerProvider = AuthControllerProvider._();

/// Current session: `AsyncData(null)` when signed out.
///
/// Mutations never put the state into loading, so the router only shows the
/// splash screen during the initial session restore. Errors from mutations
/// are thrown as `ApiException` for the calling screen to display.
final class AuthControllerProvider
    extends $AsyncNotifierProvider<AuthController, User?> {
  /// Current session: `AsyncData(null)` when signed out.
  ///
  /// Mutations never put the state into loading, so the router only shows the
  /// splash screen during the initial session restore. Errors from mutations
  /// are thrown as `ApiException` for the calling screen to display.
  AuthControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authControllerHash();

  @$internal
  @override
  AuthController create() => AuthController();
}

String _$authControllerHash() => r'981748f5b58e1aaa550e251f00d5e74875114340';

/// Current session: `AsyncData(null)` when signed out.
///
/// Mutations never put the state into loading, so the router only shows the
/// splash screen during the initial session restore. Errors from mutations
/// are thrown as `ApiException` for the calling screen to display.

abstract class _$AuthController extends $AsyncNotifier<User?> {
  FutureOr<User?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<User?>, User?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<User?>, User?>,
              AsyncValue<User?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
