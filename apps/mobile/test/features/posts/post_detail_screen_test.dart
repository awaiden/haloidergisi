import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mobile/features/posts/data/issue_file_cache.dart';
import 'package:mobile/features/posts/domain/entities/post.dart';
import 'package:mobile/features/posts/domain/repositories/posts_repository.dart';
import 'package:mobile/features/posts/presentation/controllers/posts_controller.dart';
import 'package:mobile/features/posts/presentation/screens/post_detail_screen.dart';
import 'package:mocktail/mocktail.dart';

class _Posts extends Mock implements PostsRepository {}

class _Auth extends Mock implements AuthRepository {}

void main() {
  setUpAll(() => initializeDateFormatting('tr'));

  testWidgets('offers feedback and other issues', (tester) async {
    final posts = _Posts();
    final auth = _Auth();
    when(() => auth.restoreSession()).thenAnswer((_) async => null);
    when(() => posts.getPost('halo-18')).thenAnswer(
      (_) async => Post(id: 'p18', slug: 'halo-18', title: 'Halo 18. Dal', createdAt: DateTime(2026, 9)),
    );
    when(() => posts.getOtherIssues(excludeId: 'p18')).thenAnswer(
      (_) async => [Post(id: 'p17', slug: 'halo-17', title: 'Halo 17. Dal', createdAt: DateTime(2026, 6))],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          postsRepositoryProvider.overrideWithValue(posts),
          authRepositoryProvider.overrideWithValue(auth),
        ],
        child: const MaterialApp(home: PostDetailScreen(idOrSlug: 'halo-18')),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(find.text('Halo 17. Dal'), 300, scrollable: find.byType(Scrollable).first);
    expect(find.text('Diğer sayılarımıza göz atın'), findsOneWidget);

    await tester.tap(find.text('Geri Bildirim Gönder'));
    await tester.pumpAndSettle();
    expect(find.text('Geri Bildirim'), findsOneWidget);
    expect(find.text('İsim (isteğe bağlı)'), findsOneWidget);
  });

  testWidgets('shows download confirmation dialog when PDF is not cached', (tester) async {
    final posts = _Posts();
    final auth = _Auth();
    when(() => auth.restoreSession()).thenAnswer((_) async => null);
    when(() => posts.getPost('halo-18')).thenAnswer(
      (_) async => Post(
        id: 'p18',
        slug: 'halo-18',
        title: 'Halo 18. Dal',
        attachment: 'issue.pdf',
        createdAt: DateTime(2026, 9),
      ),
    );
    when(() => posts.getOtherIssues(excludeId: 'p18')).thenAnswer((_) async => []);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          postsRepositoryProvider.overrideWithValue(posts),
          authRepositoryProvider.overrideWithValue(auth),
          isIssueCachedProvider('https://cdn.haloidergisi.com/issue.pdf')
              .overrideWith((ref) => false),
        ],
        child: const MaterialApp(home: PostDetailScreen(idOrSlug: 'halo-18')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Dergiyi İndir ve Oku'), findsOneWidget);

    await tester.ensureVisible(find.text('Dergiyi İndir ve Oku'));
    await tester.tap(find.text('Dergiyi İndir ve Oku'));
    await tester.pumpAndSettle();

    expect(find.text('Dijital Sayı (PDF)'), findsOneWidget);
    expect(find.text('Daha Sonra'), findsOneWidget);
    expect(find.text('İndir ve Oku'), findsOneWidget);

    await tester.tap(find.text('Daha Sonra'));
    await tester.pumpAndSettle();

    expect(find.text('Dijital Sayı (PDF)'), findsNothing);
  });

  testWidgets('shows Dergiyi Oku directly when PDF is cached', (tester) async {
    final posts = _Posts();
    final auth = _Auth();
    when(() => auth.restoreSession()).thenAnswer((_) async => null);
    when(() => posts.getPost('halo-18')).thenAnswer(
      (_) async => Post(
        id: 'p18',
        slug: 'halo-18',
        title: 'Halo 18. Dal',
        attachment: 'issue.pdf',
        createdAt: DateTime(2026, 9),
      ),
    );
    when(() => posts.getOtherIssues(excludeId: 'p18')).thenAnswer((_) async => []);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          postsRepositoryProvider.overrideWithValue(posts),
          authRepositoryProvider.overrideWithValue(auth),
          isIssueCachedProvider('https://cdn.haloidergisi.com/issue.pdf')
              .overrideWith((ref) => true),
        ],
        child: const MaterialApp(home: PostDetailScreen(idOrSlug: 'halo-18')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Dergiyi Oku'), findsOneWidget);
    expect(find.text('Dergiyi İndir ve Oku'), findsNothing);
  });
}
