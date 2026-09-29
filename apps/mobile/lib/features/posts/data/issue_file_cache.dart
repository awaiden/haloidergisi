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
  Future<File?> cached(String url) async {
    final file = await _fileFor(url);
    if (!await file.exists()) return null;
    if (await file.length() == 0) {
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
      await _dio.download(
        url,
        partial.path,
        cancelToken: cancelToken,
        onReceiveProgress: (received, total) =>
            onProgress?.call(received, total > 0 ? total : null),
      );
      if (await file.exists()) await file.delete();
      return await partial.rename(file.path);
    } catch (e) {
      if (await partial.exists()) await partial.delete();
      if (e is DioException && CancelToken.isCancel(e)) rethrow;
      throw ApiException.from(e);
    }
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
