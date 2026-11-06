import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/post.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
abstract class CategoryModel with _$CategoryModel {
  const CategoryModel._();

  const factory CategoryModel({required String id, required String name}) =
      _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  PostCategory toEntity() => PostCategory(id: id, name: name);
}

@freezed
abstract class PostModel with _$PostModel {
  const PostModel._();

  const factory PostModel({
    required String id,
    required String slug,
    required String title,
    required DateTime createdAt,
    String? content,
    String? coverImage,
    String? attachment,
    CategoryModel? category,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  Post toEntity() => Post(
    id: id,
    slug: slug,
    title: title,
    createdAt: createdAt,
    content: content,
    coverImage: coverImage,
    attachment: attachment,
    category: category?.toEntity(),
  );
}
