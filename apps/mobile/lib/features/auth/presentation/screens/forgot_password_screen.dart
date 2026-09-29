import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/utils/validators.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/submit_button.dart';
import '../widgets/turnstile_form_mixin.dart';

/// Requests a reset email. The link in that email opens the web reset page.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen>
    with TurnstileFormMixin {
  Future<void> _onSubmit() => submit((values, token) async {
        await ref.read(authControllerProvider.notifier).requestPasswordReset(
              email: values['email'] as String,
              turnstileToken: token,
            );
        if (!mounted) return;
        showMessage('Şifre sıfırlama talimatları e-posta adresinize gönderildi.');
        context.go(Routes.login);
      });

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      icon: Icons.lock_reset,
      title: 'Şifremi Unuttum',
      description: 'Şifre sıfırlama bağlantısı için e-posta adresinizi girin',
      child: FormBuilder(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FormBuilderTextField(
              name: 'email',
              decoration: const InputDecoration(labelText: 'E-posta'),
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              textInputAction: TextInputAction.done,
              validator: Validators.email,
            ),
            const SizedBox(height: 16),
            buildTurnstile(),
            const SizedBox(height: 16),
            SubmitButton(
              label: 'Bağlantı Gönder',
              loading: submitting,
              onPressed: _onSubmit,
            ),
          ],
        ),
      ),
    );
  }
}
