// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submissions_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(activeCalls)
final activeCallsProvider = ActiveCallsProvider._();

final class ActiveCallsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SubmissionCall>>,
          List<SubmissionCall>,
          FutureOr<List<SubmissionCall>>
        >
    with
        $FutureModifier<List<SubmissionCall>>,
        $FutureProvider<List<SubmissionCall>> {
  ActiveCallsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeCallsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeCallsHash();

  @$internal
  @override
  $FutureProviderElement<List<SubmissionCall>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SubmissionCall>> create(Ref ref) {
    return activeCalls(ref);
  }
}

String _$activeCallsHash() => r'93c73b9a67f0a10bbf55f14d1720827a073c620b';

@ProviderFor(callDetail)
final callDetailProvider = CallDetailFamily._();

final class CallDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<SubmissionCall>,
          SubmissionCall,
          FutureOr<SubmissionCall>
        >
    with $FutureModifier<SubmissionCall>, $FutureProvider<SubmissionCall> {
  CallDetailProvider._({
    required CallDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'callDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$callDetailHash();

  @override
  String toString() {
    return r'callDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<SubmissionCall> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SubmissionCall> create(Ref ref) {
    final argument = this.argument as String;
    return callDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CallDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$callDetailHash() => r'2cf54e4ef9168b541a1869118a75020f422f9118';

final class CallDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<SubmissionCall>, String> {
  CallDetailFamily._()
    : super(
        retry: null,
        name: r'callDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CallDetailProvider call(String id) =>
      CallDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'callDetailProvider';
}

/// The signed-in user's submission to a call; only watch while signed in.

@ProviderFor(mySubmissionFor)
final mySubmissionForProvider = MySubmissionForFamily._();

/// The signed-in user's submission to a call; only watch while signed in.

final class MySubmissionForProvider
    extends
        $FunctionalProvider<
          AsyncValue<Submission?>,
          Submission?,
          FutureOr<Submission?>
        >
    with $FutureModifier<Submission?>, $FutureProvider<Submission?> {
  /// The signed-in user's submission to a call; only watch while signed in.
  MySubmissionForProvider._({
    required MySubmissionForFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'mySubmissionForProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$mySubmissionForHash();

  @override
  String toString() {
    return r'mySubmissionForProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Submission?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Submission?> create(Ref ref) {
    final argument = this.argument as String;
    return mySubmissionFor(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MySubmissionForProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mySubmissionForHash() => r'338bcf966423a01edf80e5bd4fe711d59b2bb99a';

/// The signed-in user's submission to a call; only watch while signed in.

final class MySubmissionForFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Submission?>, String> {
  MySubmissionForFamily._()
    : super(
        retry: null,
        name: r'mySubmissionForProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The signed-in user's submission to a call; only watch while signed in.

  MySubmissionForProvider call(String callId) =>
      MySubmissionForProvider._(argument: callId, from: this);

  @override
  String toString() => r'mySubmissionForProvider';
}

@ProviderFor(mySubmissions)
final mySubmissionsProvider = MySubmissionsProvider._();

final class MySubmissionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Submission>>,
          List<Submission>,
          FutureOr<List<Submission>>
        >
    with $FutureModifier<List<Submission>>, $FutureProvider<List<Submission>> {
  MySubmissionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mySubmissionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mySubmissionsHash();

  @$internal
  @override
  $FutureProviderElement<List<Submission>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Submission>> create(Ref ref) {
    return mySubmissions(ref);
  }
}

String _$mySubmissionsHash() => r'f9f4f58f343fb200161b482fa47c5b8b9c729d0d';
