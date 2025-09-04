import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final baseUrlProvider = Provider<String>((ref) {
  // Adjust for your backend host/port
  return const String.fromEnvironment('API_BASE_URL', defaultValue: 'http://10.0.2.2:3000');
});

final dioProvider = Provider<Dio>((ref) {
  final baseUrl = ref.watch(baseUrlProvider);
  final dio = Dio(BaseOptions(
    baseUrl: '$baseUrl/api',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 20),
    headers: {
      'Content-Type': 'application/json',
    },
  ));
  return dio;
});

