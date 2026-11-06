/// Form validators mirroring the API DTOs (`apps/api/src/modules/auth/auth.dto.ts`)
/// with the same Turkish messages as the web forms.
abstract final class Validators {
  static final _email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (!_email.hasMatch(v)) return 'Geçerli bir e-posta adresi girin.';
    return null;
  }

  static String? password(String? value) {
    final v = value ?? '';
    if (v.length < 6) return 'Şifre en az 6 karakter olmalıdır.';
    if (v.length > 100) return 'Şifre en fazla 100 karakter olabilir.';
    return null;
  }

  static String? name(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'İsim gereklidir.';
    if (v.length < 3) return 'İsim en az 3 karakter olmalıdır.';
    if (v.length > 50) return 'İsim en fazla 50 karakter olabilir.';
    return null;
  }

  static String? optionalUrl(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return null;
    final uri = Uri.tryParse(v);
    if (uri == null ||
        !uri.hasAuthority ||
        !uri.isScheme('http') && !uri.isScheme('https')) {
      return 'Geçerli bir bağlantı girin (https://…).';
    }
    return null;
  }
}
