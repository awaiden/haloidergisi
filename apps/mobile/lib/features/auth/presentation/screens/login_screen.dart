import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/utils/validators.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/google_sign_in_button.dart';
import '../widgets/submit_button.dart';
import '../widgets/turnstile_form_mixin.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key, this.initialEmail, this.justRegistered = false});

  final String? initialEmail;
  final bool justRegistered;

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with TurnstileFormMixin {
  @override
  void initState() {
    super.initState();
    if (widget.justRegistered) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => showMessage('Kayıt başarılı! Lütfen giriş yapın.'),
      );
    }
  }

  // Success needs no navigation: the router redirects once the session is set.
  Future<void> _onSubmit() => submit(
        (values, token) => ref.read(authControllerProvider.notifier).login(
              email: values['email'] as String,
              password: values['password'] as String,
              turnstileToken: token,
            ),
      );

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      icon: Icons.login,
      title: 'Giriş Yapın',
      description: 'Hesabınıza erişmek için giriş yapın',
      child: FormBuilder(
        key: formKey,
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FormBuilderTextField(
                name: 'email',
                initialValue: widget.initialEmail,
                decoration: const InputDecoration(labelText: 'E-posta'),
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                textInputAction: TextInputAction.next,
                validator: Validators.email,
              ),
              const SizedBox(height: 16),
              FormBuilderTextField(
                name: 'password',
                decoration: const InputDecoration(labelText: 'Şifre'),
                obscureText: true,
                autofillHints: const [AutofillHints.password],
                textInputAction: TextInputAction.done,
                validator: Validators.password,
                onSubmitted: (_) => _onSubmit(),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => context.push(Routes.forgotPassword),
                  child: const Text('Şifremi Unuttum?'),
                ),
              ),
              const SizedBox(height: 8),
              buildTurnstile(),
              const SizedBox(height: 16),
              SubmitButton(
                label: 'Giriş Yap',
                loading: submitting,
                onPressed: _onSubmit,
              ),
              const SizedBox(height: 16),
              const OrDivider(),
              const SizedBox(height: 16),
              const GoogleSignInButton(),
              const SizedBox(height: 8),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text('Hesabınız yok mu?'),
                  TextButton(
                    onPressed: () => context.go(Routes.register),
                    child: const Text('Kayıt Olun'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
