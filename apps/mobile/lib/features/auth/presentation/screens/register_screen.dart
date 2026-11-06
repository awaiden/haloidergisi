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

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen>
    with TurnstileFormMixin {
  // `POST /auth/register` returns no session token, so send the user to login.
  Future<void> _onSubmit() => submit((values, token) async {
        final email = (values['email'] as String).trim();
        await ref.read(authControllerProvider.notifier).register(
              name: values['name'] as String,
              email: email,
              password: values['password'] as String,
              turnstileToken: token,
            );
        if (!mounted) return;
        context.go(
          Uri(
            path: Routes.login,
            queryParameters: {'email': email, 'registered': '1'},
          ).toString(),
        );
      });

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      icon: Icons.person_add_alt_1,
      title: 'Yeni Hesap Oluştur',
      description: 'HALO topluluğuna katılmak için hesap oluşturun',
      child: FormBuilder(
        key: formKey,
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FormBuilderTextField(
                name: 'name',
                decoration: const InputDecoration(labelText: 'İsim'),
                autofillHints: const [AutofillHints.name],
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validator: Validators.name,
              ),
              const SizedBox(height: 16),
              FormBuilderTextField(
                name: 'email',
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
                autofillHints: const [AutofillHints.newPassword],
                textInputAction: TextInputAction.done,
                validator: Validators.password,
              ),
              const SizedBox(height: 8),
              FormBuilderCheckbox(
                name: 'acceptTerms',
                initialValue: false,
                title: const Text("Kullanım Şartları'nı kabul ediyorum"),
                decoration: const InputDecoration(border: InputBorder.none),
                validator: (value) => value == true
                    ? null
                    : "Kullanım Şartları'nı kabul etmelisiniz.",
              ),
              const SizedBox(height: 8),
              buildTurnstile(),
              const SizedBox(height: 16),
              SubmitButton(
                label: 'Kayıt Ol',
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
                  const Text('Zaten bir hesabınız var mı?'),
                  TextButton(
                    onPressed: () => context.go(Routes.login),
                    child: const Text('Giriş Yapın'),
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
