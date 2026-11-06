import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/turnstile/turnstile_field.dart';

/// Form + Turnstile + submitting state shared by the Turnstile-guarded auth forms.
mixin TurnstileFormMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  final formKey = GlobalKey<FormBuilderState>();
  final _turnstileKey = GlobalKey<TurnstileFieldState>();
  String? _turnstileToken;
  Completer<String>? _tokenWaiter;
  bool submitting = false;

  Widget buildTurnstile() => TurnstileField(
        key: _turnstileKey,
        onTokenChanged: (token) {
          _turnstileToken = token;
          if (token != null && !(_tokenWaiter?.isCompleted ?? true)) {
            _tokenWaiter!.complete(token);
          }
        },
      );

  /// The background check usually finishes while the user types; if they are
  /// faster, wait a little instead of failing right away.
  Future<String?> _awaitToken() async {
    final current = _turnstileToken;
    if (current != null) return current;
    _tokenWaiter = Completer<String>();
    try {
      return await _tokenWaiter!.future.timeout(const Duration(seconds: 10));
    } on TimeoutException {
      return null;
    } finally {
      _tokenWaiter = null;
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  /// Validates the form, then runs [action] with the form values and a
  /// Turnstile token. On API failure the error is shown and the (single-use)
  /// token is refreshed.
  Future<void> submit(
    Future<void> Function(Map<String, dynamic> values, String turnstileToken)
        action,
  ) async {
    final form = formKey.currentState;
    if (form == null || !form.saveAndValidate()) return;

    setState(() => submitting = true);
    try {
      final token = await _awaitToken();
      if (!mounted) return;
      if (token == null) {
        showMessage('Güvenlik doğrulaması tamamlanamadı. Lütfen tekrar deneyin.');
        return;
      }
      await action(form.value, token);
    } on ApiException catch (e) {
      if (!mounted) return;
      showMessage(e.message);
      await _turnstileKey.currentState?.reset();
    } finally {
      if (mounted) setState(() => submitting = false);
    }
  }
}
