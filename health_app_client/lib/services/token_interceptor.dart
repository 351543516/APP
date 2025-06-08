// lib/services/token_interceptor.dart
import 'package:dio/dio.dart';
import 'storage/storage_service.dart'; // 确保使用正确的导入路径

class TokenInterceptor extends Interceptor {
  final StorageService storageService;

  TokenInterceptor({required this.storageService});

  @override
  Future<void> onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    final token = await storageService.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }
}