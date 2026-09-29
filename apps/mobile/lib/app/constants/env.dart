abstract final class Env {
  /// Local API. On Android (device or emulator) run
  /// `adb reverse tcp:3000 tcp:3000` so the phone's localhost reaches your
  /// machine; the iOS simulator shares the host's localhost already.
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
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
