import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/constants/env.dart';
import '../storage/token_storage.dart';
import 'auth_interceptor.dart';

/// Fires when an authenticated request comes back 401 (token expired or
/// revoked). The auth controller listens and signs the user out.
final sessionExpiredProvider = Provider<StreamController<void>>((ref) {
  final controller = StreamController<void>.broadcast();
  ref.onDispose(controller.close);
  return controller;
});

final dioProvider = Provider<Dio>((ref) {
  final sessionExpired = ref.watch(sessionExpiredProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: Env.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      contentType: Headers.jsonContentType,
    ),
  );
  dio.interceptors.add(
    AuthInterceptor(
      ref.watch(tokenStorageProvider),
      onSessionExpired: () => sessionExpired.add(null),
    ),
  );
  ref.onDispose(dio.close);
  return dio;
});
