import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/utils/cdn.dart';

void main() {
  test('resolves stored paths against the CDN, encoding spaces and unicode', () {
    expect(
      cdnUrl('1788630821567-Halo 18. Dal - Eylül.pdf'),
      'https://cdn.haloidergisi.com/1788630821567-Halo%2018.%20Dal%20-%20Eyl%C3%BCl.pdf',
    );
  });

  test('passes absolute URLs through and ignores empty values', () {
    expect(cdnUrl('https://example.com/a.pdf'), 'https://example.com/a.pdf');
    expect(cdnUrl(null), isNull);
    expect(cdnUrl(''), isNull);
  });
}
