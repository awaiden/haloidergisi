import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/posts/data/reading_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('remembers the last page per issue', () async {
    SharedPreferences.setMockInitialValues({});
    final progress = ReadingProgress(await SharedPreferences.getInstance());

    expect(progress.lastPage('halo-18'), isNull);
    await progress.save('halo-18', 42);
    await progress.save('halo-17', 3);

    expect(progress.lastPage('halo-18'), 42);
    expect(progress.lastPage('halo-17'), 3);
  });

  test('works (without persisting) when preferences are unavailable', () async {
    final progress = ReadingProgress(null);
    await progress.save('halo-18', 5);
    expect(progress.lastPage('halo-18'), isNull);
  });
}
