import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/widgets/error_retry.dart';
import '../../../auth/presentation/widgets/submit_button.dart';
import '../../domain/entities/submission.dart';
import '../../domain/usecases/submission_usecases.dart';
import '../controllers/submissions_controller.dart';
import '../widgets/upload_file_field.dart';
import '../../../../core/widgets/halo.dart';

/// Send a piece to a call, or edit the existing one while it is editable.
class SubmitScreen extends ConsumerWidget {
  const SubmitScreen({super.key, required this.callId});

  final String callId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final call = ref.watch(callDetailProvider(callId));
    final mine = ref.watch(mySubmissionForProvider(callId));

    return Scaffold(
      appBar: AppBar(title: Text(call.value?.title.trim() ?? 'Yazı Gönder')),
      body: switch ((call, mine)) {
        (AsyncError(:final error), _) || (_, AsyncError(:final error)) =>
          ErrorRetry(
            error: error,
            onRetry: () {
              ref.invalidate(callDetailProvider(callId));
              ref.invalidate(mySubmissionForProvider(callId));
            },
          ),
        (AsyncData(), AsyncData(value: final existing)) =>
          existing != null && !existing.status.canEdit
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      'Yazınız "${existing.status.label}" durumunda; şu anda düzenlenemez.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : _SubmitForm(callId: callId, existing: existing),
        _ => const HaloLoading(),
      },
    );
  }
}

class _SubmitForm extends ConsumerStatefulWidget {
  const _SubmitForm({required this.callId, required this.existing});

  final String callId;
  final Submission? existing;

  @override
  ConsumerState<_SubmitForm> createState() => _SubmitFormState();
}

class _SubmitFormState extends ConsumerState<_SubmitForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _saving = false;

  Future<void> _save() async {
    final form = _formKey.currentState;
    if (form == null || !form.saveAndValidate()) return;
    final values = form.value;
    final messenger = ScaffoldMessenger.of(context);

    setState(() => _saving = true);
    try {
      await SaveSubmission(ref.read(submissionsRepositoryProvider))(
        callId: widget.callId,
        title: values['title'] as String,
        fileUrl: values['fileUrl'] as String,
        content: values['content'] as String?,
        existing: widget.existing,
      );
      ref
        ..invalidate(mySubmissionForProvider(widget.callId))
        ..invalidate(mySubmissionsProvider);
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            widget.existing == null
                ? 'Yazınız gönderildi. Değerlendirme sonucunu e-posta ile bildireceğiz.'
                : 'Yazınız güncellendi.',
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
    final existing = widget.existing;

    return FormBuilder(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (existing?.adminNote?.isNotEmpty ?? false) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Editör notu: ${existing!.adminNote}'),
              ),
            ),
            const SizedBox(height: 16),
          ],
          FormBuilderTextField(
            name: 'title',
            initialValue: existing?.title,
            decoration: const InputDecoration(labelText: 'Yazı Başlığı'),
            textCapitalization: TextCapitalization.sentences,
            validator: (value) {
              final v = value?.trim() ?? '';
              if (v.length < 3) return 'Başlık en az 3 karakter olmalıdır.';
              if (v.length > 100) return 'Başlık 100 karakteri geçemez.';
              return null;
            },
          ),
          const SizedBox(height: 16),
          UploadFileField(name: 'fileUrl', initialValue: existing?.fileUrl),
          const SizedBox(height: 16),
          FormBuilderTextField(
            name: 'content',
            initialValue: existing?.content,
            decoration: const InputDecoration(
              labelText: 'Editöre not (isteğe bağlı)',
              alignLabelWithHint: true,
            ),
            minLines: 3,
            maxLines: 6,
          ),
          const SizedBox(height: 24),
          SubmitButton(
            label: existing == null ? 'Gönder' : 'Güncelle',
            loading: _saving,
            onPressed: _save,
          ),
        ],
      ),
    );
  }
}
