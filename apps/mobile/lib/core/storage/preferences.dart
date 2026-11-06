import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Loaded in `main` before the first frame (so saved choices apply without a
/// flash); `null`, e.g. in tests, just means nothing is persisted.
final sharedPreferencesProvider = Provider<SharedPreferences?>((ref) => null);
