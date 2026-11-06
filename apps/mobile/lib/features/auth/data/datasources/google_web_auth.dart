import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

import '../../../../core/network/api_exception.dart';

/// Opens the API's Google flow in a secure browser tab (Custom Tabs /
/// ASWebAuthenticationSession) and returns the `halo://` callback URL.
abstract interface class WebAuthenticator {
  /// Returns the callback URL, or `null` if the user closed the browser.
  Future<Uri?> authenticate(Uri url);
}

/// Scheme registered for `CallbackActivity` in the Android manifest
/// (the API redirects to `halo://auth-callback`).
const googleCallbackScheme = 'halo';

class FlutterWebAuthenticator implements WebAuthenticator {
  const FlutterWebAuthenticator();

  @override
  Future<Uri?> authenticate(Uri url) async {
    try {
      final result = await FlutterWebAuth2.authenticate(
        url: url.toString(),
        callbackUrlScheme: googleCallbackScheme,
      );
      return Uri.parse(result);
    } on PlatformException catch (e) {
      if (e.code == 'CANCELED') return null;
      debugPrint('Google sign-in browser error: ${e.code} ${e.message} ${e.details}');
      throw ApiException(switch (e.code) {
        'NO_BROWSER' => 'Google girişi için bir tarayıcı bulunamadı.',
        'CANNOT_RESTORE' => 'Oturum kayboldu, lütfen tekrar deneyin.',
        _ => 'Google girişi açılamadı (${e.code}: ${e.message}).',
      });
    } on MissingPluginException {
      // Native plugins are only added by a full rebuild, not hot reload/restart.
      throw const ApiException(
        'Google girişi eklentisi yüklenmedi. Uygulamayı kapatıp flutter run ile yeniden başlatın.',
      );
    }
  }
}
