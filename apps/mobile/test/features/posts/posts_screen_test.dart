import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobile/core/models/paginated.dart';
import 'package:mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mobile/features/posts/domain/entities/post.dart';
import 'package:mobile/features/posts/domain/repositories/posts_repository.dart';
import 'package:mobile/features/posts/presentation/controllers/posts_controller.dart';
import 'package:mobile/features/posts/presentation/screens/posts_screen.dart';
import 'package:mocktail/mocktail.dart';

class _MockPosts extends Mock implements PostsRepository {}

class _MockAuth extends Mock implements AuthRepository {}

void main() {
  late _MockPosts posts;
  late _MockAuth auth;

  setUpAll(() => initializeDateFormatting('tr'));

  setUp(() {
    posts = _MockPosts();
    auth = _MockAuth();
    when(() => auth.restoreSession()).thenAnswer((_) async => null);
    when(() => posts.getCategories()).thenAnswer(
      (_) async => const [PostCategory(id: 'c1', name: 'Edebiyat')],
    );
  });

  Future<void> pump(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          postsRepositoryProvider.overrideWithValue(posts),
          authRepositoryProvider.overrideWithValue(auth),
        ],
        child: const MaterialApp(home: PostsScreen()),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('features the latest issue and lists the rest in the archive',
      (tester) async {
    when(
      () => posts.getPosts(
        page: 1,
        limit: any(named: 'limit'),
        categoryId: any(named: 'categoryId'),
        search: any(named: 'search'),
      ),
    ).thenAnswer(
      (_) async => Paginated(
        items: [
          Post(
            id: 'p1',
            slug: 'halo-18',
            title: 'Halo 18. Dal - Eylül 2026 Sayısı',
            createdAt: DateTime.utc(2026, 9, 18, 12),
            content: '**Dönüşüm** üzerine bir sayı.',
            category: const PostCategory(id: 'c1', name: 'Edebiyat'),
          ),
          Post(
            id: 'p0',
            slug: 'halo-17',
            title: 'Halo 17. Dal',
            createdAt: DateTime.utc(2026, 6, 1, 12),
          ),
        ],
        total: 2,
      ),
    );

    await pump(tester);

    // The newest issue is the hero; older ones go to the archive grid.
    expect(find.text('Son sayı'), findsOneWidget);
    expect(find.text('Halo 18. Dal - Eylül 2026 Sayısı'), findsOneWidget);
    expect(find.text('18 Eylül 2026'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Halo 17. Dal'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Halo 17. Dal'), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, 'Edebiyat'), findsOneWidget);
  });

  testWidgets('selecting a category refetches with that filter',
      (tester) async {
    when(
      () => posts.getPosts(
        page: 1,
        limit: any(named: 'limit'),
        categoryId: any(named: 'categoryId'),
        search: any(named: 'search'),
      ),
    ).thenAnswer((_) async => const Paginated(items: [], total: 0));

    await pump(tester);
    expect(find.text('Henüz yayınlanmış dergi yok.'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Edebiyat'));
    await tester.pumpAndSettle();

    verify(
      () => posts.getPosts(
        page: 1,
        limit: any(named: 'limit'),
        categoryId: 'c1',
        search: any(named: 'search'),
      ),
    ).called(1);
  });
}
