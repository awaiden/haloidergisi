import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/storage/preferences.dart';
import '../constants/storage_keys.dart';

part 'theme_mode_controller.g.dart';

/// Sistem / Açık / Koyu, remembered across launches.
@Riverpod(keepAlive: true)
class ThemeModeController extends _$ThemeModeController {
  @override
  ThemeMode build() {
    final saved = ref.watch(sharedPreferencesProvider)?.getString(StorageKeys.themeMode);
    return ThemeMode.values.asNameMap()[saved] ?? ThemeMode.system;
  }

  Future<void> set(ThemeMode mode) async {
    state = mode;
    await ref.read(sharedPreferencesProvider)?.setString(StorageKeys.themeMode, mode.name);
  }
}
