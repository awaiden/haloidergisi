// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(team)
final teamProvider = TeamProvider._();

final class TeamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Crew>>,
          List<Crew>,
          FutureOr<List<Crew>>
        >
    with $FutureModifier<List<Crew>>, $FutureProvider<List<Crew>> {
  TeamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'teamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$teamHash();

  @$internal
  @override
  $FutureProviderElement<List<Crew>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Crew>> create(Ref ref) {
    return team(ref);
  }
}

String _$teamHash() => r'f90f89059d25634ffe061e3d0dfabd3cd5e9af33';
