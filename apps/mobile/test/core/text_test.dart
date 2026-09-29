import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/utils/text.dart';

void main() {
  test('turns markdown into a readable one-line excerpt', () {
    expect(
      plainTextExcerpt('## Kader\n\nBu sayıda **kader** temasını [buradan](https://x.y) okuyun.\n\n> Alıntı'),
      'Kader Bu sayıda kader temasını buradan okuyun. Alıntı',
    );
  });
}
