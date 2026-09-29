import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mobile/features/submissions/domain/entities/submission.dart';
import 'package:mobile/features/submissions/domain/repositories/submissions_repository.dart';
import 'package:mobile/features/submissions/presentation/controllers/submissions_controller.dart';
import 'package:mobile/features/submissions/presentation/screens/call_detail_screen.dart';
import 'package:mocktail/mocktail.dart';

class _Auth extends Mock implements AuthRepository {}

class _Submissions extends Mock implements SubmissionsRepository {}

void main() {
  setUpAll(() => initializeDateFormatting('tr'));

  testWidgets('the submit action sits at the bottom, below the call text', (tester) async {
    final auth = _Auth();
    final submissions = _Submissions();
    when(() => auth.restoreSession()).thenAnswer((_) async => null);
    when(() => submissions.getCall('c1')).thenAnswer(
      (_) async => SubmissionCall(
        id: 'c1',
        title: 'Kader',
        description: 'Kader temasına farklı açılardan yaklaşabilirsiniz.',
        startDate: DateTime(2026, 9, 1),
        endDate: DateTime(2026, 10, 30),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(auth),
          submissionsRepositoryProvider.overrideWithValue(submissions),
        ],
        child: const MaterialApp(home: CallDetailScreen(callId: 'c1')),
      ),
    );
    await tester.pumpAndSettle();

    final action = find.text('Yazı göndermek için giriş yapın');
    final body = find.textContaining('Kader temasına');
    expect(action, findsOneWidget);
    final screenHeight = tester.view.physicalSize.height / tester.view.devicePixelRatio;
    expect(tester.getBottomLeft(action).dy, greaterThan(screenHeight - 100));
    expect(tester.getTopLeft(action).dy, greaterThan(tester.getBottomLeft(body).dy));
  });
}
