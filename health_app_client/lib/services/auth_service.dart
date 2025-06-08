// lib/services/auth_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final http.Client _client;

  AuthService({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> login(String phone, String password) async {
    final response = await _client.post(
      Uri.parse('https://api.example.com/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'phone': phone,
        'password': password
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('登录失败: ${response.statusCode}');
    }
  }
}