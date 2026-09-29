import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobile/features/posts/data/issue_file_cache.dart';
import 'package:mobile/features/posts/domain/entities/post.dart';
import 'package:mobile/features/posts/domain/repositories/posts_repository.dart';
import 'package:mobile/features/posts/presentation/controllers/posts_controller.dart';
import 'package:mobile/features/posts/presentation/screens/issue_reader_screen.dart';
import 'package:mocktail/mocktail.dart';

class _Posts extends Mock implements PostsRepository {}
class _Cache extends Mock implements IssueFileCache {}

void main() {
  setUpAll(() => initializeDateFormatting('tr'));

  testWidgets('prompts before downloading when PDF is not cached', (tester) async {
    final posts = _Posts();
    final cache = _Cache();

    when(() => posts.getPost('halo-18')).thenAnswer(
      (_) async => Post(
        id: 'p18',
        slug: 'halo-18',
        title: 'Halo 18. Dal',
        attachment: 'issue.pdf',
        createdAt: DateTime(2026, 9),
      ),
    );

    when(() => cache.cached(any())).thenAnswer((_) async => null);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          postsRepositoryProvider.overrideWithValue(posts),
          issueFileCacheProvider.overrideWithValue(cache),
        ],
        child: const MaterialApp(home: IssueReaderScreen(idOrSlug: 'halo-18')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Halo 18. Dal'), findsWidgets);
    expect(find.text('İndir ve Oku'), findsOneWidget);
    expect(find.text('Geri Dön'), findsOneWidget);
  });
}
