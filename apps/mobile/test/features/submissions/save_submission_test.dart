import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/submissions/domain/entities/submission.dart';
import 'package:mobile/features/submissions/domain/repositories/submissions_repository.dart';
import 'package:mobile/features/submissions/domain/usecases/submission_usecases.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements SubmissionsRepository {}

Submission _existing(ArticleStatus status) => Submission(
      id: 'a1',
      callId: 'c1',
      title: 'Eski',
      status: status,
      createdAt: DateTime(2026),
    );

void main() {
  late _MockRepository repository;
  late SaveSubmission save;

  setUp(() {
    repository = _MockRepository();
    save = SaveSubmission(repository);
    when(
      () => repository.submit(
        callId: any(named: 'callId'),
        title: any(named: 'title'),
        fileUrl: any(named: 'fileUrl'),
        content: any(named: 'content'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => repository.update(
        any(),
        title: any(named: 'title'),
        fileUrl: any(named: 'fileUrl'),
        content: any(named: 'content'),
      ),
    ).thenAnswer((_) async {});
  });

  test('creates a new submission with trimmed fields', () async {
    await save(callId: 'c1', title: '  Kader  ', fileUrl: 'k.pdf', content: '  ');

    verify(
      () => repository.submit(
        callId: 'c1',
        title: 'Kader',
        fileUrl: 'k.pdf',
        content: null,
      ),
    ).called(1);
  });

  test('updates an editable submission', () async {
    await save(
      callId: 'c1',
      title: 'Yeni',
      fileUrl: 'k2.pdf',
      existing: _existing(ArticleStatus.revisionRequested),
    );

    verify(
      () => repository.update('a1', title: 'Yeni', fileUrl: 'k2.pdf', content: null),
    ).called(1);
  });

  test('refuses to touch a submission under review', () {
    expect(
      () => save(
        callId: 'c1',
        title: 'Yeni',
        fileUrl: 'k2.pdf',
        existing: _existing(ArticleStatus.reviewing),
      ),
      throwsStateError,
    );
  });

  test('status mapping and edit rules mirror the API guard', () {
    expect(ArticleStatus.fromApi('REVISION_REQ'), ArticleStatus.revisionRequested);
    expect(ArticleStatus.fromApi('APPROVED').canEdit, isFalse);
    expect(ArticleStatus.fromApi('PENDING').canEdit, isTrue);
  });
}
