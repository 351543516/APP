// test/services/token_interceptor_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:health_app_client/services/token_interceptor.dart';
import 'package:health_app_client/services/storage/storage_service.dart'; // 使用正确的路径
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

// 生成专用的 mock 文件
@GenerateMocks([StorageService])
import 'token_interceptor_test.mocks.dart';

void main() {
  test('Interceptor adds auth header', () async {
    // 1. 创建模拟存储服务
    final storageService = MockStorageService();

    // 2. 配置模拟响应
    when(storageService.getToken()).thenAnswer((_) async => 'test_token');

    // 3. 创建拦截器
    final interceptor = TokenInterceptor(storageService: storageService);

    // 4. 创建Dio请求选项
    final options = RequestOptions(path: '/api/test');
    final handler = RequestInterceptorHandler();

    // 5. 执行拦截器
    await interceptor.onRequest(options, handler);

    // 6. 验证结果
    expect(options.headers['Authorization'], 'Bearer test_token');
  });
}