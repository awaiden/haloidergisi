import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/datasources/news_remote_datasource.dart';
import '../../data/repositories/news_repository_impl.dart';
import '../../domain/entities/news.dart';
import '../../domain/repositories/news_repository.dart';
import '../../domain/usecases/get_news.dart';
import '../../domain/usecases/get_news_item.dart';

part 'news_controller.g.dart';

final newsRepositoryProvider = Provider<NewsRepository>(
  (ref) => NewsRepositoryImpl(NewsRemoteDataSource(ref.watch(dioProvider))),
);

@riverpod
Future<List<News>> newsList(Ref ref) =>
    GetNews(ref.watch(newsRepositoryProvider))();

@riverpod
Future<News> newsDetail(Ref ref, String idOrSlug) =>
    GetNewsItem(ref.watch(newsRepositoryProvider))(idOrSlug);
