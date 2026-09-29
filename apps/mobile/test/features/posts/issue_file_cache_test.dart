import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/network/api_exception.dart';
import 'package:mobile/features/posts/data/issue_file_cache.dart';

/// Serves [body] for every request (or fails with [status]).
class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.body, {this.status = 200});

  final List<int> body;
  final int status;
  int requests = 0;

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? _, Future<void>? _) async {
    requests++;
    return ResponseBody.fromBytes(body, status, headers: {
      Headers.contentLengthHeader: ['${body.length}'],
    });
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late Directory dir;

  setUp(() async => dir = await Directory.systemTemp.createTemp('issues'));
  tearDown(() async {
    if (await dir.exists()) await dir.delete(recursive: true);
  });

  IssueFileCache cacheWith(_FakeAdapter adapter) =>
      IssueFileCache(Dio()..httpClientAdapter = adapter, () async => dir);

  const url = 'https://cdn.example/Halo 18. Dal.pdf';

  test('downloads once, then serves the saved copy', () async {
    final adapter = _FakeAdapter(utf8.encode('%PDF-1.4 fake'));
    final cache = cacheWith(adapter);
    final progress = <int>[];

    expect(await cache.cached(url), isNull);
    final file = await cache.download(url, onProgress: (received, _) => progress.add(received));

    expect(await file.readAsString(), '%PDF-1.4 fake');
    expect(progress.last, 13);
    expect((await cache.cached(url))?.path, file.path);
    expect(await cache.sizeBytes(), 13);
    expect(adapter.requests, 1);
  });

  test('a failed download leaves nothing behind', () async {
    final cache = cacheWith(_FakeAdapter(utf8.encode('Not found'), status: 404));

    await expectLater(cache.download(url), throwsA(isA<ApiException>()));

    expect(await cache.cached(url), isNull);
    expect(dir.listSync(), isEmpty);
  });

  test('clear frees the space', () async {
    final cache = cacheWith(_FakeAdapter(utf8.encode('%PDF')));
    await cache.download(url);

    await cache.clear();

    expect(await cache.sizeBytes(), 0);
    expect(await cache.cached(url), isNull);
  });
}
