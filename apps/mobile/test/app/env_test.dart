import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/constants/env.dart';

void main() {
  group('resolveApiBaseUrl', () {
    test('uses the define, without a trailing slash', () {
      expect(
        resolveApiBaseUrl('https://staging.example.com/', release: true),
        'https://staging.example.com',
      );
      expect(
        resolveApiBaseUrl('http://192.168.1.20:3000', release: false),
        'http://192.168.1.20:3000',
      );
    });

    test('defaults per build mode when the define is missing', () {
      expect(resolveApiBaseUrl('', release: false), Env.devApiUrl);
      expect(resolveApiBaseUrl('', release: true), Env.productionApiUrl);
    });

    test('never lets a release build call a local API', () {
      for (final local in [
        'http://localhost:3000',
        'http://127.0.0.1:3000',
        'http://10.0.2.2:3000',
        'http://[::1]:3000',
        'http://api.localhost',
        'not a url',
      ]) {
        expect(
          resolveApiBaseUrl(local, release: true),
          Env.productionApiUrl,
          reason: local,
        );
      }
      expect(
        resolveApiBaseUrl('http://localhost:3000', release: false),
        'http://localhost:3000',
      );
    });
  });
}
