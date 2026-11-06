import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/news/data/models/news_model.dart';

void main() {
  test('maps the API shape, splitting keywords and reading the author name',
      () {
    final news = NewsModel.fromJson({
      'id': 'n1',
      'slug': 'yeni-donem',
      'title': 'Yeni Bir Dönem',
      'content': 'Merhaba **Halo** topluluğu!',
      'keywords': 'halo dergisi, yazı gönder, ,yazar paneli',
      'authorId': 'u1',
      'isPublished': true,
      'publishedAt': '2026-05-10T11:53:31.329Z',
      'createdAt': '2026-05-10T11:53:31.396Z',
      'author': {
        'id': 'u1',
        'email': 'editor@halo.test',
        'profile': {'id': 'p1', 'name': 'Editör'},
      },
    }).toEntity();

    expect(news.keywords, ['halo dergisi', 'yazı gönder', 'yazar paneli']);
    expect(news.authorName, 'Editör');
    expect(news.date, DateTime.parse('2026-05-10T11:53:31.329Z'));
  });

  test('tolerates missing keywords and author', () {
    final news = NewsModel.fromJson({
      'id': 'n2',
      'slug': 'kisa',
      'title': 'Kısa',
      'content': 'x',
      'createdAt': '2026-05-10T11:53:31.396Z',
    }).toEntity();

    expect(news.keywords, isEmpty);
    expect(news.authorName, isNull);
    expect(news.date, news.createdAt);
  });
}
