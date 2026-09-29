import '../../app/constants/env.dart';

/// Mirrors `getCdnUrl` in `apps/web/src/utils/cdn.ts`: stored file paths are
/// relative to the CDN, absolute URLs pass through.
String? cdnUrl(String? path) {
  if (path == null || path.isEmpty) return null;
  if (path.startsWith('http://') || path.startsWith('https://')) return path;
  final base = Env.cdnBaseUrl.endsWith('/')
      ? Env.cdnBaseUrl
      : '${Env.cdnBaseUrl}/';
  return Uri.parse(base).resolve(path).toString();
}
