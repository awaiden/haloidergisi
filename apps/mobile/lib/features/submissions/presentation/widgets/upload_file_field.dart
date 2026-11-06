import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/files/file_upload.dart';
import '../../../../core/network/api_exception.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

/// Formats the web submit form accepts.
const submissionFileExtensions = [
  'docx', 'doc', 'pdf', 'rtf', 'odt', 'txt', 'md', 'html', //
];

/// Picks a document and uploads it right away (`POST /files`); the field's
/// value is the returned CDN key, as on the web form.
class UploadFileField extends ConsumerStatefulWidget {
  const UploadFileField({super.key, required this.name, this.initialValue});

  final String name;
  final String? initialValue;

  @override
  ConsumerState<UploadFileField> createState() => _UploadFileFieldState();
}

class _UploadFileFieldState extends ConsumerState<UploadFileField> {
  bool _uploading = false;

  Future<void> _pickAndUpload(FormFieldState<String> field) async {
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _uploading = true);
    try {
      final key = await ref.read(fileUploaderProvider).pickAndUpload(
            isAdmin: ref.read(authControllerProvider).value?.isAdmin ?? false,
            type: FileType.custom,
            allowedExtensions: submissionFileExtensions,
          );
      if (key != null) field.didChange(key);
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<String>(
      name: widget.name,
      initialValue: widget.initialValue,
      validator: (value) => value == null || value.isEmpty
          ? 'Lütfen yazınızın dosyasını yükleyin.'
          : null,
      builder: (field) {
        final value = field.value;
        return InputDecorator(
          decoration: InputDecoration(
            labelText: 'Dosya',
            helperText: submissionFileExtensions.join(', '),
            errorText: field.errorText,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value == null ? 'Dosya seçilmedi' : _displayName(value),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              _uploading
                  ? const SizedBox.square(
                      dimension: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : TextButton.icon(
                      onPressed: () => _pickAndUpload(field),
                      icon: const Icon(Icons.attach_file),
                      label: Text(value == null ? 'Seç' : 'Değiştir'),
                    ),
            ],
          ),
        );
      },
    );
  }
}

/// Stored keys look like `<timestamp>-<original name>`.
String _displayName(String key) =>
    key.replaceFirst(RegExp(r'^\d+-'), '');
