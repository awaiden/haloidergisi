import 'package:flutter/foundation.dart';

abstract final class Env {
  static const productionApiUrl = 'https://api.haloidergisi.com';

  /// Local API for debug builds. On Android (device or emulator) run
  /// `adb reverse tcp:3000 tcp:3000` so the phone's localhost reaches your
  /// machine; the iOS simulator shares the host's localhost already.
  static const devApiUrl = 'http://localhost:3000';

  /// `API_BASE_URL` from `--dart-define`, or the default for the build mode.
  /// Release builds never use a local address (`dart_defines.json` usually
  /// holds one), so a store build can't ship pointing at a laptop.
  static final apiBaseUrl = resolveApiBaseUrl(
    const String.fromEnvironment('API_BASE_URL'),
    release: kReleaseMode,
  );

  /// Same value as `VITE_TURNSTILE_SITE_KEY` in the root `.env`. Site keys are
  /// public (the web ships it in its bundle), so the production key is the default.
  static const turnstileSiteKey = String.fromEnvironment(
    'TURNSTILE_SITE_KEY',
    defaultValue: '0x4AAAAAACN8voBpRMLOZ9Nu',
  );

  /// On Android/iOS the Turnstile WebView must load from a hostname that is in
  /// the widget's allowed domains list.
  static const turnstileBaseUrl = String.fromEnvironment(
    'TURNSTILE_BASE_URL',
    defaultValue: 'https://haloidergisi.com/',
  );

  /// Same value as `VITE_CDN_URL`; relative file paths (covers, PDFs) resolve against it.
  static const cdnBaseUrl = String.fromEnvironment(
    'CDN_BASE_URL',
    defaultValue: 'https://cdn.haloidergisi.com/',
  );
}

/// See [Env.apiBaseUrl].
@visibleForTesting
String resolveApiBaseUrl(String value, {required bool release}) {
  final url = value.trim().replaceFirst(RegExp(r'/+$'), '');
  if (url.isEmpty) return release ? Env.productionApiUrl : Env.devApiUrl;
  if (release && _isLocal(url)) return Env.productionApiUrl;
  return url;
}

const _loopbackHosts = {'localhost', '127.0.0.1', '0.0.0.0', '::1', '10.0.2.2'};

bool _isLocal(String url) {
  final host = Uri.tryParse(url)?.host ?? '';
  return host.isEmpty ||
      _loopbackHosts.contains(host) ||
      host.endsWith('.localhost');
}
