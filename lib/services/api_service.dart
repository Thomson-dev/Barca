import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Base URL for the API. Move this to an env-specific config file
/// (e.g. `--dart-define`) once the backend is known.
const String kBaseUrl = 'https://example.com/api';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: kBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  // Add shared interceptors here (auth headers, logging, retry, etc.)
  // dio.interceptors.add(LogInterceptor());

  return dio;
});
