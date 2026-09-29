import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/datasources/info_remote_datasource.dart';
import '../../data/repositories/info_repository_impl.dart';
import '../../domain/entities/team.dart';
import '../../domain/repositories/info_repository.dart';

part 'info_controller.g.dart';

final infoRepositoryProvider = Provider<InfoRepository>(
  (ref) => InfoRepositoryImpl(InfoRemoteDataSource(ref.watch(dioProvider))),
);

@riverpod
Future<List<Crew>> team(Ref ref) => ref.watch(infoRepositoryProvider).getTeam();
