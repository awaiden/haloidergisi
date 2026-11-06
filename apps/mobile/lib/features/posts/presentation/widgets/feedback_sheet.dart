import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/validators.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../auth/presentation/widgets/submit_button.dart';
import '../../../auth/presentation/widgets/turnstile_form_mixin.dart';
import '../../../info/domain/entities/contact_message.dart';
import '../../../info/presentation/controllers/info_controller.dart';
import '../../domain/entities/post.dart';

/// Opens the "Geri Bildirim Gönder" sheet for an issue (same as the web's
/// feedback dialog: name and email optional, sent as a message).
Future<void> showFeedbackSheet(BuildContext context, Post post) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _FeedbackForm(post: post),
    );

class _FeedbackForm extends ConsumerStatefulWidget {
  const _FeedbackForm({required this.post});

  final Post post;

  @override
  ConsumerState<_FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends ConsumerState<_FeedbackForm> with TurnstileFormMixin {
  Future<void> _onSubmit() => submit((values, token) async {
        String? optional(String key) {
          final value = (values[key] as String?)?.trim();
          return value == null || value.isEmpty ? null : value;
        }

        await ref.read(infoRepositoryProvider).sendMessage(
              ContactMessage(
                subject: 'Dergi Geri Bildirimi: ${widget.post.title}',
                // Same placeholders as the web form when left empty.
                name: optional('name') ?? 'Anonim',
                email: optional('email') ?? 'anon@example.com',
                content: (values['content'] as String).trim(),
              ),
              turnstileToken: token,
            );
        if (!mounted) return;
        final messenger = ScaffoldMessenger.of(context);
        Navigator.of(context).pop();
        messenger.showSnackBar(
          const SnackBar(content: Text('Geri bildiriminiz için teşekkürler!')),
        );
      });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = ref.watch(authControllerProvider).value;

    return Padding(
      // Keep the form above the keyboard.
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: FormBuilder(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Geri Bildirim Gönder', style: theme.textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(
                '${widget.post.title} hakkında düşüncelerinizi editörlerimize iletin.',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 20),
              FormBuilderTextField(
                name: 'content',
                decoration: const InputDecoration(
                  labelText: 'Geri Bildirim',
                  alignLabelWithHint: true,
                ),
                minLines: 4,
                maxLines: 8,
                textCapitalization: TextCapitalization.sentences,
                validator: (value) =>
                    (value?.trim().isEmpty ?? true) ? 'Lütfen geri bildiriminizi yazın.' : null,
              ),
              const SizedBox(height: 16),
              FormBuilderTextField(
                name: 'name',
                initialValue: user?.profile?.name,
                decoration: const InputDecoration(labelText: 'İsim (isteğe bağlı)'),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              FormBuilderTextField(
                name: 'email',
                initialValue: user?.email,
                decoration: const InputDecoration(labelText: 'E-posta (isteğe bağlı)'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    (value?.trim().isEmpty ?? true) ? null : Validators.email(value),
              ),
              const SizedBox(height: 16),
              buildTurnstile(),
              const SizedBox(height: 16),
              SubmitButton(label: 'Gönder', loading: submitting, onPressed: _onSubmit),
            ],
          ),
        ),
      ),
    );
  }
}
