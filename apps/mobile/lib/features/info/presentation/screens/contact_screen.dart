import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/validators.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../auth/presentation/widgets/submit_button.dart';
import '../../../auth/presentation/widgets/turnstile_form_mixin.dart';
import '../../domain/entities/contact_message.dart';
import '../controllers/info_controller.dart';

class ContactScreen extends ConsumerStatefulWidget {
  const ContactScreen({super.key});

  @override
  ConsumerState<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends ConsumerState<ContactScreen> with TurnstileFormMixin {
  Future<void> _onSubmit() => submit((values, token) async {
        await ref.read(infoRepositoryProvider).sendMessage(
              ContactMessage(
                name: (values['name'] as String).trim(),
                email: (values['email'] as String).trim(),
                subject: (values['subject'] as String).trim(),
                content: (values['content'] as String).trim(),
              ),
              turnstileToken: token,
            );
        if (!mounted) return;
        showMessage('Mesajınız başarıyla gönderildi!');
        context.pop();
      });

  String? _required(String? value, String label) =>
      (value?.trim().isEmpty ?? true) ? '$label gereklidir.' : null;

  @override
  Widget build(BuildContext context) {
    // Signed-in users don't have to type their name and email again.
    final user = ref.watch(authControllerProvider).value;

    return Scaffold(
      appBar: AppBar(title: const Text('İletişim')),
      body: FormBuilder(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Bizimle iletişime geçmek için aşağıdaki formu doldurun.'),
            const SizedBox(height: 16),
            FormBuilderTextField(
              name: 'name',
              initialValue: user?.profile?.name,
              decoration: const InputDecoration(labelText: 'İsim'),
              textCapitalization: TextCapitalization.words,
              validator: (v) => _required(v, 'İsim'),
            ),
            const SizedBox(height: 16),
            FormBuilderTextField(
              name: 'email',
              initialValue: user?.email,
              decoration: const InputDecoration(labelText: 'E-posta'),
              keyboardType: TextInputType.emailAddress,
              validator: Validators.email,
            ),
            const SizedBox(height: 16),
            FormBuilderTextField(
              name: 'subject',
              decoration: const InputDecoration(labelText: 'Konu'),
              validator: (v) => _required(v, 'Konu'),
            ),
            const SizedBox(height: 16),
            FormBuilderTextField(
              name: 'content',
              decoration: const InputDecoration(
                labelText: 'Mesaj',
                alignLabelWithHint: true,
              ),
              minLines: 5,
              maxLines: 10,
              validator: (v) => _required(v, 'Mesaj'),
            ),
            const SizedBox(height: 16),
            buildTurnstile(),
            const SizedBox(height: 16),
            SubmitButton(label: 'Gönder', loading: submitting, onPressed: _onSubmit),
          ],
        ),
      ),
    );
  }
}
