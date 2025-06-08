// test/services/auth_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:health_app_client/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'auth_service_test.mocks.dart'; // 生成的模拟文件

@GenerateMocks([http.Client])
void main() {
  test('Login returns token on success', () async {
    // 创建模拟客户端（使用生成的MockClient）
    final client = MockClient();

    // 配置模拟响应
    when(client.post(
      any, // 匹配任何URL（Uri类型）
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response(
      '{"success": true, "token": "fake_token"}',
      200,
    ));

    // 创建AuthService并注入模拟客户端
    final authService = AuthService(client: client);

    // 执行测试
    final response = await authService.login("13800138000", "password");

    // 验证结果
    expect(response['success'], true);
    expect(response['token'], 'fake_token');
  });
}