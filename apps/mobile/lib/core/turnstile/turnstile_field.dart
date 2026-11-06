import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../app/constants/env.dart';

/// Cloudflare Turnstile challenge for endpoints guarded by `TurnstileGuard`,
/// rendered with Cloudflare's own `api.js` inside a WebView.
///
/// It verifies automatically (`appearance: "interaction-only"`): the widget
/// takes no space until Cloudflare actually needs the user to interact.
///
/// Tokens are single-use: after a failed submit call [TurnstileFieldState.reset]
/// (via a `GlobalKey<TurnstileFieldState>`) to get a fresh one.
class TurnstileField extends StatefulWidget {
  const TurnstileField({super.key, required this.onTokenChanged});

  final ValueChanged<String?> onTokenChanged;

  @override
  State<TurnstileField> createState() => TurnstileFieldState();
}

class TurnstileFieldState extends State<TurnstileField> {
  WebViewController? _controller;

  /// True while Cloudflare shows an interactive challenge.
  bool _interactive = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // No WebView implementation in widget tests (plugins aren't registered).
    if (_controller != null || WebViewPlatform.instance == null) return;

    final dark = Theme.of(context).brightness == Brightness.dark;
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..addJavaScriptChannel('TurnstileChannel', onMessageReceived: _onMessage)
      // The baseUrl hostname must be in the widget's allowed domains list.
      ..loadHtmlString(
        _html(siteKey: Env.turnstileSiteKey, theme: dark ? 'dark' : 'light'),
        baseUrl: Env.turnstileBaseUrl,
      );
  }

  void _onMessage(JavaScriptMessage message) {
    final data = message.message;
    if (data == 'interactive:on' || data == 'interactive:off') {
      if (mounted) setState(() => _interactive = data == 'interactive:on');
      return;
    }
    widget.onTokenChanged(
      data.startsWith('token:') ? data.substring('token:'.length) : null,
    );
  }

  Future<void> reset() async {
    widget.onTokenChanged(null);
    await _controller?.runJavaScript('resetTurnstile()');
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null) {
      return Text(
        'Doğrulama bu cihazda yüklenemiyor.',
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      );
    }

    // Stays in the tree (it must keep running) but collapses while the check
    // runs invisibly in the background.
    return Center(
      child: AnimatedSize(
        duration: const Duration(milliseconds: 200),
        child: SizedBox(
          width: 300,
          height: _interactive ? 65 : 1,
          child: WebViewWidget(controller: controller),
        ),
      ),
    );
  }
}

String _html({required String siteKey, required String theme}) =>
    '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <style>html, body { margin: 0; background: transparent; overflow: hidden; }</style>
  <script src="https://challenges.cloudflare.com/turnstile/v0/api.js?onload=onTurnstileLoad&render=explicit" async defer></script>
</head>
<body>
  <div id="widget"></div>
  <script>
    var widgetId;
    function post(message) { TurnstileChannel.postMessage(message); }
    function onTurnstileLoad() {
      widgetId = turnstile.render('#widget', {
        sitekey: ${jsonEncode(siteKey)},
        theme: ${jsonEncode(theme)},
        language: 'tr',
        appearance: 'interaction-only',
        'refresh-expired': 'auto',
        callback: function (token) { post('interactive:off'); post('token:' + token); },
        'before-interactive-callback': function () { post('interactive:on'); },
        'after-interactive-callback': function () { post('interactive:off'); },
        'expired-callback': function () { post('expired'); },
        'error-callback': function () { post('error'); },
      });
    }
    function resetTurnstile() {
      if (widgetId !== undefined) turnstile.reset(widgetId);
    }
  </script>
</body>
</html>
''';
