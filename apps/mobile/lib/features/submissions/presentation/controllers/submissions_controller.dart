import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/datasources/submissions_remote_datasource.dart';
import '../../data/repositories/submissions_repository_impl.dart';
import '../../domain/entities/submission.dart';
import '../../domain/repositories/submissions_repository.dart';
import '../../domain/usecases/submission_usecases.dart';

part 'submissions_controller.g.dart';

final submissionsRepositoryProvider = Provider<SubmissionsRepository>(
  (ref) => SubmissionsRepositoryImpl(
    SubmissionsRemoteDataSource(ref.watch(dioProvider)),
  ),
);

@riverpod
Future<List<SubmissionCall>> activeCalls(Ref ref) =>
    GetActiveCalls(ref.watch(submissionsRepositoryProvider))();

@riverpod
Future<SubmissionCall> callDetail(Ref ref, String id) =>
    ref.watch(submissionsRepositoryProvider).getCall(id);

/// The signed-in user's submission to a call; only watch while signed in.
@riverpod
Future<Submission?> mySubmissionFor(Ref ref, String callId) =>
    ref.watch(submissionsRepositoryProvider).getMySubmissionFor(callId);

@riverpod
Future<List<Submission>> mySubmissions(Ref ref) =>
    GetMySubmissions(ref.watch(submissionsRepositoryProvider))();
