// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(postCategories)
final postCategoriesProvider = PostCategoriesProvider._();

final class PostCategoriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PostCategory>>,
          List<PostCategory>,
          FutureOr<List<PostCategory>>
        >
    with
        $FutureModifier<List<PostCategory>>,
        $FutureProvider<List<PostCategory>> {
  PostCategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postCategoriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postCategoriesHash();

  @$internal
  @override
  $FutureProviderElement<List<PostCategory>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<PostCategory>> create(Ref ref) {
    return postCategories(ref);
  }
}

String _$postCategoriesHash() => r'8d5bbea89f37e0f9e2082af5e98ce0a640aef968';

/// "Diğer sayılarımız" on an issue page.

@ProviderFor(otherIssues)
final otherIssuesProvider = OtherIssuesFamily._();

/// "Diğer sayılarımız" on an issue page.

final class OtherIssuesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Post>>,
          List<Post>,
          FutureOr<List<Post>>
        >
    with $FutureModifier<List<Post>>, $FutureProvider<List<Post>> {
  /// "Diğer sayılarımız" on an issue page.
  OtherIssuesProvider._({
    required OtherIssuesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'otherIssuesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$otherIssuesHash();

  @override
  String toString() {
    return r'otherIssuesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Post>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Post>> create(Ref ref) {
    final argument = this.argument as String;
    return otherIssues(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is OtherIssuesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$otherIssuesHash() => r'a680eebe06707e74ff871dbc8be3652093d3964b';

/// "Diğer sayılarımız" on an issue page.

final class OtherIssuesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Post>>, String> {
  OtherIssuesFamily._()
    : super(
        retry: null,
        name: r'otherIssuesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// "Diğer sayılarımız" on an issue page.

  OtherIssuesProvider call(String excludeId) =>
      OtherIssuesProvider._(argument: excludeId, from: this);

  @override
  String toString() => r'otherIssuesProvider';
}

@ProviderFor(postDetail)
final postDetailProvider = PostDetailFamily._();

final class PostDetailProvider
    extends $FunctionalProvider<AsyncValue<Post>, Post, FutureOr<Post>>
    with $FutureModifier<Post>, $FutureProvider<Post> {
  PostDetailProvider._({
    required PostDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'postDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$postDetailHash();

  @override
  String toString() {
    return r'postDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Post> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Post> create(Ref ref) {
    final argument = this.argument as String;
    return postDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PostDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$postDetailHash() => r'bda2ab3a0fcf80b00853ba625fbf2981a9773039';

final class PostDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Post>, String> {
  PostDetailFamily._()
    : super(
        retry: null,
        name: r'postDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PostDetailProvider call(String idOrSlug) =>
      PostDetailProvider._(argument: idOrSlug, from: this);

  @override
  String toString() => r'postDetailProvider';
}

/// Paginated list of published issues for one filter combination.

@ProviderFor(PostsFeed)
final postsFeedProvider = PostsFeedFamily._();

/// Paginated list of published issues for one filter combination.
final class PostsFeedProvider
    extends $AsyncNotifierProvider<PostsFeed, PostsFeedState> {
  /// Paginated list of published issues for one filter combination.
  PostsFeedProvider._({
    required PostsFeedFamily super.from,
    required ({String? categoryId, String? search}) super.argument,
  }) : super(
         retry: null,
         name: r'postsFeedProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$postsFeedHash();

  @override
  String toString() {
    return r'postsFeedProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  PostsFeed create() => PostsFeed();

  @override
  bool operator ==(Object other) {
    return other is PostsFeedProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$postsFeedHash() => r'0819a1c259c3b2859dd71fb579d3faf6fc7e5c51';

/// Paginated list of published issues for one filter combination.

final class PostsFeedFamily extends $Family
    with
        $ClassFamilyOverride<
          PostsFeed,
          AsyncValue<PostsFeedState>,
          PostsFeedState,
          FutureOr<PostsFeedState>,
          ({String? categoryId, String? search})
        > {
  PostsFeedFamily._()
    : super(
        retry: null,
        name: r'postsFeedProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Paginated list of published issues for one filter combination.

  PostsFeedProvider call({String? categoryId, String? search}) =>
      PostsFeedProvider._(
        argument: (categoryId: categoryId, search: search),
        from: this,
      );

  @override
  String toString() => r'postsFeedProvider';
}

/// Paginated list of published issues for one filter combination.

abstract class _$PostsFeed extends $AsyncNotifier<PostsFeedState> {
  late final _$args = ref.$arg as ({String? categoryId, String? search});
  String? get categoryId => _$args.categoryId;
  String? get search => _$args.search;

  FutureOr<PostsFeedState> build({String? categoryId, String? search});
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PostsFeedState>, PostsFeedState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PostsFeedState>, PostsFeedState>,
              AsyncValue<PostsFeedState>,
              Object?,
              Object?
            >;
    return element.handleCreate(
      ref,
      () => build(categoryId: _$args.categoryId, search: _$args.search),
    );
  }
}
