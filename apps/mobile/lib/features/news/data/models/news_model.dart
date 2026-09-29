import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/news.dart';

part 'news_model.freezed.dart';
part 'news_model.g.dart';

@freezed
abstract class NewsAuthorModel with _$NewsAuthorModel {
  const factory NewsAuthorModel({NewsAuthorProfileModel? profile}) =
      _NewsAuthorModel;

  factory NewsAuthorModel.fromJson(Map<String, dynamic> json) =>
      _$NewsAuthorModelFromJson(json);
}

@freezed
abstract class NewsAuthorProfileModel with _$NewsAuthorProfileModel {
  const factory NewsAuthorProfileModel({required String name}) =
      _NewsAuthorProfileModel;

  factory NewsAuthorProfileModel.fromJson(Map<String, dynamic> json) =>
      _$NewsAuthorProfileModelFromJson(json);
}

@freezed
abstract class NewsModel with _$NewsModel {
  const NewsModel._();

  const factory NewsModel({
    required String id,
    required String slug,
    required String title,
    required String content,
    required DateTime createdAt,
    DateTime? publishedAt,
    String? keywords,
    NewsAuthorModel? author,
  }) = _NewsModel;

  factory NewsModel.fromJson(Map<String, dynamic> json) =>
      _$NewsModelFromJson(json);

  News toEntity() => News(
        id: id,
        slug: slug,
        title: title,
        content: content,
        createdAt: createdAt,
        publishedAt: publishedAt,
        keywords: (keywords ?? '')
            .split(',')
            .map((k) => k.trim())
            .where((k) => k.isNotEmpty)
            .toList(),
        authorName: author?.profile?.name,
      );
}
