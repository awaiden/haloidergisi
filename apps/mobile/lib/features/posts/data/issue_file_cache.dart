import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/network/api_exception.dart';

final issueFileCacheProvider = Provider<IssueFileCache>(
  (ref) => IssueFileCache(
    Dio(),
    () async =>
        Directory('${(await getApplicationCacheDirectory()).path}/issues'),
  ),
);

final isIssueCachedProvider = FutureProvider.family<bool, String>(
  (ref, url) async {
    final cache = ref.watch(issueFileCacheProvider);
    return (await cache.cached(url)) != null;
  },
);

/// Downloaded issue PDFs, kept in the app's cache folder so reopening an
/// issue is instant (and works offline). The OS may reclaim the space when
/// storage runs low; Ayarlar can also clear it.
class IssueFileCache {
  IssueFileCache(this._dio, this._directory);

  final Dio _dio;
  final Future<Directory> Function() _directory;

  Future<File> _fileFor(String url) async {
    final dir = await _directory();
    final name = sha1.convert(utf8.encode(url)).toString();
    return File('${dir.path}/$name.pdf');
  }

  /// The saved copy of [url], or `null` if it hasn't been downloaded.
  /// A saved file that isn't a PDF (e.g. an HTML page an older build stored)
  /// is dropped, so the reader offers a fresh download instead of failing.
  Future<File?> cached(String url) async {
    final file = await _fileFor(url);
    if (!await file.exists()) return null;
    if (!await _looksLikePdf(file)) {
      await file.delete();
      return null;
    }
    return file;
  }

  /// Downloads [url] (reporting bytes received / total) and returns the file.
  /// Writes to a `.part` file first, so an interrupted download never
  /// looks complete.
  Future<File> download(
    String url, {
    void Function(int received, int? total)? onProgress,
    CancelToken? cancelToken,
  }) async {
    final file = await _fileFor(url);
    await file.parent.create(recursive: true);
    final partial = File('${file.path}.part');
    try {
      if (await partial.exists()) await partial.delete();
      final response = await _dio.download(
        url,
        partial.path,
        cancelToken: cancelToken,
        onReceiveProgress: (received, total) =>
            onProgress?.call(received, total > 0 ? total : null),
      );
      // A CDN or proxy can answer 200 with an HTML page (challenge, login,
      // error). Saving that as the issue would make it unopenable forever.
      if (!await _looksLikePdf(partial)) {
        final type = response.headers.value(Headers.contentTypeHeader);
        throw ApiException(
          'Sunucu PDF yerine başka bir içerik gönderdi'
          '${type == null ? '' : ' ($type)'}. Lütfen daha sonra tekrar deneyin.',
        );
      }
      if (await file.exists()) await file.delete();
      return await partial.rename(file.path);
    } catch (e) {
      if (await partial.exists()) await partial.delete();
      if (e is DioException && CancelToken.isCancel(e)) rethrow;
      if (e is ApiException) rethrow;
      throw ApiException.from(e);
    }
  }

  /// PDFs start with `%PDF` (the spec allows up to 1 KB of junk before it).
  static Future<bool> _looksLikePdf(File file) async {
    if (!await file.exists() || await file.length() == 0) return false;
    final head = <int>[];
    await for (final chunk in file.openRead(0, 1024)) {
      head.addAll(chunk);
    }
    return latin1.decode(head, allowInvalid: true).contains('%PDF');
  }

  /// Total size of downloaded issues, in bytes.
  Future<int> sizeBytes() async {
    final dir = await _directory();
    if (!await dir.exists()) return 0;
    var total = 0;
    await for (final entity in dir.list()) {
      if (entity is File) total += await entity.length();
    }
    return total;
  }

  Future<void> clear() async {
    final dir = await _directory();
    if (await dir.exists()) await dir.delete(recursive: true);
  }
}
