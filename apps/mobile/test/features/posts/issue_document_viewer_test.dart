import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/storage/preferences.dart';
import 'package:mobile/features/posts/domain/entities/post.dart';
import 'package:mobile/features/posts/presentation/screens/issue_reader_screen.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Document extends Mock implements PdfDocument {
  @override
  Future<void> loadPagesProgressively<T>({
    PdfPageLoadingCallback<T>? onPageLoadProgress,
    T? data,
    Duration loadUnitDuration = const Duration(milliseconds: 250),
  }) async {}
}

class _Page extends Mock implements PdfPage {}

/// An in-memory document with [count] A4 pages that render nothing.
_Document _fakeDocument(int count) {
  final document = _Document();
  final pages = List.generate(count, (i) {
    final page = _Page();
    when(() => page.document).thenReturn(document);
    when(() => page.pageNumber).thenReturn(i + 1);
    when(() => page.width).thenReturn(595);
    when(() => page.height).thenReturn(842);
    when(() => page.rotation).thenReturn(PdfPageRotation.none);
    when(() => page.isLoaded).thenReturn(true);
    return page;
  });
  when(() => document.sourceName).thenReturn('fake-issue.pdf');
  when(() => document.pages).thenReturn(pages);
  when(() => document.events).thenAnswer((_) => const Stream.empty());
  when(() => document.dispose()).thenAnswer((_) async {});
  return document;
}

void main() {
  late SharedPreferences preferences;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    preferences = await SharedPreferences.getInstance();
  });

  Future<void> pumpViewer(
    WidgetTester tester, {
    int startPage = 1,
    int pageCount = 3,
    VoidCallback? onRedownload,
  }) async {
    final post = Post(
      id: 'p18',
      slug: 'halo-18',
      title: 'Halo 18. Dal',
      attachment: 'issue.pdf',
      createdAt: DateTime(2026, 9),
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
        child: MaterialApp(
          home: IssueDocumentViewer(
            documentRef: PdfDocumentRefDirect(_fakeDocument(pageCount)),
            post: post,
            startPage: startPage,
            onRedownload: onRedownload ?? () {},
          ),
        ),
      ),
    );
    // Let the document "load" and the reader settle.
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  testWidgets('shows the pages and the page bar once the document loads', (
    tester,
  ) async {
    await pumpViewer(tester);

    expect(tester.takeException(), isNull);
    expect(find.text('1 / 3'), findsOneWidget);
    expect(find.byType(PdfPageView), findsOneWidget);
  });

  testWidgets('reopens on the saved page', (tester) async {
    await pumpViewer(tester, startPage: 2);

    expect(tester.takeException(), isNull);
    expect(find.text('2 / 3'), findsOneWidget);
    expect(find.textContaining('Kaldığınız yerden'), findsOneWidget);
  });

  testWidgets('offers to download again when the document has no pages', (
    tester,
  ) async {
    var redownloads = 0;
    await pumpViewer(tester, pageCount: 0, onRedownload: () => redownloads++);

    expect(tester.takeException(), isNull);
    expect(find.textContaining('Dergi dosyası açılamadı'), findsOneWidget);
    await tester.tap(find.byType(OutlinedButton));
    expect(redownloads, 1);
  });
}
