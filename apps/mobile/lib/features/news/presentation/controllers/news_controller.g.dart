// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(newsList)
final newsListProvider = NewsListProvider._();

final class NewsListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<News>>,
          List<News>,
          FutureOr<List<News>>
        >
    with $FutureModifier<List<News>>, $FutureProvider<List<News>> {
  NewsListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'newsListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$newsListHash();

  @$internal
  @override
  $FutureProviderElement<List<News>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<News>> create(Ref ref) {
    return newsList(ref);
  }
}

String _$newsListHash() => r'351acd8b9a5988e8c3a26ba1e2a8bb96e627706a';

@ProviderFor(newsDetail)
final newsDetailProvider = NewsDetailFamily._();

final class NewsDetailProvider
    extends $FunctionalProvider<AsyncValue<News>, News, FutureOr<News>>
    with $FutureModifier<News>, $FutureProvider<News> {
  NewsDetailProvider._({
    required NewsDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'newsDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$newsDetailHash();

  @override
  String toString() {
    return r'newsDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<News> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<News> create(Ref ref) {
    final argument = this.argument as String;
    return newsDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is NewsDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$newsDetailHash() => r'd419f0f6102aed94c0e33579351ddf103555b2f4';

final class NewsDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<News>, String> {
  NewsDetailFamily._()
    : super(
        retry: null,
        name: r'newsDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  NewsDetailProvider call(String idOrSlug) =>
      NewsDetailProvider._(argument: idOrSlug, from: this);

  @override
  String toString() => r'newsDetailProvider';
}
