import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/files/file_upload.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/user_avatar.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../auth/presentation/widgets/submit_button.dart';
import '../../domain/entities/profile_update.dart';
import '../../domain/usecases/update_profile.dart';
import '../controllers/account_controller.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _saving = false;
  bool _uploadingAvatar = false;

  bool get _isAdmin => ref.read(authControllerProvider).value?.isAdmin ?? false;

  /// CDN key of a newly picked photo; saved together with the form.
  String? _newAvatar;

  Future<void> _pickAvatar() async {
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _uploadingAvatar = true);
    try {
      final key = await ref.read(fileUploaderProvider).pickAndUpload(
            isAdmin: ref.read(authControllerProvider).value?.isAdmin ?? false,
            type: FileType.image,
          );
      if (key != null && mounted) setState(() => _newAvatar = key);
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _uploadingAvatar = false);
    }
  }

  Future<void> _save(String profileId) async {
    final form = _formKey.currentState;
    if (form == null || !form.saveAndValidate()) return;
    final values = form.value;
    final messenger = ScaffoldMessenger.of(context);

    setState(() => _saving = true);
    try {
      await UpdateProfile(ref.read(accountRepositoryProvider))(
        profileId,
        ProfileUpdate(
          name: values['name'] as String,
          title: values['title'] as String?,
          updateTitle: _isAdmin,
          bio: values['bio'] as String?,
          website: values['website'] as String?,
          avatarUrl: _newAvatar,
        ),
      );
      await ref.read(authControllerProvider.notifier).refreshUser();
      messenger.showSnackBar(
        const SnackBar(content: Text('Profiliniz güncellendi.')),
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
    final profile = ref.watch(authControllerProvider).value?.profile;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: profile == null
          ? const Center(child: Text('Profil bulunamadı.'))
          : FormBuilder(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Center(
                    child: UserAvatar(
                      name: profile.name,
                      avatarPath: _newAvatar ?? profile.avatarUrl,
                      radius: 44,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: _uploadingAvatar
                        ? const SizedBox.square(
                            dimension: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : TextButton.icon(
                            onPressed: _saving ? null : _pickAvatar,
                            icon: const Icon(Icons.photo_camera_outlined),
                            label: const Text('Fotoğrafı Değiştir'),
                          ),
                  ),
                  const SizedBox(height: 16),
                  FormBuilderTextField(
                    name: 'name',
                    initialValue: profile.name,
                    decoration: const InputDecoration(
                      labelText: 'İsim',
                      helperText: 'Görünür isminiz.',
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: Validators.name,
                  ),
                  const SizedBox(height: 16),
                  // The title is assigned by admins; others only see it.
                  FormBuilderTextField(
                    name: 'title',
                    initialValue: profile.title,
                    enabled: _isAdmin,
                    decoration: InputDecoration(
                      labelText: 'Unvan',
                      helperText: _isAdmin ? null : 'Unvanınızı yöneticiler belirler.',
                    ),
                  ),
                  const SizedBox(height: 16),
                  FormBuilderTextField(
                    name: 'website',
                    initialValue: profile.website,
                    decoration: const InputDecoration(labelText: 'Website'),
                    keyboardType: TextInputType.url,
                    validator: Validators.optionalUrl,
                  ),
                  const SizedBox(height: 16),
                  FormBuilderTextField(
                    name: 'bio',
                    initialValue: profile.bio,
                    decoration: const InputDecoration(
                      labelText: 'Biyografi',
                      alignLabelWithHint: true,
                    ),
                    minLines: 4,
                    maxLines: 8,
                  ),
                  const SizedBox(height: 24),
                  SubmitButton(
                    label: 'Kaydet',
                    loading: _saving || _uploadingAvatar,
                    onPressed: () => _save(profile.id),
                  ),
                ],
              ),
            ),
    );
  }
}
