import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/storage/preferences.dart';

final readingProgressProvider = Provider<ReadingProgress>(
  (ref) => ReadingProgress(ref.watch(sharedPreferencesProvider)),
);

/// Last page read per issue, so the reader reopens where the user left off.
class ReadingProgress {
  ReadingProgress(this._preferences);

  final SharedPreferences? _preferences;

  static String _key(String slug) => 'reader_page:$slug';

  int? lastPage(String slug) => _preferences?.getInt(_key(slug));

  Future<void> save(String slug, int page) async =>
      _preferences?.setInt(_key(slug), page);
}
