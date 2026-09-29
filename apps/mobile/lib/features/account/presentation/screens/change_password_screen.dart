import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/utils/validators.dart';
import '../../../auth/presentation/widgets/submit_button.dart';
import '../../domain/usecases/change_password.dart';
import '../controllers/account_controller.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _saving = false;

  Future<void> _save() async {
    final form = _formKey.currentState;
    if (form == null || !form.saveAndValidate()) return;
    final values = form.value;
    final messenger = ScaffoldMessenger.of(context);

    setState(() => _saving = true);
    try {
      await ChangePassword(ref.read(accountRepositoryProvider))(
        currentPassword: values['currentPassword'] as String,
        newPassword: values['newPassword'] as String,
      );
      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            'Parolanız değiştirildi. Diğer cihazlardaki oturumlar kapatıldı.',
          ),
        ),
      );
      if (mounted) context.pop();
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parola ve Güvenlik')),
      body: FormBuilder(
        key: _formKey,
        child: AutofillGroup(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              FormBuilderTextField(
                name: 'currentPassword',
                decoration: const InputDecoration(labelText: 'Mevcut Parola'),
                obscureText: true,
                autofillHints: const [AutofillHints.password],
                validator: (v) =>
                    (v ?? '').isEmpty ? 'Mevcut parolanızı girin.' : null,
              ),
              const SizedBox(height: 16),
              FormBuilderTextField(
                name: 'newPassword',
                decoration: const InputDecoration(labelText: 'Yeni Parola'),
                obscureText: true,
                autofillHints: const [AutofillHints.newPassword],
                validator: Validators.password,
              ),
              const SizedBox(height: 16),
              FormBuilderTextField(
                name: 'confirmNewPassword',
                decoration:
                    const InputDecoration(labelText: 'Yeni Parola (Tekrar)'),
                obscureText: true,
                autofillHints: const [AutofillHints.newPassword],
                validator: (v) =>
                    v != _formKey.currentState?.fields['newPassword']?.value
                        ? 'Yeni parolalar eşleşmiyor.'
                        : null,
              ),
              const SizedBox(height: 8),
              Text(
                'Parolanızı değiştirdiğinizde diğer cihazlardaki oturumlarınız kapatılır.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 24),
              SubmitButton(
                label: 'Parolayı Değiştir',
                loading: _saving,
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
